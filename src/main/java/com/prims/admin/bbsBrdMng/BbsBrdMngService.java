package com.prims.admin.bbsBrdMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service("BbsBrdMngService")
public class BbsBrdMngService {

    @Inject
    private BbsBrdMngDao bbsBrdMngDao;

    public List<Map<String, Object>> getSelectBbsBrdList(Map<String, Object> paramMap) {
        return bbsBrdMngDao.getSelectBbsBrdList(paramMap);
    }

    public Map<String, Object> getSelectBbsBrdOne(Map<String, Object> paramMap) {
        return bbsBrdMngDao.getSelectBbsBrdOne(paramMap);
    }

    public int saveBbsBrd(Map<String, Object> paramMap) {
        return bbsBrdMngDao.saveBbsBrd(paramMap);
    }
}
