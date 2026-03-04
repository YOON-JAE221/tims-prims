package com.prims.admin.sendLogMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SendLogMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectSendLogList(Map<String, Object> param) {
        return sqlSession.selectList("sendLogMng.getSelectSendLogList", param);
    }
}
