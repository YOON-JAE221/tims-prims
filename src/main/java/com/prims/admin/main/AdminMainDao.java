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

    /** 매물 현황 요약 */
    public Map<String, Object> getPropSummary() {
        return sqlSession.selectOne("adminMain.getPropSummary");
    }

    /** 문의 통계 (오늘/미답변/이번달/전체) */
    public Map<String, Object> getQnaSummary() {
        return sqlSession.selectOne("adminMain.getQnaSummary");
    }

    /** 최근 등록 매물 10건 */
    public List<Map<String, Object>> getRecentPropList(Map<String, Object> paramMap) {
        return sqlSession.selectList("adminMain.getRecentPropList", paramMap);
    }

    /** 인기 매물 TOP 5 */
    public List<Map<String, Object>> getTopPropList() {
        return sqlSession.selectList("adminMain.getTopPropList");
    }

    /** 최근 문의 10건 */
    public List<Map<String, Object>> getRecentQnaList() {
        return sqlSession.selectList("adminMain.getRecentQnaList");
    }

    /** TB_UPLD_FILE 확장자 WebP로 변경 */
    public int updateFileExtToWebp() {
        return sqlSession.update("adminMain.updateFileExtToWebp");
    }

    /** TB_PROPERTY 썸네일 경로 WebP로 변경 */
    public int updateThumbPathToWebp() {
        return sqlSession.update("adminMain.updateThumbPathToWebp");
    }
}
