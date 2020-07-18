package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicValueService {
    List<DicValue> findValueAll();

    Map<String,Object> findByCodeOrValue(String value,String typeCode);

    void saveDicValue(DicValue dicValue);

    String[] findAllDicType();

    DicValue findDicValueById(String id);

    void updateDicValue(DicValue dicValue);

    void deleteDicValue(String[] ids);

    Map<String,Object> findByItv(DicValue dicValue);

    List<DicValue> findDicValueByCode (String code);
}
