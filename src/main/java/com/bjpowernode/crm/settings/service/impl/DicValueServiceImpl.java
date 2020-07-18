package com.bjpowernode.crm.settings.service.impl;


import com.bjpowernode.crm.settings.dao.DicTypeDao;
import com.bjpowernode.crm.settings.dao.DicValueDao;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.utils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueDao dicValueDao;



    @Override
    public List<DicValue> findValueAll() {

        List<DicValue> dicValueList=dicValueDao.findValueAll();
        return dicValueList;
    }

    @Override
    public Map<String,Object> findByCodeOrValue(String value,String typeCode) {
        Map<String,Object> map=new HashMap<>();
        DicValue dicValue=dicValueDao.findByCodeOrValue(value,typeCode);
        if(dicValue==null){
            map.put("success",true);
            map.put("msg","allowed");
        }else{
            map.put("success",false);
            map.put("msg","not allowed");
        }

        return map;
    }

    @Override
    public void saveDicValue(DicValue dicValue) {
        dicValue.setId(UUIDUtil.getUUID());
        dicValueDao.saveDicValue(dicValue);
    }

    @Autowired
    private DicTypeDao dicTypeDao;

    @Override
    public String[] findAllDicType() {
        return dicTypeDao.findAllDicType();
    }

    @Override
    public DicValue findDicValueById(String id) {
        return dicValueDao.findDicValueById(id);
    }

    @Override
    public void updateDicValue(DicValue dicValue) {

        dicValueDao.updateDicValue(dicValue);
    }

    @Override
    public void deleteDicValue(String[] ids) {
        dicValueDao.deleteDicValue(ids);
    }

    @Override
    public Map<String, Object> findByItv(DicValue dicValue) {
        Map<String,Object> map=new HashMap<>();
        DicValue dicValue1=dicValueDao.findByItv(dicValue);
        if(dicValue1==null){
            map.put("success",true);
            map.put("msg","allowed");
        }else{
            map.put("success",false);
            map.put("msg","not allowed");
        }

        return map;


    }

    @Override
    public List<DicValue> findDicValueByCode(String code) {
        return dicValueDao.findDicValueByCode(code);
    }
}
