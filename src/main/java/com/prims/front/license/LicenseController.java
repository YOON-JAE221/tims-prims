package com.prims.front.license;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.prims.admin.licenseMng.LicenseMngService;
import com.prims.common.config.AppProperties;
import com.prims.common.constant.Constant;

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
