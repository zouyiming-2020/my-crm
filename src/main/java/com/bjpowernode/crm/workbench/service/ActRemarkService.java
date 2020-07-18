package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActRemarkService {
    List<ActivityRemark> getARListByActId(String actId);

    void updateActRemark(ActivityRemark activityRemark);

    void deleteActRemark(String id);
}
