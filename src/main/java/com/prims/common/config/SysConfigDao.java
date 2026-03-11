package com.prims.common.config;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SysConfigDao {

    @Autowired
    private SqlSession sqlSession;

    /**
     * 설정값 조회 (값만)
     */
    public String getConfigValue(String configKey) {
        return sqlSession.selectOne("sysConfig.getConfigValue", configKey);
    }

    /**
     * 설정 상세 조회 (USE_YN 포함, 복호화)
     */
    public Map<String, Object> getConfigOne(Map<String, Object> param) {
        return sqlSession.selectOne("sysConfig.getConfigOne", param);
    }

    /**
     * 설정 리스트 조회
     */
    public List<Map<String, Object>> getConfigList(Map<String, Object> param) {
        return sqlSession.selectList("sysConfig.getConfigList", param);
    }

    /**
     * 설정값 저장 (기존 호환)
     */
    public int saveConfigValue(Map<String, Object> param) {
        return sqlSession.update("sysConfig.saveConfigValue", param);
    }

    /**
     * 환경설정 저장 (USE_YN + 암호화)
     */
    public int saveConfig(Map<String, Object> param) {
        return sqlSession.update("sysConfig.saveConfig", param);
    }

    /**
     * 접근코드 검증 (암호화 비교)
     */
    public int verifyAccessCode(Map<String, Object> param) {
        return sqlSession.selectOne("sysConfig.verifyAccessCode", param);
    }

    /**
     * 접근 필요 여부 확인
     */
    public int isAccessRequired(String configKey) {
        return sqlSession.selectOne("sysConfig.isAccessRequired", configKey);
    }
}
