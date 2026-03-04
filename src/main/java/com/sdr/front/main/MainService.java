package com.sdr.front.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sdr.common.constant.Constant;

@Service("MainService")
public class MainService {

    @Autowired
    private MainDao mainDao;

    // 메인 엔지니어링 서비스 리스트 (8개 게시판 통합, 조회수 DESC, 9건)
    public List<Map<String, Object>> getSelectMainEngList() {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("brdCdStra", Constant.BRD_CD_STRA);
        paramMap.put("brdCdStre", Constant.BRD_CD_STRE);
        paramMap.put("brdCdDise", Constant.BRD_CD_DISE);
        paramMap.put("brdCdSafe", Constant.BRD_CD_SAFE);
        paramMap.put("brdCdSpfe", Constant.BRD_CD_SPFE);
        paramMap.put("brdCdTere", Constant.BRD_CD_TERE);
        paramMap.put("brdCdVera", Constant.BRD_CD_VERA);
        paramMap.put("brdCdSdse", Constant.BRD_CD_SDSE);
        return mainDao.getSelectMainEngList(paramMap);
    }

    // FO 활성 팝업 목록
    public List<Map<String, Object>> getSelectActivePopList() {
        return mainDao.getSelectActivePopList(new HashMap<>());
    }
}
