package com.prims.common.util;

import net.coobird.thumbnailator.Thumbnails;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

/**
 * 이미지 처리 유틸리티
 * - 이미지 압축 (원본 대체)
 * - WebP 변환
 */
public class ImageUtil {

    private static final Logger logger = LoggerFactory.getLogger(ImageUtil.class);

    // 압축 설정 (웹 최적화 - 강화)
    public static final int MAX_WIDTH = 600;       // 최대 가로
    public static final int MAX_HEIGHT = 600;      // 최대 세로
    public static final double QUALITY = 0.65;     // 품질 (65%)

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

    /**
     * 디렉토리 내 모든 이미지 압축 (통계 포함)
     * @param directory 대상 디렉토리
     * @return [총 이미지 수, 압축 성공 수, 절약된 용량(bytes)]
     */
    public static long[] compressImagesWithStats(File directory) {
        long[] stats = new long[3]; // [total, success, savedBytes]
        compressImagesWithStatsRecursive(directory, stats);
        return stats;
    }

    private static void compressImagesWithStatsRecursive(File directory, long[] stats) {
        if (directory == null || !directory.isDirectory()) return;

        File[] files = directory.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                compressImagesWithStatsRecursive(file, stats);
            } else if (isImageFile(file.getName())) {
                // GIF 스킵
                if (file.getName().toLowerCase().endsWith(".gif")) continue;
                
                long originalSize = file.length();
                
                // 이미 작은 파일 스킵
                if (originalSize < 100 * 1024) continue;
                
                stats[0]++; // total
                
                if (compressImageForBatch(file)) {
                    long newSize = file.length();
                    stats[1]++; // success
                    stats[2] += (originalSize - newSize); // savedBytes
                }
            }
        }
    }

    /**
     * 배치용 이미지 압축 (로그 최소화)
     */
    private static boolean compressImageForBatch(File imageFile) {
        try {
            File tempFile = new File(imageFile.getAbsolutePath() + ".tmp");

            Thumbnails.of(imageFile)
                    .size(MAX_WIDTH, MAX_HEIGHT)
                    .keepAspectRatio(true)
                    .outputQuality(QUALITY)
                    .toFile(tempFile);

            if (imageFile.delete() && tempFile.renameTo(imageFile)) {
                return true;
            }
            
            tempFile.delete();
            return false;

        } catch (IOException e) {
            logger.debug("압축 실패: {} - {}", imageFile.getName(), e.getMessage());
            return false;
        }
    }

    // ==================== WebP 변환 ====================

    /**
     * JPG/PNG → WebP 변환 가능한 파일인지 확인
     */
    public static boolean isConvertibleToWebp(String fileName) {
        if (fileName == null || fileName.isEmpty()) return false;
        String lower = fileName.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png");
    }

    /**
     * 단일 파일 WebP 변환 (클라이언트에서 리사이즈 완료된 상태)
     * @param imageFile 원본 이미지 (jpg, png)
     * @return 변환된 WebP 파일 (성공 시), null (실패 시)
     */
    public static File convertToWebp(File imageFile) {
        if (imageFile == null || !imageFile.exists()) {
            logger.warn("파일이 없습니다: {}", imageFile);
            return null;
        }

        if (!isConvertibleToWebp(imageFile.getName())) {
            logger.debug("WebP 변환 불가: {}", imageFile.getName());
            return null;
        }

        try {
            // WebP 파일명 생성 (확장자만 변경)
            String webpPath = imageFile.getAbsolutePath().replaceAll("\\.(jpg|jpeg|png)$", ".webp");
            File webpFile = new File(webpPath);

            // 이미지 읽기
            BufferedImage image = ImageIO.read(imageFile);
            if (image == null) {
                logger.error("이미지 읽기 실패: {}", imageFile.getName());
                return null;
            }

            // WebP로 저장 (ImageIO)
            boolean success = ImageIO.write(image, "webp", webpFile);
            if (!success) {
                logger.error("WebP 저장 실패: {}", imageFile.getName());
                return null;
            }

            logger.debug("WebP 변환 완료: {} → {}", imageFile.getName(), webpFile.getName());
            return webpFile;

        } catch (IOException e) {
            logger.error("WebP 변환 실패: {} - {}", imageFile.getName(), e.getMessage());
            return null;
        }
    }

    /**
     * 디렉토리 백업
     * @param sourceDir 원본 디렉토리
     * @param backupDir 백업 디렉토리
     * @return 백업된 파일 수
     */
    public static int backupDirectory(File sourceDir, File backupDir) throws IOException {
        if (!sourceDir.exists() || !sourceDir.isDirectory()) {
            return 0;
        }

        if (!backupDir.exists()) {
            backupDir.mkdirs();
        }

        int count = 0;
        File[] files = sourceDir.listFiles();
        if (files == null) return 0;

        for (File file : files) {
            File destFile = new File(backupDir, file.getName());
            if (file.isDirectory()) {
                count += backupDirectory(file, destFile);
            } else {
                Files.copy(file.toPath(), destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                count++;
            }
        }

        return count;
    }

    /**
     * 디렉토리 내 모든 이미지 WebP 변환 (통계 포함)
     * @param directory 대상 디렉토리
     * @return [총 대상 수, 변환 성공 수, 절약된 용량(bytes), 변환된 파일 경로 리스트]
     */
    public static Object[] convertAllToWebpWithStats(File directory) {
        long[] stats = new long[3]; // [total, success, savedBytes]
        List<String[]> convertedFiles = new ArrayList<>(); // [원본경로, 새경로]
        convertToWebpRecursive(directory, stats, convertedFiles);
        return new Object[]{stats, convertedFiles};
    }

    private static void convertToWebpRecursive(File directory, long[] stats, List<String[]> convertedFiles) {
        if (directory == null || !directory.isDirectory()) return;

        File[] files = directory.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                convertToWebpRecursive(file, stats, convertedFiles);
            } else if (isConvertibleToWebp(file.getName())) {
                stats[0]++; // total

                long originalSize = file.length();
                File webpFile = convertToWebp(file);

                if (webpFile != null && webpFile.exists()) {
                    long newSize = webpFile.length();
                    
                    // 원본 삭제
                    if (file.delete()) {
                        stats[1]++; // success
                        stats[2] += (originalSize - newSize); // savedBytes
                        
                        // 변환된 파일 정보 저장 (DB 업데이트용)
                        convertedFiles.add(new String[]{
                            file.getAbsolutePath(),
                            webpFile.getAbsolutePath()
                        });
                    } else {
                        // 원본 삭제 실패 시 WebP 파일도 삭제
                        webpFile.delete();
                    }
                }
            }
        }
    }
}
