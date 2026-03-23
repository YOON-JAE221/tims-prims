package com.prims.common.util;

import net.coobird.thumbnailator.Thumbnails;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;

/**
 * 이미지 처리 유틸리티
 * - 이미지 압축 (원본 대체)
 */
public class ImageUtil {

    private static final Logger logger = LoggerFactory.getLogger(ImageUtil.class);

    // 압축 설정 (웹 최적화)
    public static final int MAX_WIDTH = 1200;      // 최대 가로
    public static final int MAX_HEIGHT = 1200;     // 최대 세로
    public static final double QUALITY = 0.85;     // 품질 (85%)

    /**
     * 이미지 파일인지 확인
     */
    public static boolean isImageFile(String fileName) {
        if (fileName == null || fileName.isEmpty()) return false;
        String lower = fileName.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") 
            || lower.endsWith(".png") || lower.endsWith(".gif")
            || lower.endsWith(".webp") || lower.endsWith(".bmp");
    }

    /**
     * 이미지 압축 (원본 파일 대체)
     * - 1200px 이하로 리사이즈
     * - 85% 품질로 압축
     * 
     * @param imageFile 원본 파일 (압축 후 덮어씀)
     * @return 압축 성공 여부
     */
    public static boolean compressImage(File imageFile) {
        return compressImage(imageFile, MAX_WIDTH, MAX_HEIGHT, QUALITY);
    }

    /**
     * 이미지 압축 (커스텀 설정)
     */
    public static boolean compressImage(File imageFile, int maxWidth, int maxHeight, double quality) {
        if (imageFile == null || !imageFile.exists()) {
            logger.warn("파일이 없습니다: {}", imageFile);
            return false;
        }

        if (!isImageFile(imageFile.getName())) {
            logger.debug("이미지 파일이 아닙니다: {}", imageFile.getName());
            return false;
        }

        // GIF는 압축하지 않음 (애니메이션 손실)
        if (imageFile.getName().toLowerCase().endsWith(".gif")) {
            logger.debug("GIF 파일은 압축하지 않습니다: {}", imageFile.getName());
            return true;
        }

        long originalSize = imageFile.length();
        
        // 이미 작은 파일은 스킵 (100KB 이하)
        if (originalSize < 100 * 1024) {
            logger.debug("이미 작은 파일입니다 ({}KB): {}", originalSize / 1024, imageFile.getName());
            return true;
        }

        try {
            // 임시 파일로 압축
            File tempFile = new File(imageFile.getAbsolutePath() + ".tmp");

            Thumbnails.of(imageFile)
                    .size(maxWidth, maxHeight)
                    .keepAspectRatio(true)
                    .outputQuality(quality)
                    .toFile(tempFile);

            // 원본 삭제 후 임시파일로 교체
            if (imageFile.delete()) {
                if (tempFile.renameTo(imageFile)) {
                    long newSize = imageFile.length();
                    logger.info("이미지 압축 완료: {} ({}KB → {}KB, {:.1f}% 감소)", 
                            imageFile.getName(),
                            originalSize / 1024,
                            newSize / 1024,
                            (1 - (double)newSize / originalSize) * 100);
                    return true;
                }
            }
            
            // 실패 시 임시파일 정리
            tempFile.delete();
            logger.error("이미지 교체 실패: {}", imageFile.getName());
            return false;

        } catch (IOException e) {
            logger.error("이미지 압축 실패: {} - {}", imageFile.getName(), e.getMessage());
            return false;
        }
    }

    /**
     * 디렉토리 내 모든 이미지 압축 (재귀)
     * @param directory 대상 디렉토리
     * @return 압축된 이미지 개수
     */
    public static int compressImagesInDirectory(File directory) {
        if (directory == null || !directory.isDirectory()) {
            return 0;
        }

        int count = 0;
        File[] files = directory.listFiles();
        
        if (files == null) return 0;

        for (File file : files) {
            if (file.isDirectory()) {
                // 하위 디렉토리 재귀 처리
                count += compressImagesInDirectory(file);
            } else if (isImageFile(file.getName())) {
                if (compressImage(file)) {
                    count++;
                }
            }
        }

        return count;
    }
}
