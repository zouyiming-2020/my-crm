package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.ActDao;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.TransactionService;
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
@RequestMapping("/workbench/transaction")
public class TransactionController {
    @Autowired
    private ActDao actDao;

    @Autowired
    private TransactionService transactionService;



    @RequestMapping("/toIndex.do")
    public ModelAndView toIndex(){
        ModelAndView mv=new ModelAndView();
        mv.setViewName("/workbench/transaction/index");

        return mv;
    }

    @RequestMapping("/toSave.do")
    public ModelAndView toSave(){
        ModelAndView mv=new ModelAndView();
        mv.setViewName("/workbench/transaction/save");

        return mv;
    }


    @RequestMapping("/getActSource.do")
    @ResponseBody
    public Map getActSource(){
        List<Activity> aList=actDao.findAllAct();
        return HandleFlag.successObj("aList",aList);

    }

//    @RequestMapping("/getContactsSource.do")
//    @ResponseBody
//    public Map getContactsSource(){
//        List<Contacts> contactsList=transactionService.getContactsSource();
//    }


    @RequestMapping("/getTranPage.do")
    @ResponseBody
    public Map getTranPage(Integer pageNo,Integer pageSize){
        List<Tran> tranList=transactionService.getTranPage(pageNo,pageSize);
        Integer count=transactionService.getCount();

        Map<String,Object> map=new HashMap<>();
        map.put("success",true);
        map.put("total",count);
        map.put("tList",tranList);

        return map;




    }





    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name){
        List<String> strings=transactionService.getCustomerName(name);
        return strings;
    }

    @RequestMapping("/toDetail.do")
    public ModelAndView toDetail(String id, HttpSession session){
        User user=(User)session.getAttribute("user");
        Tran t=transactionService.findTranById(id);
        t.setCreateTime(DateTimeUtil.getSysTime());
        t.setCreateBy(user.getName());

        Map<String,String> sMap=(Map<String,String>)session.getServletContext().getAttribute("sMap");
        String possibility=sMap.get(t.getStage());
        t.setPossibility(possibility);

        ModelAndView mv=new ModelAndView();
        mv.addObject("t",t);
        mv.setViewName("/workbench/transaction/detail");

        return mv;


    }


    @RequestMapping("/getTranHistory.do")
    @ResponseBody
    public Map<String,Object>getTranHistory(String tranId,HttpSession session){
        List<TranHistory> thList=transactionService.getTranHistory(tranId);
        Map<String,String> sMap=(Map<String,String>)session.getServletContext().getAttribute("sMap");
        for(TranHistory th:thList){
            String stage=th.getStage();
            String ps=sMap.get(stage);
            th.setPossibility(ps);
        }


        return HandleFlag.successObj("thList",thList);




    }

    @RequestMapping("/updateTranAndTranHistory.do")
    @ResponseBody
    public Map<String,Object> updateTranAndTranHistory(Tran tran,HttpSession session){
        Map<String,String> sMap=(Map<String,String>)session.getServletContext().getAttribute("sMap");
        String possibility=sMap.get(tran.getStage());
        tran.setPossibility(possibility);
        tran.setEditTime(DateTimeUtil.getSysTime());
        tran.setEditBy(tran.getOwner());
        transactionService.updateTran(tran);

        TranHistory th=new TranHistory();
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setCreateBy(tran.getOwner());
        th.setStage(tran.getStage());
        th.setTranId(tran.getId());
        transactionService.addTranHistory(th);

        Tran tran1=transactionService.findTranById(tran.getId());
        tran1.setPossibility(possibility);
        return HandleFlag.successObj("t",tran1);



    }

}
