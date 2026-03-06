package com.prims.front.property;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PropertySearchDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getPropertyMapList(Map<String, Object> paramMap) {
        return sqlSession.selectList("propertySearch.getPropertyMapList", paramMap);
    }

    public List<Map<String, Object>> getPropertyTypeList(Map<String, Object> paramMap) {
        return sqlSession.selectList("propertySearch.getPropertyTypeList", paramMap);
    }

    public int getPropertyTypeCount(Map<String, Object> paramMap) {
        return sqlSession.selectOne("propertySearch.getPropertyTypeCount", paramMap);
    }

    /** 메인 슬라이더 매물 (MAIN_YN=Y, 최신 1건) */
    public Map<String, Object> getMainSliderProperty() {
        return sqlSession.selectOne("propertySearch.getMainSliderProperty");
    }

    /** 메인 추천매물 (RECOMMEND+URGENT, 최신 3건) */
    public List<Map<String, Object>> getMainFeaturedList() {
        return sqlSession.selectList("propertySearch.getMainFeaturedList");
    }
}
