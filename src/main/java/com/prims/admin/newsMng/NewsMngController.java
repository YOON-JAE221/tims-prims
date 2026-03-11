package com.prims.admin.newsMng;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping("/newsMng")
public class NewsMngController {

    @Autowired
    private NewsMngDao newsMngDao;

    /**
     * 뉴스 관리 화면
     */
    @RequestMapping(value = "/viewNewsMng", method = RequestMethod.GET)
    public String viewNewsMng(Model model) {
        return "admin/newsMng/newsMng";
    }

    /**
     * 뉴스 목록 조회 (그리드용)
     */
    @RequestMapping(value = "/getNewsList", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getNewsList(@RequestParam Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = newsMngDao.getSelectNewsList(paramMap);
            result.put("DATA", list);
            result.put("result", "OK");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 뉴스 멀티저장 (TG.save용 - mergeRows)
     */
    @RequestMapping(value = "/saveNewsList", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveNewsList(@RequestParam("mergeRows") String mergeRowsJson, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            String sessionId = (String) session.getAttribute("USR_CD");
            if (sessionId == null) sessionId = "admin";

            ObjectMapper om = new ObjectMapper();
            List<Map<String, Object>> rows = om.readValue(mergeRowsJson,
                    om.getTypeFactory().constructCollectionType(List.class, Map.class));

            int cnt = 0;
            for (Map<String, Object> row : rows) {
                row.put("sessionId", sessionId);

                // 신규: newsCd 없으면 UUID 생성
                if (row.get("newsCd") == null || "".equals(row.get("newsCd"))) {
                    row.put("newsCd", UUID.randomUUID().toString().replace("-", ""));
                    newsMngDao.insertNews(row);
                } else {
                    newsMngDao.updateNews(row);
                }
                cnt++;
            }
            result.put("resultCnt", cnt);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("resultCnt", 0);
            result.put("Message", e.getMessage());
        }
        return result;
    }

    /**
     * 뉴스 삭제
     */
    @RequestMapping(value = "/deleteNews", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteNews(@RequestParam Map<String, Object> paramMap, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            String sessionId = (String) session.getAttribute("USR_CD");
            if (sessionId == null) sessionId = "admin";
            paramMap.put("sessionId", sessionId);

            int cnt = newsMngDao.deleteNews(paramMap);
            result.put("resultCnt", cnt);
            result.put("result", "OK");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("resultCnt", 0);
            result.put("result", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }
}
