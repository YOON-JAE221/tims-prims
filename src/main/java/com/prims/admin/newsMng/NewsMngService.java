package com.prims.admin.newsMng;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("NewsMngService")
public class NewsMngService {

    @Autowired
    private NewsMngDao newsMngDao;

    // 뉴스 목록 조회
    public List<Map<String, Object>> getSelectNewsList(Map<String, Object> paramMap) {
        return newsMngDao.getSelectNewsList(paramMap);
    }

    // 뉴스 등록
    public int insertNews(Map<String, Object> paramMap) {
        paramMap.put("newsCd", UUID.randomUUID().toString().replace("-", ""));
        return newsMngDao.insertNews(paramMap);
    }

    // 뉴스 수정
    public int updateNews(Map<String, Object> paramMap) {
        return newsMngDao.updateNews(paramMap);
    }

    // 뉴스 삭제
    public int deleteNews(Map<String, Object> paramMap) {
        return newsMngDao.deleteNews(paramMap);
    }
}
