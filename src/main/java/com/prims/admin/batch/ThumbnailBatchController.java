package com.prims.admin.batch;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.config.AppProperties;
import com.prims.common.util.ImageUtil;

/**
 * 이미지 일괄 압축 배치 컨트롤러
 * - 기존 업로드된 이미지를 압축하여 용량 절감
 * - 관리자 로그인 필요
 */
@Controller
@RequestMapping("/batch")
public class ThumbnailBatchController {

    private static final Logger logger = LoggerFactory.getLogger(ThumbnailBatchController.class);

    @Autowired
    private AppProperties appProperties;

    /**
     * 기존 이미지 일괄 압축
     * - /upload/property/ 폴더 대상
     * - 원본 파일을 압축된 파일로 교체 (용량 절감)
     */
    @RequestMapping(value = "/compressImages", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> compressImages(HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        // 관리자 로그인 체크
        if (session.getAttribute("loginUser") == null) {
            result.put("result", "FAIL");
            result.put("message", "관리자 로그인이 필요합니다.");
            return result;
        }

        try {
            String uploadBaseDir = appProperties.getUploadBaseDir();
            
            // property 폴더 대상 (매물 이미지)
            File propertyDir = new File(uploadBaseDir + "property");
            
            int totalCount = 0;
            
            if (propertyDir.exists() && propertyDir.isDirectory()) {
                logger.info("이미지 일괄 압축 시작: {}", propertyDir.getAbsolutePath());
                totalCount = ImageUtil.compressImagesInDirectory(propertyDir);
                logger.info("이미지 일괄 압축 완료: {}개 처리", totalCount);
            } else {
                logger.warn("property 디렉토리가 없습니다: {}", propertyDir.getAbsolutePath());
            }

            result.put("result", "OK");
            result.put("count", totalCount);
            result.put("message", totalCount + "개의 이미지가 압축되었습니다.");

        } catch (Exception e) {
            logger.error("이미지 일괄 압축 오류: {}", e.getMessage(), e);
            result.put("result", "FAIL");
            result.put("message", "오류 발생: " + e.getMessage());
        }

        return result;
    }

    /**
     * 압축 대상 이미지 개수 확인 (미리보기)
     */
    @RequestMapping(value = "/compressImagesPreview", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> compressImagesPreview(HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        if (session.getAttribute("loginUser") == null) {
            result.put("result", "FAIL");
            result.put("message", "관리자 로그인이 필요합니다.");
            return result;
        }

        try {
            String uploadBaseDir = appProperties.getUploadBaseDir();
            File propertyDir = new File(uploadBaseDir + "property");
            
            // 압축 대상 파일 개수 확인 (100KB 초과 이미지)
            int[] counts = countLargeImages(propertyDir);
            
            result.put("result", "OK");
            result.put("totalImages", counts[0]);
            result.put("targetImages", counts[1]);  // 100KB 초과
            result.put("targetDir", propertyDir.getAbsolutePath());
            result.put("message", "전체 이미지: " + counts[0] + "개, 압축 대상(100KB+): " + counts[1] + "개");

        } catch (Exception e) {
            result.put("result", "FAIL");
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 큰 이미지 개수 카운트
     * @return [전체 이미지 수, 100KB 초과 이미지 수]
     */
    private int[] countLargeImages(File directory) {
        int[] counts = {0, 0};
        if (directory == null || !directory.isDirectory()) return counts;
        
        File[] files = directory.listFiles();
        if (files == null) return counts;
        
        for (File file : files) {
            if (file.isDirectory()) {
                int[] sub = countLargeImages(file);
                counts[0] += sub[0];
                counts[1] += sub[1];
            } else if (ImageUtil.isImageFile(file.getName())) {
                counts[0]++;
                if (file.length() > 100 * 1024) {  // 100KB 초과
                    counts[1]++;
                }
            }
        }
        return counts;
    }
}
