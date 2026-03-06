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

        // 숫자 필드 변환 (빈 문자열 → 0)
        paramMap.put("sellPrice", toLong(paramMap.get("sellPrice")));
        paramMap.put("deposit", toLong(paramMap.get("deposit")));
        paramMap.put("monthlyRent", toLong(paramMap.get("monthlyRent")));
        paramMap.put("mgmtCost", toInt(paramMap.get("mgmtCost")));
        paramMap.put("roomCnt", toInt(paramMap.get("roomCnt")));
        paramMap.put("bathCnt", toInt(paramMap.get("bathCnt")));
        paramMap.put("areaExclusive", toDecimal(paramMap.get("areaExclusive")));
        paramMap.put("areaSupply", toDecimal(paramMap.get("areaSupply")));
        paramMap.put("lat", toDecimal(paramMap.get("lat")));
        paramMap.put("lng", toDecimal(paramMap.get("lng")));

        // 기본값 처리
        if (paramMap.get("mainYn") == null || "".equals(paramMap.get("mainYn"))) paramMap.put("mainYn", "N");
        if (paramMap.get("soldYn") == null || "".equals(paramMap.get("soldYn"))) paramMap.put("soldYn", "N");
        if (paramMap.get("badgeType") == null || "".equals(paramMap.get("badgeType"))) paramMap.put("badgeType", "NONE");

        // MAIN_YN_DTM 로직
        String mainYn = String.valueOf(paramMap.get("mainYn"));
        if ("N".equals(mainYn)) {
            // N이면 무조건 null
            paramMap.put("mainYnDtm", null);
        } else {
            // Y일 때: 기존 데이터 확인
            if (isNew) {
                // 신규: NOW
                paramMap.put("mainYnDtm", new java.sql.Timestamp(System.currentTimeMillis()));
            } else {
                // 수정: 기존 값 확인
                Map<String, Object> existing = propertyMngDao.getSelectPropertyDetail(paramMap);
                String oldMainYn = existing != null ? String.valueOf(existing.getOrDefault("mainYn", "N")) : "N";
                if ("Y".equals(oldMainYn)) {
                    // Y→Y: 기존값 유지
                    paramMap.put("mainYnDtm", existing.get("mainYnDtm"));
                } else {
                    // N→Y: NOW
                    paramMap.put("mainYnDtm", new java.sql.Timestamp(System.currentTimeMillis()));
                }
            }
        }

        return propertyMngDao.saveProperty(paramMap);
    }

    private long toLong(Object val) {
        if (val == null) return 0;
        String s = val.toString().trim();
        if (s.isEmpty()) return 0;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return 0; }
    }

    private int toInt(Object val) {
        if (val == null) return 0;
        String s = val.toString().trim();
        if (s.isEmpty()) return 0;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return 0; }
    }

    private java.math.BigDecimal toDecimal(Object val) {
        if (val == null) return null;
        String s = val.toString().trim();
        if (s.isEmpty()) return null;
        try { return new java.math.BigDecimal(s); } catch (NumberFormatException e) { return null; }
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteProperty(Map<String, Object> paramMap) throws Exception {
        return propertyMngDao.deleteProperty(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public String copyProperty(Map<String, Object> paramMap) throws Exception {
        String newPropCd = Utility.getUuidPk32();
        paramMap.put("newPropCd", newPropCd);
        propertyMngDao.copyProperty(paramMap);
        return newPropCd;
    }
}
