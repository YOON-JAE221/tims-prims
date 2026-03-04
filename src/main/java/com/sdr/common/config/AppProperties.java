package com.sdr.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 환경별 설정값 보관 빈
 * - application-{profile}.properties 에서 주입
 * - local  : C:/upload/
 * - dev    : /web/upload/
 * - prod   : /web/upload/
 */
@Component
public class AppProperties {

    /** 물리 디스크 저장 루트 (예: C:/upload/ , /web/upload/) */
    @Value("${upload.base.dir}")
    private String uploadBaseDir;

    /** 웹 접근 prefix (예: /upload) */
    @Value("${upload.base.web}")
    private String uploadBaseWeb;

    public String getUploadBaseDir() {
        return uploadBaseDir;
    }

    public String getUploadBaseWeb() {
        return uploadBaseWeb;
    }
}
