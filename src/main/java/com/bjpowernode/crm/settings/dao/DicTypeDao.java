package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

public interface DicTypeDao {
    List<DicType> findAll();
    DicType checkDicType(String code);

    void saveDicType(DicType dicType);

    void updateDicType(DicType dicType);

    void deleteDicType(String[] codes);

     String[] findAllDicType();

}
