package com.sdr.admin.sysMenuMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service("SysMenuMngService")
public class SysMenuMngService {

    @Inject
    private SysMenuMngDao sysMenuMngDao;

    public List<Map<String, Object>> getSelectSysMenuList(Map<String, Object> paramMap) {
        return sysMenuMngDao.getSelectSysMenuList(paramMap);
    }

    public List<Map<String, Object>> getSelectBbsBrdCombo(Map<String, Object> paramMap) {
        return sysMenuMngDao.getSelectBbsBrdCombo(paramMap);
    }

    public int saveSysMenu(Map<String, Object> paramMap) {
        return sysMenuMngDao.saveSysMenu(paramMap);
    }

    public int deleteSysMenu(Map<String, Object> paramMap) {
        return sysMenuMngDao.deleteSysMenu(paramMap);
    }

    public int getCountBySysMenuCd(Map<String, Object> paramMap) {
        return sysMenuMngDao.getCountBySysMenuCd(paramMap);
    }
}
