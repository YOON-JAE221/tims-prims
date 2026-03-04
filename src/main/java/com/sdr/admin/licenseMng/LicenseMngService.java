package com.sdr.admin.licenseMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sdr.common.file.FileService;


@Service("LicenseMngService")
public class LicenseMngService{
	
	@Autowired
    private LicenseMngDao licenseMngDao;
	
	@Inject
	@Named("FileService")
	private FileService fileService;


	public List<Map<String, Object>> getSelectList(Map<String, Object> paramMap) {
	    return licenseMngDao.getSelectList(paramMap);
	}

	public int saveLicenseMng(Map<String, Object> paramMap) {
		return licenseMngDao.saveLicenseMng(paramMap);
	}

	
	public int deleteLicenseMng(Map<String, Object> paramMap) throws Exception {
	    Map<String, Object> map = licenseMngDao.selectLicenseOne(paramMap); 
	    map.put("ssnUsrCd", paramMap.get("ssnUsrCd").toString());

	    fileService.deleteCommonFile(map); //파일 삭제

	    int resultCnt = licenseMngDao.deleteLicenseMng(paramMap);//마스터 삭제

	    return resultCnt;
	}


	
}
