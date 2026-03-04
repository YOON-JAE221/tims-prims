package com.prims.front.greeting;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class GreetingDao {

    @Autowired
    private SqlSession sqlSession;

    public Map<String, Object> selectGreetingPost(Map<String, Object> paramMap) {
        return sqlSession.selectOne("greeting.selectGreetingPost", paramMap);
    }


}