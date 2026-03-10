package com.prims.front.main;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.prims.common.constant.Constant;
import com.prims.front.property.PropertySearchDao;

@Controller
public class MainController {

    @Inject
    @Named("MainService")
    private MainService mainService;

    @Autowired
    private PropertySearchDao propertySearchDao;

    @RequestMapping(value = "/", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewMain(Model model) {

        // FO 활성 팝업 목록
        try {
            List<Map<String, Object>> popupList = mainService.getSelectActivePopList();
            model.addAttribute("popupList", popupList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Slide 1: 추천매물 (RECOMMEND + MAIN_YN=Y)
        try {
            Map<String, Object> sliderProp = propertySearchDao.getMainSliderProperty();
            model.addAttribute("sliderProp", sliderProp);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Slide 2: 인기매물 (조회수 높은 순, 거래중 1건)
        try {
            Map<String, Object> latestProp = propertySearchDao.getMainLatestProperty();
            model.addAttribute("latestProp", latestProp);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Slide 3: 급매매물 (URGENT + MAIN_YN=Y)
        try {
            Map<String, Object> urgentProp = propertySearchDao.getMainUrgentProperty();
            model.addAttribute("urgentProp", urgentProp);
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
