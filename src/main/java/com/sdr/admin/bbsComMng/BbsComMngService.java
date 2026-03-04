package com.sdr.admin.bbsComMng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sdr.common.constant.Constant;
import com.sdr.common.file.FileService;
import com.sdr.common.util.Utility;


@Service("BbsComMngService")
public class BbsComMngService{
	
	@Autowired
    private BbsComMngDao bbsComMngDao;
	
	@Autowired
	private FileService fileService;

	//게시글 리스트 조회
	public List<Map<String, Object>> getSelectBbsPstList(Map<String, Object> paramMap) {
	    return bbsComMngDao.getSelectBbsPstList(paramMap);
	}
	public int getSelectBbsPstCount(Map<String, Object> paramMap) {
	    return bbsComMngDao.getSelectBbsPstCount(paramMap);
	}
	
	//게시글 조회(공지글)
	public List<Map<String, Object>> getSelectBbsNoticeList(Map<String, Object> paramMap) {
	    return bbsComMngDao.getSelectBbsNoticeList(paramMap);
	}
	
	//게시판 조회
	public Map<String, Object> selectBbsBrdOne(Map<String, Object> paramMap) {
	    return bbsComMngDao.selectBbsBrdOne(paramMap);
	}

	//게시글 상세 조회
	public Map<String, Object> getSelectBbsPstDetail(Map<String, Object> paramMap) {
	    return bbsComMngDao.getSelectBbsPstDetail(paramMap);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int saveBbsPst(Map<String, Object> paramMap, MultipartFile[] atchFile) throws Exception {

	    String ssnUsrCd = String.valueOf(paramMap.getOrDefault("ssnUsrCd", "SYSTEM"));

	    // 1. 게시판 정보 조회 (권한 체크용)
	    Map<String, Object> brd = bbsComMngDao.selectBbsBrdOne(paramMap);
	    String brdProp = String.valueOf(brd.getOrDefault("brdPropBinary", ""));

	    // 2. 첨부파일 처리 — F 권한 있을 때만
	    if (brdProp.contains(Constant.BRD_PROP_FILE) && atchFile != null) {

	        // 빈 파일 제거
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
	    
	    //2-1. 썸네일 이미지 권한 있을시
	    if (brdProp.contains(Constant.BRD_PROP_IMG)) {
		    // 썸네일 추출 (에디터 HTML에서 첫 번째 img src)
		    String pstCnts = String.valueOf(paramMap.getOrDefault("pstCnts", ""));
		    String thumbUrl = Utility.extractFirstImgSrc(pstCnts);
		    paramMap.put("thumbUrl", thumbUrl);
	    }
	    
	    String pstCd = String.valueOf(paramMap.getOrDefault("pstCd", ""));
	    if (pstCd.isEmpty() || "null".equals(pstCd)) {
	        String newPstCd = Utility.getUuidPk32();
	        paramMap.put("pstCd", newPstCd);
	        paramMap.put("rotPstCd", newPstCd);
	        paramMap.put("pstLvl", 0);
	    }

	    paramMap.put("rgtUsrNm", "관리자");
	    // 3. 게시글 머지 (INSERT ON DUPLICATE KEY UPDATE)
	    int cnt = bbsComMngDao.saveBbsPst(paramMap);

	    // 4. 지연 삭제 파일 처리
	    processDeleteFiles(paramMap);

	    return cnt;
	}
	
	//게시글 조회수 UPDATE
	@Transactional(rollbackFor = Exception.class)
	public int updateViewCnt(Map<String, Object> paramMap) throws Exception {
	    return bbsComMngDao.updateViewCnt(paramMap);
	}
	
	//게시글 삭제
	@Transactional(rollbackFor = Exception.class)
	public int updateBbsPstDelYn(Map<String, Object> paramMap) throws Exception {

	    // 1. 게시글 조회 (첨부파일 키 확인)
	    Map<String, Object> pst = bbsComMngDao.getSelectBbsPstDetail(paramMap);
	    if (pst == null) return 0;

	    String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

	    // 2. 첨부파일 있으면 삭제
	    if (!atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	        fileService.deleteBbsAtchFiles(atchFileKey, String.valueOf(paramMap.get("ssnUsrCd")));
	    }

	    // 3. 게시글 논리 삭제
	    return bbsComMngDao.updateBbsPstDelYn(paramMap);
	}
	
	//첨부파일 조회
	public List<Map<String, Object>> getSelectUpldFileList(Map<String, Object> paramMap) {
	    return fileService.getSelectUpldFileList(paramMap);
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
	            fileInfo.put("ssnUsrCd", paramMap.get("ssnUsrCd").toString());
	            fileService.deleteCommonFile(fileInfo);
	        }
	    }
	}

	
}
