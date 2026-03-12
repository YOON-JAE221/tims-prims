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

    // 카테고리 전체 목록 (트리용)
    public List<Map<String, Object>> getCatList() {
        return sqlSession.selectList("propCatMng.getCatList");
    }

    // 카테고리 저장 (등록/수정)
    public int saveCat(Map<String, Object> param) {
        return sqlSession.update("propCatMng.saveCat", param);
    }

    // 카테고리 삭제 (하위 포함)
    public int deleteCat(Map<String, Object> param) {
        return sqlSession.delete("propCatMng.deleteCat", param);
    }

    // 카테고리코드 중복 체크
    public int getCountByCatCd(Map<String, Object> param) {
        return sqlSession.selectOne("propCatMng.getCountByCatCd", param);
    }

    // 다음 카테고리코드 자동채번
    public String getNextCatCd(Map<String, Object> param) {
        return sqlSession.selectOne("propCatMng.getNextCatCd", param);
    }
}
