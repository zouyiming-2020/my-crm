package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Service
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private TranDao tranDao;

    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public List<String> getCustomerName(String name) {
        return tranDao.getCustomerName(name);
    }

    @Override
    public List<Contacts> getContactsSource() {
        return tranDao.getContactsSource();
    }

    @Override
    public List<Tran> getTranPage(Integer pageNo, Integer pageSize) {
        return tranDao.getTranPage(pageNo,pageSize);
    }


    @Override
    public Integer getCount() {
        return tranDao.getCount();
    }

    @Override
    public Tran findTranById(String id) {
        return tranDao.findTranById(id);
    }

    @Override
    public List<TranHistory> getTranHistory(String tranId) {
        return tranHistoryDao.getTranHistory(tranId);
    }

    @Override
    public void updateTran(Tran tran) {

        tranDao.updateTran(tran);

    }


    @Override
    public void addTranHistory(TranHistory th) {
        String id= UUIDUtil.getUUID();
        th.setId(id);
        th.setCreateTime(DateTimeUtil.getSysTime());
        tranHistoryDao.addTranHistory(th);

    }
}
