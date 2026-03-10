package com.prims.admin.propertyMng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.prims.common.constant.Constant;
import com.prims.common.web.ParamMap;

@Controller
@RequestMapping("/propertyMng")
public class PropertyMngController {

    @Inject
    @Named("PropertyMngService")
    private PropertyMngService propertyMngService;

    // 매물 목록 화면
    @RequestMapping(value = "/viewPropertyMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertyMng(@ParamMap Map<String, Object> paramMap, Model model) {
        String catCd = (String) paramMap.get("catCd");
        if (catCd != null && !catCd.isEmpty()) {
            model.addAttribute("initCatCd", catCd);
        }
        // 검색조건 초기값
        String soldYn = (String) paramMap.get("soldYn");
        String badgeType = (String) paramMap.get("badgeType");
        if (soldYn != null && !soldYn.isEmpty()) {
            model.addAttribute("initSoldYn", soldYn);
        }
        if (badgeType != null && !badgeType.isEmpty()) {
            model.addAttribute("initBadgeType", badgeType);
        }
        // 대분류 목록
        model.addAttribute("catList", propertyMngService.getCatListForSelect());
        return "admin/propertyMng/propertyMng";
    }

    // 매물 목록 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSelectPropertyList")
    public Map<String, Object> getSelectPropertyList(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<?> list = propertyMngService.getSelectPropertyList(paramMap);
            result.put("DATA", list);
            result.put("resultCnt", 1);
        } catch (Exception e) {
            result.put("DATA", new ArrayList<>());
            result.put("Message", "조회에 실패하였습니다.");
            e.printStackTrace();
        }
        return result;
    }

    // 매물 등록/수정 화면
    @RequestMapping(value = "/viewPropertyWrite", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertyWrite(@ParamMap Map<String, Object> paramMap, Model model) {
        String propCd = (String) paramMap.get("propCd");
        if (propCd != null && !propCd.isEmpty()) {
            Map<String, Object> prop = propertyMngService.getSelectPropertyDetail(paramMap);
            model.addAttribute("prop", prop);

            // 첨부파일
            String atchFileKey = String.valueOf(prop.getOrDefault("atchFileKey", ""));
            if (!atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
                Map<String, Object> fileParam = new HashMap<>();
                fileParam.put("upldFileCd", atchFileKey);
                model.addAttribute("fileList", propertyMngService.getSelectUpldFileList(fileParam));
            }
        }
        // 대분류 목록
        model.addAttribute("catList", propertyMngService.getCatListForSelect());
        return "admin/propertyMng/propertyWrite";
    }

    // 소분류 목록 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSubCatList", method = RequestMethod.POST)
    public Map<String, Object> getSubCatList(@RequestParam("catCd") String catCd) {
        Map<String, Object> result = new HashMap<>();
        result.put("DATA", propertyMngService.getSubCatListForSelect(catCd));
        result.put("result", Constant.OK);
        return result;
    }

    // 매물 저장
    @RequestMapping(value = "/saveProperty", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveProperty(@ParamMap Map<String, Object> paramMap,
                                            @RequestParam(value = "atchFile", required = false) MultipartFile[] atchFile,
                                            @RequestParam(value = "deleteFiles", required = false) String[] deleteFiles) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = propertyMngService.saveProperty(paramMap, atchFile, deleteFiles);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
            result.put("propCd", paramMap.get("propCd"));
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 매물 삭제
    @RequestMapping(value = "/deleteProperty", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteProperty(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = propertyMngService.deleteProperty(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
            result.put("resultCnt", cnt);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 매물 복사
    @RequestMapping(value = "/copyProperty", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> copyProperty(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            String newPropCd = propertyMngService.copyProperty(paramMap);
            result.put("result", Constant.OK);
            result.put("newPropCd", newPropCd);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 매물 상태 멀티저장 (TG.save용)
    @ResponseBody
    @RequestMapping(value = "/savePropertySoldYnList", method = RequestMethod.POST)
    public Map<String, Object> savePropertySoldYnList(@RequestParam("mergeRows") String mergeRowsJson,
                                                      @ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
            List<Map<String, Object>> rows = om.readValue(mergeRowsJson,
                    om.getTypeFactory().constructCollectionType(List.class, Map.class));
            String ssnUsrCd = String.valueOf(paramMap.getOrDefault("ssnUsrCd", "ADMIN"));
            int cnt = propertyMngService.updatePropertySoldYnList(rows, ssnUsrCd);
            result.put("resultCnt", cnt);
        } catch (Exception e) {
            result.put("resultCnt", 0);
            result.put("Message", e.getMessage());
        }
        return result;
    }
}
