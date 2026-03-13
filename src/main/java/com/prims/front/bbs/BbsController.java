package com.prims.front.bbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.prims.common.constant.Constant;
import com.prims.common.util.Utility;
import com.prims.common.web.ParamMap;

@Controller
@RequestMapping("/bbs")
public class BbsController {

	@Inject
	@Named("BbsService")
	private BbsService bbsService;

	// ===== 공지사항 =====
	@RequestMapping(value = "/viewBbsNotice", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsNotice(@ParamMap Map<String, Object> paramMap, Model model) {

	    paramMap.put("brdCd", Constant.BRD_CD_NOTICE);

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

	// ===== FAQ =====
	@RequestMapping(value = "/viewBbsFaq", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsFaq(@ParamMap Map<String, Object> paramMap, Model model) {

	    paramMap.put("brdCd", Constant.BRD_CD_FAQ);

	    List<Map<String, Object>> noticeList = bbsService.getSelectBbsNoticeList(paramMap);

	    int totalCnt = bbsService.getSelectBbsPstCount(paramMap);
	    Map<String, Object> paging = Utility.getPagingMap(paramMap, totalCnt);

	    List<Map<String, Object>> list = bbsService.getSelectBbsPstList(paramMap);

	    model.addAttribute("noticeList", noticeList);
	    model.addAttribute("list", list);
	    model.addAllAttributes(paging);
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());

	    return "front/bbs/bbsFaq/bbsFaq";
	}

	// ===== 문의게시판 =====
	@RequestMapping(value = "/viewBbsQna", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsQna(@ParamMap Map<String, Object> paramMap, Model model) {

	    paramMap.put("brdCd", Constant.BRD_CD_QNA);

	    int totalCnt = bbsService.getSelectBbsQnaPstCount(paramMap);
	    Map<String, Object> paging = Utility.getPagingMap(paramMap, totalCnt);

	    List<Map<String, Object>> list = bbsService.getSelectBbsQnaPstList(paramMap);

	    int originalCnt = bbsService.getSelectBbsQnaOriginalCount(paramMap);

	    model.addAttribute("list", list);
	    model.addAllAttributes(paging);
	    model.addAttribute("originalCnt", originalCnt);
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());

	    return "front/bbs/bbsQna/bbsQna";
	}

	// ===== 문의게시판 글쓰기 =====
    @RequestMapping(value = "/viewBbsWriteQna", method = RequestMethod.POST)
    public String viewBbsWriteQna(@RequestParam(value="brdCd") String brdCd,
                                   @RequestParam(value="pstCd", required=false) String pstCd,
                                   @RequestParam(value="pstNm", required=false) String pstNm,
                                   Model model) {

        Map<String, Object> paramMap = new HashMap<>();

        paramMap.put("brdCd", brdCd);
        paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
        if (pstCd != null) paramMap.put("pstCd", pstCd);

        Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
        model.addAttribute("brd", bbsBrd);

        if (pstCd != null && !pstCd.isEmpty()) {
            Map<String, Object> pst = bbsService.getSelectBbsPstDetail(paramMap);
            model.addAttribute("pst", pst);

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
        model.addAttribute("brdMenuNm", "고객지원");
        model.addAttribute("brdCd", brdCd);
        model.addAttribute("pageNo", "1");

        // 매물 문의 시 제목 자동 설정
        if (pstNm != null && !pstNm.isEmpty() && pstCd == null) {
            model.addAttribute("initPstNm", pstNm);
        }

        return "front/bbs/bbsQna/bbsWriteQna";
    }

	// ===== 글 상세 (공통) =====
	@RequestMapping(value = "/viewBbsDetail", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsDetail(@ParamMap Map<String, Object> paramMap, Model model, HttpServletRequest request) throws Exception {

	    String brdCd = (String) paramMap.get("brdCd");
	    String pstCd = (String) paramMap.get("pstCd");
	    
	    // GET 요청이거나 필수값 없으면 목록으로
	    if ("GET".equalsIgnoreCase(request.getMethod()) || brdCd == null || brdCd.isEmpty() || pstCd == null || pstCd.isEmpty()) {
	        return "redirect:/bbs/viewBbsNotice";
	    }

	    Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    Map<String, Object> pst = bbsService.getSelectBbsPstDetail(paramMap);
	    model.addAttribute("pst", pst);

	    String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	    String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

	    if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty()) {
	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("upldFileCd", atchFileKey);
	        List<Map<String, Object>> fileList = bbsService.getSelectUpldFileList(fileParam);
	        model.addAttribute("fileList", fileList);
	    }

	    bbsService.updateViewCnt(paramMap);

	    model.addAttribute("listUrl", bbsBrd.get("brdListUrl").toString());
	    model.addAttribute("brdMenuNm", "고객지원");
	    model.addAttribute("brdCd", paramMap.get("brdCd").toString());
	    model.addAttribute("pageNo", paramMap.getOrDefault("pageNo", "1"));

	    return "front/bbs/bbsCommon/bbsDetail";
	}

	// ===== 문의게시판 답변 저장 (관리자 - 로그인 필요) =====
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

	// ===== 문의게시판 저장 (비로그인) =====
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

	// ===== 문의게시판 삭제 (비로그인 포함) =====
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

	// ===== 비밀번호 확인 (문의게시판) =====
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

	// ===== 문의게시판 답변 작성 (관리자) =====
	@RequestMapping(value = "/viewBbsWriteQnaAns", method = RequestMethod.POST)
	public String viewBbsWriteQnaAns(@ParamMap Map<String, Object> paramMap, Model model) throws Exception {

	    paramMap.put("brdCd", Constant.BRD_CD_QNA);
	    paramMap.put("encryptKey", Constant.ENCRYPT_KEY);

	    Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    Map<String, Object> parentPst = bbsService.getSelectBbsPstDetail(paramMap);
	    model.addAttribute("parentPst", parentPst);

	    String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	    String atchFileKey = String.valueOf(parentPst.getOrDefault("atchFileKey", ""));
	    if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("upldFileCd", atchFileKey);
	        model.addAttribute("parentFileList", bbsService.getSelectUpldFileList(fileParam));
	    }

	    String ansPstCd = String.valueOf(paramMap.getOrDefault("ansPstCd", ""));
	    if (!ansPstCd.isEmpty() && !"null".equals(ansPstCd)) {
	        Map<String, Object> ansParam = new HashMap<>();
	        ansParam.put("brdCd", Constant.BRD_CD_QNA);
	        ansParam.put("pstCd", ansPstCd);
	        Map<String, Object> ansPst = bbsService.getSelectBbsPstDetail(ansParam);
	        model.addAttribute("ansPst", ansPst);

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

	// ===== 문의게시판 상세 =====
	@RequestMapping(value = "/viewBbsDetailQna", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsDetailQna(@ParamMap Map<String, Object> paramMap, Model model, HttpServletRequest request) throws Exception {

	    String pstCd = (String) paramMap.get("pstCd");
	    
	    // GET 요청이거나 필수값 없으면 목록으로
	    if ("GET".equalsIgnoreCase(request.getMethod()) || pstCd == null || pstCd.isEmpty()) {
	        return "redirect:/bbs/viewBbsQna";
	    }

	    paramMap.put("brdCd", Constant.BRD_CD_QNA);
	    paramMap.put("encryptKey", Constant.ENCRYPT_KEY);

	    Map<String, Object> bbsBrd = bbsService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    Map<String, Object> pst = bbsService.getSelectBbsPstDetail(paramMap);
	    model.addAttribute("pst", pst);

	    String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	    String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));

	    if (brdProp.contains(Constant.BRD_PROP_FILE) && !atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("upldFileCd", atchFileKey);
	        List<Map<String, Object>> fileList = bbsService.getSelectUpldFileList(fileParam);
	        model.addAttribute("fileList", fileList);
	    }

	    List<Map<String, Object>> replyList = bbsService.getSelectBbsReplyList(paramMap);

	    for (Map<String, Object> reply : replyList) {
	        String replyAtchKey = String.valueOf(reply.getOrDefault("atchFileKey", ""));
	        if (!replyAtchKey.isEmpty() && !"null".equals(replyAtchKey)) {
	            Map<String, Object> replyFileParam = new HashMap<>();
	            replyFileParam.put("upldFileCd", replyAtchKey);
	            reply.put("fileList", bbsService.getSelectUpldFileList(replyFileParam));
	        }
	    }

	    model.addAttribute("replyList", replyList);

	    bbsService.updateViewCnt(paramMap);

	    model.addAttribute("brdCd", Constant.BRD_CD_QNA);
	    model.addAttribute("pageNo", paramMap.getOrDefault("pageNo", "1"));

	    return "front/bbs/bbsQna/bbsDetailQna";
	}

}
