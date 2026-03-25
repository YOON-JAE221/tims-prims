package com.prims.admin.main;

import java.util.ArrayList;
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

@Controller
@RequestMapping("/admin")
public class AdminMainController {

	@Inject
	@Named("AdminMainService")
	private AdminMainService adminMainService;

	// 모바일 차단 페이지
	@RequestMapping(value = "/mobileBlock", method = {RequestMethod.GET, RequestMethod.POST})
	public String mobileBlock() {
		return "admin/main/mobileBlock";
	}

	@RequestMapping(value = "/viewAdminMain", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewAdminMain(Model model) {

		try {
			// 매물 현황 요약
			Map<String, Object> propSummary = adminMainService.getPropSummary();
			model.addAttribute("propSummary", propSummary);
		} catch (Exception e) {
			model.addAttribute("propSummary", new HashMap<>());
		}

		try {
			// 문의 통계
			Map<String, Object> qnaSummary = adminMainService.getQnaSummary();
			model.addAttribute("qna", qnaSummary);
		} catch (Exception e) {
			model.addAttribute("qna", new HashMap<>());
		}

		return "admin/main/index";
	}

	// 최근 등록 매물 목록 (AJAX)
	@ResponseBody
	@RequestMapping(value = "/getRecentPropList", method = RequestMethod.POST)
	public Map<String, Object> getRecentPropList(@RequestParam Map<String, Object> paramMap) {
		Map<String, Object> result = new HashMap<>();
		try {
			List<?> list = adminMainService.getRecentPropList(paramMap);
			result.put("data", list);
		} catch (Exception e) {
			result.put("data", new ArrayList<>());
		}
		return result;
	}

	// 인기 매물 TOP 5 (AJAX)
	@ResponseBody
	@RequestMapping(value = "/getTopPropList", method = RequestMethod.POST)
	public Map<String, Object> getTopPropList() {
		Map<String, Object> result = new HashMap<>();
		try {
			List<?> list = adminMainService.getTopPropList();
			result.put("data", list);
		} catch (Exception e) {
			result.put("data", new ArrayList<>());
		}
		return result;
	}

	// 최근 문의 목록 (AJAX)
	@ResponseBody
	@RequestMapping(value = "/getRecentQnaList", method = RequestMethod.POST)
	public Map<String, Object> getRecentQnaList() {
		Map<String, Object> result = new HashMap<>();
		try {
			List<?> list = adminMainService.getRecentQnaList();
			result.put("data", list);
		} catch (Exception e) {
			result.put("data", new ArrayList<>());
		}
		return result;
	}
}
