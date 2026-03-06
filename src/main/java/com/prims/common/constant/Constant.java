package com.prims.common.constant;

/**
 * 공통 전역 상수 모음
 * - 프리머스 부동산
 */
public final class Constant {

    private Constant() {
        throw new UnsupportedOperationException("Constant class");
    }

    /* =========================
     * 공통 세션 키
     * ========================= */
    public static final String SESSION_LOGIN_USER = "loginUser";

    /* =========================
     * 공통 응답 키 (Map JSON)
     * ========================= */
    public static final String RES_DATA = "DATA";
    public static final String RES_MESSAGE = "Message";
    public static final String RES_RESULT_CNT = "resultCnt";
    public static final String RES_RESULT = "result";

    /* =========================
     * 공통 결과 값
     * ========================= */
    public static final String OK = "OK";
    public static final String FAIL = "FAIL";

    /* =========================
     * 비로그인 사용자
     * ========================= */
    public static final String Guest = "GUEST";

    /* =========================
     * 게시판 코드 (TB_BBS_BRD)
     * ========================= */
    public static final String BRD_CD_ABOUT   = "1216aff3025611f18771908d6ec6e544"; // 회사소개
    public static final String BRD_CD_NOTICE  = "38f5e73ffcbf11f08771908d6ec6e544"; // 공지사항
    public static final String BRD_CD_QNA     = "3ccd942dfcbf11f08771908d6ec6e544"; // 문의게시판
    public static final String BRD_CD_FAQ     = "3f9cdc5efcbf11f08771908d6ec6e544"; // FAQ

    /* =========================
     * 게시판 속성 (BRD_PROP_BINARY)
     * ========================= */
    public static final String BRD_PROP_IDIV = "A"; // 등록구분
    public static final String BRD_PROP_QNA  = "Q"; // 문의게시판
    public static final String BRD_PROP_FILE = "F"; // 첨부파일
    public static final String BRD_PROP_IMG  = "S"; // 썸네일 이미지

    /* =========================
     * 암호화 키
     * ========================= */
    public static final String ENCRYPT_KEY = "PARKSE";

    /* =========================
     * 파일 업로드 경로
     * → AppProperties 로 이관됨 (환경별 자동 적용)
     * ========================= */
    @Deprecated
    public static final String UPLOAD_BASE_DIR = "/web/upload/";
    @Deprecated
    public static final String UPLOAD_BASE_WEB = "/upload";

    /* =========================
     * 이메일 발송 설정
     * ========================= */
    public static final String MAIL_FROM_EMAIL  = "minwook8507@gmail.com";   // 발신자 이메일 (추후 변경)
    public static final String MAIL_FROM_NAME   = "프리머스 부동산";
    public static final String MAIL_ADMIN_EMAIL = "minuk94@naver.com";       // 관리자 수신 이메일 (추후 변경)
    public static final String SITE_URL         = "http://primusrealestate.co.kr"; // 사이트 URL

    /* =========================
     * 발송 유형 (TB_SEND_LOG.SEND_TYPE)
     * ========================= */
    public static final String SEND_TYPE_EMAIL    = "E";  // 이메일
    public static final String SEND_TYPE_SMS      = "S";  // SMS
    public static final String SEND_TYPE_ALIMTALK = "A";  // 알림톡

    /* =========================
     * 발송 결과 (TB_SEND_LOG.SEND_RSLT)
     * ========================= */
    public static final String SEND_RSLT_SUCCESS = "SUCCESS";
    public static final String SEND_RSLT_FAIL    = "FAIL";

    /* =========================
     * NHN Cloud SMS 설정
     * ========================= */
    public static final String SMS_APP_KEY    = "";
    public static final String SMS_SECRET_KEY = "";
    public static final String SMS_SENDER_NO  = "";

    /* =========================
     * 매물유형 (TB_PROPERTY.PROP_TYPE)
     * ========================= */
    public static final String PROP_TYPE_APT       = "APT";        // 아파트
    public static final String PROP_TYPE_OFFICETEL  = "OFFICETEL";  // 오피스텔
    public static final String PROP_TYPE_VILLA      = "VILLA";      // 빌라/주택
    public static final String PROP_TYPE_ONEROOM    = "ONEROOM";    // 원룸/투룸
    public static final String PROP_TYPE_SHOP       = "SHOP";       // 상가
    public static final String PROP_TYPE_OFFICE     = "OFFICE";     // 사무실

    /* =========================
     * 거래유형 (TB_PROPERTY.DEAL_TYPE)
     * ========================= */
    public static final String DEAL_TYPE_SELL    = "SELL";    // 매매
    public static final String DEAL_TYPE_JEONSE  = "JEONSE";  // 전세
    public static final String DEAL_TYPE_WOLSE   = "WOLSE";   // 월세
    public static final String DEAL_TYPE_RENT    = "RENT";     // 임대

    /* =========================
     * 매물 뱃지 (TB_PROPERTY.BADGE_TYPE)
     * ========================= */
    public static final String BADGE_NONE      = "NONE";       // 없음
    public static final String BADGE_RECOMMEND = "RECOMMEND";  // 추천
    public static final String BADGE_URGENT    = "URGENT";     // 급매

}
