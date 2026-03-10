package com.prims.front.property;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/property")
public class PropertyController {

    @RequestMapping(value = "/viewPropertyList", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertyList(@RequestParam(value = "type", required = false, defaultValue = "all") String type,
                                   @RequestParam(value = "dealType", required = false, defaultValue = "") String dealType,
                                   @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                                   @RequestParam(value = "pageNo", required = false, defaultValue = "1") int pageNo,
                                   Model model) {
        int pageSize = 12;
        int offset = (pageNo - 1) * pageSize;
        Map<String, Object> param = new HashMap<>();
        param.put("catCd", type);
        param.put("dealType", dealType);
        param.put("keyword", keyword);
        param.put("pageSize", Integer.valueOf(pageSize));
        param.put("offset", Integer.valueOf(offset));

        List<?> list = propertySearchDao.getPropertyTypeList(param);
        int totalCnt = propertySearchDao.getPropertyTypeCount(param);
        int totalPage = totalCnt > 0 ? (int) Math.ceil((double) totalCnt / pageSize) : 1;

        model.addAttribute("type", type);
        model.addAttribute("dealType", dealType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("list", list);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("pageNo", pageNo);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("catList", propertySearchDao.getFrontCatList());
        return "front/property/propertyList";
    }

    @RequestMapping(value = "/viewPropertyDetail", method = RequestMethod.POST)
    public String viewPropertyDetail(@RequestParam(value = "type", required = false, defaultValue = "apt") String type,
                                     @RequestParam(value = "id", required = false, defaultValue = "") String id,
                                     HttpSession session, Model model) {
        model.addAttribute("type", type);
        if (id != null && !id.isEmpty()) {
            Map<String, Object> param = new HashMap<>();
            param.put("id", id);

            // 관리자가 아닌 경우에만 조회수 증가
            Object loginUser = session.getAttribute("loginUser");
            if (loginUser == null) {
                propertySearchDao.increaseViewCnt(param);
            }

            Map<String, Object> prop = propertySearchDao.getPropertyDetail(param);
            model.addAttribute("prop", prop);
            List<Map<String, Object>> imgList = propertySearchDao.getPropertyImageList(param);
            model.addAttribute("imgList", imgList);
        }
        model.addAttribute("catList", propertySearchDao.getFrontCatList());
        return "front/property/propertyDetail";
    }

    @RequestMapping(value = "/viewPropertySearch", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertySearch(Model model) {
        model.addAttribute("catList", propertySearchDao.getFrontCatList());
        return "front/property/propertySearch";
    }

    @ResponseBody
    @RequestMapping(value = "/getPropertyMapList", method = RequestMethod.POST)
    public Map<String, Object> getPropertyMapList(@RequestParam(value = "swLat", required = false) String swLat,
                                                   @RequestParam(value = "swLng", required = false) String swLng,
                                                   @RequestParam(value = "neLat", required = false) String neLat,
                                                   @RequestParam(value = "neLng", required = false) String neLng,
                                                   @RequestParam(value = "propType", required = false, defaultValue = "ALL") String propType,
                                                   @RequestParam(value = "dealType", required = false, defaultValue = "ALL") String dealType) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("catCd", propType);
            param.put("dealType", dealType);
            if (swLat != null && !swLat.isEmpty()) {
                param.put("swLat", Double.parseDouble(swLat));
                param.put("swLng", Double.parseDouble(swLng));
                param.put("neLat", Double.parseDouble(neLat));
                param.put("neLng", Double.parseDouble(neLng));
            }
            List<?> list = propertySearchDao.getPropertyMapList(param);
            result.put("DATA", list);
            result.put("result", "OK");
        } catch (Exception e) {
            result.put("DATA", new java.util.ArrayList<>());
            result.put("result", "FAIL");
            e.printStackTrace();
        }
        return result;
    }

    @org.springframework.beans.factory.annotation.Autowired
    private PropertySearchDao propertySearchDao;
}
