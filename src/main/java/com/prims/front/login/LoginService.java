package com.prims.front.login;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prims.admin.sys.usrMng.UsrMngDao;


import com.prims.common.constant.Constant;


@Service("LoginService")
public class LoginService{
	
	@Autowired
    private LoginDao loginDao;


	public Map<String, Object> getSelectUserOne(Map<String, Object> paramMap) {
		paramMap.put("encryptKey", Constant.ENCRYPT_KEY);
		return loginDao.getSelectUserOne(paramMap);
	}


	public int updateUserLoginInfo(Map<String, Object> paramMap) {
		return loginDao.updateUserLoginInfo(paramMap);
	}
	
}
