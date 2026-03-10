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

    /** 메인 슬라이더 추천매물 (RECOMMEND + MAIN_YN=Y, 최신 1건) */
    public Map<String, Object> getMainSliderProperty() {
        return sqlSession.selectOne("propertySearch.getMainSliderProperty");
    }

    /** 메인 신규매물 (최신 등록 1건) */
    public Map<String, Object> getMainLatestProperty() {
        return sqlSession.selectOne("propertySearch.getMainLatestProperty");
    }

    /** 메인 급매매물 (URGENT + MAIN_YN=Y, 최신 1건) */
    public Map<String, Object> getMainUrgentProperty() {
        return sqlSession.selectOne("propertySearch.getMainUrgentProperty");
    }

    /** 메인 추천매물 섹션 (RECOMMEND+URGENT, 최신 3건) */
    public List<Map<String, Object>> getMainFeaturedList() {
        return sqlSession.selectList("propertySearch.getMainFeaturedList");
    }

    /** 매물 상세 */
    public Map<String, Object> getPropertyDetail(Map<String, Object> paramMap) {
        return sqlSession.selectOne("propertySearch.getPropertyDetail", paramMap);
    }

    /** 조회수 증가 */
    public void increaseViewCnt(Map<String, Object> paramMap) {
        sqlSession.update("propertySearch.increaseViewCnt", paramMap);
    }

    /** 매물 이미지 목록 */
    public List<Map<String, Object>> getPropertyImageList(Map<String, Object> paramMap) {
        return sqlSession.selectList("propertySearch.getPropertyImageList", paramMap);
    }

    /** FO 사이드바용 대분류 목록 */
    public List<Map<String, Object>> getFrontCatList() {
        return sqlSession.selectList("propertySearch.getFrontCatList");
    }
}
