package com.prims.front.comHistory;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service("ComHistoryService")
public class ComHistoryService{
	
	@Autowired
    private ComHistoryDao comHistoryDao;


	public List<Map<String, Object>> getSelectComHstList(Map<String, Object> paramMap) {
	    return comHistoryDao.getSelectComHstList(paramMap);
	}

	
//	public int updateUserLoginInfo(Map<String, Object> paramMap) {
//		return loginDao.updateUserLoginInfo(paramMap);
//	}
	
}
