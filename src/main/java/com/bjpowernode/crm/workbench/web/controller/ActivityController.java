package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActService;
import com.bjpowernode.crm.workbench.service.UserService;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    private ActService actService;


    @RequestMapping("/toActIndex.do")
    public String toActIndex(){
//        ModelAndView mv=new ModelAndView();
//        List<Activity> aList=actService.findAllAct();
//        mv.addObject("aList",aList);
//        mv.setViewName("/workbench/activity/index");

        return "/workbench/activity/index";


    }
    @Autowired
    private UserService userService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public Map<String,Object> getUserList(){
        Map<String,Object> map=new HashMap<>();
        map.put("uList",userService.getUserList());
        map.put("success",true);
        return map;
    }

    @RequestMapping("/saveActivity.do")
    @ResponseBody
    public Map saveActivity(Activity activity, HttpSession httpSession){
        String id= UUIDUtil.getUUID();
        activity.setId(id);

        String time=DateTimeUtil.getSysTime();
        activity.setCreateTime(time);

        String createBy=((User)httpSession.getAttribute("user")).getName();
        activity.setCreateBy(createBy);

        actService.saveActivity(activity);

        return HandleFlag.successObj("msg","success");

    }

    @RequestMapping("/getActById.do")
    @ResponseBody
    public Map<String,Object> getActById(String id){
        Activity activity=actService.getActById(id);
        Map<String,Object> map=new HashMap<>();
        map.put("success",true);
        map.put("activity",activity);
        return map;
    }

    @RequestMapping("/getActAndUser")
    @ResponseBody
    public Map<String,Object> getActAndUser(String id){
        Activity activity=actService.getActById(id);
        List<User> userList=userService.getUserList();
        Map<String,Object> map=new HashMap<>();
        map.put("act",activity);
        map.put("uList",userList);
        map.put("success",true);
        return map;

    }

    @RequestMapping("/getPage.do")
    @ResponseBody
    public Map<String,Object>getPage(@RequestParam Map<String,Object> map){
        String p1=(String)map.get("pageNo");
        String p2=(String)map.get("pageSize");

        Integer pageNo=Integer.valueOf(p1);
        Integer pageSize=Integer.valueOf(p2);

        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);

        String id=(String)map.get("id");

        Long count=actService.getActCount(map);
        System.out.println(count);
        List<Activity> activityList=actService.getLimAct(map);

        Map<String,Object> map1=new HashMap<>();
        map1.put("success",true);
        map1.put("msg","success");
        map1.put("aList",activityList);
        map1.put("total",count);
        map1.put("id",id);
        return map1;

    }

    @RequestMapping("/updateActById.do")
    @ResponseBody
    public Map<String,Object> updateActById(Activity activity,HttpSession session){
        activity.setEditTime(DateTimeUtil.getSysTime());
        User user=(User)session.getAttribute("user");
        activity.setEditBy(user.getName());

        actService.updateActById(activity);

        return HandleFlag.successObj("msg","success");
    }

    @RequestMapping("/deleteActById.do")
    @ResponseBody
    public Map<String,Object> deleteActById(String[] ids){
        actService.deleteActById(ids);
        return HandleFlag.successObj("msg","deleted");
    }

    @RequestMapping("/toExportAllAct.do")
    public void toExportAllAct(HttpServletResponse response)throws Exception{
        List<Activity> aList =actService.findAllAct();
        downloadExcel(aList,response);
    }


    @RequestMapping("/toExportActXZ.do")
    public void toExportActXZ(HttpServletResponse response,String[] ids)throws Exception{
        List<Activity> aList =actService.findActById(ids);
        downloadExcel(aList,response);
    }

    /**
     * 获取上传文件，将数据导入数据库
     * @param myFile
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/importActivity.do")
    @ResponseBody
    public Map<String,Object> importActivity(MultipartFile myFile, HttpSession session, HttpServletRequest request)throws Exception{
        //获取myFile的原始文件名称
        String originalFileName=myFile.getOriginalFilename();
        //获取文件格式名称
        String suffix=originalFileName.substring(originalFileName.lastIndexOf(".")+1);
        //通过UUID获取一个唯一的文件名称
        String fileName=UUIDUtil.getUUID()+"."+suffix;
        //获取上传路径
        String realPath=request.getRealPath("/upload");

        //执行上传操作,获取上传文件
        myFile.transferTo(new File(realPath + "/" + fileName));


        //创建工作簿对象，通过流将上传文件写入
        InputStream in= new FileInputStream(realPath+"/"+fileName);
        HSSFWorkbook workbook=new HSSFWorkbook(in);

        //获取页码对象
        HSSFSheet sheet = workbook.getSheetAt(0);
        int firstRowNum=sheet.getFirstRowNum();
        int lastRowNum=sheet.getLastRowNum();

        //创建一个Activity集合来接受工作簿数据
        List<Activity> aList=new ArrayList<>();
        User user=(User)session.getAttribute("user");
        System.out.println(user);

        //通过遍历获取activity对象放入aList
        for(int i=firstRowNum+1;i<=lastRowNum;i++){
            HSSFRow row=sheet.getRow(i);
            Activity a=new Activity();
            a.setId(UUIDUtil.getUUID());
            a.setOwner(user.getId());
            a.setCreateBy(user.getName());
            a.setCreateTime(DateTimeUtil.getSysTime());
            String name = row.getCell(0).getStringCellValue();
            String startDate = row.getCell(1).getStringCellValue();
            String endDate = row.getCell(2).getStringCellValue();
            String cost = row.getCell(3).getStringCellValue();
            String description = row.getCell(4).getStringCellValue();

            a.setStartDate(startDate);
            a.setEndDate(endDate);
            a.setName(name);
            a.setCost(cost);
            a.setDescription(description);
            System.out.println(a);
            aList.add(a);

        }


        actService.saveActList(aList);


        return HandleFlag.successObj("msg","success");
    }
    /**
     * 封装下载方法
     * @param aList
     * @param response
     * @throws Exception
     */
    private void downloadExcel (List<Activity> aList, HttpServletResponse response)throws Exception{
        HSSFWorkbook workbook=new HSSFWorkbook();

        HSSFSheet sheet =workbook.createSheet();

        HSSFRow r1=sheet.createRow(0);

        r1.createCell(0).setCellValue("id");
        r1.createCell(1).setCellValue("owner");
        r1.createCell(3).setCellValue("startDate");
        r1.createCell(4).setCellValue("endDate");
        r1.createCell(5).setCellValue("cost");
        r1.createCell(6).setCellValue("description");
        r1.createCell(7).setCellValue("createTime");
        r1.createCell(8).setCellValue("createBy");
        r1.createCell(9).setCellValue("editTime");
        r1.createCell(10).setCellValue("editBy");

        for(int i=1;i<=aList.size();i++){
            HSSFRow row=sheet.createRow(i);
            Activity activity=aList.get(i-1);

            row.createCell(0).setCellValue(activity.getId());
            row.createCell(1).setCellValue(activity.getOwner());
            row.createCell(2).setCellValue(activity.getName());
            row.createCell(3).setCellValue(activity.getStartDate());
            row.createCell(4).setCellValue(activity.getEndDate());
            row.createCell(5).setCellValue(activity.getCost());
            row.createCell(6).setCellValue(activity.getDescription());
            row.createCell(7).setCellValue(activity.getCreateTime());
            row.createCell(8).setCellValue(activity.getCreateBy());
            row.createCell(9).setCellValue(activity.getEditBy());
            row.createCell(10).setCellValue(activity.getEditBy());

        }

        response.setContentType("octets/stream");
        response.setHeader("Content-Disposition","attachment;filename=Activity-"+DateTimeUtil.getSysTime()+".xls");
        OutputStream out = response.getOutputStream();
        workbook.write(out);
    }
}
