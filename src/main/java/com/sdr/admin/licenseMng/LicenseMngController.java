package com.sdr.admin.licenseMng;

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

import com.sdr.common.config.AppProperties;
import com.sdr.common.constant.Constant;
import com.sdr.common.util.Utility;
import com.sdr.common.web.ParamMap;

@Controller
@RequestMapping("/licenseMng")
public class LicenseMngController {

	@Inject
	private AppProperties appProperties;

	@Inject
	@Named("LicenseMngService")
	private LicenseMngService licenseMngService;
	
	
	@RequestMapping("/viewLicenseMng")
	public String viewLicenseMng() {
	    return "admin/licenseMng/licenseMng";
	}
	
	//등록 및 면허 조회
	@ResponseBody
	@RequestMapping(value = "/getSelectLicenseList")
	public Map<String, Object> getSelectLicenseList( HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap ) {

	    String Message = "";
	    int resultCnt = 0;
	    List<?> list  = new ArrayList<Object>();
	    try {
	    	
	    	paramMap.put("uploadBaseDir", appProperties.getUploadBaseWeb());
	        list = licenseMngService.getSelectList(paramMap);
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
	
	//등록 및 면허 저장
	@RequestMapping(value = "/saveLicenseMng")
	@ResponseBody
	public Map<String, Object> saveLicenseMng(HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap) {
		
		List<Map<String, Object>> mergeRows = Utility.convertRequestParamToList(request, "mergeRows");  //여기서 List로 변환
	    paramMap.put("mergeRows", mergeRows);

	    String message = "";
	    int resultCnt = -1;
	    try {
	        resultCnt = licenseMngService.saveLicenseMng(paramMap);
	    } catch (Exception e) {
	        message = "저장에 실패하였습니다.";
	        e.printStackTrace();
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("Message", message);
	    result.put("resultCnt", resultCnt);
	    return result;
	}
	
	//등록 및 면허 삭제
	@ResponseBody
	@RequestMapping(value = "/deleteLicenseMng")
	public Map<String, Object> deleteLicenseMng( HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap ) {
		
		String Message = "";
		int resultCnt = 0;
		try {
			resultCnt += licenseMngService.deleteLicenseMng(paramMap);
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
