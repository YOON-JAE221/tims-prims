package com.sdr.front.bbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sdr.common.constant.Constant;
import com.sdr.common.util.Utility;
import com.sdr.common.web.ParamMap;

@Controller
@RequestMapping("/bbs")
public class BbsController {

	@Inject
	@Named("BbsService")
	private BbsService bbsService;

	//게시글 리스트 화면(공지사항)
	@RequestMapping(value = "/viewBbsNotice", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsNotice(@ParamMap Map<String, Object> paramMap, Model model) {

	    paramMap.put("brdCd", Constant.BRD_CD_NOTICE);
	    
	    // 공지글 (항상 상단 고정)
	    List<Map<String, Object>> noticeList = bbsService.getSelectBbsNoticeList(paramMap);

	    int totalCnt = bbsService.getSelectBbsPstCount(paramMap);
	    Map<String, Object> paging = Utility.getPagingMap(paramMap, totalCnt);

	    List<Map<String, Object>> list = bbsService.getSelectBbsPstList(paramMap);

	    model.addAttribute("noticeList", noticeList);
	    model.addAttribute("list", list);
	    model.addAllAttributes(paging);
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());

	    return "front/bbs/bbsNotice/bbsNotice";
	}
	
	//게시글 리스트 화면(자료실)
	@RequestMapping(value = "/viewBbsDataRoom", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsDataRoom(@ParamMap Map<String, Object> paramMap, Model model) {

	    paramMap.put("brdCd", Constant.BRD_CD_DATA);
	    
	    // 공지글 (항상 상단 고정)
	    List<Map<String, Object>> noticeList = bbsService.getSelectBbsNoticeList(paramMap);


	    int totalCnt = bbsService.getSelectBbsPstCount(paramMap);
	    Map<String, Object> paging = Utility.getPagingMap(paramMap, totalCnt);

	    List<Map<String, Object>> list = bbsService.getSelectBbsPstList(paramMap);

	    model.addAttribute("noticeList", noticeList);
	    model.addAttribute("list", list);
	    model.addAllAttributes(paging);
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());

	    return "front/bbs/bbsDataRoom/bbsDataRoom";
	}
	
	//게시글 리스트 화면(문의게시판)
	@RequestMapping(value = "/viewBbsQna", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsQna(@ParamMap Map<String, Object> paramMap, Model model) {

	    paramMap.put("brdCd", Constant.BRD_CD_QNA);
	    
	    int totalCnt = bbsService.getSelectBbsQnaPstCount(paramMap);
	    Map<String, Object> paging = Utility.getPagingMap(paramMap, totalCnt);

	    List<Map<String, Object>> list = bbsService.getSelectBbsQnaPstList(paramMap);

	    // 원글 건수 (TOTAL 표시용)
	    int originalCnt = bbsService.getSelectBbsQnaOriginalCount(paramMap);

	    model.addAttribute("list", list);
	    model.addAllAttributes(paging);
	    model.addAttribute("originalCnt", originalCnt);
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());

	    return "front/bbs/bbsQna/bbsQna";
	}

    @RequestMapping(value = {"/viewBbsStra", "/viewBbsStre", "/viewBbsDise", "/viewBbsSafe",
            "/viewBbsSpfe", "/viewBbsTere", "/viewBbsVera", "/viewBbsSdse"},
            method = {RequestMethod.GET, RequestMethod.POST})
    public String viewBbsStra(@ParamMap Map<String, Object> paramMap, Model model, javax.servlet.http.HttpServletRequest request) {

        String[] bbsInfo = resolveBbsInfo(request.getRequestURI());

        paramMap.put("brdCd", bbsInfo[0]);
        paramMap.put("pageSize", 9);
        int totalCnt = bbsService.getSelectBbsPstCount(paramMap);
        Map<String, Object> paging = Utility.getPagingMap(paramMap, totalCnt);

        List<Map<String, Object>> list = bbsService.getSelectBbsPstList(paramMap);

        model.addAttribute("list", list);
        model.addAllAttributes(paging);
        model.addAttribute("brdCd", bbsInfo[0]);

        return bbsInfo[1];
    }
	
	
	// 글쓰기 및 수정 (공통)
	@RequestMapping("/viewBbsWrite")
	public String viewBbsWrite(@RequestParam("brdCd") String brdCd,
	                           @RequestParam(value="pstCd", required=false) String pstCd,
	                           @ParamMap Map<String, Object> paramMap,
	                           Model model) {

	    paramMap.put("brdCd", brdCd);
	    if (pstCd != null) paramMap.put("pstCd", pstCd);

	    Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    if (pstCd != null && !pstCd.isEmpty()) {
	        Map<String, Object> pst = bbsService.getSelectBbsPstDetail(paramMap);
	        model.addAttribute("pst", pst);

	        // 기존 첨부파일 목록
	        String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	        String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

	        if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	            Map<String, Object> fileParam = new HashMap<>();
	            fileParam.put("upldFileCd", atchFileKey);
	            List<Map<String, Object>> fileList = bbsService.getSelectUpldFileList(fileParam);
	            model.addAttribute("fileList", fileList);
	        }
	    }

	    model.addAttribute("listUrl", bbsBrd.get("brdListUrl").toString());
	    model.addAttribute("brdMenuNm", getMenuNmByBrdCd(paramMap.get("brdCd").toString()));
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());
	    model.addAttribute("pageNo", paramMap.getOrDefault("pageNo", "1"));
	    
	    return "front/bbs/bbsCommon/bbsWrite";
	}
	
	// 문의게시판 전용 글쓰기
    @RequestMapping(value = "/viewBbsWriteQna", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewBbsWriteQna(@RequestParam(value="brdCd") String brdCd, @RequestParam(value="pstCd", required=false) String pstCd, Model model) {

        // paramMap 직접 선언 (세션 정보 불필요)
        Map<String, Object> paramMap = new HashMap<>();

        paramMap.put("brdCd", brdCd);
        if (pstCd != null) paramMap.put("pstCd", pstCd);

        Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
        
        model.addAttribute("brd", bbsBrd);

        if (pstCd != null && !pstCd.isEmpty()) {
            Map<String, Object> pst = bbsService.getSelectBbsPstDetail(paramMap);
            model.addAttribute("pst", pst);

            // 기존 첨부파일 목록
            String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
            String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

            if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
                Map<String, Object> fileParam = new HashMap<>();
                fileParam.put("upldFileCd", atchFileKey);
                List<Map<String, Object>> fileList = bbsService.getSelectUpldFileList(fileParam);
                model.addAttribute("fileList", fileList);
            }
        }

        model.addAttribute("listUrl", bbsBrd.getOrDefault("brdListUrl", "/bbs/viewBbsQna"));
        model.addAttribute("brdMenuNm", getMenuNmByBrdCd(brdCd));
        model.addAttribute("brdCd", brdCd);
        model.addAttribute("pageNo", "1");

        return "front/bbs/bbsQna/bbsWriteQna";
    }
	
	// 글쓰기 상세 (공통)
	@RequestMapping(value = "/viewBbsDetail", method = RequestMethod.POST)
	public String viewBbsDetail(@ParamMap Map<String, Object> paramMap, Model model) throws Exception {

	    Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    Map<String, Object> pst = bbsService.getSelectBbsPstDetail(paramMap);
	    model.addAttribute("pst", pst);

	    // 첨부파일 권한 있고, 파일키 있으면 파일 목록 조회
	    String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	    String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

	    if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty()) {
	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("upldFileCd", atchFileKey);
	        List<Map<String, Object>> fileList = bbsService.getSelectUpldFileList(fileParam);
	        model.addAttribute("fileList", fileList);
	    }
	    
	    // 조회수 증가
	    bbsService.updateViewCnt(paramMap);
	    
	    model.addAttribute("listUrl", bbsBrd.get("brdListUrl").toString());
	    model.addAttribute("brdMenuNm", getMenuNmByBrdCd(paramMap.get("brdCd").toString()));
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());
	    model.addAttribute("pageNo", paramMap.getOrDefault("pageNo", "1"));
	    
	    return "front/bbs/bbsCommon/bbsDetail";
	}
	
	
	// 게시글 저장 (등록/수정) - 로그인 필요
	@RequestMapping(value = "/saveBbsPst", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBbsPst(@ParamMap Map<String, Object> paramMap, @RequestParam(value = "atchFile", required = false) MultipartFile[] atchFile) {

	    Map<String, Object> result = new HashMap<>();

	    try {
	        int cnt = bbsService.saveBbsPst(paramMap, atchFile);
	        result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
	        result.put("pstCd", paramMap.get("pstCd"));
	    } catch (Exception e) {
	        result.put("result", Constant.FAIL);
	        result.put("message", e.getMessage());
	    }

	    return result;
	}

	// 문의게시판 전용 저장 (비로그인 허용)
	@RequestMapping(value = "/saveBbsPstQna", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBbsPstQna(@ParamMap Map<String, Object> paramMap, @RequestParam(value = "atchFile", required = false) MultipartFile[] atchFile) {

	    Map<String, Object> result = new HashMap<>();

	    try {
	        int cnt = bbsService.saveBbsPstQna(paramMap, atchFile);
	        result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
	        result.put("pstCd", paramMap.get("pstCd"));
	    } catch (Exception e) {
	        result.put("result", Constant.FAIL);
	        result.put("message", e.getMessage());
	    }

	    return result;
	}
	
	// 게시글 삭제
	@RequestMapping(value = "/deleteBbsPst", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteBbsPst(@ParamMap Map<String, Object> paramMap) {

	    Map<String, Object> result = new HashMap<>();

	    try {
	        int cnt = bbsService.updateBbsPstDelYn(paramMap);
	        result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
	    } catch (Exception e) {
	        result.put("result", Constant.FAIL);
	        result.put("message", e.getMessage());
	    }

	    return result;
	}

	// 비밀번호 확인 (문의게시판)
	@RequestMapping(value = "/checkSecretPwd", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkSecretPwd(@ParamMap Map<String, Object> paramMap) {

	    Map<String, Object> result = new HashMap<>();

	    try {
	        boolean matched = bbsService.checkSecretPwd(paramMap);
	        result.put("result", matched ? Constant.OK : Constant.FAIL);
	        if (!matched) {
	            result.put("message", "비밀번호가 일치하지 않습니다.");
	        }
	    } catch (Exception e) {
	        result.put("result", Constant.FAIL);
	        result.put("message", e.getMessage());
	    }

	    return result;
	}

	// 문의게시판 답변 작성/수정 화면 (관리자 전용)
	@RequestMapping(value = "/viewBbsWriteQnaAns", method = RequestMethod.POST)
	public String viewBbsWriteQnaAns(@ParamMap Map<String, Object> paramMap, Model model) throws Exception {

	    paramMap.put("brdCd", Constant.BRD_CD_QNA);

	    // 게시판 정보
	    Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    // 원글(부모) 정보
	    Map<String, Object> parentPst = bbsService.getSelectBbsPstDetail(paramMap);
	    model.addAttribute("parentPst", parentPst);

	    // 원글 첨부파일
	    String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	    String atchFileKey = String.valueOf(parentPst.getOrDefault("atchFileKey", ""));
	    if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("upldFileCd", atchFileKey);
	        model.addAttribute("parentFileList", bbsService.getSelectUpldFileList(fileParam));
	    }

	    // 답변 수정 모드: ansPstCd 있으면 기존 답변 로드
	    String ansPstCd = String.valueOf(paramMap.getOrDefault("ansPstCd", ""));
	    if (!ansPstCd.isEmpty() && !"null".equals(ansPstCd)) {
	        Map<String, Object> ansParam = new HashMap<>();
	        ansParam.put("brdCd", Constant.BRD_CD_QNA);
	        ansParam.put("pstCd", ansPstCd);
	        Map<String, Object> ansPst = bbsService.getSelectBbsPstDetail(ansParam);
	        model.addAttribute("ansPst", ansPst);

	        // 답변 첨부파일
	        String ansAtchFileKey = String.valueOf(ansPst.getOrDefault("atchFileKey", ""));
	        if (brdProp.contains(Constant.BRD_PROP_FILE) && !ansAtchFileKey.isEmpty() && !"null".equals(ansAtchFileKey)) {
	            Map<String, Object> ansFileParam = new HashMap<>();
	            ansFileParam.put("upldFileCd", ansAtchFileKey);
	            model.addAttribute("ansFileList", bbsService.getSelectUpldFileList(ansFileParam));
	        }
	    }

	    model.addAttribute("brdCd", Constant.BRD_CD_QNA);
	    model.addAttribute("pageNo", paramMap.getOrDefault("pageNo", "1"));

	    return "front/bbs/bbsQna/bbsWriteQnaAns";
	}

	// 문의게시판 전용 상세
	@RequestMapping(value = "/viewBbsDetailQna", method = RequestMethod.POST)
	public String viewBbsDetailQna(@ParamMap Map<String, Object> paramMap, Model model) throws Exception {

	    paramMap.put("brdCd", Constant.BRD_CD_QNA);

	    Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    Map<String, Object> pst = bbsService.getSelectBbsPstDetail(paramMap);
	    model.addAttribute("pst", pst);

	    // 첨부파일
	    String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	    String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

	    if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("upldFileCd", atchFileKey);
	        List<Map<String, Object>> fileList = bbsService.getSelectUpldFileList(fileParam);
	        model.addAttribute("fileList", fileList);
	    }

	    // 답변 목록
	    List<Map<String, Object>> replyList = bbsService.getSelectBbsReplyList(paramMap);

	    // 답변별 첨부파일 조회
	    for (Map<String, Object> reply : replyList) {
	        String replyAtchKey = String.valueOf(reply.getOrDefault("atchFileKey", ""));
	        if (!replyAtchKey.isEmpty() && !"null".equals(replyAtchKey)) {
	            Map<String, Object> replyFileParam = new HashMap<>();
	            replyFileParam.put("upldFileCd", replyAtchKey);
	            reply.put("fileList", bbsService.getSelectUpldFileList(replyFileParam));
	        }
	    }

	    model.addAttribute("replyList", replyList);

	    // 조회수 증가
	    bbsService.updateViewCnt(paramMap);

	    model.addAttribute("brdCd", Constant.BRD_CD_QNA);
	    model.addAttribute("pageNo", paramMap.getOrDefault("pageNo", "1"));

	    return "front/bbs/bbsQna/bbsDetailQna";
	}
	

	private String getMenuNmByBrdCd(String brdCd) {
	    if (Constant.BRD_CD_NOTICE.equals(brdCd)) return "고객지원";
	    if (Constant.BRD_CD_DATA.equals(brdCd))   return "고객지원";
	    if (Constant.BRD_CD_QNA.equals(brdCd))    return "고객지원";
	    return "ENGINEERING";
	}

    // 컨트롤러 하단에 private 메서드 추가
    private static final Map<String, String[]> BBS_URI_MAP = new HashMap<>();
    static {
        BBS_URI_MAP.put("/viewBbsStra", new String[]{Constant.BRD_CD_STRA, "front/bbs/bbsStra/bbsStra"});
        BBS_URI_MAP.put("/viewBbsStre", new String[]{Constant.BRD_CD_STRE, "front/bbs/bbsStre/bbsStre"});
        BBS_URI_MAP.put("/viewBbsDise", new String[]{Constant.BRD_CD_DISE, "front/bbs/bbsDise/bbsDise"});
        BBS_URI_MAP.put("/viewBbsSafe", new String[]{Constant.BRD_CD_SAFE, "front/bbs/bbsSafe/bbsSafe"});
        BBS_URI_MAP.put("/viewBbsSpfe", new String[]{Constant.BRD_CD_SPFE, "front/bbs/bbsSpfe/bbsSpfe"});
        BBS_URI_MAP.put("/viewBbsTere", new String[]{Constant.BRD_CD_TERE, "front/bbs/bbsTere/bbsTere"});
        BBS_URI_MAP.put("/viewBbsVera", new String[]{Constant.BRD_CD_VERA, "front/bbs/bbsVera/bbsVera"});
        BBS_URI_MAP.put("/viewBbsSdse", new String[]{Constant.BRD_CD_SDSE, "front/bbs/bbsSdse/bbsSdse"});
    }

    private String[] resolveBbsInfo(String uri) {
        for (Map.Entry<String, String[]> entry : BBS_URI_MAP.entrySet()) {
            if (uri.contains(entry.getKey())) {
                return entry.getValue(); // [0]=brdCd, [1]=viewName
            }
        }
        return new String[]{Constant.BRD_CD_STRA, "front/bbs/bbsStra/bbsStra"}; // default
    }
	
}
