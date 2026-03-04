package com.sdr.admin.popMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service("PopMngService")
public class PopMngService {

    @Inject
    private PopMngDao popMngDao;

    public List<Map<String, Object>> getSelectPopList(Map<String, Object> paramMap) {
        return popMngDao.getSelectPopList(paramMap);
    }

    public Map<String, Object> getSelectPopOne(Map<String, Object> paramMap) {
        return popMngDao.getSelectPopOne(paramMap);
    }

    public int savePop(Map<String, Object> paramMap) {
        return popMngDao.savePop(paramMap);
    }

    public int deletePop(Map<String, Object> paramMap) {
        return popMngDao.deletePop(paramMap);
    }
}
