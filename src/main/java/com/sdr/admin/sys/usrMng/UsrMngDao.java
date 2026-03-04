package com.sdr.admin.sys.usrMng;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UsrMngDao {

    @Autowired
    private SqlSession sqlSession;

    @SuppressWarnings("unchecked")
	public Map<String, Object> getSelectUserOne(Map<String, Object> paramMap) {
        return (Map<String, Object>) sqlSession.selectOne("usrMng.getSelectUserOne", paramMap);
    }

	public int updateUserLoginInfo(Map<String, Object> paramMap) {
        return sqlSession.update("usrMng.updateUserLoginInfo", paramMap);
    }

    // 필요 시 추가 메서드
//    public int insertSomething(Map<String, Object> paramMap) {
//        return sqlSession.insert("comBoard.insertSomething", paramMap);
//    }
}