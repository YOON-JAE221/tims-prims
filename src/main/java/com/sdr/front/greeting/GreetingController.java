package com.sdr.front.greeting;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sdr.common.constant.Constant;

@Controller
@RequestMapping("/greeting")
public class GreetingController {

	@Inject
	@Named("GreetingService")
	private GreetingService greetingService;
	
	@RequestMapping("/viewGreeting")
	public String viewGreeting(Model model) {

		Map<String, Object> param = new HashMap<>();

	    param.put("brdCd", Constant.BRD_CD_GREETING);

	    Map<String, Object> map = greetingService.selectGreetingPost(param);

	    // 화면에서 ${pstCnts}로 출력할 값
	    String pstCnts = (map == null) ? "" : String.valueOf(map.getOrDefault("pstCnts", ""));
	    model.addAttribute("pstCnts", pstCnts);
	    model.addAttribute("pstCd", map.get("pstCd").toString());

	    return "front/greeting/greeting";
	}
	
}
