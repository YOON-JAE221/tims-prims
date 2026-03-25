package com.prims.common.file;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.prims.common.config.AppProperties;
import com.prims.common.util.ImageUtil;
import com.prims.common.util.Utility;

@Service("FileService")
public class FileService {

    @Autowired
    private FileDao fileDao;

    @Autowired
    private AppProperties appProperties;

    /**
     * 공통 첨부 1건 저장
     * - 물리 저장 + TB_UPLD_FILE INSERT
     * - 반환: upldFileCd, url, filePath, saveFileNm, orgFileNm, fileSiz, fileExtn ...
     *
     * @param file      업로드 파일
     * @param subDir    업무별 폴더명 (예: "editor", "license", "bbs", "popup" ...)
     * @param webPrefix 웹 접근 prefix (예: "/upload/editor/", "/upload/license/")  // 리소스 매핑에 맞춰 넘겨
     * @param ssnUsrCd  세션 사용자
     * @param meta      추가 메타(옵션) - 화면/테이블/참조키 등 공통 저장하고 싶으면 넣어
     */
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> saveCommonFile(MultipartFile file,
                                             String subDir,
                                             String webPrefix,
                                             String ssnUsrCd,
                                             Map<String, Object> meta) throws Exception {

        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("file is empty");
        }
        if (subDir == null || subDir.trim().isEmpty()) subDir = "common";

        // ====== 경로 규칙: {UPLOAD_BASE_DIR}/{subDir}/ ======
        String ym = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMM"));

        String physDir = appProperties.getUploadBaseDir() + subDir + "/" + ym + "/";// C:/upload/license/
        String webDir  = "/" + normalizeWebDir(subDir) + ym + "/"; //license / 202500

        // 만약 webPrefix 자체가 "/upload/editor/" 처럼 subDir 포함이라면:
        // webDir = normalizeWebDir(webPrefix) + ymd + "/";

        mkdirs(physDir);

        String orgFileNm = (file.getOriginalFilename() == null) ? "" : file.getOriginalFilename();
        String fileExtn = getExt(orgFileNm);           // "jpg"
        String dotExt = fileExtn.isEmpty() ? "" : "." + fileExtn;

        // 저장 파일명 (uuid32 + 확장자)
        String saveFileNm = Utility.getUuidPk32() + dotExt;

        Path target = Paths.get(physDir, saveFileNm).normalize();

        // ====== 물리 저장 ======
        Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

        // ====== DB 저장용 PK ======
        String upldFileCd = Utility.getUuidPk32();

        // ====== TB_UPLD_FILE insert param ======
        Map<String, Object> p = new HashMap<>();
        p.put("upldFileCd", upldFileCd);
        p.put("fileSeq", 1);
        p.put("fileNm", orgFileNm);
        p.put("saveFileNm", saveFileNm);

        // ✅ 테이블에 "물리경로" 저장하는지 "웹경로" 저장하는지 너희 기준으로 통일
        // 보통은 "물리경로(디스크)" + "웹prefix"를 함께 저장하거나,
        // 아니면 filePath를 웹경로로 저장하고 실제 디스크는 규칙으로 재구성.
        p.put("savePath", webDir);        // 여기선 웹경로 기준
//        p.put("physPath", physDir);       // 컬럼 없으면 mapper에서 빼도 됨

        p.put("fileSiz", file.getSize());
        p.put("fileExtn", fileExtn);
        p.put("useYn", "Y");
        p.put("delYn", "N");
        p.put("ssnUsrCd", ssnUsrCd);

        // 추가 메타(옵션) - refTable/refKey 같은 거 저장하고 싶으면 여기서 합쳐서 insert
        if (meta != null && !meta.isEmpty()) {
            p.putAll(meta);
        }

        try {
            fileDao.insertUpldFile(p);
        } catch (Exception dbEx) {
            // DB 실패하면 물리파일 롤백
            try { Files.deleteIfExists(target); } catch (Exception ignore) {}
            throw dbEx;
        }

        // ====== 반환 ======
        Map<String, Object> r = new HashMap<>();
        r.put("upldFileCd", upldFileCd);
        r.put("orgFileNm", orgFileNm);
        r.put("saveFileNm", saveFileNm);
        r.put("fileSiz", file.getSize());
        r.put("fileExtn", fileExtn);
        r.put("filePath", webDir);
        r.put("url", webDir + saveFileNm);
        return r;
    }

    /** 공통 첨부 여러 건 저장 */
    @Transactional(rollbackFor = Exception.class)
    public List<Map<String, Object>> saveCommonFiles(List<MultipartFile> files,
                                                     String subDir,
                                                     String webPrefix,
                                                     String ssnUsrCd,
                                                     Map<String, Object> meta) throws Exception {
        List<Map<String, Object>> out = new ArrayList<>();
        if (files == null || files.isEmpty()) return out;

        int seq = 1;
        for (MultipartFile f : files) {
            Map<String, Object> oneMeta = (meta == null) ? new HashMap<>() : new HashMap<>(meta);
            oneMeta.put("fileSeq", seq++); // 다건이면 seq 증가시키고 싶을 때
            out.add(saveCommonFile(f, subDir, webPrefix, ssnUsrCd, oneMeta));
        }
        return out;
    }

    // ----------------- 내부 유틸 -----------------
    private static void mkdirs(String dir) {
        File d = new File(dir);
        if (!d.exists()) d.mkdirs();
    }

    private static String getExt(String fileName) {
        if (fileName == null) return "";
        int idx = fileName.lastIndexOf('.');
        if (idx < 0) return "";
        return fileName.substring(idx + 1).toLowerCase();
    }

    private static String normalizeWebDir(String s) {
        if (s == null || s.isEmpty()) return "/";
        return s.endsWith("/") ? s : (s + "/");
    }
    
    
    //파일 물리 삭제 및 파일테이블 논리삭제 (게시판용)
    @Transactional(rollbackFor = Exception.class)
    public int deleteCommonFile(Map<String, Object> fileMap) throws Exception {

        String upldFileCd = String.valueOf(fileMap.get("upldFileCd"));
        int fileSeq       = Integer.parseInt(String.valueOf(fileMap.get("fileSeq")));
        String savePath   = String.valueOf(fileMap.get("savePath"));     // 예: "/upload/license/" 또는 "license/"
        String saveFileNm = String.valueOf(fileMap.get("saveFileNm"));   // 예: "uuid.jpg"
        String ssnUsrCd   = String.valueOf(fileMap.get("ssnUsrCd"));

        // 1) 물리 삭제 (SAVE_PATH + SAVE_FILE_NM)
        // savePath가 "/upload/..."(웹경로)로 저장된 경우 "upload/" 제거해서 디스크 경로로 변환
        String relPath = savePath.replace("\\", "/");

        // 베이스 + 상대경로 + 파일명
        Path target = Paths.get(appProperties.getUploadBaseDir(), relPath, saveFileNm).normalize();

        // (최소 안전장치) 베이스 밖으로 나가면 중단
        Path base = Paths.get(appProperties.getUploadBaseDir()).normalize();
        if (!target.startsWith(base)) {
            throw new IllegalArgumentException("invalid path");
        }

        Files.deleteIfExists(target);

        // 2) TB_UPLD_FILE 논리 삭제(DEL_YN='Y')
        Map<String, Object> map = new HashMap<>();
        map.put("upldFileCd", upldFileCd);
        map.put("fileSeq", fileSeq);
        map.put("ssnUsrCd", ssnUsrCd);

        return fileDao.updateUpldFileDelYn(map);
    }

    /**
     * 파일 물리 삭제 및 파일테이블 물리삭제 (매물관리용)
     * - 물리파일 삭제 + DB에서 완전 삭제
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteCommonFilePhysical(Map<String, Object> fileMap) throws Exception {

        String upldFileCd = String.valueOf(fileMap.get("upldFileCd"));
        int fileSeq       = Integer.parseInt(String.valueOf(fileMap.get("fileSeq")));
        String savePath   = String.valueOf(fileMap.get("savePath"));
        String saveFileNm = String.valueOf(fileMap.get("saveFileNm"));

        // 1) 물리 파일 삭제
        String relPath = savePath.replace("\\", "/");
        Path target = Paths.get(appProperties.getUploadBaseDir(), relPath, saveFileNm).normalize();

        Path base = Paths.get(appProperties.getUploadBaseDir()).normalize();
        if (!target.startsWith(base)) {
            throw new IllegalArgumentException("invalid path");
        }

        Files.deleteIfExists(target);

        // 2) TB_UPLD_FILE 물리 삭제 (DELETE)
        Map<String, Object> map = new HashMap<>();
        map.put("upldFileCd", upldFileCd);
        map.put("fileSeq", fileSeq);

        return fileDao.deleteUpldFile(map);
    }
   
    
    /**
     * 게시판용 첨부파일 다건 저장
     * - 동일 upldFileCd(ATCH_FILE_KEY)로 묶어서 저장
     * - 이미지: 압축 → WebP 변환
     *
     * @return upldFileCd (= ATCH_FILE_KEY), 파일 없으면 null
     */
    @Transactional(rollbackFor = Exception.class)
    public String saveBbsAtchFiles(List<MultipartFile> files,
                                   String subDir,
                                   String ssnUsrCd) throws Exception {
        return saveBbsAtchFiles(files, subDir, ssnUsrCd, null);
    }

    /**
     * 게시판용 첨부파일 다건 저장 (기존 키에 추가 가능)
     * - existingKey가 있으면 해당 키에 추가, 없으면 새 키 생성
     * - 병렬 처리로 WebP 변환 속도 개선
     *
     * @param existingKey 기존 upldFileCd (수정 모드에서 기존 파일에 추가할 때)
     * @return upldFileCd
     */
    @Transactional(rollbackFor = Exception.class)
    public String saveBbsAtchFiles(List<MultipartFile> files,
                                   String subDir,
                                   String ssnUsrCd,
                                   String existingKey) throws Exception {

        if (files == null || files.isEmpty()) return existingKey;
        if (subDir == null || subDir.trim().isEmpty()) subDir = "bbs";

        // 기존 키가 있으면 사용, 없으면 새로 생성
        String upldFileCd = (existingKey != null && !existingKey.isEmpty() && !"null".equals(existingKey))
                            ? existingKey : Utility.getUuidPk32();

        String ym = java.time.LocalDate.now()
                    .format(java.time.format.DateTimeFormatter.ofPattern("yyyyMM"));
        String physDir = appProperties.getUploadBaseDir() + subDir + "/" + ym + "/";
        String webDir  = "/" + subDir + "/" + ym + "/";

        File dir = new File(physDir);
        if (!dir.exists()) dir.mkdirs();

        // 기존 키 사용 시 최대 fileSeq 조회
        AtomicInteger seqCounter = new AtomicInteger(1);
        if (existingKey != null && !existingKey.isEmpty() && !"null".equals(existingKey)) {
            Map<String, Object> param = new HashMap<>();
            param.put("upldFileCd", existingKey);
            List<Map<String, Object>> existingFiles = fileDao.getSelectUpldFileList(param);
            if (existingFiles != null && !existingFiles.isEmpty()) {
                int maxSeq = 0;
                for (Map<String, Object> f : existingFiles) {
                    int fSeq = Integer.parseInt(String.valueOf(f.get("fileSeq")));
                    if (fSeq > maxSeq) maxSeq = fSeq;
                }
                seqCounter.set(maxSeq + 1);
            }
        }

        // 유효한 파일만 필터링
        List<MultipartFile> validFiles = files.stream()
                .filter(f -> f != null && !f.isEmpty())
                .collect(Collectors.toList());

        if (validFiles.isEmpty()) return existingKey;

        // 결과 저장용 (순서 보장 위해 ConcurrentHashMap 사용)
        final String finalPhysDir = physDir;
        final String finalWebDir = webDir;
        Map<Integer, Map<String, Object>> resultMap = new ConcurrentHashMap<>();

        // ★ 병렬 처리: 파일 저장 + WebP 변환 ★
        validFiles.parallelStream().forEach(f -> {
            try {
                int seq = seqCounter.getAndIncrement();
                
                String orgFileNm = (f.getOriginalFilename() == null) ? "" : f.getOriginalFilename();
                String fileExtn = "";
                if (orgFileNm.contains(".")) {
                    fileExtn = orgFileNm.substring(orgFileNm.lastIndexOf('.') + 1).toLowerCase();
                }
                String dotExt = fileExtn.isEmpty() ? "" : "." + fileExtn;
                String saveFileNm = Utility.getUuidPk32() + dotExt;

                // 물리 저장
                Path target = Paths.get(finalPhysDir, saveFileNm).normalize();
                Files.copy(f.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

                long fileSiz = f.getSize();

                // 이미지 파일 처리: WebP 변환 (JPG/PNG → WebP)
                if (ImageUtil.isImageFile(saveFileNm) && ImageUtil.isConvertibleToWebp(saveFileNm)) {
                    File webpFile = ImageUtil.convertToWebp(target.toFile());
                    if (webpFile != null && webpFile.exists()) {
                        // 원본 삭제
                        Files.deleteIfExists(target);
                        // 파일명, 확장자 변경
                        saveFileNm = webpFile.getName();
                        fileExtn = "webp";
                        fileSiz = webpFile.length();
                    }
                }

                // 결과 저장
                Map<String, Object> fileInfo = new HashMap<>();
                fileInfo.put("seq", seq);
                fileInfo.put("orgFileNm", orgFileNm);
                fileInfo.put("saveFileNm", saveFileNm);
                fileInfo.put("fileExtn", fileExtn);
                fileInfo.put("fileSiz", fileSiz);
                resultMap.put(seq, fileInfo);

            } catch (Exception e) {
                throw new RuntimeException("파일 처리 실패: " + f.getOriginalFilename(), e);
            }
        });

        // ★ 순차 처리: DB 저장 (순서대로) ★
        List<Integer> sortedKeys = resultMap.keySet().stream().sorted().collect(Collectors.toList());
        int savedCount = 0;
        
        for (Integer seq : sortedKeys) {
            Map<String, Object> fileInfo = resultMap.get(seq);
            
            Map<String, Object> p = new HashMap<>();
            p.put("upldFileCd", upldFileCd);
            p.put("fileSeq", seq);
            p.put("fileNm", fileInfo.get("orgFileNm"));
            p.put("saveFileNm", fileInfo.get("saveFileNm"));
            p.put("savePath", finalWebDir);
            p.put("fileSiz", fileInfo.get("fileSiz"));
            p.put("fileExtn", fileInfo.get("fileExtn"));
            p.put("useYn", "Y");
            p.put("delYn", "N");
            p.put("ssnUsrCd", ssnUsrCd);

            try {
                fileDao.insertUpldFile(p);
                savedCount++;
            } catch (Exception dbEx) {
                // 실패 시 해당 파일 삭제
                try { 
                    Files.deleteIfExists(Paths.get(finalPhysDir, String.valueOf(fileInfo.get("saveFileNm")))); 
                } catch (Exception ignore) {}
                throw dbEx;
            }
        }

        return (savedCount > 0 || (existingKey != null && !existingKey.isEmpty())) ? upldFileCd : null;
    }
    
    
    /**
     * 게시판 첨부파일 일괄 삭제 (물리 + DB)
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteBbsAtchFiles(String upldFileCd, String ssnUsrCd) throws Exception {

        // 해당 키의 파일 목록 조회
        Map<String, Object> param = new HashMap<>();
        param.put("upldFileCd", upldFileCd);
        List<Map<String, Object>> fileList = fileDao.getSelectUpldFileList(param);

        if (fileList == null || fileList.isEmpty()) return;

        for (Map<String, Object> file : fileList) {
            file.put("ssnUsrCd", ssnUsrCd);
            deleteCommonFile(file);
        }
    }
    
    public List<Map<String, Object>> getSelectUpldFileList(Map<String, Object> paramMap) {
        return fileDao.getSelectUpldFileList(paramMap);
    }
    
    public Map<String, Object> getSelectUpldFileOne(Map<String, Object> paramMap) {
        return fileDao.getSelectUpldFileOne(paramMap);
    }
    
    /**
     * 파일 순서 일괄 업데이트
     * @param upldFileCd 파일 그룹 키
     * @param orderList  [{oldFileSeq: 1, newFileSeq: 2}, ...]
     * @param ssnUsrCd   세션 사용자
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateFileOrder(String upldFileCd, List<Map<String, Object>> orderList, String ssnUsrCd) {
        if (upldFileCd == null || orderList == null || orderList.isEmpty()) return;

        for (Map<String, Object> item : orderList) {
            Map<String, Object> param = new HashMap<>();
            param.put("upldFileCd", upldFileCd);
            param.put("oldFileSeq", item.get("oldFileSeq"));
            param.put("newFileSeq", item.get("newFileSeq"));
            param.put("ssnUsrCd", ssnUsrCd);
            fileDao.updateFileSeq(param);
        }
    }


    
}
