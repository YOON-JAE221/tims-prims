package com.prims.admin.sendLogMng;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.prims.common.constant.Constant;
import com.prims.common.web.ParamMap;

@Controller
@RequestMapping("/sendLogMng")
public class SendLogMngController {

    @Inject
    @Named("SendLogMngService")
    private SendLogMngService sendLogMngService;

    /** 발송내역 목록 화면 */
    @RequestMapping(value = "/viewSendLogMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewSendLogMng(Model model) {
        return "admin/sendLogMng/sendLogMng";
    }

    /** 발송내역 목록 조회 (AJAX) */
    @RequestMapping(value = "/getSelectSendLogList", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getSelectSendLogList(@ParamMap Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> list = sendLogMngService.getSelectSendLogList(paramMap);
        result.put(Constant.RES_DATA, list);
        return result;
    }
}
