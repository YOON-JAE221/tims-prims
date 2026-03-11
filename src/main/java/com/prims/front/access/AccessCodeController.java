package com.prims.front.access;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.config.SysConfigDao;
import com.prims.common.constant.Constant;
import com.prims.common.interceptor.AccessCodeInterceptor;

@Controller
public class AccessCodeController {

    @Autowired
    private SysConfigDao sysConfigDao;

    // 접속코드 입력 페이지
    @RequestMapping(value = "/accessCode", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewAccessCode(HttpSession session) {
        // 이미 인증된 경우 메인으로
        if ("Y".equals(session.getAttribute(AccessCodeInterceptor.SESSION_ACCESS_KEY))) {
            return "redirect:/";
        }
        return "front/access/accessCode";
    }

    // 접속코드 확인 (AJAX) - 암호화 비교
    @ResponseBody
    @RequestMapping(value = "/verifyAccessCode", method = RequestMethod.POST)
    public Map<String, Object> verifyAccessCode(@RequestParam("code") String code, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        try {
            Map<String, Object> param = new HashMap<>();
            param.put("configKey", Constant.CFG_SITE_ACCESS_CODE);
            param.put("accessCode", code.trim());
            param.put("encryptKey", Constant.ENCRYPT_KEY);

            int cnt = sysConfigDao.verifyAccessCode(param);

            if (cnt > 0) {
                session.setAttribute(AccessCodeInterceptor.SESSION_ACCESS_KEY, "Y");
                result.put("result", "OK");
            } else {
                result.put("result", "FAIL");
                result.put("message", "접속코드가 올바르지 않습니다.");
            }
        } catch (Exception e) {
            result.put("result", "FAIL");
            result.put("message", "오류가 발생했습니다.");
        }

        return result;
    }
}
