package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.exception.TraditionRequestException;
import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

public interface DicTypeService {
    public List<DicType> findAll();


    public DicType checkDicType(String code);

    public void saveDicType(DicType dicType);

    public void updateDicType(DicType dicType)throws TraditionRequestException;

    public  void deleteDicType(String[] codes);
}
