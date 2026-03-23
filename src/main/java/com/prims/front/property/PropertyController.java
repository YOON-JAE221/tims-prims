package com.prims.front.property;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.config.SysConfigDao;
import com.prims.common.constant.Constant;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/property")
public class PropertyController {

    // 세션 키 (매물 접근코드 통합)
    public static final String PROP_VERIFIED = "PROP_VERIFIED";

    @Autowired
    private PropertySearchDao propertySearchDao;

    @Autowired
    private SysConfigDao sysConfigDao;

    /**
     * 매물안내 (리스트)
     */
    @RequestMapping(value = "/viewPropertyList", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertyList(@RequestParam(value = "type", required = false, defaultValue = "all") String type,
                                   @RequestParam(value = "midCatCd", required = false, defaultValue = "") String midCatCd,
                                   @RequestParam(value = "subCatCd", required = false, defaultValue = "") String subCatCd,
                                   @RequestParam(value = "dealType", required = false, defaultValue = "") String dealType,
                                   @RequestParam(value = "badgeType", required = false, defaultValue = "") String badgeType,
                                   @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                                   @RequestParam(value = "areaMin", required = false, defaultValue = "") String areaMin,
                                   @RequestParam(value = "areaMax", required = false, defaultValue = "") String areaMax,
                                   @RequestParam(value = "priceMin", required = false, defaultValue = "") String priceMin,
                                   @RequestParam(value = "priceMax", required = false, defaultValue = "") String priceMax,
                                   @RequestParam(value = "rentMin", required = false, defaultValue = "") String rentMin,
                                   @RequestParam(value = "rentMax", required = false, defaultValue = "") String rentMax,
                                   @RequestParam(value = "floorType", required = false, defaultValue = "") String floorType,
                                   @RequestParam(value = "pageNo", required = false, defaultValue = "1") int pageNo,
                                   HttpSession session, Model model) {

        // 관리자 로그인 시 접근코드 체크 스킵
        boolean isAdmin = session.getAttribute(Constant.SESSION_LOGIN_USER) != null;

        // 접근 코드 체크 (관리자가 아닐 때만)
        if (!isAdmin && isAccessRequired(Constant.CFG_PROP_ACCESS_CODE)) {
            if (!"Y".equals(session.getAttribute(PROP_VERIFIED))) {
                model.addAttribute("codeType", "PROP");
                model.addAttribute("returnUrl", "LIST");
                return "front/property/propertyAccessCode";
            }
        }

        int pageSize = 12;
        int offset = (pageNo - 1) * pageSize;
        Map<String, Object> param = new HashMap<>();
        param.put("catCd", type);
        param.put("midCatCd", midCatCd);
        param.put("subCatCd", subCatCd);
        param.put("dealType", dealType);
        param.put("badgeType", badgeType);
        param.put("keyword", keyword);
        param.put("pageSize", Integer.valueOf(pageSize));
        param.put("offset", Integer.valueOf(offset));

        // 면적 조건 (평 → ㎡ 변환, DB는 ㎡ 기준)
        if (areaMin != null && !areaMin.isEmpty()) {
            double minVal = Double.parseDouble(areaMin) * 3.3058;
            param.put("areaMin", minVal);
        }
        if (areaMax != null && !areaMax.isEmpty()) {
            double maxVal = Double.parseDouble(areaMax) * 3.3058;
            param.put("areaMax", maxVal);
        }

        // 가격 조건 (만원 단위)
        if (priceMin != null && !priceMin.isEmpty()) {
            param.put("priceMin", Integer.parseInt(priceMin));
        }
        if (priceMax != null && !priceMax.isEmpty()) {
            param.put("priceMax", Integer.parseInt(priceMax));
        }
        if (rentMin != null && !rentMin.isEmpty()) {
            param.put("rentMin", Integer.parseInt(rentMin));
        }
        if (rentMax != null && !rentMax.isEmpty()) {
            param.put("rentMax", Integer.parseInt(rentMax));
        }

        // 층수 조건
        if (floorType != null && !floorType.isEmpty()) {
            param.put("floorType", floorType);
        }

        List<?> list = propertySearchDao.getPropertyTypeList(param);
        int totalCnt = propertySearchDao.getPropertyTypeCount(param);
        int totalPage = totalCnt > 0 ? (int) Math.ceil((double) totalCnt / pageSize) : 1;

        model.addAttribute("type", type);
        model.addAttribute("midCatCd", midCatCd);
        model.addAttribute("subCatCd", subCatCd);
        model.addAttribute("dealType", dealType);
        model.addAttribute("badgeType", badgeType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("areaMin", areaMin);
        model.addAttribute("areaMax", areaMax);
        model.addAttribute("priceMin", priceMin);
        model.addAttribute("priceMax", priceMax);
        model.addAttribute("rentMin", rentMin);
        model.addAttribute("rentMax", rentMax);
        model.addAttribute("floorType", floorType);
        model.addAttribute("list", list);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("pageNo", pageNo);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("catList", propertySearchDao.getFrontCatList());
        
        // 특정 대분류 선택 시 중분류/소분류 목록 전달 (전체매물 제외)
        if (type != null && !type.isEmpty() && !"all".equalsIgnoreCase(type)) {
            model.addAttribute("midCatList", propertySearchDao.getMidCatList(type.toUpperCase()));
            if (midCatCd != null && !midCatCd.isEmpty()) {
                model.addAttribute("subCatList", propertySearchDao.getSubCatList(midCatCd));
            }
        }
        
        return "front/property/propertyList";
    }

    /**
     * 매물 상세
     */
    @RequestMapping(value = "/viewPropertyDetail", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertyDetail(@RequestParam(value = "type", required = false, defaultValue = "apt") String type,
                                     @RequestParam(value = "id", required = false, defaultValue = "") String id,
                                     HttpSession session, Model model) {
        model.addAttribute("type", type);
        if (id != null && !id.isEmpty()) {
            Map<String, Object> param = new HashMap<>();
            param.put("id", id);

            // 관리자가 아닌 경우에만 조회수 증가
            Object loginUser = session.getAttribute("loginUser");
            if (loginUser == null) {
                propertySearchDao.increaseViewCnt(param);
            }

            Map<String, Object> prop = propertySearchDao.getPropertyDetail(param);
            model.addAttribute("prop", prop);
            List<Map<String, Object>> imgList = propertySearchDao.getPropertyImageList(param);
            model.addAttribute("imgList", imgList);
            
            // 세션에 마지막 조회 매물 정보 저장 (로그인 후 POST 복귀용)
            Map<String, Object> lastView = new HashMap<>();
            lastView.put("url", "/property/viewPropertyDetail");
            lastView.put("type", type);
            lastView.put("id", id);
            session.setAttribute("lastViewPage", lastView);
        }
        model.addAttribute("catList", propertySearchDao.getFrontCatList());
        return "front/property/propertyDetail";
    }

    /**
     * 중분류 변경 시 소분류 목록 조회 (AJAX)
     */
    @ResponseBody
    @RequestMapping(value = "/getSubCatList", method = RequestMethod.POST)
    public Map<String, Object> getSubCatList(@RequestParam("midCatCd") String midCatCd) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = propertySearchDao.getSubCatList(midCatCd);
            result.put("DATA", list);
            result.put("result", "OK");
        } catch (Exception e) {
            result.put("DATA", new java.util.ArrayList<>());
            result.put("result", "FAIL");
        }
        return result;
    }

    /**
     * 매물검색 (지도)
     */
    @RequestMapping(value = "/viewPropertySearch", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertySearch(HttpSession session, Model model) {

        // 관리자 로그인 시 접근코드 체크 스킵
        boolean isAdmin = session.getAttribute(Constant.SESSION_LOGIN_USER) != null;

        // 접근 코드 체크 (관리자가 아닐 때만)
        if (!isAdmin && isAccessRequired(Constant.CFG_PROP_ACCESS_CODE)) {
            if (!"Y".equals(session.getAttribute(PROP_VERIFIED))) {
                model.addAttribute("codeType", "PROP");
                model.addAttribute("returnUrl", "SEARCH");
                return "front/property/propertyAccessCode";
            }
        }

        model.addAttribute("catList", propertySearchDao.getFrontCatList());
        return "front/property/propertySearch";
    }

    /**
     * 지도 매물 조회 (AJAX)
     */
    @ResponseBody
    @RequestMapping(value = "/getPropertyMapList", method = RequestMethod.POST)
    public Map<String, Object> getPropertyMapList(@RequestParam(value = "swLat", required = false) String swLat,
                                                   @RequestParam(value = "swLng", required = false) String swLng,
                                                   @RequestParam(value = "neLat", required = false) String neLat,
                                                   @RequestParam(value = "neLng", required = false) String neLng,
                                                   @RequestParam(value = "propType", required = false, defaultValue = "ALL") String propType,
                                                   @RequestParam(value = "dealType", required = false, defaultValue = "ALL") String dealType) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("catCd", propType);
            param.put("dealType", dealType);
            if (swLat != null && !swLat.isEmpty()) {
                param.put("swLat", Double.parseDouble(swLat));
                param.put("swLng", Double.parseDouble(swLng));
                param.put("neLat", Double.parseDouble(neLat));
                param.put("neLng", Double.parseDouble(neLng));
            }
            List<?> list = propertySearchDao.getPropertyMapList(param);
            result.put("DATA", list);
            result.put("result", "OK");
        } catch (Exception e) {
            result.put("DATA", new java.util.ArrayList<>());
            result.put("result", "FAIL");
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 접근코드 검증 (AJAX)
     */
    @ResponseBody
    @RequestMapping(value = "/verifyAccessCode", method = RequestMethod.POST)
    public Map<String, Object> verifyAccessCode(@RequestParam("codeType") String codeType,
                                                 @RequestParam("accessCode") String accessCode,
                                                 HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("configKey", Constant.CFG_PROP_ACCESS_CODE);
            param.put("accessCode", accessCode.trim());
            param.put("encryptKey", Constant.ENCRYPT_KEY);

            int cnt = sysConfigDao.verifyAccessCode(param);

            if (cnt > 0) {
                session.setAttribute(PROP_VERIFIED, "Y");
                result.put("result", "OK");
            } else {
                result.put("result", "FAIL");
                result.put("message", "접근코드가 일치하지 않습니다.");
            }
        } catch (Exception e) {
            result.put("result", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 접근 제한 필요 여부 체크
     */
    private boolean isAccessRequired(String configKey) {
        try {
            int cnt = sysConfigDao.isAccessRequired(configKey);
            return cnt > 0;
        } catch (Exception e) {
            return false;
        }
    }
}
