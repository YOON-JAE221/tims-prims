package com.prims.admin.main;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminMainDao {

    @Autowired
    private SqlSession sqlSession;

    /** 문의 통계 (오늘/미답변/이번달/전체) */
    public Map<String, Object> getQnaSummary() {
        return sqlSession.selectOne("adminMain.getQnaSummary");
    }

    /** 최근 문의 10건 */
    public List<Map<String, Object>> getRecentQnaList() {
        return sqlSession.selectList("adminMain.getRecentQnaList");
    }

    /** 배치 현황 */
    public List<Map<String, Object>> getBatStatusList() {
        return sqlSession.selectList("adminMain.getBatStatusList");
    }
}
