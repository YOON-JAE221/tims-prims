package com.sdr.common.batch;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("BatchService")
public class BatchService {

    private static final Logger logger = LoggerFactory.getLogger(BatchService.class);

    @Inject
    private BatchDao batchDao;

    /** 활성 잡 목록 조회 */
    public List<Map<String, Object>> getActiveJobList() {
        return batchDao.getActiveJobList();
    }

    /**
     * 배치 잡 실행 (이력 관리 포함)
     *
     * @param jobCd     잡코드 (= Bean명)
     * @param job       실행할 BatchJob
     * @param execType  AUTO / MANUAL
     * @param execUsrCd 수동실행자 코드 (MANUAL일 때)
     */
    public void executeJob(String jobCd, BatchJob job, String execType, String execUsrCd) {

        String histCd = UUID.randomUUID().toString().replace("-", "");

        // 1. 이력 등록 (RUNNING)
        Map<String, Object> histParam = new HashMap<>();
        histParam.put("histCd", histCd);
        histParam.put("jobCd", jobCd);
        histParam.put("execType", execType);
        histParam.put("execUsrCd", execUsrCd);

        try {
            batchDao.insertBatHist(histParam);
        } catch (Exception e) {
            logger.error("[Batch] 이력 등록 실패 - jobCd: {}", jobCd, e);
            return;
        }

        // 2. 잡 실행
        BatchResult result;
        try {
            logger.info("[Batch] 실행 시작 - jobCd: {}, execType: {}", jobCd, execType);
            result = job.execute();
        } catch (Exception e) {
            logger.error("[Batch] 실행 중 에러 - jobCd: {}", jobCd, e);
            result = BatchResult.fail(getStackTrace(e));
        }

        // 3. 이력 갱신 (SUCCESS / FAIL)
        Map<String, Object> updateParam = new HashMap<>();
        updateParam.put("histCd", histCd);
        updateParam.put("execRslt", result.isSuccess() ? "SUCCESS" : "FAIL");
        updateParam.put("tgtCnt", result.getTgtCnt());
        updateParam.put("procCnt", result.getProcCnt());
        updateParam.put("errMsg", result.getErrMsg());

        if (!result.isSuccess() && result.getErrMsg() != null) {
            // errDetail에는 긴 메시지, errMsg에는 앞 2000자
            String msg = result.getErrMsg();
            updateParam.put("errMsg", msg.length() > 2000 ? msg.substring(0, 2000) : msg);
            updateParam.put("errDetail", msg);
        }

        try {
            batchDao.updateBatHist(updateParam);
        } catch (Exception e) {
            logger.error("[Batch] 이력 갱신 실패 - histCd: {}", histCd, e);
        }

        // 4. TB_BAT 최근 실행 정보 갱신
        Map<String, Object> lastParam = new HashMap<>();
        lastParam.put("jobCd", jobCd);
        lastParam.put("lastExecRslt", result.isSuccess() ? "SUCCESS" : "FAIL");

        try {
            batchDao.updateLastExec(lastParam);
        } catch (Exception e) {
            logger.error("[Batch] TB_BAT 갱신 실패 - jobCd: {}", jobCd, e);
        }

        logger.info("[Batch] 실행 완료 - jobCd: {}, result: {}, tgt: {}, proc: {}",
                jobCd, result.isSuccess() ? "SUCCESS" : "FAIL",
                result.getTgtCnt(), result.getProcCnt());
    }

    private String getStackTrace(Exception e) {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        return sw.toString();
    }
}
