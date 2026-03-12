package com.prims.admin.usrMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UsrMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectUsrList(Map<String, Object> paramMap) {
        return sqlSession.selectList("usrMng.getSelectUsrList", paramMap);
    }

    public Map<String, Object> getSelectUsrDetail(Map<String, Object> paramMap) {
        return sqlSession.selectOne("usrMng.getSelectUsrDetail", paramMap);
    }

    public int updateUsr(Map<String, Object> paramMap) {
        return sqlSession.update("usrMng.updateUsr", paramMap);
    }

    public int deleteUsr(Map<String, Object> paramMap) {
        return sqlSession.delete("usrMng.deleteUsr", paramMap);
    }

    public int resetPassword(Map<String, Object> paramMap) {
        return sqlSession.update("usrMng.resetPassword", paramMap);
    }
}
