package com.sdr.admin.bbsComMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BbsComMngDao {

    @Autowired
    private SqlSession sqlSession;

    //게시글 리스트 조회
    public List<Map<String, Object>> getSelectBbsPstList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbsComMng.getSelectBbsPstList", paramMap);
    }

    //게시판 조회
    public Map<String, Object> selectBbsBrdOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbsComMng.selectBbsBrdOne", paramMap);
    }
    public int getSelectBbsPstCount(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbsComMng.getSelectBbsPstCount", paramMap);
    }
    
    //게시판 조회(공지글)
    public List<Map<String, Object>> getSelectBbsNoticeList(Map<String, Object> paramMap) {
        return sqlSession.selectList("bbsComMng.getSelectBbsNoticeList", paramMap);
    }
    
    //게시글 상세 조회
    public Map<String, Object> getSelectBbsPstDetail(Map<String, Object> paramMap) {
        return sqlSession.selectOne("bbsComMng.getSelectBbsPstDetail", paramMap);
    }
    
    //게시글 저장
    public int saveBbsPst(Map<String, Object> paramMap) {
        return sqlSession.update("bbsComMng.saveBbsPst", paramMap);
    }
    
    //게시글 조회수 update
    public int updateViewCnt(Map<String, Object> paramMap) {
    	return sqlSession.update("bbsComMng.updateViewCnt", paramMap);
    }
    
    //게시글 삭제
    public int updateBbsPstDelYn(Map<String, Object> paramMap) {
        return sqlSession.update("bbsComMng.updateBbsPstDelYn", paramMap);
    }

}