package com.prims.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.prims.common.config.SysConfigDao;

@Component
public class AccessCodeInterceptor implements HandlerInterceptor {

    public static final String SESSION_ACCESS_KEY = "ACCESS_CODE_VERIFIED";
    public static final String CONFIG_KEY = "SITE_ACCESS_CODE";

    @Autowired
    private SysConfigDao sysConfigDao;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        // 이미 인증된 세션이면 통과
        if ("Y".equals(session.getAttribute(SESSION_ACCESS_KEY))) {
            return true;
        }

        // DB에서 접속코드 조회 (빈 값이면 기능 비활성 → 통과)
        String accessCode = null;
        try {
            accessCode = sysConfigDao.getConfigValue(CONFIG_KEY);
        } catch (Exception e) {
            // 테이블 없거나 오류 시 통과 (사이트 접속 차단 방지)
            return true;
        }

        if (accessCode == null || accessCode.trim().isEmpty()) {
            return true; // 코드 미설정 → 누구나 접속 가능
        }

        // AJAX 요청이면 401
        String xrw = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(xrw)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }

        // 접속코드 입력 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/accessCode");
        return false;
    }
}
