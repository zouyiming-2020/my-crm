package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.sun.javafx.collections.MappingChange;
import org.apache.ibatis.annotations.Param;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

public interface ClueService {
    List<Clue> findClueByOwner(String owner);

    Clue finClueByClueId(String clueId);

    List<Activity> getBindedAct(String clueId,String name);

    void deleteBindedAct(String relationId);


    List<Activity> findActNotBinded(String clueId, String name);

    void addNewAct(String[] activities,String clueId);


    void clueTransForm(Map<String,String> paramap, HttpSession session);

    List<Clue> getClueListX(String owner,Integer pageNo,Integer pageSize);

    Integer getClueCount(String owner);

    void saveClue(Clue clue);

    void updateClue(Clue clue);

    void deleteClueByIds(String[] ids);
}