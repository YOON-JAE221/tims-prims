package com.sdr.admin.greeting;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sdr.common.constant.Constant;
import com.sdr.common.web.ParamMap;

@Controller
@RequestMapping("/greetingMng")  
public class GreetingMngController {
	
	@Inject
	@Named("GreetingMngService")
	private GreetingMngService greetingMngService;
	
	//인사말 조회
	@RequestMapping("/viewGreetingMng")
	public String viewGreetingMng(Model model) {

	    Map<String, Object> param = new HashMap<>();

	    param.put("brdCd", Constant.BRD_CD_GREETING);

	    Map<String, Object> map = greetingMngService.selectGreetingPost(param);

	    // 화면에서 ${pstCnts}로 출력할 값
	    String pstCnts = (map == null) ? "" : String.valueOf(map.getOrDefault("pstCnts", ""));
	    model.addAttribute("pstCnts", pstCnts);
	    model.addAttribute("pstCd", map.get("pstCd").toString());

	    return "admin/greetingMng/greetingMng";
	}
	
	// 인사말 저장
	@RequestMapping(value = "/saveGreetingMng")
	@ResponseBody
	public Map<String, Object> saveGreetingMng(HttpSession session, HttpServletRequest request, @ParamMap Map<String, Object> paramMap) {

	    String message = "";
	    int resultCnt = -1;

	    try {
	    resultCnt = greetingMngService.saveGreetingMng(paramMap); 
	    } catch (Exception e) {
	        message = "저장에 실패하였습니다.";
	        e.printStackTrace();
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("Message", message);
	    result.put("resultCnt", resultCnt);
	    return result;
	}
	
	
}
