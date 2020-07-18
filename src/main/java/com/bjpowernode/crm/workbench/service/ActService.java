package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActService {
    List<Activity> findAllAct();
    void saveActivity(Activity activity);

    Activity getActById(String id);

    Long getActCount(Map map);

    List<Activity> getLimAct(Map<String,Object> map);

    void updateActById(Activity activity);

    void deleteActById(String[] ids);

    List<Activity> findActById(String[] ids);

    void saveActList(List<Activity> aList);
}
