package com.prims.admin.usrMng;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.prims.common.constant.Constant;

@Service("UsrMngService")
public class UsrMngService {

    @Autowired
    private UsrMngDao usrMngDao;

    public List<Map<String, Object>> getSelectUsrList(Map<String, Object> paramMap) {
        paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
        return usrMngDao.getSelectUsrList(paramMap);
    }

    public Map<String, Object> getSelectUsrDetail(Map<String, Object> paramMap) {
        paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
        return usrMngDao.getSelectUsrDetail(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateUsr(Map<String, Object> paramMap) {
        paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
        return usrMngDao.updateUsr(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteUsr(Map<String, Object> paramMap) {
        return usrMngDao.deleteUsr(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int resetPassword(Map<String, Object> paramMap) {
        paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
        paramMap.put("newPassword", "primus1234");
        return usrMngDao.resetPassword(paramMap);
    }

    @Transactional(rollbackFor = Exception.class)
    public int changeMyPassword(Map<String, Object> paramMap) {
        paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
        return usrMngDao.changeMyPassword(paramMap);
    }
}
