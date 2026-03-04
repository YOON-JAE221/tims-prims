package com.sdr.common.notification;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SendLogDao {

    @Autowired
    private SqlSession sqlSession;

    /** 발송 로그 INSERT */
    public int insertSendLog(Map<String, Object> param) {
        return sqlSession.insert("sendLog.insertSendLog", param);
    }
}
