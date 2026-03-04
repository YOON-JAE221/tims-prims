package com.prims.admin.greeting;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service("GreetingMngService")
public class GreetingMngService{
	
	@Autowired
    private GreetingMngDao greetingMngDao;

	public Map<String, Object> selectGreetingPost(Map<String, Object> paramMap) {
	    return greetingMngDao.selectGreetingPost(paramMap);
	}
	
	public int saveGreetingMng(Map<String, Object> paramMap) {
	    return greetingMngDao.saveGreetingMng(paramMap);
	}

	
}
