package com.prims.common.interceptor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class MenuInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        
//        String uri = request.getRequestURI();
//        String uri = request.getRequestURI().replaceFirst(request.getContextPath(), "");
//        if (Utility.isAjaxOrDataRequest(uri)) {
//            return true;
//        }
        
//        Map<String, Object> paramMap = new HashMap<>();
//        
//    	if (uri.startsWith("/admin")) {
//    	    // 관리자 메뉴 처리
//    		paramMap.put("menuSysDiv", "A");
//    	} else {
//    	    // 사용자 메뉴 처리
//    		paramMap.put("menuSysDiv", "F");
//    	}
//    	
//        List<?> menuList = menuMngService.getMenuNaviTreeList(paramMap);
//        session.setAttribute("menuList", menuList);
        return true;
    }
  
    
}
