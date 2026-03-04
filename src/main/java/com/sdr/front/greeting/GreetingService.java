package com.sdr.front.greeting;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service("GreetingService")
public class GreetingService{
	
	@Autowired
    private GreetingDao greetingDao;

	public Map<String, Object> selectGreetingPost(Map<String, Object> paramMap) {
	    return greetingDao.selectGreetingPost(paramMap);
	}

	
}
