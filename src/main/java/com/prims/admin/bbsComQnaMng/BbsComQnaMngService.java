package com.prims.admin.bbsComQnaMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service("BbsComQnaMngService")
public class BbsComQnaMngService {

    @Inject
    private BbsComQnaMngDao bbsComQnaMngDao;

    // 문의글 리스트
    public List<Map<String, Object>> getSelectQnaPstList(Map<String, Object> paramMap) {
        return bbsComQnaMngDao.getSelectQnaPstList(paramMap);
    }

    // 문의글 삭제 (답변 포함)
    public int deleteQnaPst(Map<String, Object> paramMap) {
        return bbsComQnaMngDao.deleteQnaPst(paramMap);
    }

    // 게시판 정보
    public Map<String, Object> selectBbsBrdOne(Map<String, Object> paramMap) {
        return bbsComQnaMngDao.selectBbsBrdOne(paramMap);
    }

    // 문의글 상세
    public Map<String, Object> getSelectQnaPstDetail(Map<String, Object> paramMap) {
        return bbsComQnaMngDao.getSelectQnaPstDetail(paramMap);
    }

    // 답변 목록
    public List<Map<String, Object>> getSelectQnaReplyList(Map<String, Object> paramMap) {
        return bbsComQnaMngDao.getSelectQnaReplyList(paramMap);
    }

    // 첨부파일 목록
    public List<Map<String, Object>> getSelectUpldFileList(Map<String, Object> paramMap) {
        return bbsComQnaMngDao.getSelectUpldFileList(paramMap);
    }
}
