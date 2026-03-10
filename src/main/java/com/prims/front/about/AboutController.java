package com.prims.front.about;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/about")
public class AboutController {

    @RequestMapping(value = "/viewAbout", method = RequestMethod.POST)
    public String viewAbout() {
        return "front/about/about";
    }
}
