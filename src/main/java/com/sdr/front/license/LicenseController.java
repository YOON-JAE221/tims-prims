package com.sdr.front.license;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sdr.admin.licenseMng.LicenseMngService;
import com.sdr.common.config.AppProperties;
import com.sdr.common.constant.Constant;

@Controller
@RequestMapping("/license")
public class LicenseController {
	
	@Inject
	private AppProperties appProperties;

	@Inject
	@Named("LicenseService")
	private LicenseService licenseService;

	@RequestMapping("/viewLicense")  
    public String viewLicense(Model model) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("uploadBaseDir", appProperties.getUploadBaseWeb());
	    List<Map<String, Object>> licenseList = licenseService.getSelectLiceList(paramMap);
        model.addAttribute("licenseList", licenseList);
        return "front/license/license";
    }
}
