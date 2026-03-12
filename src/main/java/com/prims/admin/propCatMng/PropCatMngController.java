package com.prims.admin.propCatMng;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.constant.Constant;

@Controller
@RequestMapping("/propCatMng")
public class PropCatMngController {

    @Autowired
    private PropCatMngDao propCatMngDao;

    // 카테고리관리 화면
    @RequestMapping(value = "/viewPropCatMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropCatMng(Model model) {
        return "admin/propCatMng/propCatMng";
    }

    // 카테고리 전체 목록 조회 (AJAX - 트리용)
    @ResponseBody
    @RequestMapping(value = "/getCatList", method = RequestMethod.POST)
    public Map<String, Object> getCatList() {
        Map<String, Object> result = new HashMap<>();
        result.put("DATA", propCatMngDao.getCatList());
        result.put("result", Constant.OK);
        return result;
    }

    // 카테고리 저장 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/saveCat", method = RequestMethod.POST)
    public Map<String, Object> saveCat(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            propCatMngDao.saveCat(param);
            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 카테고리 삭제 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/deleteCat", method = RequestMethod.POST)
    public Map<String, Object> deleteCat(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            propCatMngDao.deleteCat(param);
            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 다음 카테고리코드 자동채번 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getNextCatCd", method = RequestMethod.POST)
    public Map<String, Object> getNextCatCd(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        String nextCd = propCatMngDao.getNextCatCd(param);
        result.put("catCd", nextCd);
        result.put("result", Constant.OK);
        return result;
    }

    // 엑셀 다운로드
    @RequestMapping(value = "/excelDown", method = RequestMethod.GET)
    public void excelDown(HttpServletResponse response) throws IOException {
        List<Map<String, Object>> list = propCatMngDao.getCatList();

        // 계층 구조로 정렬된 리스트 생성
        List<Map<String, Object>> sortedList = buildHierarchyList(list);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("카테고리목록");

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

        CellStyle centerStyle = workbook.createCellStyle();
        centerStyle.cloneStyleFrom(dataStyle);
        centerStyle.setAlignment(HorizontalAlignment.CENTER);

        // 레벨별 배경색 스타일
        CellStyle lv0Style = workbook.createCellStyle();
        lv0Style.cloneStyleFrom(dataStyle);
        lv0Style.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        lv0Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        lv0Style.setFont(boldFont);

        CellStyle lv1Style = workbook.createCellStyle();
        lv1Style.cloneStyleFrom(dataStyle);
        lv1Style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        lv1Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        CellStyle lv2Style = workbook.createCellStyle();
        lv2Style.cloneStyleFrom(dataStyle);

        // 헤더 생성
        Row headerRow = sheet.createRow(0);
        String[] headers = {"구분", "카테고리명", "카테고리코드", "상위코드", "사용여부", "정렬순서"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 데이터 생성
        int rowNum = 1;

        for (Map<String, Object> item : sortedList) {
            Row row = sheet.createRow(rowNum++);
            int catLvl = item.get("catLvl") != null ? Integer.parseInt(item.get("catLvl").toString()) : 0;
            String catCd = (String) item.get("catCd");
            String catNm = (String) item.get("catNm");
            String uprCatCd = (String) item.get("uprCatCd");
            String useYn = (String) item.get("useYn");
            Object sortOrder = item.get("sortOrder");

            // 레벨별 스타일 선택
            CellStyle rowStyle = catLvl == 0 ? lv0Style : (catLvl == 1 ? lv1Style : lv2Style);
            CellStyle rowCenterStyle = workbook.createCellStyle();
            rowCenterStyle.cloneStyleFrom(rowStyle);
            rowCenterStyle.setAlignment(HorizontalAlignment.CENTER);

            // 구분
            Cell cell0 = row.createCell(0);
            cell0.setCellStyle(rowCenterStyle);
            cell0.setCellValue(catLvl == 0 ? "대분류" : (catLvl == 1 ? "중분류" : "소분류"));

            // 카테고리명 (들여쓰기)
            Cell cell1 = row.createCell(1);
            cell1.setCellStyle(rowStyle);
            String indent = "";
            if (catLvl == 1) indent = "  └ ";
            else if (catLvl == 2) indent = "      └ ";
            cell1.setCellValue(indent + catNm);

            // 카테고리코드
            Cell cell2 = row.createCell(2);
            cell2.setCellStyle(rowStyle);
            cell2.setCellValue(catCd);

            // 상위코드
            Cell cell3 = row.createCell(3);
            cell3.setCellStyle(rowStyle);
            cell3.setCellValue(uprCatCd != null ? uprCatCd : "");

            // 사용여부
            Cell cell4 = row.createCell(4);
            cell4.setCellStyle(rowCenterStyle);
            cell4.setCellValue("Y".equals(useYn) ? "사용" : "미사용");

            // 정렬순서
            Cell cell5 = row.createCell(5);
            cell5.setCellStyle(rowCenterStyle);
            cell5.setCellValue(sortOrder != null ? sortOrder.toString() : "0");
        }

        // 컬럼 너비 설정
        sheet.setColumnWidth(0, 3000);  // 구분
        sheet.setColumnWidth(1, 10000); // 카테고리명
        sheet.setColumnWidth(2, 5000);  // 카테고리코드
        sheet.setColumnWidth(3, 5000);  // 상위코드
        sheet.setColumnWidth(4, 3000);  // 사용여부
        sheet.setColumnWidth(5, 3000);  // 정렬순서

        // 응답 설정
        String fileName = URLEncoder.encode("카테고리목록", "UTF-8").replaceAll("\\+", "%20");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".xlsx\"");

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    // 계층 구조로 리스트 정렬
    private List<Map<String, Object>> buildHierarchyList(List<Map<String, Object>> list) {
        java.util.List<Map<String, Object>> result = new java.util.ArrayList<>();
        // 대분류만 먼저 추출
        for (Map<String, Object> item : list) {
            int lvl = item.get("catLvl") != null ? Integer.parseInt(item.get("catLvl").toString()) : 0;
            if (lvl == 0) {
                result.add(item);
                // 해당 대분류의 중분류 추가
                addChildren(result, list, (String) item.get("catCd"), 1);
            }
        }
        return result;
    }

    private void addChildren(List<Map<String, Object>> result, List<Map<String, Object>> list, String parentCd, int targetLvl) {
        for (Map<String, Object> item : list) {
            int lvl = item.get("catLvl") != null ? Integer.parseInt(item.get("catLvl").toString()) : 0;
            String uprCd = (String) item.get("uprCatCd");
            if (lvl == targetLvl && parentCd.equals(uprCd)) {
                result.add(item);
                // 하위 레벨 추가
                if (targetLvl < 2) {
                    addChildren(result, list, (String) item.get("catCd"), targetLvl + 1);
                }
            }
        }
    }
}
