package com.prims.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.prims.common.config.SysConfigDao;
import com.prims.common.constant.Constant;

/**
 * 사이트 접속코드 인터셉터
 * - TB_SYS_CONFIG에서 SITE_ACCESS_CODE의 USE_YN = 'Y'일 때만 동작
 */
@Component
public class AccessCodeInterceptor implements HandlerInterceptor {

    public static final String SESSION_ACCESS_KEY = "SITE_ACCESS_VERIFIED";

    @Autowired
    private SysConfigDao sysConfigDao;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        // 관리자 로그인 상태이면 무조건 통과
        if (session.getAttribute(Constant.SESSION_LOGIN_USER) != null) {
            return true;
        }

        // 이미 인증된 세션이면 통과
        if ("Y".equals(session.getAttribute(SESSION_ACCESS_KEY))) {
            return true;
        }

        // USE_YN = 'Y' 인지 체크 (접근 제한 활성화 여부)
        try {
            int cnt = sysConfigDao.isAccessRequired(Constant.CFG_SITE_ACCESS_CODE);
            if (cnt == 0) {
                // USE_YN = 'N' 이거나 데이터 없음 → 누구나 접속 가능
                return true;
            }
        } catch (Exception e) {
            // 테이블 없거나 오류 시 통과 (사이트 접속 차단 방지)
            return true;
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
