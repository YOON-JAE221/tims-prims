package com.prims.common.file;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.prims.common.config.AppProperties;
import com.prims.common.constant.Constant;
import com.prims.common.web.ParamMap;


@Controller
@RequestMapping("/file")
public class FileController {

	@Inject
	@Named("FileService")
	private FileService fileService;

	@Inject
	private AppProperties appProperties;
	
	
	  /**
     * 공통 업로드 (물리저장 + TB_UPLD_FILE insert)
     * 요청 FormData:
     *  - file      : MultipartFile (필수)
     *  - subDir    : "license" 같은 업무폴더 (옵션)
     *  - webPrefix : "/upload/" 같은 웹 prefix (옵션)
     */
    @RequestMapping(value = "/commonUpload", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> commonUpload(@RequestParam("file") MultipartFile file,
                                           @RequestParam(value = "subDir", required = false) String subDir,
                                           HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        try {
            if (file == null || file.isEmpty()) {
                result.put("fail", true);
                result.put("message", "파일이 비어 있습니다.");
                return result;
            }

            // 프로젝트 세션 키에 맞게 꺼내
            String ssnUsrCd = session.getAttribute("ssnUsrCd").toString();
            if (ssnUsrCd == null || ssnUsrCd.trim().isEmpty()) ssnUsrCd = "SYSTEM";
            
            

            // (옵션) 추가 메타 필요하면 넣기
            Map<String, Object> meta = new HashMap<>();
            // meta.put("refTable", "TB_LICE");
            // meta.put("refKey", "....");
            
            String webPrefix = appProperties.getUploadBaseWeb() + '/' + subDir;
            Map<String, Object> upRes = fileService.saveCommonFile( file, subDir, webPrefix, ssnUsrCd, meta );

            result.put("success", true);
            result.putAll(upRes); // upldFileCd, orgFileNm, saveFileNm, fileSiz, fileExtn, filePath, url ...

            return result;

        } catch (Exception e) {
            result.put("fail", true);
            result.put("message", e.getMessage());
            return result;
        }
    }
	

    @RequestMapping(value="/editorUpload", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> uploadEditorImage(@RequestParam("image") MultipartFile image, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        String subDir = "editor";

        try {
            // 유효성 검사
            if (image == null || image.isEmpty()) {
                result.put("fail", true);
                result.put("message", "파일이 비어 있습니다.");
                return result;
            }

            // 업로드 디렉토리 없으면 생성
            String uploadDirPath = appProperties.getUploadBaseDir() + subDir + "/";
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // 고유 파일명 생성 (UUID + 확장자)
            String originalName = image.getOriginalFilename();
            String extension = "";
            if (originalName != null && originalName.contains(".")) {
                extension = originalName.substring(originalName.lastIndexOf("."));
            }
            String savedName = UUID.randomUUID().toString() + extension;

            // 저장
            File targetFile = new File(uploadDirPath + savedName);
            image.transferTo(targetFile);

            // 에디터에 삽입할 URL 반환 (웹URL)
            result.put("returnUrl", appProperties.getUploadBaseWeb() + "/" + subDir + "/" + savedName);
        } catch (IOException e) {
            result.put("fail", true);
            result.put("message", "업로드 중 오류 발생: " + e.getMessage());
        }

        return result;
    }
    
    @RequestMapping(value="/editorDelete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> uploadEditorImage(@RequestParam("fileName") String fileName, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        try {
            if (fileName == null || fileName.trim().isEmpty()) {
                result.put("fail", true);
                result.put("message", "fileName is empty");
                return result;
            }

            // 경로조작 방지 (../, \, / 등 차단)
            if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\") || fileName.contains(":")) {
                result.put("fail", true);
                result.put("message", "invalid fileName");
                return result;
            }

            String subDir = "editor";

            Path base = Paths.get(appProperties.getUploadBaseDir(), subDir).normalize(); // C:/upload/editor
            Path target = base.resolve(fileName).normalize();
            if (!target.startsWith(base)) {
        	  result.put("fail", true);
        	  result.put("message", "path traversal detected");
        	  return result;
        	}

            boolean deleted = Files.deleteIfExists(target);

            result.put("success", true);
            result.put("deleted", deleted);
            return result;

        } catch (Exception e) {
            result.put("fail", true);
            result.put("message", "delete error: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 첨부파일 다운로드
     */
    @RequestMapping(value = "/download", method = RequestMethod.GET)
    public void download(@RequestParam("upldFileCd") String upldFileCd,
                         @RequestParam("fileSeq") int fileSeq,
                         HttpServletResponse response) throws Exception {

        Map<String, Object> param = new HashMap<>();
        param.put("upldFileCd", upldFileCd);
        param.put("fileSeq", fileSeq);

        Map<String, Object> fileInfo = fileService.getSelectUpldFileOne(param);

        if (fileInfo == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String savePath = String.valueOf(fileInfo.get("savePath"));
        String saveFileNm = String.valueOf(fileInfo.get("saveFileNm"));
        String fileNm = String.valueOf(fileInfo.get("fileNm"));

        Path filePath = Paths.get(appProperties.getUploadBaseDir(), savePath, saveFileNm).normalize();

        // 경로 이탈 방지
        if (!filePath.startsWith(Paths.get(appProperties.getUploadBaseDir()).normalize())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        File file = filePath.toFile();
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 한글 파일명 처리 (RFC 5987)
        String encodedName = java.net.URLEncoder.encode(fileNm, "UTF-8").replace("+", "%20");

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + encodedName + "\"; filename*=UTF-8''" + encodedName);
        response.setContentLengthLong(file.length());

        Files.copy(filePath, response.getOutputStream());
        response.getOutputStream().flush();
    }
    
    
    @RequestMapping(value = "/deleteFile", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteFile(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();

        try {
            Map<String, Object> fileInfo = fileService.getSelectUpldFileOne(paramMap);

            if (fileInfo != null) {
                fileInfo.put("ssnUsrCd", paramMap.getOrDefault("ssnUsrCd", "SYSTEM"));
                fileService.deleteCommonFile(fileInfo);
            }

            result.put("result", "OK");
        } catch (Exception e) {
            result.put("result", "FAIL");
            result.put("message", e.getMessage());
        }

        return result;
    }
    
    
	
	
}
