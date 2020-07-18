package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActRemarkService;
import com.bjpowernode.crm.workbench.service.ActService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/ActivityRemark")
public class ActivityRemarkController {

    @Autowired
    private ActRemarkService actRemarkService;
    @Autowired
    private ActService actService;


    @RequestMapping("/toDetail.do")
    public ModelAndView toDetail(String actId){
        Activity activity=actService.getActById(actId);

        ModelAndView mv=new ModelAndView();
        mv.addObject("act",activity);
        mv.setViewName("/workbench/activity/detail");
        return mv;
    }

    @RequestMapping("/getARListByActId.do")
    @ResponseBody
    public Map<String,Object> getARListByActId(String actId){
        List<ActivityRemark> arList= actRemarkService.getARListByActId(actId);

         Map<String,Object> map=new HashMap<>();
         map.put("success",true);
         map.put("msg","success");
         map.put("arList",arList);
         return map;


    }

    @RequestMapping("/updateActRemark.do")
    @ResponseBody
    public Map<String,Object> updateActRemark(ActivityRemark activityRemark, HttpSession session){
        User user=(User)session.getAttribute("user");

        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setEditFlag("1");
        activityRemark.setEditBy(user.getName());
        activityRemark.setEditTime(DateTimeUtil.getSysTime());

        actRemarkService.updateActRemark(activityRemark);

        Map<String,Object> map=new HashMap<>();
        map.put("editBy",user.getName());
        map.put("editTime",DateTimeUtil.getSysTime());
        map.put("success",true);

        return map;
    }

    @RequestMapping("/deleteActRemark.do")
    @ResponseBody
    public Map<String,Object> deleteActRemark(String id){
        actRemarkService.deleteActRemark(id);
        return HandleFlag.successObj("msg",true);
    }

}
