package com.prims.front.license;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



@Service("LicenseService")
public class LicenseService{
	
	@Autowired
    private LicenseDao licenseDao;
	
	public List<Map<String, Object>> getSelectLiceList(Map<String, Object> paramMap) {
	    return licenseDao.getSelectLiceList(paramMap);
	}


	
}
