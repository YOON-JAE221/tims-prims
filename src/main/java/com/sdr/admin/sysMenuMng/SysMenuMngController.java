package com.sdr.admin.sysMenuMng;

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
@RequestMapping("/sysMenuMng")
public class SysMenuMngController {

    @Inject
    @Named("SysMenuMngService")
    private SysMenuMngService sysMenuMngService;

    // 메뉴관리 화면
    @RequestMapping(value = "/viewSysMenuMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewSysMenuMng(Model model) {
        // 게시판 콤보 데이터
        List<Map<String, Object>> brdList = sysMenuMngService.getSelectBbsBrdCombo(new HashMap<>());
        model.addAttribute("brdList", brdList);
        return "admin/sysMenuMng/sysMenuMng";
    }

    // 메뉴 리스트 조회 (AJAX - 트리용)
    @ResponseBody
    @RequestMapping(value = "/getSelectSysMenuList")
    public Map<String, Object> getSelectSysMenuList(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            List<?> list = sysMenuMngService.getSelectSysMenuList(paramMap);
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

    // 메뉴 저장
    @ResponseBody
    @RequestMapping(value = "/saveSysMenu", method = RequestMethod.POST)
    public Map<String, Object> saveSysMenu(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            // 신규일 때 메뉴코드 중복 체크
            String isEditMode = (String) paramMap.get("isEditMode");
            if (!"Y".equals(isEditMode)) {
                int cnt = sysMenuMngService.getCountBySysMenuCd(paramMap);
                if (cnt > 0) {
                    result.put("result", Constant.FAIL);
                    result.put("message", "이미 존재하는 메뉴코드입니다.");
                    return result;
                }
            }

            int cnt = sysMenuMngService.saveSysMenu(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    // 메뉴 삭제
    @ResponseBody
    @RequestMapping(value = "/deleteSysMenu", method = RequestMethod.POST)
    public Map<String, Object> deleteSysMenu(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = sysMenuMngService.deleteSysMenu(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
