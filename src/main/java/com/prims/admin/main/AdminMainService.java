package com.prims.admin.main;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.prims.common.config.AppProperties;
import com.prims.common.util.ImageUtil;

@Service("AdminMainService")
public class AdminMainService {

    private static final Logger logger = LoggerFactory.getLogger(AdminMainService.class);

    @Inject
    private AdminMainDao adminMainDao;

    @Autowired
    private AppProperties appProperties;

    // 압축 진행 상태 (간단한 static 변수 사용)
    private static volatile boolean compressing = false;
    private static volatile String compressStatus = "";
    private static volatile Map<String, Object> compressResult = null;

    // WebP 변환 진행 상태
    private static volatile boolean converting = false;
    private static volatile String convertStatus = "";
    private static volatile Map<String, Object> convertResult = null;

    public Map<String, Object> getPropSummary() {
        return adminMainDao.getPropSummary();
    }

    public Map<String, Object> getQnaSummary() {
        return adminMainDao.getQnaSummary();
    }

    public List<Map<String, Object>> getRecentPropList(Map<String, Object> paramMap) {
        return adminMainDao.getRecentPropList(paramMap);
    }

    public List<Map<String, Object>> getTopPropList() {
        return adminMainDao.getTopPropList();
    }

    public List<Map<String, Object>> getRecentQnaList() {
        return adminMainDao.getRecentQnaList();
    }

    /**
     * 압축 진행 상태 조회 (조회 후 결과 초기화)
     */
    public Map<String, Object> getCompressStatus() {
        Map<String, Object> result = new HashMap<>();
        result.put("compressing", compressing);
        result.put("status", compressStatus);
        if (compressResult != null) {
            result.putAll(compressResult);
            // 완료 결과는 한 번 조회 후 초기화 (진행 중이 아닐 때만)
            if (!compressing) {
                compressResult = null;
                compressStatus = "";
            }
        }
        return result;
    }

    /**
     * 압축 진행 중인지 확인
     */
    public boolean isCompressing() {
        return compressing;
    }

    /**
     * 비동기 이미지 압축 실행
     */
    @Async
    public void compressAllImagesAsync() {
        if (compressing) {
            return; // 이미 진행 중이면 무시
        }

        compressing = true;
        compressStatus = "압축 시작...";
        compressResult = null;

        try {
            String propertyDir = appProperties.getUploadBaseDir() + "property";
            File dir = new File(propertyDir);

            if (!dir.exists() || !dir.isDirectory()) {
                compressStatus = "폴더를 찾을 수 없습니다: " + propertyDir;
                compressResult = new HashMap<>();
                compressResult.put("result", "FAIL");
                compressResult.put("message", compressStatus);
                return;
            }

            compressStatus = "이미지 검색 중...";

            // 일괄 압축 실행
            long[] stats = ImageUtil.compressImagesWithStats(dir);

            compressStatus = "완료";
            compressResult = new HashMap<>();
            compressResult.put("result", "OK");
            compressResult.put("totalCount", stats[0]);
            compressResult.put("successCount", stats[1]);
            compressResult.put("savedBytes", stats[2]);
            compressResult.put("savedMB", String.format("%.2f", stats[2] / 1024.0 / 1024.0));
            compressResult.put("message", String.format("압축 완료: %d개 중 %d개 성공, %.2fMB 절약",
                    stats[0], stats[1], stats[2] / 1024.0 / 1024.0));

            logger.info("이미지 압축 완료: {}개 중 {}개 성공, {}MB 절약", stats[0], stats[1],
                    String.format("%.2f", stats[2] / 1024.0 / 1024.0));

        } catch (Exception e) {
            logger.error("이미지 압축 오류", e);
            compressStatus = "오류 발생";
            compressResult = new HashMap<>();
            compressResult.put("result", "FAIL");
            compressResult.put("message", "압축 중 오류: " + e.getMessage());
        } finally {
            compressing = false;
        }
    }

    // ==================== WebP 변환 ====================

    /**
     * WebP 변환 진행 상태 조회
     */
    public Map<String, Object> getConvertStatus() {
        Map<String, Object> result = new HashMap<>();
        result.put("converting", converting);
        result.put("status", convertStatus);
        if (convertResult != null) {
            result.putAll(convertResult);
            if (!converting) {
                convertResult = null;
                convertStatus = "";
            }
        }
        return result;
    }

    /**
     * WebP 변환 진행 중인지 확인
     */
    public boolean isConverting() {
        return converting;
    }

    /**
     * 비동기 WebP 변환 실행 (백업 + 변환 + DB 업데이트)
     */
    @Async
    public void convertAllToWebpAsync() {
        if (converting) {
            return;
        }

        converting = true;
        convertStatus = "WebP 변환 시작...";
        convertResult = null;

        try {
            String propertyDir = appProperties.getUploadBaseDir() + "property";
            String backupDir = appProperties.getUploadBaseDir() + "property_backup";
            File srcDir = new File(propertyDir);
            File bkDir = new File(backupDir);

            if (!srcDir.exists() || !srcDir.isDirectory()) {
                convertStatus = "폴더를 찾을 수 없습니다: " + propertyDir;
                convertResult = new HashMap<>();
                convertResult.put("result", "FAIL");
                convertResult.put("message", convertStatus);
                return;
            }

            // 1. 백업
            convertStatus = "백업 중...";
            int backupCount = ImageUtil.backupDirectory(srcDir, bkDir);
            logger.info("백업 완료: {}개 파일 → {}", backupCount, backupDir);

            // 2. WebP 변환
            convertStatus = "WebP 변환 중...";
            Object[] result = ImageUtil.convertAllToWebpWithStats(srcDir);
            long[] stats = (long[]) result[0];
            @SuppressWarnings("unchecked")
            List<String[]> convertedFiles = (List<String[]>) result[1];

            // 3. DB 업데이트
            convertStatus = "DB 업데이트 중...";
            int fileUpdateCnt = adminMainDao.updateFileExtToWebp();
            int thumbUpdateCnt = adminMainDao.updateThumbPathToWebp();
            logger.info("DB 업데이트: TB_UPLD_FILE {}건, TB_PROPERTY {}건", fileUpdateCnt, thumbUpdateCnt);

            // 완료
            convertStatus = "완료";
            convertResult = new HashMap<>();
            convertResult.put("result", "OK");
            convertResult.put("totalCount", stats[0]);
            convertResult.put("successCount", stats[1]);
            convertResult.put("savedBytes", stats[2]);
            convertResult.put("savedMB", String.format("%.2f", stats[2] / 1024.0 / 1024.0));
            convertResult.put("backupCount", backupCount);
            convertResult.put("backupDir", backupDir);
            convertResult.put("message", String.format("WebP 변환 완료: %d개 중 %d개 성공, %.2fMB 절약 (백업: %s)",
                    stats[0], stats[1], stats[2] / 1024.0 / 1024.0, backupDir));

            logger.info("WebP 변환 완료: {}개 중 {}개 성공, {}MB 절약", stats[0], stats[1],
                    String.format("%.2f", stats[2] / 1024.0 / 1024.0));

        } catch (Exception e) {
            logger.error("WebP 변환 오류", e);
            convertStatus = "오류 발생";
            convertResult = new HashMap<>();
            convertResult.put("result", "FAIL");
            convertResult.put("message", "WebP 변환 중 오류: " + e.getMessage());
        } finally {
            converting = false;
        }
    }
}
