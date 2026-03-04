package com.sdr.common.batch;

/**
 * 배치 잡 공통 인터페이스
 * - 모든 배치 잡은 이 인터페이스를 구현
 * - Bean명 = TB_BAT.JOB_CD (예: @Component("usrInfoMaskingJob"))
 */
public interface BatchJob {
    BatchResult execute();
}
