package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value="/workbench/main")
public class MainController {
    @RequestMapping(value="/toMain.do")
    public String toMain(){
        return "/workbench/main/index";
    }
}
