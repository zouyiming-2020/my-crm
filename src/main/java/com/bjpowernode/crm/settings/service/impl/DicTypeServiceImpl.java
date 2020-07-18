package com.bjpowernode.crm.settings.service.impl;


import com.bjpowernode.crm.exception.TraditionRequestException;
import com.bjpowernode.crm.settings.dao.DicTypeDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class DicTypeServiceImpl implements DicTypeService{

    @Autowired
    private DicTypeDao dicTypeDao;

    @Override
    public List<DicType> findAll() {
        List<DicType> dicTypeList=dicTypeDao.findAll();
        return dicTypeList;
    }

    public DicType checkDicType(String code){
        DicType dicType=dicTypeDao.checkDicType(code);
        return dicType;
    }

    @Override
    public void saveDicType(DicType dicType) {
        dicTypeDao.saveDicType(dicType);
    }


    @Override
    public void updateDicType(DicType dicType)throws TraditionRequestException{
        dicTypeDao.updateDicType(dicType);
    }

    @Override
    public void deleteDicType(String[] codes) {
        dicTypeDao.deleteDicType(codes);
    }
}
