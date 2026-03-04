package com.prims.front.main;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MainDao {

    @Autowired
    private SqlSession sqlSession;

    // 메인 엔지니어링 서비스 리스트
    public List<Map<String, Object>> getSelectMainEngList(Map<String, Object> paramMap) {
        return sqlSession.selectList("frontMain.getSelectMainEngList", paramMap);
    }

    // FO 활성 팝업 목록
    public List<Map<String, Object>> getSelectActivePopList(Map<String, Object> paramMap) {
        return sqlSession.selectList("frontMain.getSelectActivePopList", paramMap);
    }
}
