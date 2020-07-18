package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Autowired
    private ClueService clueService;

    @RequestMapping("/toClueIndex.do")
    public ModelAndView toClueIndex(){

        ModelAndView mv=new ModelAndView();
        mv.setViewName("/workbench/clue/index");
        return mv;
    }

    @RequestMapping("/getClueList.do")
    @ResponseBody
    public Map<String, Object> getClueList(String owner){
        List<Clue> clueList=clueService.findClueByOwner(owner);
        return HandleFlag.successObj("cList",clueList);

    }

    @RequestMapping("/toDetail.do")
    public ModelAndView toDetail(String clueId){
        ModelAndView mv=new ModelAndView();
        mv.setViewName("/workbench/clue/detail");
        Clue clue=clueService.finClueByClueId(clueId);
        mv.addObject("c",clue);

        return mv;
    }

    @RequestMapping("/getBindedAct.do")
    @ResponseBody
    public Map<String,Object> getBindedClue(String clueId,String name){
        List<Activity> activityList=clueService.getBindedAct(clueId,name);
        return HandleFlag.successObj("aList",activityList);
    }

    @RequestMapping("/removeAct.do")
    @ResponseBody
    public Map<String,Object> removeAct(String relationId){
        clueService.deleteBindedAct(relationId);
        return HandleFlag.successObj("msg","success");
    }



    @RequestMapping("/findActNotBinded.do")
    @ResponseBody
    public Map<String,Object> findActNotBinded(String clueId,String name){
        List<Activity> activityList=clueService.findActNotBinded(clueId,name);
        return HandleFlag.successObj("aList",activityList);
    }

    @RequestMapping("/bindNewAct.do")
    @ResponseBody
    public Map bindNewAct(@RequestParam String[] activities, String clueId){
        clueService.addNewAct(activities,clueId);
        return HandleFlag.successObj("msg","success");
    }


    @RequestMapping("/getClueListX.do")
    @ResponseBody
    public Map getClueListX(String owner ,String pageNo ,String pageSize ){
        Integer pgNo=Integer.parseInt(pageNo);
        Integer pgSize=Integer.parseInt(pageSize);
        List<Clue> cList=clueService.getClueListX(owner,pgNo,pgSize);
        Integer count=clueService.getClueCount(owner);
        Map<String,Object> map=new HashMap<>();
        map.put("success",true);
        map.put("cList",cList);
        map.put("total",count);

        return  map;
    }


    @RequestMapping("/saveClue.do")
    public String saveClue(Clue clue,HttpSession session){
        User user=(User)session.getAttribute("user");
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(user.getName());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        clueService.saveClue(clue);

        return "/workbench/clue/index";


    }

    @RequestMapping("/findClueById.do")
    @ResponseBody
    public Map  findClueById(String clueId){

        Clue clue=clueService.finClueByClueId(clueId);

        return HandleFlag.successObj("clue",clue);
    }


    @RequestMapping("/updateClue.do")
    public String updateClue(Clue clue,HttpSession session){
        User user=(User)session.getAttribute("user");
        clue.setEditBy(user.getName());
        clue.setEditTime(DateTimeUtil.getSysTime());
        clueService.updateClue(clue);

        return "/workbench/clue/index";
    }

    @RequestMapping("/deleteClueByIds.do")
    @ResponseBody
    public Map<String,Object> deleteClueByIds(String[] ids){
        clueService.deleteClueByIds(ids);
        return HandleFlag.successObj("msg","success");
    }



//---------------------------线索转换---------------------------------------------------------------//
    @RequestMapping("/toClueConvert.do")
    public ModelAndView toClueConvert(Clue clue){
        ModelAndView mv=new ModelAndView();

        mv.addObject("c",clue);
        mv.setViewName("/workbench/clue/convert");
        return mv;
    }


    @RequestMapping("/clueTransform.do")
    public String clueTransForm(@RequestParam Map<String,String> paramap, HttpSession session){
        //1.通过线索创建联系人和客户
        //2.通过线索备注创建联系人备注和客户备注
        //3.通过线索，活动中间表创建联系人，活动中间表
        //4.根据flag值判断是否创建交易，交易备注和交易历史
        //5.删除线索，活动中间表中的内容
        //6.删除线索备注
        //7.删除线索

        clueService.clueTransForm(paramap,session);

        return "redirect:/workbench/clue/toClueIndex.do";



    }





}
