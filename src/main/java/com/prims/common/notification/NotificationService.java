package com.prims.common.notification;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import javax.annotation.PreDestroy;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.prims.common.constant.Constant;
import com.prims.common.config.AppProperties;

@Service("NotificationService")
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    /** NHN Cloud SMS API URL */
    private static final String SMS_API_URL = "https://api-sms.cloud.toast.com/sms/v3.0/appKeys/%s/sender/sms";

    /** 비동기 발송용 스레드풀 (최대 2개 — 이메일+SMS 동시 발송) */
    private final ExecutorService executor = Executors.newFixedThreadPool(2);

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private SendLogDao sendLogDao;

    @Autowired
    private AppProperties appProperties;

    @PreDestroy
    public void destroy() {
        executor.shutdown();
        try {
            if (!executor.awaitTermination(10, TimeUnit.SECONDS)) {
                executor.shutdownNow();
            }
        } catch (InterruptedException e) {
            executor.shutdownNow();
        }
        logger.info("[Notification] ExecutorService 종료 완료");
    }

    // =============================================
    // 발송 로그 공통
    // =============================================

    /**
     * 발송 로그 저장
     */
    private void saveSendLog(String sendType, String recvNm, String recvAddr,
                             String sendTitle, String sendContent,
                             String sendRslt, String errMsg,
                             String refCd, String creUsrCd) {
        try {
            Map<String, Object> log = new HashMap<>();
            log.put("sendType",    sendType);
            log.put("recvNm",      recvNm);
            log.put("recvAddr",    recvAddr);
            log.put("sendTitle",   sendTitle);
            log.put("sendContent", sendContent != null && sendContent.length() > 3000
                                   ? sendContent.substring(0, 3000) : sendContent);
            log.put("sendRslt",    sendRslt);
            log.put("errMsg",      errMsg);
            log.put("refCd",       refCd);
            log.put("creUsrCd",    creUsrCd);
            sendLogDao.insertSendLog(log);
        } catch (Exception e) {
            logger.error("[Notification] 발송로그 저장 실패: {}", e.getMessage());
        }
    }

    // =============================================
    // 문의 접수 알림 (관리자에게)
    // =============================================

    /**
     * 문의 접수 시 관리자에게 알림 발송 (이메일 + SMS) — 비동기
     */
    public void sendQnaNotification(Map<String, Object> paramMap) {
        executor.submit(() -> {
            sendQnaEmail(paramMap);
            // TODO: 발신번호 등록 후 주석 해제
            // sendQnaSms(paramMap);
        });
    }

    // =============================================
    // 문의 답변 알림 (문의자에게)
    // =============================================

    /**
     * 문의 답변 등록 시 문의자에게 알림 발송 (이메일 + SMS) — 비동기
     */
    public void sendQnaReplyNotification(Map<String, Object> parentPst, String replyContent) {
        executor.submit(() -> {
            sendQnaReplyEmail(parentPst, replyContent);
            // TODO: 발신번호 등록 후 주석 해제
            // sendQnaReplySms(parentPst);
        });
    }

    // =============================================
    // 이메일 발송
    // =============================================

    /**
     * 문의 접수 알림 이메일 (관리자에게 발송)
     */
    private void sendQnaEmail(Map<String, Object> paramMap) {
        String title   = nvl(paramMap.get("pstNm"));
        String subject = "[프리머스 부동산] 새로운 문의가 접수되었습니다 - " + title;
        String refCd   = nvl(paramMap.get("pstCd"));

        try {
            String writerNm = nvl(paramMap.get("rgtUsrNm"));
            String phone    = nvl(paramMap.get("rgtPhone"));
            String content  = nvl(paramMap.get("pstCnts"));

            if (phone.isEmpty()) phone = buildPhone(paramMap);

            String html = buildQnaEmailHtml(writerNm, phone, title, content);

            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
            helper.setFrom(Constant.MAIL_FROM_EMAIL, Constant.MAIL_FROM_NAME);
            helper.setTo(Constant.MAIL_ADMIN_EMAIL);
            helper.setSubject(subject);
            helper.setText(html, true);

            mailSender.send(message);
            logger.info("[Notification] 문의 알림 이메일 발송 완료 - 수신: {}, 제목: {}", Constant.MAIL_ADMIN_EMAIL, title);

            saveSendLog(Constant.SEND_TYPE_EMAIL, "관리자", Constant.MAIL_ADMIN_EMAIL,
                        subject, null, Constant.SEND_RSLT_SUCCESS, null, refCd, null);

        } catch (Exception e) {
            logger.error("[Notification] 문의 알림 이메일 발송 실패: {}", e.getMessage(), e);
            saveSendLog(Constant.SEND_TYPE_EMAIL, "관리자", Constant.MAIL_ADMIN_EMAIL,
                        subject, null, Constant.SEND_RSLT_FAIL, e.getMessage(), refCd, null);
        }
    }

    /**
     * 문의 답변 알림 이메일 (문의자에게 발송)
     */
    private void sendQnaReplyEmail(Map<String, Object> parentPst, String replyContent) {
        String title   = nvl(parentPst.get("pstNm"));
        String subject = "[프리머스 부동산] 문의하신 내용에 답변이 등록되었습니다";
        String refCd   = nvl(parentPst.get("pstCd"));

        try {
            String writerNm = nvl(parentPst.get("rgtUsrNm"));
            String email    = nvl(parentPst.get("rgtEmail"));

            if (email.isEmpty()) {
                logger.info("[Notification] 문의자 이메일 없음 - 답변 알림 스킵");
                return;
            }

            String html = buildQnaReplyEmailHtml(writerNm, title, replyContent);

            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
            helper.setFrom(Constant.MAIL_FROM_EMAIL, Constant.MAIL_FROM_NAME);
            helper.setTo(email);
            helper.setSubject(subject);
            helper.setText(html, true);

            mailSender.send(message);
            logger.info("[Notification] 답변 알림 이메일 발송 완료 - 수신: {}, 원글: {}", email, title);

            saveSendLog(Constant.SEND_TYPE_EMAIL, writerNm, email,
                        subject, null, Constant.SEND_RSLT_SUCCESS, null, refCd, null);

        } catch (Exception e) {
            logger.error("[Notification] 답변 알림 이메일 발송 실패: {}", e.getMessage(), e);
            saveSendLog(Constant.SEND_TYPE_EMAIL, nvl(parentPst.get("rgtUsrNm")),
                        nvl(parentPst.get("rgtEmail")),
                        subject, null, Constant.SEND_RSLT_FAIL, e.getMessage(), refCd, null);
        }
    }

    // =============================================
    // SMS 발송 (NHN Cloud)
    // =============================================

    /**
     * 문의 접수 SMS 알림 (관리자에게)
     */
    private void sendQnaSms(Map<String, Object> paramMap) {
        String writerNm = nvl(paramMap.get("rgtUsrNm"));
        String title    = nvl(paramMap.get("pstNm"));
        String refCd    = nvl(paramMap.get("pstCd"));

        String content = "[프리머스 부동산] 새 문의가 접수되었습니다.\n"
                       + "제목: " + title + "\n"
                       + "작성자: " + writerNm;

        // 관리자 번호로 발송 (Constant에 관리자 번호 추가 필요)
        // sendSmsNhn("관리자", "관리자번호", content, refCd, null);
    }

    /**
     * 문의 답변 SMS 알림 (문의자에게)
     */
    private void sendQnaReplySms(Map<String, Object> parentPst) {
        String writerNm = nvl(parentPst.get("rgtUsrNm"));
        String phone    = nvl(parentPst.get("rgtPhone"));
        String title    = nvl(parentPst.get("pstNm"));
        String refCd    = nvl(parentPst.get("pstCd"));

        if (phone.isEmpty()) {
            logger.info("[Notification] 문의자 연락처 없음 - SMS 스킵");
            return;
        }

        String content = "[프리머스 부동산] 문의하신 내용에 답변이 등록되었습니다.\n"
                       + "제목: " + title;

        sendSmsNhn(writerNm, phone, content, refCd, null);
    }

    /**
     * NHN Cloud SMS 발송 공통 메서드
     * @param recvNm     수신자명
     * @param recvPhone  수신번호 (하이픈 포함/미포함 모두 가능)
     * @param content    발송 내용
     * @param refCd      참조코드
     * @param creUsrCd   발송 요청자
     */
    public void sendSmsNhn(String recvNm, String recvPhone, String content, String refCd, String creUsrCd) {

        String phone = recvPhone.replaceAll("-", "").trim();

        if (phone.isEmpty()) {
            logger.info("[SMS] 수신번호 없음 - 발송 스킵");
            return;
        }

        try {
            String appKey    = Constant.SMS_APP_KEY;
            String secretKey = Constant.SMS_SECRET_KEY;
            String senderNo  = Constant.SMS_SENDER_NO;

            if (appKey.isEmpty() || secretKey.isEmpty() || senderNo.isEmpty()) {
                throw new RuntimeException("SMS 설정값 미입력 (Constant.java 확인)");
            }

            String apiUrl = String.format(SMS_API_URL, appKey);

            // 요청 JSON
            String json = "{"
                + "\"body\":\"" + escapeJson(content) + "\","
                + "\"sendNo\":\"" + senderNo + "\","
                + "\"recipientList\":[{"
                + "  \"recipientNo\":\"" + phone + "\""
                + "}]"
                + "}";

            // HTTP 요청
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            conn.setRequestProperty("X-Secret-Key", secretKey);
            conn.setDoOutput(true);
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(10000);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                        responseCode >= 400 ? conn.getErrorStream() : conn.getInputStream(),
                        StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            if (responseCode == 200 && response.toString().contains("\"isSuccessful\":true")) {
                logger.info("[SMS] 발송 성공 - 수신: {}", phone);
                saveSendLog(Constant.SEND_TYPE_SMS, recvNm, phone,
                            null, content, Constant.SEND_RSLT_SUCCESS, null, refCd, creUsrCd);
            } else {
                String errMsg = "HTTP " + responseCode + " / " + response.toString();
                logger.error("[SMS] 발송 실패 - 수신: {}, 응답: {}", phone, errMsg);
                saveSendLog(Constant.SEND_TYPE_SMS, recvNm, phone,
                            null, content, Constant.SEND_RSLT_FAIL, errMsg, refCd, creUsrCd);
            }

        } catch (Exception e) {
            logger.error("[SMS] 발송 실패 - 수신: {}, 에러: {}", phone, e.getMessage(), e);
            saveSendLog(Constant.SEND_TYPE_SMS, recvNm, phone,
                        null, content, Constant.SEND_RSLT_FAIL, e.getMessage(), refCd, creUsrCd);
        }
    }

    // =============================================
    // 이메일 HTML 템플릿
    // =============================================

    private String buildQnaReplyEmailHtml(String writerNm, String title, String replyContent) {

        String safeWriterNm = escapeHtml(writerNm);
        String safeTitle    = escapeHtml(title);

        String safeContent = replyContent
                .replaceAll("<[^>]*>", "")
                .replaceAll("&nbsp;", " ")
                .replaceAll("\n", "<br/>");
        safeContent = escapeHtml(safeContent).replace("&lt;br/&gt;", "<br/>");

        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>");
        sb.append("<html><head><meta charset='UTF-8'/></head><body>");
        sb.append("<div style='max-width:600px;margin:0 auto;font-family:-apple-system,BlinkMacSystemFont,\"Segoe UI\",Roboto,sans-serif;'>");

        sb.append("<div style='background:#2c3e50;padding:24px 28px;border-radius:8px 8px 0 0;'>");
        sb.append("<h2 style='margin:0;color:#fff;font-size:18px;font-weight:700;'>문의하신 내용에 답변이 등록되었습니다</h2>");
        sb.append("</div>");

        sb.append("<div style='border:1px solid #e5e7eb;border-top:none;border-radius:0 0 8px 8px;padding:28px;background:#fff;'>");

        sb.append("<p style='margin:0 0 20px;font-size:14px;color:#333;line-height:1.7;'>");
        sb.append("안녕하세요, <strong>").append(safeWriterNm).append("</strong>님.<br/>");
        sb.append("문의해 주신 내용에 대한 답변이 등록되었습니다.");
        sb.append("</p>");

        sb.append("<table style='width:100%;border-collapse:collapse;margin-bottom:24px;'>");
        sb.append(infoRow("문의 제목", safeTitle));
        sb.append("</table>");

        sb.append("<div style='background:#f8f9fa;border:1px solid #e9ecef;border-radius:6px;padding:18px 20px;'>");
        sb.append("<p style='margin:0 0 8px;font-size:13px;font-weight:700;color:#555;'>답변 내용</p>");
        sb.append("<div style='font-size:14px;line-height:1.7;color:#333;'>");
        sb.append(safeContent);
        sb.append("</div></div>");

        String qnaUrl = appProperties.getSiteUrl() + "/bbs/viewBbsQna";
        sb.append("<div style='text-align:center;margin-top:24px;'>");
        sb.append("<a href='").append(qnaUrl).append("' style='display:inline-block;padding:12px 32px;background:#2c3e50;color:#fff;font-size:14px;font-weight:700;text-decoration:none;border-radius:6px;'>답변 보러가기</a>");
        sb.append("</div>");

        sb.append("<p style='margin:16px 0 0;font-size:12px;color:#999;text-align:center;line-height:1.6;'>");
        sb.append("본 메일은 문의 답변 알림을 위해 자동 발송된 메일입니다.<br/>");
        sb.append("프리머스 부동산 | TEL 032-327-1277");
        sb.append("</p>");

        sb.append("</div></div>");
        sb.append("</body></html>");

        return sb.toString();
    }

    private String buildQnaEmailHtml(String name, String phone, String title, String content) {

        String safeName  = escapeHtml(name);
        String safePhone = escapeHtml(phone);
        String safeTitle = escapeHtml(title);

        String safeContent = content
                .replaceAll("<[^>]*>", "")
                .replaceAll("&nbsp;", " ")
                .replaceAll("\n", "<br/>");
        safeContent = escapeHtml(safeContent).replace("&lt;br/&gt;", "<br/>");

        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>");
        sb.append("<html><head><meta charset='UTF-8'/></head><body>");
        sb.append("<div style='max-width:600px;margin:0 auto;font-family:-apple-system,BlinkMacSystemFont,\"Segoe UI\",Roboto,sans-serif;'>");

        sb.append("<div style='background:#2c3e50;padding:24px 28px;border-radius:8px 8px 0 0;'>");
        sb.append("<h2 style='margin:0;color:#fff;font-size:18px;font-weight:700;'>📩 새로운 문의가 접수되었습니다</h2>");
        sb.append("</div>");

        sb.append("<div style='border:1px solid #e5e7eb;border-top:none;border-radius:0 0 8px 8px;padding:28px;background:#fff;'>");

        sb.append("<table style='width:100%;border-collapse:collapse;margin-bottom:24px;'>");
        sb.append(infoRow("성명", safeName));
        sb.append(infoRow("연락처", safePhone));
        sb.append(infoRow("제목", safeTitle));
        sb.append("</table>");

        sb.append("<div style='background:#f8f9fa;border:1px solid #e9ecef;border-radius:6px;padding:18px 20px;'>");
        sb.append("<p style='margin:0 0 8px;font-size:13px;font-weight:700;color:#555;'>문의 내용</p>");
        sb.append("<div style='font-size:14px;line-height:1.7;color:#333;'>");
        sb.append(safeContent);
        sb.append("</div></div>");

        String qnaUrl = appProperties.getSiteUrl() + "/bbs/viewBbsQna";
        sb.append("<div style='text-align:center;margin-top:24px;'>");
        sb.append("<a href='").append(qnaUrl).append("' style='display:inline-block;padding:12px 32px;background:#2c3e50;color:#fff;font-size:14px;font-weight:700;text-decoration:none;border-radius:6px;'>답변하러 가기</a>");
        sb.append("</div>");

        sb.append("<p style='margin:16px 0 0;font-size:12px;color:#999;text-align:center;line-height:1.6;'>");
        sb.append("로그인 후 해당 문의글에서 답변을 등록해주세요.");
        sb.append("</p>");

        sb.append("</div></div>");
        sb.append("</body></html>");

        return sb.toString();
    }

    private String infoRow(String label, String value) {
        return "<tr>"
             + "<td style='padding:10px 12px;font-size:13px;font-weight:700;color:#555;background:#f8f9fa;border-bottom:1px solid #eee;width:80px;'>" + label + "</td>"
             + "<td style='padding:10px 12px;font-size:14px;color:#111;border-bottom:1px solid #eee;'>" + value + "</td>"
             + "</tr>";
    }

    // =============================================
    // 유틸리티
    // =============================================

    private String buildPhone(Map<String, Object> paramMap) {
        String p1 = nvl(paramMap.get("phone1"));
        String p2 = nvl(paramMap.get("phone2"));
        String p3 = nvl(paramMap.get("phone3"));
        if (p1.isEmpty() && p2.isEmpty() && p3.isEmpty()) return "-";
        return p1 + "-" + p2 + "-" + p3;
    }

    private String buildEmail(Map<String, Object> paramMap) {
        String e1 = nvl(paramMap.get("email1"));
        String e2 = nvl(paramMap.get("email2"));
        if (e1.isEmpty() || e2.isEmpty()) return "";
        return e1 + "@" + e2;
    }

    private String nvl(Object obj) {
        if (obj == null) return "";
        String s = obj.toString().trim();
        return "null".equals(s) ? "" : s;
    }

    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "");
    }
}
