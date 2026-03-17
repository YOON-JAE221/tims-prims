package com.prims.common.batch.job;

import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import com.prims.common.batch.BatchJob;
import com.prims.common.batch.BatchResult;
import com.prims.common.config.AppProperties;
import com.prims.common.constant.Constant;
import com.prims.common.notification.SendLogDao;

/**
 * 접근코드 변경 알림 배치
 * - 매월 말일 오전 1시 실행
 * - 관리자에게 "내일(1일)부터 접근코드 변경 필요" 메일 발송
 *
 * Bean명 = TB_BAT.JOB_CD = "accessCodeAlertJob"
 * CRON = 0 0 1 L * ? (매월 마지막날 01:00)
 */
@Component("accessCodeAlertJob")
public class AccessCodeAlertJob implements BatchJob {

    private static final Logger logger = LoggerFactory.getLogger(AccessCodeAlertJob.class);

    /** 알림 수신자 이메일 - Constant에서 관리 */
    private static final String ALERT_TO_EMAIL = Constant.MAIL_ADMIN_EMAIL;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private AppProperties appProperties;

    @Autowired
    private SendLogDao sendLogDao;

    @Override
    public BatchResult execute() {

        logger.info("[AccessCodeAlertJob] 접근코드 변경 알림 배치 시작");

        String subject = "[프리머스 부동산] 접근코드 변경 알림 - 내일(1일) 변경 필요";

        try {
            sendAlertEmail(subject);
            logger.info("[AccessCodeAlertJob] 메일 발송 완료 - 수신: {}", ALERT_TO_EMAIL);

            // 발송 로그 저장 (성공)
            saveSendLog(subject, Constant.SEND_RSLT_SUCCESS, null);

            return BatchResult.success(1, 1);

        } catch (Exception e) {
            logger.error("[AccessCodeAlertJob] 메일 발송 실패: {}", e.getMessage(), e);

            // 발송 로그 저장 (실패)
            saveSendLog(subject, Constant.SEND_RSLT_FAIL, e.getMessage());

            return BatchResult.fail(e.getMessage());
        }
    }

    /**
     * 발송 로그 저장
     */
    private void saveSendLog(String sendTitle, String sendRslt, String errMsg) {
        try {
            Map<String, Object> log = new HashMap<>();
            log.put("sendType",    Constant.SEND_TYPE_EMAIL);
            log.put("recvNm",      "관리자");
            log.put("recvAddr",    ALERT_TO_EMAIL);
            log.put("sendTitle",   sendTitle);
            log.put("sendContent", null);
            log.put("sendRslt",    sendRslt);
            log.put("errMsg",      errMsg);
            log.put("refCd",       "BATCH_ACCESS_CODE_ALERT");
            log.put("creUsrCd",    "SYSTEM");
            sendLogDao.insertSendLog(log);
        } catch (Exception e) {
            logger.error("[AccessCodeAlertJob] 발송로그 저장 실패: {}", e.getMessage());
        }
    }

    /**
     * 접근코드 변경 알림 메일 발송
     */
    private void sendAlertEmail(String subject) throws Exception {

        String html = buildEmailHtml();

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
        helper.setFrom(Constant.MAIL_FROM_EMAIL, Constant.MAIL_FROM_NAME);
        helper.setTo(ALERT_TO_EMAIL);
        helper.setSubject(subject);
        helper.setText(html, true);

        mailSender.send(message);
    }

    /**
     * 이메일 HTML 템플릿
     */
    private String buildEmailHtml() {

        String loginUrl = appProperties.getSiteUrl() + "/login/loginView";

        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>");
        sb.append("<html><head><meta charset='UTF-8'/></head><body>");
        sb.append("<div style='max-width:600px;margin:0 auto;font-family:-apple-system,BlinkMacSystemFont,\"Segoe UI\",Roboto,sans-serif;'>");

        // 헤더
        sb.append("<div style='background:#E8830C;padding:24px 28px;border-radius:8px 8px 0 0;'>");
        sb.append("<h2 style='margin:0;color:#fff;font-size:18px;font-weight:700;'>🔐 접근코드 변경 알림</h2>");
        sb.append("</div>");

        // 본문
        sb.append("<div style='border:1px solid #e5e7eb;border-top:none;border-radius:0 0 8px 8px;padding:28px;background:#fff;'>");

        sb.append("<p style='margin:0 0 20px;font-size:15px;color:#333;line-height:1.7;'>");
        sb.append("안녕하세요, 관리자님.<br/><br/>");
        sb.append("내일 <strong style='color:#E8830C;'>1일</strong>부터 새로운 달이 시작됩니다.<br/>");
        sb.append("보안을 위해 <strong>접근코드 변경</strong>을 진행해 주세요.");
        sb.append("</p>");

        // 안내 박스
        sb.append("<div style='background:#FFF3E6;border:1px solid #E8830C;border-radius:8px;padding:20px;margin-bottom:20px;'>");
        sb.append("<p style='margin:0;font-size:14px;color:#333;line-height:1.8;'>");
        sb.append("<strong>📌 변경 방법</strong><br/>");
        sb.append("1. 관리자 페이지 접속<br/>");
        sb.append("2. 시스템관리 → 환경설정<br/>");
        sb.append("3. 새로운 접근코드 설정");
        sb.append("</p>");
        sb.append("</div>");

        // 로그인 버튼
        sb.append("<div style='text-align:center;margin-bottom:24px;'>");
        sb.append("<a href='").append(loginUrl).append("' style='display:inline-block;padding:14px 40px;background:#1B2A4A;color:#fff;font-size:15px;font-weight:700;text-decoration:none;border-radius:8px;'>관리자 로그인</a>");
        sb.append("</div>");

        // 주의사항
        sb.append("<p style='margin:0;font-size:13px;color:#666;line-height:1.6;'>");
        sb.append("※ 매월 1일 접근코드를 변경하여 보안을 유지해 주세요.<br/>");
        sb.append("※ 이 메일은 매월 말일에 자동 발송됩니다.");
        sb.append("</p>");

        sb.append("</div>");

        // 푸터
        sb.append("<p style='margin:16px 0 0;font-size:12px;color:#999;text-align:center;line-height:1.6;'>");
        sb.append("본 메일은 자동 발송된 알림 메일입니다.<br/>");
        sb.append("프리머스 부동산 | TEL 032-327-1277");
        sb.append("</p>");

        sb.append("</div>");
        sb.append("</body></html>");

        return sb.toString();
    }
}
