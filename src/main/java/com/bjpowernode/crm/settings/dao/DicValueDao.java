package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.DicValue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DicValueDao {
    List<DicValue> findValueAll();
    DicValue findByCodeOrValue(@Param("value")String value,@Param("typeCode")String typeCode);

    void saveDicValue(DicValue dicValue);

    DicValue findDicValueById(String id);

    void updateDicValue(DicValue dicValue);

    void deleteDicValue(String[] ids);

    DicValue findByItv (DicValue dicValue);

    List<DicValue> findDicValueByCode (String code);
}
