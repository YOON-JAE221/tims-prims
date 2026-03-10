package com.prims.admin.main;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MainDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NAMESPACE = "adminMain.";

    /**
     * 매물 현황 요약
     */
    public Map<String, Object> getPropSummary() {
        return sqlSession.selectOne(NAMESPACE + "getPropSummary");
    }

    /**
     * 문의 현황 요약
     */
    public Map<String, Object> getQnaSummary() {
        return sqlSession.selectOne(NAMESPACE + "getQnaSummary");
    }

    /**
     * 최근 등록 매물 목록
     */
    public List<Map<String, Object>> getRecentPropList() {
        return sqlSession.selectList(NAMESPACE + "getRecentPropList");
    }

    /**
     * 인기 매물 TOP 5
     */
    public List<Map<String, Object>> getTopPropList() {
        return sqlSession.selectList(NAMESPACE + "getTopPropList");
    }

    /**
     * 최근 문의 목록
     */
    public List<Map<String, Object>> getRecentQnaList() {
        return sqlSession.selectList(NAMESPACE + "getRecentQnaList");
    }
}
