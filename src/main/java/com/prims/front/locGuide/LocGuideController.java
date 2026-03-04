package com.prims.front.locGuide;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/locGuide")
public class LocGuideController {

    @RequestMapping(value = "/viewLocGuide", method = {RequestMethod.GET, RequestMethod.POST})
    public String viewLocGuide() {
        return "front/locGuide/locGuide";
    }
}
