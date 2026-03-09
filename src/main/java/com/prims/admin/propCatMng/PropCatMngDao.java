package com.prims.admin.propCatMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PropCatMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getCatList() {
        return sqlSession.selectList("propCatMng.getCatList");
    }

    public List<Map<String, Object>> getSubCatList(String catCd) {
        return sqlSession.selectList("propCatMng.getSubCatList", catCd);
    }

    public int saveCat(Map<String, Object> param) {
        return sqlSession.update("propCatMng.saveCat", param);
    }

    public int saveSubCat(Map<String, Object> param) {
        return sqlSession.update("propCatMng.saveSubCat", param);
    }

    public int deleteSubCat(Map<String, Object> param) {
        return sqlSession.delete("propCatMng.deleteSubCat", param);
    }

    public int deleteCat(String catCd) {
        return sqlSession.delete("propCatMng.deleteCat", catCd);
    }

    public String getNextSubCatCd(String catCd) {
        return sqlSession.selectOne("propCatMng.getNextSubCatCd", catCd);
    }
}
