package com.sdr.admin.bbsComQnaMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BbsComQnaMngDao {

    @Autowired
    private SqlSession sqlSession;

    // 문의글 리스트 (원글만, 답변상태 포함)
    public List<Map<String, Object>> getSelectQnaPstList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbsComQnaMng.getSelectQnaPstList", paramMap);
    }

    // 문의글 삭제 (답변 포함)
    public int deleteQnaPst(Map<String, Object> paramMap) {
        return sqlSession.update("bbsComQnaMng.deleteQnaPst", paramMap);
    }

    // 게시판 정보
    public Map<String, Object> selectBbsBrdOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbsComQnaMng.selectBbsBrdOne", paramMap);
    }

    // 문의글 상세
    public Map<String, Object> getSelectQnaPstDetail(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbsComQnaMng.getSelectQnaPstDetail", paramMap);
    }

    // 답변 목록
    public List<Map<String, Object>> getSelectQnaReplyList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbsComQnaMng.getSelectQnaReplyList", paramMap);
    }

    // 첨부파일 목록
    public List<Map<String, Object>> getSelectUpldFileList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbsComQnaMng.getSelectUpldFileList", paramMap);
    }
}
