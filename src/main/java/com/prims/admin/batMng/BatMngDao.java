package com.prims.admin.batMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BatMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectBatList(Map<String, Object> paramMap) {
        return sqlSession.selectList("batMng.getSelectBatList", paramMap);
    }

    public Map<String, Object> getSelectBatOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("batMng.getSelectBatOne", paramMap);
    }

    public int insertBat(Map<String, Object> paramMap) {
        return sqlSession.insert("batMng.insertBat", paramMap);
    }

    public int updateBat(Map<String, Object> paramMap) {
        return sqlSession.update("batMng.updateBat", paramMap);
    }

    public int deleteBat(Map<String, Object> paramMap) {
        return sqlSession.update("batMng.deleteBat", paramMap);
    }

    public List<Map<String, Object>> getSelectBatHistList(Map<String, Object> paramMap) {
        return sqlSession.selectList("batMng.getSelectBatHistList", paramMap);
    }
}
