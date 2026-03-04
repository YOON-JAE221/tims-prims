package com.prims.admin.sys.menuMng;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service("MenuMngService")
public class MenuMngService{
	
	@Autowired
    private MenuMngDao menuMngDao;

	public List<?> getMenuNaviTreeList(Map<String, Object> paramMap) {
		return menuMngDao.getMenuNaviTreeList(paramMap);
	}

	public List<?> getMenuTreeList(Map<String, Object> paramMap) {
        return menuMngDao.getMenuTreeList(paramMap);
    }

	public int deleteMenuMng(Map<String, Object> paramMap) {
		return menuMngDao.deleteMenuMng(paramMap);
	}

	public int saveMenuMng(Map<String, Object> paramMap) {
		return menuMngDao.saveMenuMng(paramMap);
	}

}
