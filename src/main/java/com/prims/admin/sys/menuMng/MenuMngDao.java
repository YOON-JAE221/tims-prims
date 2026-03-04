package com.prims.admin.sys.menuMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MenuMngDao {

    @Autowired
    private SqlSession sqlSession;

    //메뉴 네비 조회
    public List<?> getMenuNaviTreeList(Map<String, Object> paramMap) {
    	return sqlSession.selectList("menuMng.getMenuNaviTreeList", paramMap);
    }
    
    //메뉴조회
    public List<?> getMenuTreeList(Map<String, Object> paramMap) {
        return sqlSession.selectList("menuMng.getMenuTreeList", paramMap);
    }

    //메뉴 삭제
	public int deleteMenuMng(Map<String, Object> paramMap) {
		return sqlSession.delete("menuMng.deleteMenuMng", paramMap);
	}

	public int saveMenuMng(Map<String, Object> paramMap) {
		return sqlSession.update("menuMng.saveMenuMng", paramMap);
	}

    // 필요 시 추가 메서드
//    public int insertSomething(Map<String, Object> paramMap) {
//        return sqlSession.insert("comBoard.insertSomething", paramMap);
//    }
}