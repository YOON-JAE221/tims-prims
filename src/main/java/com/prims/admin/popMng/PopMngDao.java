package com.prims.admin.popMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PopMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectPopList(Map<String, Object> paramMap) {
        return sqlSession.selectList("popMng.getSelectPopList", paramMap);
    }

    public Map<String, Object> getSelectPopOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("popMng.getSelectPopOne", paramMap);
    }

    public int savePop(Map<String, Object> paramMap) {
        return sqlSession.update("popMng.savePop", paramMap);
    }

    public int deletePop(Map<String, Object> paramMap) {
        return sqlSession.update("popMng.deletePop", paramMap);
    }
}
