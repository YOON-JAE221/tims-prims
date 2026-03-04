package com.prims.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class LoginCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false); // 세션 없으면 만들지 않음
        String ssnUsrCd = (session == null) ? null : (String) session.getAttribute("ssnUsrCd");

        boolean notLoggedIn = (ssnUsrCd == null || ssnUsrCd.trim().isEmpty() || "null".equalsIgnoreCase(ssnUsrCd));
        if (!notLoggedIn) return true;

        // AJAX면 redirect 말고 상태코드로 (선택)
        String xrw = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(xrw)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }

        // 홈으로 튕기기
        response.sendRedirect(request.getContextPath() + "/");
        return false;
    }
}