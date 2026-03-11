package com.prims.front.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("MainService")
public class MainService {

    @Autowired
    private MainDao mainDao;

    // FO 활성 팝업 목록
    public List<Map<String, Object>> getSelectActivePopList() {
        return mainDao.getSelectActivePopList(new HashMap<>());
    }

    // FO 메인 뉴스 목록
    public List<Map<String, Object>> getSelectMainNewsList() {
        return mainDao.getSelectMainNewsList();
    }
}
