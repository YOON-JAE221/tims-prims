package com.sdr.admin.greeting;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class GreetingMngDao {

    @Autowired
    private SqlSession sqlSession;

    public Map<String, Object> selectGreetingPost(Map<String, Object> paramMap) {
        return sqlSession.selectOne("greetingMng.selectGreetingPost", paramMap);
    }
    
    public int saveGreetingMng(Map<String, Object> paramMap) {
        return sqlSession.update("greetingMng.saveGreetingMng", paramMap);
    }


}