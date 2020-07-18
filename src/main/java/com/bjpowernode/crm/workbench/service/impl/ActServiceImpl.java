package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ActDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActServiceImpl implements ActService {
    @Autowired
    private ActDao actDao;
    @Override
    public List<Activity> findAllAct() {
        List<Activity> activityList= actDao.findAllAct();
        return activityList;
    }

    @Override
    public void saveActivity(Activity activity) {
        actDao.saveActivity(activity);
    }

    @Override
    public Activity getActById(String id) {
        return actDao.getActById(id);
    }


    @Override
    public Long getActCount(Map map) {
        return actDao.getActCount(map);
    }


    @Override
    public List<Activity> getLimAct(Map<String, Object> map) {
        return actDao.getLimAct(map);
    }


    @Override
    public void updateActById(Activity activity) {
        actDao.updateActById(activity);
    }

    @Override
    public void deleteActById(String[] ids) {
        actDao.deleteActById(ids);
    }

    @Override
    public List<Activity> findActById(String[] ids) {
        return actDao.findActById(ids);
    }

    @Override
    public void saveActList(List<Activity> aList) {
        actDao.saveActList(aList);

    }
}
