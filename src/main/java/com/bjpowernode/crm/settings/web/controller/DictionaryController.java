package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.exception.TraditionRequestException;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.utils.HandleFlag;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settings/dictionary")
public class DictionaryController {

    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping("/toDicIndex.do")
    public String toDicIndex(){
        return "/settings/dictionary/index";
    }



    @RequestMapping("/type/toTypeIndex.do")
    public ModelAndView toTypeIndex(){
        ModelAndView mv=new ModelAndView();
        List<DicType> dicTypeList=dicTypeService.findAll();
        mv.addObject("dList",dicTypeList);
        mv.setViewName("/settings/dictionary/type/index");
        return mv;
    }

    @RequestMapping("/type/toTypeSave.do")
    public  String toTypeSave(){
        return "/settings/dictionary/type/save";
    }


    @RequestMapping("/type/checkTypeCode.do")
    @ResponseBody
    public Map checkTypeCode(String code){
        DicType dicType=dicTypeService.checkDicType(code);
        Map<String,Object> map=new HashMap<>();

        if(dicType==null){
            map=HandleFlag.successObj("msg","allowed");
//            map.put("success",true);
//            map.put("msg","allowed");
        }else{

           map.put("success",false);
           map.put("msg","not allowed;try again!");
        }
        return map;
    }

    @RequestMapping("/type/saveDicType.do")
    public String saveDicType(DicType dicType){
       dicTypeService.saveDicType(dicType);
       return "redirect:/settings/dictionary/type/toTypeIndex.do";
    }



    @RequestMapping("/type/findDicTypeByCode.do")
    public ModelAndView findDicTypeByCode(String code){
        DicType dicType=dicTypeService.checkDicType(code);
        ModelAndView mv=new ModelAndView();
        mv.addObject("dt",dicType);
        mv.setViewName("/settings/dictionary/type/edit");
        return mv;
    }



//    @RequestMapping("/type/toTypeEdit.do")
//    public String toTypeEdit(){
//        return "/settings/dictionary/type/edit";
//    }

    @RequestMapping("/type/updateDicType.do")
    public String updateDicType(DicType dicType)throws TraditionRequestException {
       dicTypeService.updateDicType(dicType);






        return "redirect:/settings/dictionary/type/toTypeIndex.do";
    }

    @RequestMapping("/type/deleteDicType.do")
    @ResponseBody
    public Map deleteDicType(String[] codes){
        System.out.println(Arrays.toString(codes));
        dicTypeService.deleteDicType(codes);

        return HandleFlag.successObj("msg","删除成功");

    }

//-----------------------------------------------------------------------------------------------------//
    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/value/toValueIndex.do")
    public ModelAndView toValueIndex(){
        ModelAndView mv=new ModelAndView();
        List<DicValue> dicValueList=dicValueService.findValueAll();
        mv.addObject("dList",dicValueList);
        mv.setViewName("/settings/dictionary/value/index");
        return mv;

    }

    @RequestMapping("/value/toValueSave.do")
    public String toValueSave(Model model){
//        ModelAndView mv=new ModelAndView();
//        mv.setViewName("/settings/dictionary/value/save");
//        mv.addObject("codes",dicValueService.findAllDicType());
        model.addAttribute("codes",dicValueService.findAllDicType());

        return "/settings/dictionary/value/save";
    }

    @RequestMapping("/value/findByCodeOrValue.do")
    @ResponseBody
    public Map<String,Object> findByCodeOrValue(String value, String typeCode){

        return dicValueService.findByCodeOrValue(value,typeCode);
    }

    @RequestMapping("/value/saveDicValue.do")
    public String saveDicValue(DicValue dicValue){
        dicValueService.saveDicValue(dicValue);
        return "redirect:/settings/dictionary/value/toValueIndex.do";
    }


    @RequestMapping("/value/findDicValueById.do")
    public ModelAndView findDicValueById(String id){
        DicValue dicValue=dicValueService.findDicValueById(id);
        ModelAndView mv=new ModelAndView();
        mv.setViewName("/settings/dictionary/value/edit");
        mv.addObject("dv",dicValue);
        return mv;
    }

    @RequestMapping("/value/updateDicValue.do")
    public String updateDicValue(DicValue dicValue){
        dicValueService.updateDicValue(dicValue);
        return "redirect:/settings/dictionary/value/toValueIndex.do";
    }

    @RequestMapping("/value/deleteDicValue.do")
    @ResponseBody
    public Map deleteDicValue(String[] ids){
        dicValueService.deleteDicValue(ids);
        return HandleFlag.successObj("msg","删除成功");
    }


    @RequestMapping("/value/findByItv.do")
    @ResponseBody
    public Map<String,Object> findByItv(DicValue dicValue){
        return dicValueService.findByItv(dicValue);
    }


}
