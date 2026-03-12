package com.prims.admin.usrMng;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.constant.Constant;
import com.prims.common.web.ParamMap;

@Controller
@RequestMapping("/usrMng")
public class UsrMngController {

    @Inject
    @Named("UsrMngService")
    private UsrMngService usrMngService;

    // 회원 목록 화면
    @RequestMapping(value = "/viewUsrMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewUsrMng() {
        return "admin/usrMng/usrMng";
    }

    // 회원 목록 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getUsrList", method = RequestMethod.POST)
    public Map<String, Object> getUsrList(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<?> list = usrMngService.getSelectUsrList(paramMap);
            result.put("DATA", list);
        } catch (Exception e) {
            result.put("DATA", new ArrayList<>());
            e.printStackTrace();
        }
        return result;
    }

    // 회원 상세 화면
    @RequestMapping(value = "/viewUsrWrite", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewUsrWrite(@ParamMap Map<String, Object> paramMap, Model model) {
        String usrCd = (String) paramMap.get("usrCd");
        if (usrCd != null && !usrCd.isEmpty()) {
            Map<String, Object> usr = usrMngService.getSelectUsrDetail(paramMap);
            model.addAttribute("usr", usr);
        }
        return "admin/usrMng/usrWrite";
    }

    // 회원 수정
    @ResponseBody
    @RequestMapping(value = "/updateUsr", method = RequestMethod.POST)
    public Map<String, Object> updateUsr(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = usrMngService.updateUsr(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 회원 삭제
    @ResponseBody
    @RequestMapping(value = "/deleteUsr", method = RequestMethod.POST)
    public Map<String, Object> deleteUsr(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = usrMngService.deleteUsr(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 비밀번호 초기화
    @ResponseBody
    @RequestMapping(value = "/resetPassword", method = RequestMethod.POST)
    public Map<String, Object> resetPassword(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = usrMngService.resetPassword(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
            if (cnt > 0) {
                result.put("message", "비밀번호가 'primus1234'로 초기화되었습니다.");
            }
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 내 비밀번호 변경
    @ResponseBody
    @RequestMapping(value = "/changeMyPassword", method = RequestMethod.POST)
    public Map<String, Object> changeMyPassword(@ParamMap Map<String, Object> paramMap, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 세션에서 로그인 사용자 정보 가져오기
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            if (loginUser == null) {
                result.put("result", Constant.FAIL);
                result.put("message", "로그인 정보가 없습니다.");
                return result;
            }

            paramMap.put("usrCd", loginUser.get("usrCd"));
            int cnt = usrMngService.changeMyPassword(paramMap);

            if (cnt > 0) {
                result.put("result", Constant.OK);
            } else {
                result.put("result", Constant.FAIL);
                result.put("message", "현재 비밀번호가 일치하지 않습니다.");
            }
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
