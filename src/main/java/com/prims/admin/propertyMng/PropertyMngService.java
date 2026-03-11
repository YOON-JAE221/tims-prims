package com.prims.admin.propertyMng;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
    public int saveProperty(Map<String, Object> paramMap, MultipartFile[] atchFile, String[] deleteFiles) throws Exception {

        // 기존 첨부파일 삭제 처리
        if (deleteFiles != null && deleteFiles.length > 0) {
            for (String delKey : deleteFiles) {
                if (delKey == null || delKey.isEmpty()) continue;
                String[] parts = delKey.split(":");
                if (parts.length < 2) continue;
                Map<String, Object> fileParam = new HashMap<>();
                fileParam.put("upldFileCd", parts[0]);
                fileParam.put("fileSeq", Integer.parseInt(parts[1]));
                Map<String, Object> fileInfo = fileService.getSelectUpldFileOne(fileParam);
                if (fileInfo != null) {
                    fileService.deleteCommonFilePhysical(fileInfo);
                }
            }
        }

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

        // 숫자 필드 변환
        paramMap.put("sellPrice", toLong(paramMap.get("sellPrice")));
        paramMap.put("deposit", toLong(paramMap.get("deposit")));
        paramMap.put("monthlyRent", toLong(paramMap.get("monthlyRent")));
        paramMap.put("loanAmount", toLong(paramMap.get("loanAmount")));
        paramMap.put("premium", toLong(paramMap.get("premium")));
        paramMap.put("monthlyMgmt", toLong(paramMap.get("monthlyMgmt")));
        paramMap.put("roomCnt", toInt(paramMap.get("roomCnt")));
        paramMap.put("bathCnt", toInt(paramMap.get("bathCnt")));
        paramMap.put("floorTotal", toInt(paramMap.get("floorTotal")));
        paramMap.put("areaExclusive", toDecimal(paramMap.get("areaExclusive")));
        paramMap.put("areaSupply", toDecimal(paramMap.get("areaSupply")));
        paramMap.put("areaLand", toDecimal(paramMap.get("areaLand")));
        paramMap.put("lat", toDecimal(paramMap.get("lat")));
        paramMap.put("lng", toDecimal(paramMap.get("lng")));

        // 기본값 처리
        if (paramMap.get("soldYn") == null || "".equals(paramMap.get("soldYn"))) paramMap.put("soldYn", "N");
        if (paramMap.get("displayYn") == null || "".equals(paramMap.get("displayYn"))) paramMap.put("displayYn", "Y");
        // 빈 날짜 null 처리
        if ("".equals(paramMap.get("displayStart"))) paramMap.put("displayStart", null);
        if ("".equals(paramMap.get("displayEnd"))) paramMap.put("displayEnd", null);

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
        // 1. 매물 상세 조회 (첨부파일 키 확인)
        Map<String, Object> prop = propertyMngDao.getSelectPropertyDetail(paramMap);
        if (prop != null) {
            String atchFileKey = String.valueOf(prop.getOrDefault("atchFileKey", ""));
            if (!atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
                // 2. 첨부파일 목록 조회
                Map<String, Object> fileParam = new HashMap<>();
                fileParam.put("upldFileCd", atchFileKey);
                List<Map<String, Object>> fileList = fileService.getSelectUpldFileList(fileParam);
                
                // 3. 각 파일 물리 삭제
                for (Map<String, Object> fileInfo : fileList) {
                    fileService.deleteCommonFilePhysical(fileInfo);
                }
            }
        }
        
        // 4. 매물 DB 삭제
        return propertyMngDao.deleteProperty(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public String copyProperty(Map<String, Object> paramMap) throws Exception {
        String newPropCd = Utility.getUuidPk32();
        paramMap.put("newPropCd", newPropCd);
        propertyMngDao.copyProperty(paramMap);
        return newPropCd;
    }

    /**
     * 거래완료 처리
     * 1. 첨부파일 물리삭제
     * 2. SOLD_YN = 'Y', ATCH_FILE_KEY = NULL 업데이트
     */
    @Transactional(rollbackFor = Exception.class)
    public int completeProperty(Map<String, Object> paramMap) throws Exception {
        // 1. 매물 상세 조회 (첨부파일 키 확인)
        Map<String, Object> prop = propertyMngDao.getSelectPropertyDetail(paramMap);
        if (prop == null) {
            throw new Exception("매물 정보를 찾을 수 없습니다.");
        }
        
        // 이미 거래완료 상태면 처리 불가
        if ("Y".equals(prop.get("soldYn"))) {
            throw new Exception("이미 거래완료된 매물입니다.");
        }
        
        String atchFileKey = String.valueOf(prop.getOrDefault("atchFileKey", ""));
        if (!atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
            // 2. 첨부파일 목록 조회
            Map<String, Object> fileParam = new HashMap<>();
            fileParam.put("upldFileCd", atchFileKey);
            List<Map<String, Object>> fileList = fileService.getSelectUpldFileList(fileParam);
            
            // 3. 각 파일 물리 삭제
            for (Map<String, Object> fileInfo : fileList) {
                fileService.deleteCommonFilePhysical(fileInfo);
            }
        }
        
        // 4. SOLD_YN = 'Y', ATCH_FILE_KEY = NULL 업데이트
        return propertyMngDao.completeProperty(paramMap);
    }

    public List<Map<String, Object>> getCatListForSelect() {
        return propertyMngDao.getCatListForSelect();
    }

    public List<Map<String, Object>> getSubCatListForSelect(String catCd) {
        return propertyMngDao.getSubCatListForSelect(catCd);
    }

    @Transactional(rollbackFor = Exception.class)
    public int updatePropertySoldYnList(List<Map<String, Object>> mergeRows, String ssnUsrCd) {
        int cnt = 0;
        for (Map<String, Object> row : mergeRows) {
            row.put("ssnUsrCd", ssnUsrCd);
            cnt += propertyMngDao.updatePropertySoldYn(row);
        }
        return cnt;
    }

    /**
     * 매물 엑셀 다운로드
     */
    public void downloadPropertyExcel(Map<String, Object> paramMap, HttpServletResponse response) throws IOException {
        List<Map<String, Object>> list = propertyMngDao.getPropertyListForExcel(paramMap);

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("매물목록");

            // 헤더 스타일
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            // 데이터 스타일
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // 숫자 스타일 (천단위 콤마)
            CellStyle numberStyle = workbook.createCellStyle();
            numberStyle.cloneStyleFrom(dataStyle);
            numberStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));

            // 헤더 정의
            String[] headers = {
                "매물명", "대분류", "소분류", "거래유형", "매물특징",
                "주소", "상세주소", "건물명",
                "매매가(만원)", "보증금(만원)", "월세(만원)", "융자", "융자금액(만원)", "권리금(만원)", "월관리비(만원)",
                "공급면적(㎡)", "전용면적(㎡)", "대지면적(㎡)",
                "층", "총층수", "방수", "욕실수", "방향", "주차",
                "준공일", "현관구조", "난방방식",
                "거래상태", "등록일"
            };

            // 헤더 행 생성
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 데이터 행 생성
            int rowNum = 1;
            for (Map<String, Object> data : list) {
                Row row = sheet.createRow(rowNum++);
                int col = 0;

                // 기본정보
                createCell(row, col++, getString(data, "propNm"), dataStyle);
                createCell(row, col++, getString(data, "catNm"), dataStyle);
                createCell(row, col++, getString(data, "subCatNm"), dataStyle);
                createCell(row, col++, getString(data, "dealTypeNm"), dataStyle);
                createCell(row, col++, getString(data, "propFeature"), dataStyle);

                // 매물소재지
                createCell(row, col++, getString(data, "address"), dataStyle);
                createCell(row, col++, getString(data, "addressDtl"), dataStyle);
                createCell(row, col++, getString(data, "buildingNm"), dataStyle);

                // 가격정보
                createNumericCell(row, col++, data.get("sellPrice"), numberStyle);
                createNumericCell(row, col++, data.get("deposit"), numberStyle);
                createNumericCell(row, col++, data.get("monthlyRent"), numberStyle);
                createCell(row, col++, getString(data, "loanYnNm"), dataStyle);
                createNumericCell(row, col++, data.get("loanAmount"), numberStyle);
                createNumericCell(row, col++, data.get("premium"), numberStyle);
                createNumericCell(row, col++, data.get("monthlyMgmt"), numberStyle);

                // 면적
                createNumericCell(row, col++, data.get("areaSupply"), numberStyle);
                createNumericCell(row, col++, data.get("areaExclusive"), numberStyle);
                createNumericCell(row, col++, data.get("areaLand"), numberStyle);

                // 층/방
                createCell(row, col++, getString(data, "floorNo"), dataStyle);
                createNumericCell(row, col++, data.get("floorTotal"), numberStyle);
                createNumericCell(row, col++, data.get("roomCnt"), numberStyle);
                createNumericCell(row, col++, data.get("bathCnt"), numberStyle);
                createCell(row, col++, getString(data, "direction"), dataStyle);
                createCell(row, col++, getString(data, "parkingYnNm"), dataStyle);

                // 건물
                createCell(row, col++, getString(data, "buildDate"), dataStyle);
                createCell(row, col++, getString(data, "entranceType"), dataStyle);
                createCell(row, col++, getString(data, "heating"), dataStyle);

                // 상태
                createCell(row, col++, getString(data, "soldYnNm"), dataStyle);
                createCell(row, col++, getString(data, "rgtDtm"), dataStyle);
            }

            // 컬럼 너비 자동 조절 (일부만)
            for (int i = 0; i < Math.min(headers.length, 10); i++) {
                sheet.autoSizeColumn(i);
            }

            // 파일명 생성
            String fileName = "매물목록_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".xlsx";
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString()).replace("+", "%20");

            // 응답 헤더 설정
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

            // 엑셀 파일 출력
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
        }
    }

    private void createCell(Row row, int col, String value, CellStyle style) {
        Cell cell = row.createCell(col);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }

    private void createNumericCell(Row row, int col, Object value, CellStyle style) {
        Cell cell = row.createCell(col);
        if (value != null) {
            try {
                cell.setCellValue(Double.parseDouble(value.toString()));
            } catch (NumberFormatException e) {
                cell.setCellValue(value.toString());
            }
        }
        cell.setCellStyle(style);
    }

    private String getString(Map<String, Object> map, String key) {
        Object val = map.get(key);
        return val != null ? val.toString() : "";
    }
}
