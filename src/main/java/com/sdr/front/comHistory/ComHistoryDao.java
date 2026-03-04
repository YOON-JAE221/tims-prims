package com.sdr.front.comHistory;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ComHistoryDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectComHstList(Map<String, Object> paramMap) {
        return sqlSession.selectList("comHistory.getSelectComHstList", paramMap);
    }


}