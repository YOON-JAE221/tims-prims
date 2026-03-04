package com.sdr.admin.comHistory;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.sdr.common.util.Utility;
import com.sdr.common.web.ParamMap;

@Controller
@RequestMapping("/comHistoryMng")  
public class ComHistoryMngController {


	@Inject
	@Named("ComHistoryMngService")
	private ComHistoryMngService comHistoryMngService;
	
	
	@RequestMapping("/viewComHistoryMng")
	public String viewComHistoryMng() {
	    return "admin/comHistoryMng/comHistoryMng";
	}
	
	//회사 연혁 조회
	@ResponseBody
	@RequestMapping(value = "/getSelectComHstList")
	public Map<String, Object> getSelectComHstList( HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap ) {

	    String Message = "";
	    int resultCnt = 0;
	    List<?> list  = new ArrayList<Object>();
	    try {
	        list = comHistoryMngService.getSelectList(paramMap);
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
	
	//회사 연혁 저장
	@RequestMapping(value = "/saveComHistoryMng")
	@ResponseBody
	public Map<String, Object> saveComHistoryMng(HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap) {
		
		List<Map<String, Object>> mergeRows = Utility.convertRequestParamToList(request, "mergeRows");  //여기서 List로 변환
	    paramMap.put("mergeRows", mergeRows);

	    String message = "";
	    int resultCnt = -1;
	    try {
	        resultCnt = comHistoryMngService.saveComHistoryMng(paramMap);
	    } catch (Exception e) {
	        message = "저장에 실패하였습니다.";
	        e.printStackTrace();
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("Message", message);
	    result.put("resultCnt", resultCnt);
	    return result;
	}
	
	//연혁 삭제
	@ResponseBody
	@RequestMapping(value = "/deleteComHistoryMng")
	public Map<String, Object> deleteComHistoryMng( HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap ) {
		
		String Message = "";
		int resultCnt = 0;
		try {
			resultCnt += comHistoryMngService.deleteComHistoryMng(paramMap);
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
