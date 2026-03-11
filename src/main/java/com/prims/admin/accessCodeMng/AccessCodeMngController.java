package com.prims.admin.accessCodeMng;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.config.SysConfigDao;
import com.prims.common.constant.Constant;

/**
 * 환경설정 관리 (기존 접속코드관리 확장)
 */
@Controller
@RequestMapping("/accessCodeMng")
public class AccessCodeMngController {

    @Autowired
    private SysConfigDao sysConfigDao;

    /**
     * 환경설정 화면
     */
    @RequestMapping(value = "/viewAccessCodeMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewAccessCodeMng(Model model) {

        // 사이트 접속코드
        Map<String, Object> siteParam = new HashMap<>();
        siteParam.put("configKey", Constant.CFG_SITE_ACCESS_CODE);
        siteParam.put("encryptKey", Constant.ENCRYPT_KEY);
        Map<String, Object> siteConfig = sysConfigDao.getConfigOne(siteParam);
        model.addAttribute("siteConfig", siteConfig);

        // 매물검색 접근코드
        Map<String, Object> propSearchParam = new HashMap<>();
        propSearchParam.put("configKey", Constant.CFG_PROP_SEARCH_ACCESS_CODE);
        propSearchParam.put("encryptKey", Constant.ENCRYPT_KEY);
        Map<String, Object> propSearchConfig = sysConfigDao.getConfigOne(propSearchParam);
        model.addAttribute("propSearchConfig", propSearchConfig);

        // 매물안내 접근코드
        Map<String, Object> propListParam = new HashMap<>();
        propListParam.put("configKey", Constant.CFG_PROP_LIST_ACCESS_CODE);
        propListParam.put("encryptKey", Constant.ENCRYPT_KEY);
        Map<String, Object> propListConfig = sysConfigDao.getConfigOne(propListParam);
        model.addAttribute("propListConfig", propListConfig);

        return "admin/accessCodeMng/accessCodeMng";
    }

    /**
     * 환경설정 저장
     */
    @ResponseBody
    @RequestMapping(value = "/saveConfig", method = RequestMethod.POST)
    public Map<String, Object> saveConfig(
            @RequestParam("configKey") String configKey,
            @RequestParam("useYn") String useYn,
            @RequestParam(value = "configValue", required = false, defaultValue = "") String configValue,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        try {
            // configKey 유효성 체크
            if (!Constant.CFG_SITE_ACCESS_CODE.equals(configKey) 
                && !Constant.CFG_PROP_SEARCH_ACCESS_CODE.equals(configKey) 
                && !Constant.CFG_PROP_LIST_ACCESS_CODE.equals(configKey)) {
                result.put("result", Constant.FAIL);
                result.put("message", "유효하지 않은 설정키");
                return result;
            }

            // 사용여부 'Y'인데 코드가 비어있으면 오류
            if ("Y".equals(useYn) && (configValue == null || configValue.trim().isEmpty())) {
                result.put("result", Constant.FAIL);
                result.put("message", "접근코드를 입력해주세요.");
                return result;
            }

            // 사용여부 'Y'이고 코드가 4자 미만이면 오류
            if ("Y".equals(useYn) && configValue.trim().length() < 4) {
                result.put("result", Constant.FAIL);
                result.put("message", "접근코드는 4자 이상으로 설정해주세요.");
                return result;
            }

            // 세션에서 사용자 코드
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute(Constant.SESSION_LOGIN_USER);
            String ssnUsrCd = loginUser != null ? String.valueOf(loginUser.get("usrCd")) : "admin";

            Map<String, Object> param = new HashMap<>();
            param.put("configKey", configKey);
            param.put("useYn", useYn);
            param.put("configValue", configValue.trim());
            param.put("encryptKey", Constant.ENCRYPT_KEY);
            param.put("ssnUsrCd", ssnUsrCd);

            sysConfigDao.saveConfig(param);
            result.put("result", Constant.OK);

        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
