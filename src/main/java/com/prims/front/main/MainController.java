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

    // 루트 URL 호출 → 바로 index.jsp
    @RequestMapping("/")
    public String viewMain(Model model) {

        // 엔지니어링 서비스 (8개 게시판 통합, 조회수 DESC, 9건)
        List<Map<String, Object>> engList = mainService.getSelectMainEngList();
        model.addAttribute("engList", engList);

        // brdCd 상수 전달 (isotope 필터용)
        model.addAttribute("BRD_CD_STRA", Constant.BRD_CD_STRA);
        model.addAttribute("BRD_CD_STRE", Constant.BRD_CD_STRE);
        model.addAttribute("BRD_CD_DISE", Constant.BRD_CD_DISE);
        model.addAttribute("BRD_CD_SAFE", Constant.BRD_CD_SAFE);
        model.addAttribute("BRD_CD_SPFE", Constant.BRD_CD_SPFE);
        model.addAttribute("BRD_CD_TERE", Constant.BRD_CD_TERE);
        model.addAttribute("BRD_CD_VERA", Constant.BRD_CD_VERA);
        model.addAttribute("BRD_CD_SDSE", Constant.BRD_CD_SDSE);

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
