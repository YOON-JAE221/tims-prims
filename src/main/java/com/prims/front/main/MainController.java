package com.prims.front.main;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.prims.common.constant.Constant;

@Controller
public class MainController {

    @Inject
    @Named("MainService")
    private MainService mainService;

    @RequestMapping("/")
    public String viewMain(Model model) {

        // FO 활성 팝업 목록
        try {
            List<Map<String, Object>> popupList = mainService.getSelectActivePopList();
            model.addAttribute("popupList", popupList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "front/main/index";
    }
}
