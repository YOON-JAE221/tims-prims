package com.sdr.front.license;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LicenseDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectLiceList(Map<String, Object> paramMap) {
        return sqlSession.selectList("license.getSelectLiceList", paramMap);
    }


}