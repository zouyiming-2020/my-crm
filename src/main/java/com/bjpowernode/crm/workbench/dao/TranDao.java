package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Tran;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TranDao {
    void saveTran(Tran t);

    List<String> getCustomerName(String name);

    List<Contacts> getContactsSource();

    List<Tran> getTranPage(@Param("pageNo") Integer pageNo,@Param("pageSize") Integer pageSize);

    Integer getCount();

    Tran findTranById(String id);

    void updateTran(Tran tran);
}
