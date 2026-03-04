package com.sdr.front.bbs;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BbsDao {

    @Autowired
    private SqlSession sqlSession;

    //게시글 리스트 조회
    public List<Map<String, Object>> getSelectBbsPstList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbs.getSelectBbsPstList", paramMap);
    }

    //게시판 조회
    public Map<String, Object> selectBbsBrdOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbs.selectBbsBrdOne", paramMap);
    }
    public int getSelectBbsPstCount(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbs.getSelectBbsPstCount", paramMap);
    }
    
    //게시판 조회(공지글)
    public List<Map<String, Object>> getSelectBbsNoticeList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbs.getSelectBbsNoticeList", paramMap);
    }
    
    //게시글 상세 조회
    public Map<String, Object> getSelectBbsPstDetail(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbs.getSelectBbsPstDetail", paramMap);
    }
    
    //게시글 저장
    public int saveBbsPst(Map<String, Object> paramMap) {
        return sqlSession.update("bbs.saveBbsPst", paramMap);
    }
    
    //게시글 조회수 update
    public int updateViewCnt(Map<String, Object> paramMap) {
    	return sqlSession.update("bbs.updateViewCnt", paramMap);
    }
    
    //게시글 삭제
    public int updateBbsPstDelYn(Map<String, Object> paramMap) {
        return sqlSession.update("bbs.updateBbsPstDelYn", paramMap);
    }

    //비밀번호 확인 (문의게시판)
    public int checkSecretPwd(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbs.checkSecretPwd", paramMap);
    }

    //답변 목록 조회 (문의게시판)
    public List<Map<String, Object>> getSelectBbsReplyList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbs.getSelectBbsReplyList", paramMap);
    }

    //문의게시판 전용 리스트 (계층형)
    public List<Map<String, Object>> getSelectBbsQnaPstList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbs.getSelectBbsQnaPstList", paramMap);
    }

    //문의게시판 전용 건수
    public int getSelectBbsQnaPstCount(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbs.getSelectBbsQnaPstCount", paramMap);
    }

    //문의게시판 원글 건수 (번호용)
    public int getSelectBbsQnaOriginalCount(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbs.getSelectBbsQnaOriginalCount", paramMap);
    }

    //메인 엔지니어링 서비스 통합 리스트
    public List<Map<String, Object>> getSelectMainEngList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbs.getSelectMainEngList", paramMap);
    }

}