package com.prims.common.file;

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

    // 첨부파일 물리삭제 (단건)
    public int deleteUpldFile(Map<String, Object> param) {
        return sqlSession.delete("file.deleteUpldFile", param);
    }

    // 첨부파일 물리삭제 (해당 키 전체)
    public int deleteUpldFileByKey(String upldFileCd) {
        return sqlSession.delete("file.deleteUpldFileByKey", upldFileCd);
    }

    // 파일 순서 업데이트
    public int updateFileSeq(Map<String, Object> param) {
        return sqlSession.update("file.updateFileSeq", param);
    }

}