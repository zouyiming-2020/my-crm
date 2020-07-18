package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    List<Clue> findClueByOwner(String owner);

    Clue finClueByClueId (String clueId);

    void deleteBindedAct(String relationId);

    List<Activity> findActNotBinded( @Param("clueId") String clueId, @Param("name") String name);

    void addNewAct(@Param("id") String id, @Param("clueId") String clueId, @Param("actId") String actId);

    void deleteClueById(String id);

    List<Clue> getClueListX(@Param("owner") String owner,@Param("pageNo") Integer pageNo,@Param("pageSize") Integer pageSize);

    Integer getClueCount(String owner);

    void saveClue(Clue clue);

    void updateClue(Clue clue);
    void deleteClueByIds(String[] ids);
}
