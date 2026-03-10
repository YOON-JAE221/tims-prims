package com.prims.admin.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin")
public class MainController {

    @Autowired
    private MainDao mainDao;

    /**
     * BO 메인 대시보드
     */
    @RequestMapping(value = "/main", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewMain(Model model) {
        // 매물 현황 요약
        Map<String, Object> propSummary = mainDao.getPropSummary();
        model.addAttribute("propSummary", propSummary);

        // 문의 현황 요약
        Map<String, Object> qna = mainDao.getQnaSummary();
        model.addAttribute("qna", qna);

        return "admin/main/index";
    }

    /**
     * 최근 등록 매물 목록 (AJAX)
     */
    @RequestMapping(value = "/getRecentPropList", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getRecentPropList() {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> list = mainDao.getRecentPropList();
        result.put("data", list);
        return result;
    }

    /**
     * 인기 매물 TOP 5 (AJAX)
     */
    @RequestMapping(value = "/getTopPropList", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getTopPropList() {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> list = mainDao.getTopPropList();
        result.put("data", list);
        return result;
    }

    /**
     * 최근 문의 목록 (AJAX)
     */
    @RequestMapping(value = "/getRecentQnaList", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getRecentQnaList() {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> list = mainDao.getRecentQnaList();
        result.put("data", list);
        return result;
    }
}
