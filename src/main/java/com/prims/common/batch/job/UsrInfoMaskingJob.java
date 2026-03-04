package com.prims.common.batch.job;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.prims.common.batch.BatchJob;
import com.prims.common.batch.BatchResult;

/**
 * 개인정보 마스킹 배치
 * - 문의게시판(TB_BBS_PST) 등록일 기준 3년 경과 시
 * - 작성자명 / 이메일 / 연락처를 '****' 처리
 *
 * Bean명 = TB_BAT.JOB_CD = "usrInfoMaskingJob"
 */
@Component("usrInfoMaskingJob")
public class UsrInfoMaskingJob implements BatchJob {

    private static final Logger logger = LoggerFactory.getLogger(UsrInfoMaskingJob.class);

    @Autowired
    private SqlSession sqlSession;

    @Override
    public BatchResult execute() {

        // 1. 대상건수 조회
        int tgtCnt = sqlSession.selectOne("batch.getMaskingTargetCount");
        logger.info("[UsrInfoMaskingJob] 마스킹 대상: {}건", tgtCnt);

        if (tgtCnt == 0) {
            return BatchResult.success(0, 0);
        }

        // 2. 마스킹 실행
        int procCnt = sqlSession.update("batch.executeMasking");
        logger.info("[UsrInfoMaskingJob] 마스킹 처리: {}건", procCnt);

        return BatchResult.success(tgtCnt, procCnt);
    }
}
