package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TransactionService {
    List<String> getCustomerName(String name);

    List<Contacts> getContactsSource();

    List<Tran> getTranPage (Integer pageNo,Integer pageSize);

    Integer getCount();

    Tran findTranById(String id);

    List<TranHistory> getTranHistory(String tranId);

    void updateTran(Tran tran);

    void addTranHistory(TranHistory th);
}
