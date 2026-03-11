package com.prims.admin.newsMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NewsMngDao {

    @Autowired
    private SqlSession sqlSession;

    // 뉴스 목록 조회
    public List<Map<String, Object>> getSelectNewsList(Map<String, Object> paramMap) {
        return sqlSession.selectList("adminNewsMng.getSelectNewsList", paramMap);
    }

    // 뉴스 등록
    public int insertNews(Map<String, Object> paramMap) {
        return sqlSession.insert("adminNewsMng.insertNews", paramMap);
    }

    // 뉴스 수정
    public int updateNews(Map<String, Object> paramMap) {
        return sqlSession.update("adminNewsMng.updateNews", paramMap);
    }

    // 뉴스 삭제 (물리삭제)
    public int deleteNews(Map<String, Object> paramMap) {
        return sqlSession.delete("adminNewsMng.deleteNews", paramMap);
    }
}
