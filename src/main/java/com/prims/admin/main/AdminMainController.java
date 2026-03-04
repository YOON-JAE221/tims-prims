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
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin")
public class AdminMainController {

	@Inject
	@Named("AdminMainService")
	private AdminMainService adminMainService;

	@RequestMapping(value = "/viewAdminMain", method = {RequestMethod.GET, RequestMethod.POST})
	public String viewAdminMain(Model model) {

		try {
			// 문의 통계
			Map<String, Object> qnaSummary = adminMainService.getQnaSummary();
			model.addAttribute("qna", qnaSummary);
		} catch (Exception e) {
			model.addAttribute("qna", new HashMap<>());
		}

		return "admin/main/index";
	}

	// 최근 문의 목록 (AJAX)
	@ResponseBody
	@RequestMapping(value = "/getRecentQnaList")
	public Map<String, Object> getRecentQnaList() {
		Map<String, Object> result = new HashMap<>();
		try {
			List<?> list = adminMainService.getRecentQnaList();
			result.put("DATA", list);
		} catch (Exception e) {
			result.put("DATA", new ArrayList<>());
		}
		return result;
	}

	// 배치 현황 (AJAX)
	@ResponseBody
	@RequestMapping(value = "/getBatStatusList")
	public Map<String, Object> getBatStatusList() {
		Map<String, Object> result = new HashMap<>();
		try {
			List<?> list = adminMainService.getBatStatusList();
			result.put("DATA", list);
		} catch (Exception e) {
			result.put("DATA", new ArrayList<>());
		}
		return result;
	}
}
