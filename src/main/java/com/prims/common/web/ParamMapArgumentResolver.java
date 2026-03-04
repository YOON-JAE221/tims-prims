package com.prims.common.web;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

public class ParamMapArgumentResolver implements HandlerMethodArgumentResolver {

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(ParamMap.class)
                && Map.class.isAssignableFrom(parameter.getParameterType());
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) {

        HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
        HttpSession session = request.getSession(false);

        Map<String, Object> paramMap = new HashMap<>();

        // request param -> Map
        Map<String, String[]> reqMap = request.getParameterMap();
        for (Map.Entry<String, String[]> e : reqMap.entrySet()) {
            String key = e.getKey();
            String[] val = e.getValue();
            if (val == null) {
                paramMap.put(key, null);
            } else if (val.length == 1) {
                paramMap.put(key, val[0]);
            } else {
                paramMap.put(key, Arrays.asList(val));
            }
        }

        // 세션 ssnUsrCd 자동 주입
        if (session != null) {
            Object ssn = session.getAttribute("ssnUsrCd");
            if (ssn != null) {
                String v = String.valueOf(ssn).trim();
                if (!v.isEmpty() && !"null".equalsIgnoreCase(v)) {
                    paramMap.put("ssnUsrCd", v);
                }
            }
        }

        // 세션 ssnUsrNm 자동 주입
        if (session != null) {
            Object ssn = session.getAttribute("ssnUsrNm");
            if (ssn != null) {
                String v = String.valueOf(ssn).trim();
                if (!v.isEmpty() && !"null".equalsIgnoreCase(v)) {
                    paramMap.put("ssnUsrNm", v);
                }
            }
        }

        // 세션 ssnLoginId 자동 주입
        if (session != null) {
            Object ssn = session.getAttribute("ssnLoginId");
            if (ssn != null) {
                String v = String.valueOf(ssn).trim();
                if (!v.isEmpty() && !"null".equalsIgnoreCase(v)) {
                    paramMap.put("ssnLoginId", v);
                }
            }
        }

        return paramMap;
    }

}
