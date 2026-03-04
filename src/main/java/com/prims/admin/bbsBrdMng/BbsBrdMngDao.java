package com.prims.admin.bbsBrdMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BbsBrdMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectBbsBrdList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbsBrdMng.getSelectBbsBrdList", paramMap);
    }

    public Map<String, Object> getSelectBbsBrdOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbsBrdMng.getSelectBbsBrdOne", paramMap);
    }

    public int saveBbsBrd(Map<String, Object> paramMap) {
        return sqlSession.update("bbsBrdMng.saveBbsBrd", paramMap);
    }
}
