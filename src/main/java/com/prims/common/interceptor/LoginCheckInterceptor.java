package com.prims.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class LoginCheckInterceptor implements HandlerInterceptor {

    // 모바일 User-Agent 패턴
    private static final String MOBILE_PATTERN = "(?i).*(android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini|mobile).*";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 1. 모바일 체크 (관리자 페이지 접근 차단)
        String userAgent = request.getHeader("User-Agent");
        if (userAgent != null && userAgent.matches(MOBILE_PATTERN)) {
            // AJAX 요청이면 401
            String xrw = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equalsIgnoreCase(xrw)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return false;
            }
            // 일반 요청이면 모바일 차단 페이지로
            response.sendRedirect(request.getContextPath() + "/admin/mobileBlock");
            return false;
        }

        // 2. 로그인 체크
        HttpSession session = request.getSession(false);
        String ssnUsrCd = (session == null) ? null : (String) session.getAttribute("ssnUsrCd");

        boolean notLoggedIn = (ssnUsrCd == null || ssnUsrCd.trim().isEmpty() || "null".equalsIgnoreCase(ssnUsrCd));
        if (!notLoggedIn) return true;

        // AJAX면 상태코드로
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