package com.prims.admin.sys.menuMng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.util.Utility;

@Controller
@RequestMapping("/admin/menuMng") // 전체 URL 경로: /admin/menuMng/*
public class MenuMngController {
	
	@Inject
    @Named("MenuMngService")
    private MenuMngService menuMngService;
	
	@RequestMapping("/viewMenuMng")
	public String viewMain() {
	    return "admin/sys/menuMng/menuMng";
	}
	
	//메뉴조회
	@ResponseBody
	@RequestMapping(value = "/getMenuMngList")
	public Map<String, Object> getMenuMngList( HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) {

	    
	    String Message = "";
	    int resultCnt = 0;
	    List<?> list  = new ArrayList<Object>();
	    try {
	        list = menuMngService.getMenuTreeList(paramMap);
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

	//메뉴저장
	@RequestMapping(value = "/saveMenuMng")
	@ResponseBody
	public Map<String, Object> saveMenuMng(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		
		Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
		if (loginUser != null) {
		    paramMap.put("ssnUsrCd", loginUser.get("usrCd").toString());
		}
		
		List<Map<String, Object>> mergeRows = Utility.convertRequestParamToList(request, "mergeRows");  //여기서 List로 변환
	    paramMap.put("mergeRows", mergeRows);

	    String message = "";
	    int resultCnt = -1;
	    try {
	        resultCnt = menuMngService.saveMenuMng(paramMap);
	    } catch (Exception e) {
	        message = "저장에 실패하였습니다.";
	        e.printStackTrace();
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("Message", message);
	    result.put("resultCnt", resultCnt);
	    return result;
	}
	
	//메뉴삭제
	@ResponseBody
	@RequestMapping(value = "/deleteMenuMngList")
	public Map<String, Object> deleteMenuMngList( HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) {
		
		String Message = "";
		int resultCnt = 0;
		try {
			resultCnt += menuMngService.deleteMenuMng(paramMap);
		} catch (Exception e) {
			Message="삭제에 실패하였습니다.";
			e.printStackTrace();
		}
		
		Map<String, Object> result = new HashMap<>();
		result.put("Message", Message);
		result.put("resultCnt", resultCnt);
		return result;
	}
	
	
}
