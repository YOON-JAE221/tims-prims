package com.prims.admin.bbsComMng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.prims.common.constant.Constant;
import com.prims.common.web.ParamMap;

@Controller
@RequestMapping("/bbsComMng")
public class BbsComMngController {

	@Inject
	@Named("BbsComMngService")
	private BbsComMngService bbsComMngService;
	
	
	@RequestMapping(value = "/viewBbsComMng", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsComMng(@ParamMap Map<String, Object> paramMap, Model model) {
		String brdCd = (String) paramMap.get("brdCd");
		if (brdCd == null || brdCd.isEmpty()) {
			return "redirect:/admin/viewAdminMain";
		}
		Map<String, Object> bbsBrd = bbsComMngService.selectBbsBrdOne(paramMap);
		model.addAttribute("brd", bbsBrd);
		model.addAttribute("menuNm", getMenuNmByBrdCd(brdCd));
	    return "admin/bbsComMng/bbsComMng";
	}
	
	
	//게시글 조회
	@ResponseBody
	@RequestMapping(value = "/getSelectBbsPstList")
	public Map<String, Object> getSelectBbsPstList( HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap ) {

	    String Message = "";
	    int resultCnt = 0;
	    List<?> list  = new ArrayList<Object>();
	    try {
	        list = bbsComMngService.getSelectBbsPstList(paramMap);
	        resultCnt++;
	    } catch (Exception e) {
	    	Message="조회에 실패하였습니다.";
	        e.printStackTrace();
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("DATA", list);
        result.put("Message", Message);
        result.put("resultCnt", resultCnt);
	    return result;
	}
	
	
	// BO 글쓰기/수정 화면
	@RequestMapping(value = "/viewBbsComWrite", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewBbsComWrite(@ParamMap Map<String, Object> paramMap, Model model) {

	    String brdCd = paramMap.get("brdCd").toString();
	    Map<String, Object> bbsBrd = bbsComMngService.selectBbsBrdOne(paramMap);
	    model.addAttribute("brd", bbsBrd);

	    String pstCd = (String) paramMap.get("pstCd");
	    if (pstCd != null && !pstCd.isEmpty()) {
	        Map<String, Object> pst = bbsComMngService.getSelectBbsPstDetail(paramMap);
	        model.addAttribute("pst", pst);

	        // 첨부파일
	        String brdProp = String.valueOf(bbsBrd.getOrDefault("brdPropBinary", ""));
	        String atchFileKey = String.valueOf(pst.getOrDefault("atchFileKey", ""));
	        if (brdProp.contains("F") && !atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
	            Map<String, Object> fileParam = new HashMap<>();
	            fileParam.put("upldFileCd", atchFileKey);
	            List<Map<String, Object>> fileList = bbsComMngService.getSelectUpldFileList(fileParam);
	            model.addAttribute("fileList", fileList);
	        }
	    }

	    model.addAttribute("brdCd", brdCd);
	    model.addAttribute("menuNm", getMenuNmByBrdCd(brdCd));
	    return "admin/bbsComMng/bbsComWrite";
	}
	
	// 게시글 저장 (등록/수정)
	@RequestMapping(value = "/saveBbsPst", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBbsPst(@ParamMap Map<String, Object> paramMap, @RequestParam(value = "atchFile", required = false) MultipartFile[] atchFile) {

	    Map<String, Object> result = new HashMap<>();

	    try {
	        int cnt = bbsComMngService.saveBbsPst(paramMap, atchFile);
	        result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
	        result.put("pstCd", paramMap.get("pstCd")); // 신규든 수정이든 pstCd 반환
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
	        int cnt = bbsComMngService.updateBbsPstDelYn(paramMap);
	        result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
	        result.put("resultCnt", cnt);
	    } catch (Exception e) {
	        result.put("result", Constant.FAIL);
	        result.put("message", e.getMessage());
	    }

	    return result;
	}
	

	private String getMenuNmByBrdCd(String brdCd) {
	    if (Constant.BRD_CD_NOTICE.equals(brdCd)) return "고객지원";
	    if (Constant.BRD_CD_FAQ.equals(brdCd))    return "고객지원";
	    if (Constant.BRD_CD_QNA.equals(brdCd))    return "고객지원";
	    if (Constant.BRD_CD_ABOUT.equals(brdCd))  return "회사소개";
	    return "게시판관리";
	}
	
}
