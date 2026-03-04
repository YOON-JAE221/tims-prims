package com.prims.common.constant;

/**
 * 공통 전역 상수 모음
 * - 값 변경 가능성이 있는 건 properties/yml(DB)로 빼는 걸 권장
 * - 여기에는 "진짜 상수"만 둔다 (코드, 고정값, 키 이름 등)
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
    public static final String RES_RESULT = "result"; // OK/FAIL 같은거 쓸 때

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
     * 게시판 코드 (예: 인사말 고정 BRD_CD)
     * ========================= */
    public static final String BRD_CD_GREETING = "1216aff3025611f18771908d6ec6e544"; //인사말

    public static final String BRD_CD_NOTICE = "38f5e73ffcbf11f08771908d6ec6e544"; //공지사항
    public static final String BRD_CD_DATA = "3f9cdc5efcbf11f08771908d6ec6e544"; //자료실
    public static final String BRD_CD_QNA = "3ccd942dfcbf11f08771908d6ec6e544"; //문의게시판

    public static final String BRD_CD_STRA = "42aa2851fcbf11f08771908d6ec6e544"; //구조설계
    public static final String BRD_CD_STRE = "4bcfe3c20d5311f18771908d6ec6e544"; //구조검토
    public static final String BRD_CD_DISE = "532f6bb10d5311f18771908d6ec6e544"; //해체검토
    public static final String BRD_CD_SAFE = "48e69b00fcbf11f08771908d6ec6e544"; //안전진단
    public static final String BRD_CD_SPFE = "5556c7dc0d5311f18771908d6ec6e544"; //내진성능평가
    public static final String BRD_CD_TERE = "581f52000d5311f18771908d6ec6e544"; //가설재설계
    public static final String BRD_CD_VERA = "99913f3a0d5311f18771908d6ec6e544"; //VE설계
    public static final String BRD_CD_SDSE = "9b6fa3080d5311f18771908d6ec6e544"; //비구조요소 내진설계


    /* =========================
     * 게시판 권한 (예: BRD_PROP_BINARY = F (첨부파일))
     * ========================= */
    public static final String BRD_PROP_IDIV = "A"; //등록구분
    public static final String BRD_PROP_QNA = "Q"; //문의게시판
    public static final String BRD_PROP_FILE = "F"; //첨부파일
    public static final String BRD_PROP_IMG = "S"; //썸네일 이미지

    /* =========================
     * 암호화 키
     * ========================= */
    public static final String ENCRYPT_KEY = "SDR";

    /* =========================
     * 파일 업로드 경로 등(예시)
     * → AppProperties 로 이관됨 (환경별 자동 적용)
     * → 신규 코드에서는 AppProperties 사용할 것
     * ========================= */
    @Deprecated
    public static final String UPLOAD_BASE_DIR = "/web/upload/";
    @Deprecated
    public static final String UPLOAD_BASE_WEB = "/upload";

    /* =========================
     * 이메일 발송 설정
     * ========================= */
    public static final String MAIL_FROM_EMAIL = "minwook8507@gmail.com";     // 발신자 이메일
    public static final String MAIL_FROM_NAME  = "강한건축구조기술사사무소";      // 발신자 이름
    public static final String MAIL_ADMIN_EMAIL = "minuk94@naver.com";       // 관리자 수신 이메일
    public static final String SITE_URL = "http://mwkim-dev.com";          // 사이트 URL (운영 시 도메인으로 변경)

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
     * NHN Cloud SMS 설정 (발신번호 등록 후 값 입력)
     * ========================= */
    public static final String SMS_APP_KEY    = "";   // NHN Cloud Notification > SMS > 앱키
    public static final String SMS_SECRET_KEY = "";   // NHN Cloud Notification > SMS > 비밀키
    public static final String SMS_SENDER_NO  = "";   // 등록된 발신번호 (예: 07076401002)
    
}
