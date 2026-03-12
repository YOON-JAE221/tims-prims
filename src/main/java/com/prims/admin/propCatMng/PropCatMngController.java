package com.prims.admin.propCatMng;

import java.util.HashMap;
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

    // 카테고리관리 화면
    @RequestMapping(value = "/viewPropCatMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropCatMng(Model model) {
        return "admin/propCatMng/propCatMng";
    }

    // 카테고리 전체 목록 조회 (AJAX - 트리용)
    @ResponseBody
    @RequestMapping(value = "/getCatList", method = RequestMethod.POST)
    public Map<String, Object> getCatList() {
        Map<String, Object> result = new HashMap<>();
        result.put("DATA", propCatMngDao.getCatList());
        result.put("result", Constant.OK);
        return result;
    }

    // 카테고리 저장 (AJAX)
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

    // 카테고리 삭제 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/deleteCat", method = RequestMethod.POST)
    public Map<String, Object> deleteCat(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            propCatMngDao.deleteCat(param);
            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 다음 카테고리코드 자동채번 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getNextCatCd", method = RequestMethod.POST)
    public Map<String, Object> getNextCatCd(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        String nextCd = propCatMngDao.getNextCatCd(param);
        result.put("catCd", nextCd);
        result.put("result", Constant.OK);
        return result;
    }
}
