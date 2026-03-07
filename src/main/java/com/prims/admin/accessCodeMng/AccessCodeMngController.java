package com.prims.admin.accessCodeMng;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.config.SysConfigDao;
import com.prims.common.constant.Constant;
import com.prims.common.interceptor.AccessCodeInterceptor;

@Controller
@RequestMapping("/accessCodeMng")
public class AccessCodeMngController {

    @Autowired
    private SysConfigDao sysConfigDao;

    @RequestMapping(value = "/viewAccessCodeMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewAccessCodeMng(Model model) {
        String accessCode = "";
        try {
            accessCode = sysConfigDao.getConfigValue(AccessCodeInterceptor.CONFIG_KEY);
        } catch (Exception e) {
            // 테이블 없으면 빈 값
        }
        model.addAttribute("accessCode", accessCode != null ? accessCode : "");
        return "admin/accessCodeMng/accessCodeMng";
    }

    @ResponseBody
    @RequestMapping(value = "/saveAccessCode", method = RequestMethod.POST)
    public Map<String, Object> saveAccessCode(@RequestParam("accessCode") String accessCode) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("configKey", AccessCodeInterceptor.CONFIG_KEY);
            param.put("configValue", accessCode.trim());
            param.put("configDesc", "사이트 접속코드");
            sysConfigDao.saveConfigValue(param);
            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
