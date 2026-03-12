package com.prims.admin.propertyMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PropertyMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectPropertyList(Map<String, Object> paramMap) {
        return sqlSession.selectList("propertyMng.getSelectPropertyList", paramMap);
    }

    public int getSelectPropertyCount(Map<String, Object> paramMap) {
        return sqlSession.selectOne("propertyMng.getSelectPropertyCount", paramMap);
    }

    public Map<String, Object> getSelectPropertyDetail(Map<String, Object> paramMap) {
        return sqlSession.selectOne("propertyMng.getSelectPropertyDetail", paramMap);
    }

    public int saveProperty(Map<String, Object> paramMap) {
        return sqlSession.update("propertyMng.saveProperty", paramMap);
    }

    public int deleteProperty(Map<String, Object> paramMap) {
        return sqlSession.delete("propertyMng.deleteProperty", paramMap);
    }

    public int copyProperty(Map<String, Object> paramMap) {
        return sqlSession.insert("propertyMng.copyProperty", paramMap);
    }

    public List<Map<String, Object>> getCatListForSelect() {
        return sqlSession.selectList("propertyMng.getCatListForSelect");
    }

    public List<Map<String, Object>> getMidCatListForSelect(String catCd) {
        return sqlSession.selectList("propertyMng.getMidCatListForSelect", catCd);
    }

    public List<Map<String, Object>> getSubCatListForSelect(String midCatCd) {
        return sqlSession.selectList("propertyMng.getSubCatListForSelect", midCatCd);
    }

    public int updatePropertySoldYn(Map<String, Object> paramMap) {
        return sqlSession.update("propertyMng.updatePropertySoldYn", paramMap);
    }

    public int completeProperty(Map<String, Object> paramMap) {
        return sqlSession.update("propertyMng.completeProperty", paramMap);
    }

    public List<Map<String, Object>> getPropertyListForExcel(Map<String, Object> paramMap) {
        return sqlSession.selectList("propertyMng.getPropertyListForExcel", paramMap);
    }
}
