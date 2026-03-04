package com.prims.common.config;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

@ControllerAdvice
public class CamelCaseAdvice implements ResponseBodyAdvice<Object> {

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType,
                                  MediaType contentType, Class<? extends HttpMessageConverter<?>> converterType,
                                  ServerHttpRequest request, ServerHttpResponse response) {

        if (body instanceof Map) {
            return convertMapKeys((Map<?, ?>) body);
        } else if (body instanceof List) {
            return ((List<?>) body).stream()
                    .map(item -> item instanceof Map ? convertMapKeys((Map<?, ?>) item) : item)
                    .collect(Collectors.toList());
        }

        return body;
    }

    private Map<String, Object> convertMapKeys(Map<?, ?> original) {
        Map<String, Object> result = new LinkedHashMap<>();
        for (Map.Entry<?, ?> entry : original.entrySet()) {
            String key = entry.getKey().toString();

            // ✅ 이미 camelCase이면 그대로 유지
            if (isCamelCase(key)) {
                result.put(key, entry.getValue());
            } else {
                result.put(toCamelCase(key), entry.getValue());
            }
        }
        return result;
    }

    private String toCamelCase(String input) {
        StringBuilder sb = new StringBuilder();
        boolean nextUpper = false;
        for (char c : input.toCharArray()) {
            if (c == '_') {
                nextUpper = true;
            } else {
                sb.append(nextUpper ? Character.toUpperCase(c) : Character.toLowerCase(c));
                nextUpper = false;
            }
        }
        return sb.toString();
    }

    // ✅ 대문자가 포함된 camelCase 확인 (예: resultCnt)
    private boolean isCamelCase(String str) {
        return str.matches(".*[A-Z].*");
    }
}
