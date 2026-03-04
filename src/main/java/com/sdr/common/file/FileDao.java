package com.sdr.common.file;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FileDao {

    @Autowired
    private SqlSession sqlSession;
    
    public int insertUpldFile(Map<String, Object> param) {
        return sqlSession.insert("file.insertUpldFile", param);
    }
    
    public int updateUpldFileDelYn(Map<String, Object> param) {
        return sqlSession.update("file.updateUpldFileDelYn", param);
    }
    
    public List<Map<String, Object>> getSelectUpldFileList(Map<String, Object> paramMap) {
        return sqlSession.selectList("file.getSelectUpldFileList", paramMap);
    }
    
    public Map<String, Object> getSelectUpldFileOne(Map<String, Object> paramMap) {
        return sqlSession.selectOne("file.getSelectUpldFileOne", paramMap);
    }

}