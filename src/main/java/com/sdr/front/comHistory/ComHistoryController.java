package com.sdr.front.comHistory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/comHistory")  
public class ComHistoryController {
	
	
	@Inject
    @Named("ComHistoryService")
    private ComHistoryService comHistoryService;

	@RequestMapping("/viewComHistory")  
    public String comHistoryView(Model model) {
        
		Map<String, Object> paramMap = new HashMap<>();
        
	    List<Map<String, Object>> comHstList = comHistoryService.getSelectComHstList(paramMap);
        model.addAttribute("comHstList", comHstList);
        
        return "front/comHistory/comHistory";
    }
	

}
