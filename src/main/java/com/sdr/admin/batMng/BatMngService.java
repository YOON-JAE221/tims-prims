package com.sdr.admin.batMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service("BatMngService")
public class BatMngService {

    @Inject
    private BatMngDao batMngDao;

    public List<Map<String, Object>> getSelectBatList(Map<String, Object> paramMap) {
        return batMngDao.getSelectBatList(paramMap);
    }

    public Map<String, Object> getSelectBatOne(Map<String, Object> paramMap) {
        return batMngDao.getSelectBatOne(paramMap);
    }

    public int saveBat(Map<String, Object> paramMap) {
        String mode = String.valueOf(paramMap.getOrDefault("mode", ""));
        if ("edit".equals(mode)) {
            return batMngDao.updateBat(paramMap);
        }
        return batMngDao.insertBat(paramMap);
    }

    public int deleteBat(Map<String, Object> paramMap) {
        return batMngDao.deleteBat(paramMap);
    }

    public List<Map<String, Object>> getSelectBatHistList(Map<String, Object> paramMap) {
        return batMngDao.getSelectBatHistList(paramMap);
    }
}
