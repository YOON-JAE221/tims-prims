package com.prims.front.property;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/property")
public class PropertyController {

    @RequestMapping(value = "/viewPropertyList", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertyList(@RequestParam(value = "type", required = false, defaultValue = "all") String type, Model model) {
        model.addAttribute("type", type);
        return "front/property/propertyList";
    }

    @RequestMapping(value = "/viewPropertyDetail", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewPropertyDetail(@RequestParam(value = "type", required = false, defaultValue = "apt") String type,
                                     @RequestParam(value = "id", required = false, defaultValue = "1") String id, Model model) {
        model.addAttribute("type", type);
        model.addAttribute("propId", id);
        return "front/property/propertyDetail";
    }
}
