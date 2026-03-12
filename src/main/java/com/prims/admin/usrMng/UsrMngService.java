package com.prims.admin.usrMng;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("UsrMngService")
public class UsrMngService {

    @Autowired
    private UsrMngDao usrMngDao;

    public List<Map<String, Object>> getSelectUsrList(Map<String, Object> paramMap) {
        return usrMngDao.getSelectUsrList(paramMap);
    }

    public Map<String, Object> getSelectUsrDetail(Map<String, Object> paramMap) {
        return usrMngDao.getSelectUsrDetail(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateUsr(Map<String, Object> paramMap) {
        return usrMngDao.updateUsr(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteUsr(Map<String, Object> paramMap) {
        return usrMngDao.deleteUsr(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int resetPassword(Map<String, Object> paramMap) {
        // 기본 비밀번호: primus1234
        paramMap.put("newPassword", "primus1234");
        return usrMngDao.resetPassword(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int changeMyPassword(Map<String, Object> paramMap) {
        return usrMngDao.changeMyPassword(paramMap);
    }
}
