package com.prims.front.main;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.prims.common.constant.Constant;
import com.prims.front.property.PropertySearchDao;

@Controller
public class MainController {

    @Inject
    @Named("MainService")
    private MainService mainService;

    @Autowired
    private PropertySearchDao propertySearchDao;

    @RequestMapping("/")
    public String viewMain(Model model) {

        // FO 활성 팝업 목록
        try {
            List<Map<String, Object>> popupList = mainService.getSelectActivePopList();
            model.addAttribute("popupList", popupList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 메인 슬라이더 매물 (MAIN_YN=Y, 최신 1건)
        try {
            Map<String, Object> sliderProp = propertySearchDao.getMainSliderProperty();
            model.addAttribute("sliderProp", sliderProp);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 추천매물 (RECOMMEND+URGENT, 최신 3건)
        try {
            List<Map<String, Object>> featuredList = propertySearchDao.getMainFeaturedList();
            model.addAttribute("featuredList", featuredList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "front/main/index";
    }
}
