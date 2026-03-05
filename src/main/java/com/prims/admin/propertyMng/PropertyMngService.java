package com.prims.admin.propertyMng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.prims.common.constant.Constant;
import com.prims.common.file.FileService;
import com.prims.common.util.Utility;

@Service("PropertyMngService")
public class PropertyMngService {

    @Autowired
    private PropertyMngDao propertyMngDao;

    @Autowired
    private FileService fileService;

    public List<Map<String, Object>> getSelectPropertyList(Map<String, Object> paramMap) {
        return propertyMngDao.getSelectPropertyList(paramMap);
    }

    public int getSelectPropertyCount(Map<String, Object> paramMap) {
        return propertyMngDao.getSelectPropertyCount(paramMap);
    }

    public Map<String, Object> getSelectPropertyDetail(Map<String, Object> paramMap) {
        return propertyMngDao.getSelectPropertyDetail(paramMap);
    }

    public List<Map<String, Object>> getSelectUpldFileList(Map<String, Object> paramMap) {
        return fileService.getSelectUpldFileList(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int saveProperty(Map<String, Object> paramMap, MultipartFile[] atchFile) throws Exception {

        // 첨부파일 처리
        if (atchFile != null) {
            List<MultipartFile> fileList = new ArrayList<>();
            for (MultipartFile f : atchFile) {
                if (f != null && !f.isEmpty()) fileList.add(f);
            }
            if (!fileList.isEmpty()) {
                String atchFileKey = fileService.saveBbsAtchFiles(fileList, "property", paramMap.get("ssnUsrCd").toString());
                if (atchFileKey != null) {
                    paramMap.put("atchFileKey", atchFileKey);
                }
            }
        }

        // 신규/수정 분기
        String propCd = String.valueOf(paramMap.getOrDefault("propCd", ""));
        boolean isNew = propCd.isEmpty() || "null".equals(propCd);
        if (isNew) {
            paramMap.put("propCd", Utility.getUuidPk32());
        }

        // MAIN_YN 변경 시 MAIN_YN_DTM 설정
        String mainYn = String.valueOf(paramMap.getOrDefault("mainYn", "N"));
        if ("Y".equals(mainYn)) {
            paramMap.put("mainYnDtm", "NOW()");
        }

        return propertyMngDao.saveProperty(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteProperty(Map<String, Object> paramMap) throws Exception {
        return propertyMngDao.deleteProperty(paramMap);
    }
}
