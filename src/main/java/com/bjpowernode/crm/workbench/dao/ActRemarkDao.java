package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActRemarkDao {
    List<ActivityRemark> getARListByActId(String actId);

    void updateActRemark(ActivityRemark activityRemark);

    void deleteActRemark(String id);
}
