package com.prims.front.bbs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.prims.common.constant.Constant;
import com.prims.common.file.FileService;
import com.prims.common.util.Utility;


import com.prims.common.notification.NotificationService;


@Service("BbsService")
public class BbsService{
	
	@Autowired
    private BbsDao bbsDao;
	
	@Autowired
	private FileService fileService;

	@Autowired
	private NotificationService notificationService;

	//게시글 리스트 조회
	public List<Map<String, Object>> getSelectBbsPstList(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsPstList(paramMap);
	}
	public int getSelectBbsPstCount(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsPstCount(paramMap);
	}
	
	//게시글 조회(공지글)
	public List<Map<String, Object>> getSelectBbsNoticeList(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsNoticeList(paramMap);
	}
	
	//게시판 조회
	public Map<String, Object> selectBbsBrdOne(Map<String, Object> paramMap) {
	    return bbsDao.selectBbsBrdOne(paramMap);
	}

	//게시글 상세 조회
	public Map<String, Object> getSelectBbsPstDetail(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsPstDetail(paramMap);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int saveBbsPst(Map<String, Object> paramMap, MultipartFile[] atchFile) throws Exception {

	    // 1. 게시판 정보 조회 (권한 체크용)
	    Map<String, Object> brd = bbsDao.selectBbsBrdOne(paramMap);
	    String brdProp = String.valueOf(brd.getOrDefault("brdPropBinary", ""));

	    // 2. 첨부파일 처리 — F 권한 있을 때만
	    if (brdProp.contains(Constant.BRD_PROP_FILE) && atchFile != null) {
	        List<MultipartFile> fileList = new ArrayList<>();
	        for (MultipartFile f : atchFile) {
	            if (f != null && !f.isEmpty()) fileList.add(f);
	        }
	        if (!fileList.isEmpty()) {
	            String atchFileKey = fileService.saveBbsAtchFiles(fileList, "bbs", paramMap.get("ssnUsrCd").toString());
	            if (atchFileKey != null) {
	                paramMap.put("atchFileKey", atchFileKey);
	            }
	        }
	    }
	    
	    //2-1. 썸네일 이미지 권한 있을시
	    if (brdProp.contains(Constant.BRD_PROP_IMG)) {
		    String pstCnts = String.valueOf(paramMap.getOrDefault("pstCnts", ""));
		    String thumbUrl = Utility.extractFirstImgSrc(pstCnts);
		    paramMap.put("thumbUrl", thumbUrl);
	    }
	    
	    String pstCd = String.valueOf(paramMap.getOrDefault("pstCd", ""));
	    boolean isNew = pstCd.isEmpty() || "null".equals(pstCd);
	    if (isNew) {
	        String newPstCd = Utility.getUuidPk32();
	        paramMap.put("pstCd", newPstCd);

	        // 답변(pstLvl>0)이면 form에서 넘어온 rotPstCd/pstLvl 유지
	        String pstLvl = String.valueOf(paramMap.getOrDefault("pstLvl", "0"));
	        if ("0".equals(pstLvl) || pstLvl.isEmpty()) {
	            paramMap.put("rotPstCd", newPstCd);
	            paramMap.put("pstLvl", 0);
	        }
	    }
	    paramMap.put("rgtUsrNm", paramMap.get("ssnUsrNm").toString());

	    int cnt = bbsDao.saveBbsPst(paramMap);

	    // 지연 삭제 파일 처리
	    processDeleteFiles(paramMap);

	    // 문의게시판 답변 등록 시 문의자에게 알림 이메일 발송
	    String brdCd = String.valueOf(paramMap.getOrDefault("brdCd", ""));
	    String pstLvlStr = String.valueOf(paramMap.getOrDefault("pstLvl", "0"));
	    int pstLvlInt = 0;
	    try { pstLvlInt = Integer.parseInt(pstLvlStr); } catch (NumberFormatException ignored) {}

	    if (isNew && cnt > 0 && Constant.BRD_CD_QNA.equals(brdCd) && pstLvlInt > 0) {
	        try {
	            // 원글 조회 (문의자 이메일 확인용)
	            Map<String, Object> parentParam = new HashMap<>();
	            parentParam.put("brdCd", brdCd);
	            parentParam.put("pstCd", paramMap.get("rotPstCd"));
	            Map<String, Object> parentPst = bbsDao.getSelectBbsPstDetail(parentParam);

	            if (parentPst != null) {
	                String replyContent = String.valueOf(paramMap.getOrDefault("pstCnts", ""));
	                notificationService.sendQnaReplyNotification(parentPst, replyContent);
	            }
	        } catch (Exception e) {
	            // 메일 실패해도 답변 등록은 정상 처리
	        }
	    }

	    return cnt;
	}

	// 문의게시판 전용 저장 (비로그인 허용)
	@Transactional(rollbackFor = Exception.class)
	public int saveBbsPstQna(Map<String, Object> paramMap, MultipartFile[] atchFile) throws Exception {

	    // 비로그인 사용자 기본값
	    String ssnUsrCd = String.valueOf(paramMap.getOrDefault("ssnUsrCd", ""));
	    if (ssnUsrCd.isEmpty() || "null".equals(ssnUsrCd)) {
	        ssnUsrCd = Constant.Guest;
	        paramMap.put("ssnUsrCd", ssnUsrCd);
	    }

        // 1. 게시판 정보 조회 (권한 체크용)
        Map<String, Object> brd = bbsDao.selectBbsBrdOne(paramMap);
        String brdProp = String.valueOf(brd.getOrDefault("brdPropBinary", ""));

        // 2. 첨부파일 처리 — F 권한 있을 때만
        if (brdProp.contains(Constant.BRD_PROP_FILE) && atchFile != null) {
            // 첨부파일 처리
            List<MultipartFile> fileList = new ArrayList<>();
            for (MultipartFile f : atchFile) {
                if (f != null && !f.isEmpty()) fileList.add(f);
            }
            if (!fileList.isEmpty()) {
                String atchFileKey = fileService.saveBbsAtchFiles(fileList, "bbs", ssnUsrCd);
                if (atchFileKey != null) {
                    paramMap.put("atchFileKey", atchFileKey);
                }
            }
        }

	    // 신규글 처리
	    String pstCd = String.valueOf(paramMap.getOrDefault("pstCd", ""));
	    boolean isNew = pstCd.isEmpty() || "null".equals(pstCd);
	    if (isNew) {
	        String newPstCd = Utility.getUuidPk32();
	        paramMap.put("pstCd", newPstCd);
	        paramMap.put("rotPstCd", newPstCd);
	        paramMap.put("pstLvl", 0);
	    }

	    int cnt = bbsDao.saveBbsPst(paramMap);

	    // 지연 삭제 파일 처리
	    processDeleteFiles(paramMap);

	    // 신규 문의 등록 시 관리자 알림 메일 발송
	    if (isNew && cnt > 0) {
	        try {
	            notificationService.sendQnaNotification(paramMap);
	        } catch (Exception e) {
	            // 메일 실패해도 등록은 정상 처리
	        }
	    }

	    return cnt;
	}
	
	//게시글 조회수 UPDATE
	@Transactional(rollbackFor = Exception.class)
	public int updateViewCnt(Map<String, Object> paramMap) throws Exception {
	    return bbsDao.updateViewCnt(paramMap);
	}
	
	//게시글 삭제
	@Transactional(rollbackFor = Exception.class)
	public int updateBbsPstDelYn(Map<String, Object> paramMap) throws Exception {

	    // 비로그인 사용자 기본값
	    String ssnUsrCd = String.valueOf(paramMap.getOrDefault("ssnUsrCd", ""));
	    if (ssnUsrCd.isEmpty() || "null".equals(ssnUsrCd)) {
	        ssnUsrCd = Constant.Guest;
	        paramMap.put("ssnUsrCd", ssnUsrCd);
	    }

	    // 1. 게시글 조회 (첨부파일 키 확인)
	    Map<String, Object> pst = bbsDao.getSelectBbsPstDetail(paramMap);
	    if (pst == null) return 0;

	    String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

	    // 2. 첨부파일 있으면 삭제
	    if (!atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	        fileService.deleteBbsAtchFiles(atchFileKey, ssnUsrCd);
	    }

	    // 3. 게시글 논리 삭제
	    int cnt = bbsDao.updateBbsPstDelYn(paramMap);

	    // 4. cascade 삭제: 답변(하위글)도 함께 삭제
	    String cascade = String.valueOf(paramMap.getOrDefault("cascade", "N"));
	    if ("Y".equals(cascade)) {
	        List<Map<String, Object>> replyList = bbsDao.getSelectBbsReplyList(paramMap);
	        for (Map<String, Object> reply : replyList) {
	            Map<String, Object> replyParam = new HashMap<>();
	            replyParam.put("brdCd", paramMap.get("brdCd"));
	            replyParam.put("pstCd", reply.get("pstCd"));
	            replyParam.put("ssnUsrCd", ssnUsrCd);

	            // 답변 첨부파일 삭제
	            String replyAtchKey = String.valueOf(reply.getOrDefault("atchFileKey", ""));
	            if (!replyAtchKey.isEmpty() && !"null".equals(replyAtchKey)) {
	                fileService.deleteBbsAtchFiles(replyAtchKey, ssnUsrCd);
	            }

	            bbsDao.updateBbsPstDelYn(replyParam);
	        }
	    }

	    return cnt;
	}
	
	//첨부파일 조회
	public List<Map<String, Object>> getSelectUpldFileList(Map<String, Object> paramMap) {
	    return fileService.getSelectUpldFileList(paramMap);
	}

	//비밀번호 확인 (문의게시판)
	public boolean checkSecretPwd(Map<String, Object> paramMap) {
	    int cnt = bbsDao.checkSecretPwd(paramMap);
	    return cnt > 0;
	}

	//답변 목록 조회 (문의게시판)
	public List<Map<String, Object>> getSelectBbsReplyList(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsReplyList(paramMap);
	}

	//문의게시판 전용 리스트 (계층형)
	public List<Map<String, Object>> getSelectBbsQnaPstList(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsQnaPstList(paramMap);
	}

	//문의게시판 전용 건수
	public int getSelectBbsQnaPstCount(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsQnaPstCount(paramMap);
	}

	//문의게시판 원글 건수 (번호용)
	public int getSelectBbsQnaOriginalCount(Map<String, Object> paramMap) {
	    return bbsDao.getSelectBbsQnaOriginalCount(paramMap);
	}

	//메인 엔지니어링 서비스 통합 리스트 (조회수 DESC, 9건)
	public List<Map<String, Object>> getSelectMainEngList() {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("brdCdStra", Constant.BRD_CD_STRA);
	    paramMap.put("brdCdStre", Constant.BRD_CD_STRE);
	    paramMap.put("brdCdDise", Constant.BRD_CD_DISE);
	    paramMap.put("brdCdSafe", Constant.BRD_CD_SAFE);
	    paramMap.put("brdCdSpfe", Constant.BRD_CD_SPFE);
	    paramMap.put("brdCdTere", Constant.BRD_CD_TERE);
	    paramMap.put("brdCdVera", Constant.BRD_CD_VERA);
	    paramMap.put("brdCdSdse", Constant.BRD_CD_SDSE);
	    return bbsDao.getSelectMainEngList(paramMap);
	}

	/**
	 * 지연 삭제 파일 처리
	 * deleteFiles 파라미터: "upldFileCd:fileSeq" 형식 (단건 String 또는 List)
	 */
	@SuppressWarnings("unchecked")
	private void processDeleteFiles(Map<String, Object> paramMap) throws Exception {
	    Object deleteObj = paramMap.get("deleteFiles");
	    if (deleteObj == null) return;

	    List<String> deleteList = new ArrayList<>();
	    if (deleteObj instanceof String) {
	        deleteList.add((String) deleteObj);
	    } else if (deleteObj instanceof List) {
	        deleteList = (List<String>) deleteObj;
	    }

	    for (String key : deleteList) {
	        String[] parts = key.split(":");
	        if (parts.length != 2) continue;

	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("upldFileCd", parts[0]);
	        fileParam.put("fileSeq", Integer.parseInt(parts[1]));

	        Map<String, Object> fileInfo = fileService.getSelectUpldFileOne(fileParam);
	        if (fileInfo != null) {
	            String usrCd = String.valueOf(paramMap.getOrDefault("ssnUsrCd", ""));
	            if (usrCd.isEmpty() || "null".equals(usrCd)) usrCd = Constant.Guest;
	            fileInfo.put("ssnUsrCd", usrCd);
	            fileService.deleteCommonFile(fileInfo);
	        }
	    }
	}

	
}
