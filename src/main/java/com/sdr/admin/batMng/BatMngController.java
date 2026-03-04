package com.sdr.admin.batMng;

import java.util.ArrayList;
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

import com.sdr.common.batch.BatchScheduler;
import com.sdr.common.constant.Constant;
import com.sdr.common.web.ParamMap;

@Controller
@RequestMapping("/batMng")
public class BatMngController {

    @Inject
    @Named("BatMngService")
    private BatMngService batMngService;

    @Inject
    private BatchScheduler batchScheduler;

    // 배치관리 리스트 화면
    @RequestMapping(value = "/viewBatMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewBatMng(Model model) {
        return "admin/batMng/batMng";
    }

    // 배치 등록/수정 화면
    @RequestMapping(value = "/viewBatWrite", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewBatWrite(@ParamMap Map<String, Object> paramMap, Model model) {

        String jobCd = String.valueOf(paramMap.getOrDefault("jobCd", ""));
        if (!jobCd.isEmpty() && !"null".equals(jobCd)) {
            Map<String, Object> detail = batMngService.getSelectBatOne(paramMap);
            model.addAttribute("detail", detail);
        }
        return "admin/batMng/batWrite";
    }

    // 배치 리스트 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSelectBatList")
    public Map<String, Object> getSelectBatList(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            List<?> list = batMngService.getSelectBatList(paramMap);
            result.put("DATA", list);
            result.put("resultCnt", 1);
        } catch (Exception e) {
            result.put("DATA", new ArrayList<>());
            result.put("Message", "조회에 실패하였습니다.");
            result.put("resultCnt", 0);
            e.printStackTrace();
        }
        return result;
    }

    // 배치 저장 (등록/수정)
    @ResponseBody
    @RequestMapping(value = "/saveBat", method = RequestMethod.POST)
    public Map<String, Object> saveBat(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = batMngService.saveBat(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 배치 삭제
    @ResponseBody
    @RequestMapping(value = "/deleteBat", method = RequestMethod.POST)
    public Map<String, Object> deleteBat(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            int cnt = batMngService.deleteBat(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 수동 실행
    @ResponseBody
    @RequestMapping(value = "/manualExec", method = RequestMethod.POST)
    public Map<String, Object> manualExec(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            String jobCd = String.valueOf(paramMap.get("jobCd"));
            String execUsrCd = String.valueOf(paramMap.getOrDefault("ssnUsrCd", "SYSTEM"));

            batchScheduler.manualExecute(jobCd, execUsrCd);

            result.put("result", Constant.OK);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 실행 이력 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSelectBatHistList")
    public Map<String, Object> getSelectBatHistList(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            List<?> list = batMngService.getSelectBatHistList(paramMap);
            result.put("DATA", list);
            result.put("resultCnt", 1);
        } catch (Exception e) {
            result.put("DATA", new ArrayList<>());
            result.put("Message", "조회에 실패하였습니다.");
            result.put("resultCnt", 0);
            e.printStackTrace();
        }
        return result;
    }
}
