package com.sdr.admin.sys.usrMng;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/usrMng")  
public class UsrMngController {
	
//	@Inject
//    @Named("ComBoardService")
//    private ComBoardService comBoardService;
	
//	@RequestMapping("/viewBoard")
//	public String viewMain(
//			HttpSession session, HttpServletRequest request,
//			@RequestParam Map<String, Object> paramMap) throws Exception {
//		return "admin/comBoard/comBoard";
//	}
//	
//	
//	@RequestMapping("/getComboardList")
//	@ResponseBody
//	public Map<String, Object> getComboardList(
//	        HttpSession session, HttpServletRequest request,
//	        @RequestParam Map<String, Object> paramMap ) {
//
//	    paramMap.put("ssnEnterCd", "GSR");
//
//	    String Message = "";
//	    List<?> list  = new ArrayList<Object>();
//	    try {
//	        list = comBoardService.getComBoardList(paramMap);
//	    } catch (Exception e) {
//	    	Message="조회에 실패하였습니다.";
//	        e.printStackTrace();
//	    }
//
//	    Map<String, Object> result = new HashMap<>();
//	    result.put("DATA", list);
//        result.put("Message", Message);
//	    
//	    return result;
//	}

	
	
	
}
