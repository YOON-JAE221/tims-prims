package com.sdr.common.batch;

/**
 * 배치 실행 결과
 */
public class BatchResult {

    private int tgtCnt;     // 대상건수
    private int procCnt;    // 처리건수
    private boolean success;
    private String errMsg;

    public BatchResult(int tgtCnt, int procCnt, boolean success, String errMsg) {
        this.tgtCnt = tgtCnt;
        this.procCnt = procCnt;
        this.success = success;
        this.errMsg = errMsg;
    }

    public static BatchResult success(int tgtCnt, int procCnt) {
        return new BatchResult(tgtCnt, procCnt, true, null);
    }

    public static BatchResult fail(String errMsg) {
        return new BatchResult(0, 0, false, errMsg);
    }

    public static BatchResult fail(int tgtCnt, int procCnt, String errMsg) {
        return new BatchResult(tgtCnt, procCnt, false, errMsg);
    }

    public int getTgtCnt() { return tgtCnt; }
    public int getProcCnt() { return procCnt; }
    public boolean isSuccess() { return success; }
    public String getErrMsg() { return errMsg; }
}
