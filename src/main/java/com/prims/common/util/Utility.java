package com.prims.common.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Utility{

    // 🔸 예외 처리할 키워드 목록 (AJAX, 데이터 처리 관련 요청)
    private static final List<String> EXCLUDE_PATTERNS = Arrays.asList(
            "/get", "/select", "/save", "/delete", "/update", "/insert", "/ajax", "/api", "/getSelect"
    );

    /**
     * 인터셉터에서 메뉴 세팅을 제외할 URI인지 여부 판단
     */
    public static boolean isAjaxOrDataRequest(String uri) {
        for (String pattern : EXCLUDE_PATTERNS) {
            if (uri.contains(pattern)) return true;
        }
        return false;
    }
    
    
    /**
     * 그리드 MERGEROW 변환
     * - 1) mergeRows[0].field=... (기존 방식)
     * - 2) mergeRows=[{...},{...}] (JSON 문자열 방식)
     */
    public static List<Map<String, Object>> convertRequestParamToList(HttpServletRequest request, String keyName) {
        // 1) ✅ 기존 방식(mergeRows[0].xxx) 파라미터가 하나라도 있으면 기존 로직 수행
        String prefix0 = keyName + "[0].";
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String n = names.nextElement();
            if (n.startsWith(prefix0)) {
                return parseIndexedParams(request, keyName);
            }
        }

        // 2) ✅ JSON 문자열 방식: mergeRows = "[{...},{...}]"
        String json = request.getParameter(keyName);
        if (json == null || json.trim().isEmpty()) return new ArrayList<>();

        json = json.trim();

        // 혹시 "mergeRows=[...]"처럼 들어온 케이스 방어(로그에 그렇게 찍힌 적 있으면)
        if (json.startsWith(keyName + "=")) {
            json = json.substring((keyName + "=").length()).trim();
        }

        // JSON 배열/객체가 아니면 실패 처리
        if (!(json.startsWith("[") || json.startsWith("{"))) {
            return new ArrayList<>();
        }

        try {
            ObjectMapper om = new ObjectMapper();

            // 배열이면 그대로 List<Map>
            List<Map<String, Object>> list;
            if (json.startsWith("[")) {
                list = om.readValue(json, new TypeReference<List<Map<String, Object>>>() {});
            } else {
                // 객체면 1건으로 감싸기(혹시 단건으로 올 때)
                Map<String, Object> one = om.readValue(json, new TypeReference<Map<String, Object>>() {});
                list = new ArrayList<>();
                list.add(one);
            }

            // ✅ "" 또는 공백 문자열은 null로 변환(기존 동작 유지)
            for (Map<String, Object> row : list) {
                if (row == null) continue;
                for (Map.Entry<String, Object> e : new ArrayList<>(row.entrySet())) {
                    Object v = e.getValue();
                    if (v instanceof String) {
                        String s = ((String) v).trim();
                        if (s.isEmpty()) row.put(e.getKey(), null);
                        else row.put(e.getKey(), s);
                    }
                }
            }

            return list;

        } catch (Exception e) {
            // 파싱 실패 시 빈 리스트(또는 RuntimeException 던져도 됨)
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // 기존 방식 그대로 분리
    private static List<Map<String, Object>> parseIndexedParams(HttpServletRequest request, String keyName) {
        List<Map<String, Object>> list = new ArrayList<>();
        int idx = 0;

        while (true) {
            String prefix = keyName + "[" + idx + "].";
            boolean exists = false;
            Map<String, Object> item = new HashMap<>();

            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                if (paramName.startsWith(prefix)) {
                    exists = true;
                    String fieldName = paramName.substring(prefix.length());
                    String value = request.getParameter(paramName);

                    if (value != null && value.trim().equals("")) item.put(fieldName, null);
                    else item.put(fieldName, value);
                }
            }

            if (!exists) break;
            list.add(item);
            idx++;
        }

        return list;
    }
    
    /**
     * MySQL: REPLACE(UUID(), '-', '')
     * - 하이픈 없는 32자리 UUID 문자열 반환
     */
    public static String getUuidPk32() {
        return UUID.randomUUID().toString().replace("-", "");
    }
    
    /**
     * 페이징 공통 처리
     * - paramMap에서 pageNo 꺼내서 offset, pageSize 세팅
     * - 결과 Map에 페이징 정보 담아서 반환
     *
     * @param paramMap  요청 파라미터 (pageNo 포함)
     * @param totalCnt  총 건수
     * @return 페이징 정보 Map (pageNo, pageSize, offset, totalPage, startPage, endPage, totalCnt)
     */
    public static Map<String, Object> getPagingMap(Map<String, Object> paramMap, int totalCnt) {
        int pageSize = 0;
        int blockSize = 5;

        int pageNo = 1;
        try {
            pageNo = Integer.parseInt(String.valueOf(paramMap.getOrDefault("pageNo", "1")));
            pageSize = Integer.parseInt(String.valueOf(paramMap.getOrDefault("pageSize", "10")));
        } catch (Exception e) {}
        if (pageSize < 1) pageSize = 10;
        if (pageNo < 1) pageNo = 1;

        int totalPage = (int) Math.ceil((double) totalCnt / pageSize);
        if (totalPage < 1) totalPage = 1;
        if (pageNo > totalPage) pageNo = totalPage;

        int offset = (pageNo - 1) * pageSize;
        int startPage = ((pageNo - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        // paramMap에 쿼리용 세팅
        paramMap.put("pageSize", pageSize);
        paramMap.put("offset", offset);

        // 결과
        Map<String, Object> paging = new HashMap<>();
        paging.put("pageNo", pageNo);
        paging.put("pageSize", pageSize);
        paging.put("offset", offset);
        paging.put("totalCnt", totalCnt);
        paging.put("totalPage", totalPage);
        paging.put("startPage", startPage);
        paging.put("endPage", endPage);

        return paging;
    }
    
    public static String extractFirstImgSrc(String html) {
        if (html == null || html.isEmpty()) return null;
        // 정규식으로 첫 번째 img src 추출
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(
            "<img[^>]+src\\s*=\\s*[\"']([^\"']+)[\"']", 
            java.util.regex.Pattern.CASE_INSENSITIVE
        );
        java.util.regex.Matcher m = p.matcher(html);
        if (m.find()) {
            return m.group(1);
        }
        return null;
    }
    
}