package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.dao.DicValueDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import java.util.*;

public class SysInitListener extends ContextLoaderListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext application = event.getServletContext();

        DicValueService dicValueService = WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicValueService.class);
        DicTypeService dicTypeService = WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicTypeService.class);

        //DicValueDao dicValueDao=WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicValueDao.class);
        UserService userService=WebApplicationContextUtils.getWebApplicationContext(application).getBean(UserService.class);



        List<User> userList=userService.getUserList();
        List<DicType> dtList = dicTypeService.findAll();
        Map<String, List<DicValue>> map = new HashMap<>();



        for (DicType dt : dtList) {

            String code = dt.getCode();

            List<DicValue> dvList = dicValueService.findDicValueByCode(code);
            //key:value
            map.put(code + "List", dvList);

        }

        Set<String> set = map.keySet();

        for(String key:set){

            event.getServletContext().setAttribute(key,map.get(key));

        }

        event.getServletContext().setAttribute("userList",userList);

//---------------------------------stage-possibility-------------------------------------------//

        Map<String,String> sMap=new HashMap<>();

        ResourceBundle resourceBundle=ResourceBundle.getBundle("properties/stage-possibility");
        Enumeration<String> keys=resourceBundle.getKeys();
        while(keys.hasMoreElements()){
            String key=keys.nextElement();
            String value=(String)resourceBundle.getObject(key);
            sMap.put(key,value);
        }

        event.getServletContext().setAttribute("sMap",sMap);
    }
}
