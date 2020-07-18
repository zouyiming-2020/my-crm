package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranHistory;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TranHistoryDao {
    void saveTranHistory(TranHistory th);

    List<TranHistory> getTranHistory(String tranId);

    void addTranHistory(TranHistory th);
}
