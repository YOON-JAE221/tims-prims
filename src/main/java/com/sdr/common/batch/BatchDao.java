package com.sdr.common.batch;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BatchDao {

    @Autowired
    private SqlSession sqlSession;

    // ── TB_BAT ──

    /** 활성 잡 목록 (USE_YN='Y', DEL_YN='N', JOB_CRON 존재) */
    public List<Map<String, Object>> getActiveJobList() {
        return sqlSession.selectList("batch.getActiveJobList");
    }

    /** 잡 단건 조회 */
    public Map<String, Object> getJobByCode(String jobCd) {
        return sqlSession.selectOne("batch.getJobByCode", jobCd);
    }

    /** 최근 실행 정보 갱신 */
    public int updateLastExec(Map<String, Object> param) {
        return sqlSession.update("batch.updateLastExec", param);
    }

    // ── TB_BAT_HIST ──

    /** 이력 등록 (RUNNING) */
    public int insertBatHist(Map<String, Object> param) {
        return sqlSession.insert("batch.insertBatHist", param);
    }

    /** 이력 갱신 (SUCCESS / FAIL) */
    public int updateBatHist(Map<String, Object> param) {
        return sqlSession.update("batch.updateBatHist", param);
    }
}
