package com.sdr.admin.sendLogMng;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("SendLogMngService")
public class SendLogMngService {

    @Autowired
    private SendLogMngDao sendLogMngDao;

    public List<Map<String, Object>> getSelectSendLogList(Map<String, Object> param) {
        return sendLogMngDao.getSelectSendLogList(param);
    }
}
