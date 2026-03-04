package com.prims.admin.bbsComQnaMng;

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

import com.prims.common.constant.Constant;
import com.prims.common.web.ParamMap;

@Controller
@RequestMapping("/bbsComQnaMng")
public class BbsComQnaMngController {

    @Inject
    @Named("BbsComQnaMngService")
    private BbsComQnaMngService bbsComQnaMngService;

    // 문의게시판 관리 리스트 화면
    @RequestMapping(value = "/viewBbsComQnaMng", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewBbsComQnaMng(Model model) {
        model.addAttribute("brdCd", Constant.BRD_CD_QNA);
        return "admin/bbsComQnaMng/bbsComQnaMng";
    }

    // 문의글 상세(답변 작성/수정) 화면
    @RequestMapping(value = "/viewBbsComWriteQna", method = RequestMethod.POST)
    public String viewBbsComWriteQna(@ParamMap Map<String, Object> paramMap, Model model) {

        paramMap.put("brdCd", Constant.BRD_CD_QNA);

        // 게시판 정보
        Map<String, Object> bbsBrd = bbsComQnaMngService.selectBbsBrdOne(paramMap);
        model.addAttribute("brd", bbsBrd);

        // 원글(질문) 정보
        Map<String, Object> qst = bbsComQnaMngService.getSelectQnaPstDetail(paramMap);
        model.addAttribute("qst", qst);

        // 원글 첨부파일
        String atchFileKey = String.valueOf(qst.getOrDefault("atchFileKey", ""));
        if (!atchFileKey.isEmpty() && !"null".equals(atchFileKey)) {
            Map<String, Object> fileParam = new HashMap<>();
            fileParam.put("upldFileCd", atchFileKey);
            model.addAttribute("qstFileList", bbsComQnaMngService.getSelectUpldFileList(fileParam));
        }

        // 답변 목록
        List<Map<String, Object>> replyList = bbsComQnaMngService.getSelectQnaReplyList(paramMap);

        // 답변별 첨부파일
        for (Map<String, Object> reply : replyList) {
            String replyAtchKey = String.valueOf(reply.getOrDefault("atchFileKey", ""));
            if (!replyAtchKey.isEmpty() && !"null".equals(replyAtchKey)) {
                Map<String, Object> replyFileParam = new HashMap<>();
                replyFileParam.put("upldFileCd", replyAtchKey);
                reply.put("fileList", bbsComQnaMngService.getSelectUpldFileList(replyFileParam));
            }
        }

        // 첫 번째 답변을 수정 대상으로 (있으면)
        if (!replyList.isEmpty()) {
            model.addAttribute("ans", replyList.get(0));
        }

        model.addAttribute("replyList", replyList);
        model.addAttribute("brdCd", Constant.BRD_CD_QNA);

        return "admin/bbsComQnaMng/bbsComWriteQna";
    }

    // 문의글 리스트 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value = "/getSelectQnaPstList")
    public Map<String, Object> getSelectQnaPstList(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            paramMap.put("brdCd", Constant.BRD_CD_QNA);
            List<?> list = bbsComQnaMngService.getSelectQnaPstList(paramMap);
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

    // 문의글 삭제 (답변 포함)
    @ResponseBody
    @RequestMapping(value = "/deleteQnaPst", method = RequestMethod.POST)
    public Map<String, Object> deleteQnaPst(@ParamMap Map<String, Object> paramMap) {

        Map<String, Object> result = new HashMap<>();
        try {
            paramMap.put("brdCd", Constant.BRD_CD_QNA);
            int cnt = bbsComQnaMngService.deleteQnaPst(paramMap);
            result.put("result", cnt > 0 ? Constant.OK : Constant.FAIL);
        } catch (Exception e) {
            result.put("result", Constant.FAIL);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
