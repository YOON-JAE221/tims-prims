package com.prims.admin.licenseMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LicenseMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectList(Map<String, Object> paramMap) {
        return sqlSession.selectList("licenseMng.getSelectList", paramMap);
    }
    
    public int saveLicenseMng(Map<String, Object> paramMap) {
		return sqlSession.update("licenseMng.saveLicenseMng", paramMap);
	}
    
    public int deleteLicenseMng(Map<String, Object> paramMap) {
		return sqlSession.update("licenseMng.updateSaveLicenseMngDelYn", paramMap);
	}
    
    public Map<String, Object> selectLicenseOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("licenseMng.selectLicenseOne", paramMap);
    }


}