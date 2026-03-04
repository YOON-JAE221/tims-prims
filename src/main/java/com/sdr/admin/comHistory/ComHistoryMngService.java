package com.sdr.admin.comHistory;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service("ComHistoryMngService")
public class ComHistoryMngService{
	
	@Autowired
    private ComHistoryMngDao comHistoryMngDao;


	public List<Map<String, Object>> getSelectList(Map<String, Object> paramMap) {
	    return comHistoryMngDao.getSelectList(paramMap);
	}

	public int saveComHistoryMng(Map<String, Object> paramMap) {
		return comHistoryMngDao.saveComHistoryMng(paramMap);
	}

	public int deleteComHistoryMng(Map<String, Object> paramMap) {
		return comHistoryMngDao.deleteComHistoryMng(paramMap);
	}


	
}
