package com.prims.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.prims.common.config.AppProperties;

@Component
public class CommonInterceptor implements HandlerInterceptor {

    @Autowired
    private AppProperties appProperties;

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, 
                          Object handler, ModelAndView modelAndView) throws Exception {
        // JSP에서 사용할 siteUrl 설정
        request.setAttribute("siteUrl", appProperties.getSiteUrl());
    }
}
