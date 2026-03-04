package com.sdr.admin.sysMenuMng;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SysMenuMngDao {

    @Autowired
    private SqlSession sqlSession;

    public List<Map<String, Object>> getSelectSysMenuList(Map<String, Object> paramMap) {
        return sqlSession.selectList("sysMenuMng.getSelectSysMenuList", paramMap);
    }

    public List<Map<String, Object>> getSelectBbsBrdCombo(Map<String, Object> paramMap) {
        return sqlSession.selectList("sysMenuMng.getSelectBbsBrdCombo", paramMap);
    }

    public int saveSysMenu(Map<String, Object> paramMap) {
        return sqlSession.update("sysMenuMng.saveSysMenu", paramMap);
    }

    public int deleteSysMenu(Map<String, Object> paramMap) {
        return sqlSession.delete("sysMenuMng.deleteSysMenu", paramMap);
    }

    public int getCountBySysMenuCd(Map<String, Object> paramMap) {
        return sqlSession.selectOne("sysMenuMng.getCountBySysMenuCd", paramMap);
    }
}
