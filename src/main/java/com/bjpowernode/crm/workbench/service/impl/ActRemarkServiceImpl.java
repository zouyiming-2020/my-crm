package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ActRemarkDao;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActRemarkServiceImpl implements ActRemarkService {
    @Autowired
    private ActRemarkDao actRemarkDao;

    @Override
    public List<ActivityRemark> getARListByActId(String actId) {
        return actRemarkDao.getARListByActId(actId);
    }

    @Override
    public void updateActRemark(ActivityRemark activityRemark) {
        actRemarkDao.updateActRemark(activityRemark);
    }

    @Override
    public void deleteActRemark(String id) {
        actRemarkDao.deleteActRemark(id);
    }
}
