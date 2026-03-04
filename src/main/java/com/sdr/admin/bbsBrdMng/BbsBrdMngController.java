package com.sdr.admin.bbsBrdMng;

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

import com.sdr.common.constant.Constant;
import com.sdr.common.web.ParamMap;

@Controller
@RequestMapping("/bbsBrdMng")
public class BbsBrdMngController {

    @Inject
    @Named("BbsBrdMngService")
    private BbsBrdMngService bbsBrdMngService;

    // 게시판관리 리스트 화면
    @RequestMapping(value = "/viewBbsBrdMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewBbsBrdMng(Model model) {
        return "admin/bbsBrdMng/bbsBrdMng";
    }

    // 게시판 신규/수정 화면
    @RequestMapping(value = "/viewBbsBrdWrite", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewBbsBrdWrite(@ParamMap Map<String, Object> paramMap, Model model) {

        String brdCd = String.valueOf(paramMap.getOrDefault("brdCd", ""));
        if (!brdCd.isEmpty() && !"null".equals(brdCd)) {
            Map<String, Object> brd = bbsBrdMngService.getSelectBbsBrdOne(paramMap);
            model.addAttribute("brd", brd);
        }
        return "admin/bbsBrdMng/bbsBrdWrite";
    }

    // 게시판 저장
    @ResponseBody
    @RequestMapping(value = "/saveBbsBrd", method = RequestMethod.POST)
    public Map<String, Object> saveBbsBrd(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            // 신규일 때 UUID 생성
            String brdCd = String.valueOf(paramMap.getOrDefault("brdCd", ""));
            if (brdCd.isEmpty() || "null".equals(brdCd)) {
                paramMap.put("brdCd", java.util.UUID.randomUUID().toString().replace("-", ""));
            }
            int cnt = bbsBrdMngService.saveBbsBrd(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 게시판 리스트 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSelectBbsBrdList")
    public Map<String, Object> getSelectBbsBrdList(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            List<?> list = bbsBrdMngService.getSelectBbsBrdList(paramMap);
            result.put("DATA", list);
            result.put("resultCnt", 1);
        } catch (Exception e) {
            result.put("DATA", new ArrayList<>());
            result.put("Message", "조회에 실패하였습니다.");
            result.put("resultCnt", 0);
            e.printStackTrace();
        }
        return result;
    }
}
