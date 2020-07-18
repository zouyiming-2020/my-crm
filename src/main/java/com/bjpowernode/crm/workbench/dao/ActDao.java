package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActDao {
    List<Activity> findAllAct();

    void saveActivity(Activity activity);

    Activity getActById(String id);

    Long getActCount(Map map);

    List<Activity> getLimAct(Map<String,Object> map);

    void updateActById(Activity activity);

    void deleteActById(String[] ids);

    List<Activity> findActById(String[] ids);

    void saveActList (List<Activity> aList);

    List<Activity> getBindedAct(@Param("clueId")String clueId, @Param("name")String name);
    String getActNameById(String id);

}
