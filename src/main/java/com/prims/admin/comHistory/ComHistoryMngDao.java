package com.prims.admin.comHistory;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ComHistoryMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectList(Map<String, Object> paramMap) {
        return sqlSession.selectList("comHistoryMng.getSelectList", paramMap);
    }
    
    public int saveComHistoryMng(Map<String, Object> paramMap) {
		return sqlSession.update("comHistoryMng.saveComHistoryMng", paramMap);
	}
    
    public int deleteComHistoryMng(Map<String, Object> paramMap) {
		return sqlSession.update("comHistoryMng.updateComHistoryMngDelYn", paramMap);
	}


}