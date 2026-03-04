package com.prims.common.batch;

import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

/**
 * 배치 스케줄러
 * - 서버 기동 시 TB_BAT에서 활성 잡 목록을 읽어 JOB_CRON에 맞게 스케줄링
 * - JOB_CD = Spring Bean명 → ApplicationContext에서 빈을 찾아 실행
 */
@Component
public class BatchScheduler implements ApplicationContextAware, ApplicationListener<ContextRefreshedEvent> {

    private static final Logger logger = LoggerFactory.getLogger(BatchScheduler.class);
    private static final AtomicBoolean initialized = new AtomicBoolean(false);

    @Inject
    private BatchService batchService;

    private ApplicationContext applicationContext;
    private ThreadPoolTaskScheduler taskScheduler;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        // 컨텍스트가 여러 번 refresh 되어도 1회만 실행
        if (!initialized.compareAndSet(false, true)) return;

        initScheduler();
        scheduleAll();
    }

    /** TaskScheduler 초기화 */
    private void initScheduler() {
        taskScheduler = new ThreadPoolTaskScheduler();
        taskScheduler.setPoolSize(3);
        taskScheduler.setThreadNamePrefix("batch-");
        taskScheduler.setWaitForTasksToCompleteOnShutdown(true);
        taskScheduler.setAwaitTerminationSeconds(30);
        taskScheduler.initialize();
        logger.info("[BatchScheduler] TaskScheduler 초기화 완료");
    }

    /** TB_BAT에서 활성 잡 읽어서 스케줄 등록 */
    private void scheduleAll() {
        try {
            List<Map<String, Object>> jobList = batchService.getActiveJobList();
            logger.info("[BatchScheduler] 활성 잡 {}건 조회", jobList.size());

            for (Map<String, Object> job : jobList) {
                String jobCd = String.valueOf(job.get("jobCd"));
                String jobCron = String.valueOf(job.get("jobCron"));

                if (jobCron == null || jobCron.isEmpty() || "null".equals(jobCron)) {
                    logger.warn("[BatchScheduler] 크론식 없음 - 스킵: {}", jobCd);
                    continue;
                }

                scheduleJob(jobCd, jobCron);
            }
        } catch (Exception e) {
            logger.error("[BatchScheduler] 스케줄 등록 실패", e);
        }
    }

    /** 개별 잡 스케줄 등록 */
    private void scheduleJob(String jobCd, String cronExpr) {
        try {
            // Bean 존재 확인
            if (!applicationContext.containsBean(jobCd)) {
                logger.error("[BatchScheduler] Bean 없음 - 스킵: {}", jobCd);
                return;
            }

            Object bean = applicationContext.getBean(jobCd);
            if (!(bean instanceof BatchJob)) {
                logger.error("[BatchScheduler] BatchJob 미구현 - 스킵: {}", jobCd);
                return;
            }

            BatchJob batchJob = (BatchJob) bean;

            taskScheduler.schedule(
                () -> batchService.executeJob(jobCd, batchJob, "AUTO", null),
                new CronTrigger(cronExpr)
            );

            logger.info("[BatchScheduler] 스케줄 등록 - jobCd: {}, cron: {}", jobCd, cronExpr);

        } catch (Exception e) {
            logger.error("[BatchScheduler] 스케줄 등록 실패 - jobCd: {}", jobCd, e);
        }
    }

    /**
     * 수동 실행 (BO 관리자 화면에서 호출)
     * @param jobCd     잡코드
     * @param execUsrCd 실행자 코드
     */
    public void manualExecute(String jobCd, String execUsrCd) {
        try {
            if (!applicationContext.containsBean(jobCd)) {
                throw new RuntimeException("등록된 Bean이 없습니다: " + jobCd);
            }

            BatchJob batchJob = (BatchJob) applicationContext.getBean(jobCd);
            batchService.executeJob(jobCd, batchJob, "MANUAL", execUsrCd);

        } catch (Exception e) {
            logger.error("[BatchScheduler] 수동 실행 실패 - jobCd: {}", jobCd, e);
            throw e;
        }
    }
}
