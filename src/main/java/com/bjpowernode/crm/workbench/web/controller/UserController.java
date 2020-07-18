package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static com.bjpowernode.crm.utils.Conts.*;

@Controller
@RequestMapping("/workbench/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JedisPool jedisPool;
    /**
     * 传统的表单提交
     *
     * @param loginAct
     * @param loginPwd
     * @return
     */
    @RequestMapping("/login.do")
    public String login(String loginAct, String loginPwd) {
        //使用loginAct和loginPwd查询数据库
        User user = userService.login(loginAct, loginPwd);

        //如果查询出来对应User用户，证明登录成功
        if (user == null) {
            //登录失败，跳转到登录页面
            return "redirect:/login.jsp";
        }

        //登录成功，跳转到工作台的index.jsp页面
        //视图解析器会拼接 /WEB-INF/jsp + 返回值 + .jsp
        return "/workbench/index";
    }

    /**
     * 使用Ajax进行表单提交
     *
     * @param loginAct
     * @param loginPwd
     * @return
     */
    @RequestMapping("/ajax2login.do")
    @ResponseBody
    public Map<String, Object> ajax2login(String loginAct, String loginPwd, int flag, HttpServletRequest request, HttpServletResponse response) throws LoginException {
        System.out.println("ajax2login");
        loginPwd = MD5Util.getMD5(loginPwd);
        User user = userService.login(loginAct, loginPwd);
        request.getSession().setAttribute("user", user);

        Map<String, Object> map = new HashMap<>();

        if (user == null) {
            throw new LoginException(LOGIN_FAILED);
        }

        if ("0".equals(user.getLockState())) {
            throw new LoginException(LOGIN_LOCK);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy:MM:dd hh:mm;ss");
        String time = sdf.format(new Date());
        if (time.compareTo(user.getExpireTime()) > 0) {
            throw new LoginException(LOGIN_EXPIREDTIME);
        }

        String ip = request.getRemoteAddr();
        System.out.println(ip);
        String ips = user.getAllowIps();
        if (!ips.contains(ip)) {
            throw new LoginException(LOGIN_IPLIMITED);
        }

        if(flag==1){
//            Cookie logAct=new Cookie("loginAct",loginAct);
//            Cookie logPwd=new Cookie("loginPwd",loginPwd);
//
//            logAct.setPath("/");
//            logPwd.setPath("/");
//
//            logAct.setMaxAge(60*60*24*10);
//            logPwd.setMaxAge(60*60*24*10);
//
//            response.addCookie(logAct);
//            response.addCookie(logPwd);

            Jedis jedis=jedisPool.getResource();
            jedis.set("loginAct",loginAct);
            jedis.set("loginPwd",loginPwd);



            

        }


        map.put("success", true);
        return map;
    }

    @RequestMapping("/toWorkbenchIndex.do")
    public String toWorkbenchIndex() {
        return "/workbench/index";
    }


    @RequestMapping("/toLogin.do")
    public String toLogin(HttpServletResponse response,HttpServletRequest request) {
        Cookie[] cookies=request.getCookies();
        String loginAct=null;
        String loginPwd=null;
        if(cookies!=null){
            for (Cookie cookie : cookies) {
                if("loginAct".equals(cookie.getName())){
                    loginAct=cookie.getValue();
                    continue;
                }
                if("loginPwd".equals(cookie.getName())){
                    loginPwd=cookie.getValue();
                    continue;
                }
            }

            User user=userService.login(loginAct,loginPwd);
            request.getSession().setAttribute("user",user);
            if(user!=null){
                return "/workbench/index";
            }
        }

        return "/login";
    }


    @RequestMapping("/toLogout.do")
    public String toLogout(HttpServletRequest request,HttpServletResponse response){
        request.getSession().invalidate();

        Cookie logAct=new Cookie("loginAct","");
        Cookie logPwd=new Cookie("loginPwd","");

        logAct.setMaxAge(0);
        logPwd.setMaxAge(0);

        logAct.setPath("/");
        logPwd.setPath("/");

        response.addCookie(logAct);
        response.addCookie(logPwd);

        return "/login";

    }
}