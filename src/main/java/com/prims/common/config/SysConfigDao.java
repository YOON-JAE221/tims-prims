package com.prims.common.config;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SysConfigDao {

    @Autowired
    private SqlSession sqlSession;

    public String getConfigValue(String configKey) {
        return sqlSession.selectOne("sysConfig.getConfigValue", configKey);
    }

    public int saveConfigValue(Map<String, Object> param) {
        return sqlSession.update("sysConfig.saveConfigValue", param);
    }
}
