package com.prims.admin.main;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service("AdminMainService")
public class AdminMainService {

    @Inject
    private AdminMainDao adminMainDao;

    public Map<String, Object> getPropSummary() {
        return adminMainDao.getPropSummary();
    }

    public Map<String, Object> getQnaSummary() {
        return adminMainDao.getQnaSummary();
    }

    public List<Map<String, Object>> getRecentPropList(Map<String, Object> paramMap) {
        return adminMainDao.getRecentPropList(paramMap);
    }

    public List<Map<String, Object>> getTopPropList() {
        return adminMainDao.getTopPropList();
    }

    public List<Map<String, Object>> getRecentQnaList() {
        return adminMainDao.getRecentQnaList();
    }
}
