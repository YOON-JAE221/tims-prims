package com.sdr.admin.popMng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
@RequestMapping("/popMng")
public class PopMngController {

    @Inject
    @Named("PopMngService")
    private PopMngService popMngService;

    // 팝업관리 리스트 화면
    @RequestMapping(value = "/viewPopMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPopMng(Model model) {
        return "admin/popMng/popMng";
    }

    // 팝업 리스트 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSelectPopList")
    public Map<String, Object> getSelectPopList(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<?> list = popMngService.getSelectPopList(paramMap);
            result.put("DATA", list);
            result.put("resultCnt", 1);
        } catch (Exception e) {
            result.put("DATA", new ArrayList<>());
            result.put("resultCnt", 0);
            e.printStackTrace();
        }
        return result;
    }

    // 팝업 단건 조회 (AJAX - 미리보기용)
    @ResponseBody
    @RequestMapping(value = "/getSelectPopOne")
    public Map<String, Object> getSelectPopOne(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> detail = popMngService.getSelectPopOne(paramMap);
            result.put("DATA", detail);
            result.put("resultCnt", detail != null ? 1 : 0);
        } catch (Exception e) {
            result.put("resultCnt", 0);
            e.printStackTrace();
        }
        return result;
    }

    // 팝업 상세/등록 화면
    @RequestMapping(value = "/viewPopWrite", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPopWrite(@ParamMap Map<String, Object> paramMap, Model model) {
        String popCd = (String) paramMap.get("popCd");
        if (popCd != null && !popCd.isEmpty()) {
            Map<String, Object> detail = popMngService.getSelectPopOne(paramMap);
            model.addAttribute("detail", detail);
        }
        return "admin/popMng/popWrite";
    }

    // 팝업 저장
    @ResponseBody
    @RequestMapping(value = "/savePop", method = RequestMethod.POST)
    public Map<String, Object> savePop(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 신규: UUID 생성
            String popCd = (String) paramMap.get("popCd");
            if (popCd == null || popCd.isEmpty()) {
                popCd = UUID.randomUUID().toString().replace("-", "");
                paramMap.put("popCd", popCd);
            }

            int cnt = popMngService.savePop(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
            result.put("popCd", popCd);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    // 팝업 삭제
    @ResponseBody
    @RequestMapping(value = "/deletePop", method = RequestMethod.POST)
    public Map<String, Object> deletePop(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = popMngService.deletePop(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
