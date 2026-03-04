package com.sdr.admin.sys.usrMng;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.sdr.common.constant.Constant;


@Service("UsrMngService")
public class UsrMngService{
	
	@Autowired
    private UsrMngDao usrMngDao;


	public Map<String, Object> getSelectUserOne(Map<String, Object> paramMap) {
		paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
		return usrMngDao.getSelectUserOne(paramMap);
	}


	public int updateUserLoginInfo(Map<String, Object> paramMap) {
		return usrMngDao.updateUserLoginInfo(paramMap);
	}
	
}
