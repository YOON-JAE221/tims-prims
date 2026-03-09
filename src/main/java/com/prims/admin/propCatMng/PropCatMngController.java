package com.prims.admin.propCatMng;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.constant.Constant;

@Controller
@RequestMapping("/propCatMng")
public class PropCatMngController {

    @Autowired
    private PropCatMngDao propCatMngDao;

    // 매물코드관리 화면
    @RequestMapping(value = "/viewPropCatMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropCatMng(Model model) {
        List<Map<String, Object>> catList = propCatMngDao.getCatList();
        model.addAttribute("catList", catList);
        return "admin/propCatMng/propCatMng";
    }

    // 소분류 목록 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSubCatList", method = RequestMethod.POST)
    public Map<String, Object> getSubCatList(@RequestParam("catCd") String catCd) {
        Map<String, Object> result = new HashMap<>();
        result.put("list", propCatMngDao.getSubCatList(catCd));
        result.put("result", Constant.OK);
        return result;
    }

    // 대분류 저장 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/saveCat", method = RequestMethod.POST)
    public Map<String, Object> saveCat(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            propCatMngDao.saveCat(param);
            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 소분류 저장 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/saveSubCat", method = RequestMethod.POST)
    public Map<String, Object> saveSubCat(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 신규: 소분류코드 자동채번
            if (param.get("subCatCd") == null || "".equals(param.get("subCatCd"))) {
                String nextCd = propCatMngDao.getNextSubCatCd((String) param.get("catCd"));
                param.put("subCatCd", nextCd);
            }
            propCatMngDao.saveSubCat(param);
            result.put("result", Constant.OK);
            result.put("subCatCd", param.get("subCatCd"));
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 소분류 삭제 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/deleteSubCat", method = RequestMethod.POST)
    public Map<String, Object> deleteSubCat(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            propCatMngDao.deleteSubCat(param);
            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 대분류 삭제 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/deleteCat", method = RequestMethod.POST)
    public Map<String, Object> deleteCat(@RequestParam("catCd") String catCd) {
        Map<String, Object> result = new HashMap<>();
        try {
            propCatMngDao.deleteCat(catCd);
            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
