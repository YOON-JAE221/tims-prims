package com.prims.front.main;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MainController {

    @Inject
    @Named("MainService")
    private MainService mainService;

    @RequestMapping(value = "/", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewMain(Model model) {

        // FO 활성 팝업 목록
        try {
            List<Map<String, Object>> popupList = mainService.getSelectActivePopList();
            model.addAttribute("popupList", popupList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // FO 메인 뉴스 목록
        try {
            List<Map<String, Object>> newsList = mainService.getSelectMainNewsList();
            model.addAttribute("newsList", newsList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "front/main/index";
    }
}
