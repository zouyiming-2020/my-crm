package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.sun.org.apache.xpath.internal.operations.Bool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueDao clueDao;

    @Autowired
    private ActDao actDao;


    @Override
    public List<Clue> findClueByOwner(String owner) {
        return clueDao.findClueByOwner(owner);
    }

    @Override
    public Clue finClueByClueId(String clueId) {
        return clueDao.finClueByClueId(clueId);

    }

    @Override
    public List<Activity> getBindedAct(String clueId,String name) {
        return  actDao.getBindedAct(clueId,name);
    }


    @Override
    public void deleteBindedAct(String relationId) {
        clueDao.deleteBindedAct(relationId);
    }

    @Override
    public List<Activity> findActNotBinded(String clueId,String name) {
        return clueDao.findActNotBinded(clueId,name);
    }


    @Override
    public void addNewAct(String[] activities,String clueId) {
        for (String actId: activities) {
            clueDao.addNewAct(UUIDUtil.getUUID(),clueId,actId);
        }


    }

    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;
    @Autowired
    private  ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private  CustomerRemarkDao customerRemarkDao;
    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public List<Clue> getClueListX(String owner, Integer pageNo, Integer pageSize) {
        return clueDao.getClueListX(owner,pageNo,pageSize);
    }

    @Override
    public void deleteClueByIds(String[] ids) {
        clueDao.deleteClueByIds(ids);
    }

    @Override
    public void updateClue(Clue clue) {
        clueDao.updateClue(clue);
    }

    @Override
    public void saveClue(Clue clue) {
        clueDao.saveClue(clue);
    }

    @Override
    public Integer getClueCount(String owner) {
        return clueDao.getClueCount(owner);
    }

    @Override
    public void clueTransForm(Map<String,String> paramap, HttpSession session) {
        User u=(User)session.getAttribute("user");
        Clue c=clueDao.finClueByClueId(paramap.get("clueId"));

        //1.通过线索创建联系人和客户
        Customer ct=customerDao.findByCompany(c.getCompany());
        if(ct==null) {
            ct=new Customer();
            ct.setId(UUIDUtil.getUUID());
            ct.setOwner(u.getName());
            ct.setName(c.getCompany());
            ct.setWebsite(c.getWebsite());
            ct.setPhone(c.getPhone());
            ct.setCreateBy(u.getName());
            ct.setCreateTime(DateTimeUtil.getSysTime());
            ct.setDescription(c.getDescription());
            ct.setContactSummary(c.getContactSummary());
            ct.setNextContactTime(c.getNextContactTime());
            ct.setAddress(c.getAddress());
            customerDao.saveCustomer(ct);
        }


        Contacts con = contactsDao.findByFullName(c.getFullname(),c.getId());
        if(con==null) {
            con=new Contacts();
            con.setId(UUIDUtil.getUUID());
            con.setOwner(u.getName());
            con.setSource(c.getSource());
            con.setCustomerId(ct.getId());
            con.setFullname(c.getFullname());
            con.setAppellation(c.getAppellation());
            con.setEmail(c.getEmail());
            con.setMphone(c.getMphone());
            con.setJob(c.getJob());
            con.setCreateBy(u.getName());
            con.setCreateTime(DateTimeUtil.getSysTime());
            con.setDescription(c.getDescription());
            con.setContactSummary(c.getContactSummary());
            con.setNextContactTime(c.getNextContactTime());
            con.setAddress(c.getAddress());
            contactsDao.saveContacts(con);
        }



        //2.通过线索备注创建联系人备注和客户备注
        List<ClueRemark> crList=clueRemarkDao.findListByClueId(c.getId());
        List<CustomerRemark> customerRemarks=new ArrayList<>();
        List<ContactsRemark> contactsRemarks=new ArrayList<>();
        for (ClueRemark cr:
            crList ) {
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setContactsId(con.getId());
            contactsRemark.setCreateBy(u.getName());
            contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
            contactsRemark.setEditFlag("0");//未修改
            contactsRemark.setNoteContent(cr.getNoteContent());

            contactsRemarks.add(contactsRemark);

            //创建客户备注对象，封装到容器中，批量插入
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(u.getName());
            customerRemark.setCreateTime(DateTimeUtil.getSysTime());
            customerRemark.setCustomerId(ct.getId());
            customerRemark.setEditFlag("0");//未修改
            customerRemark.setNoteContent(cr.getNoteContent());

            customerRemarks.add(customerRemark);

        }

        contactsRemarkDao.saveContactsRemarks(contactsRemarks);
        customerRemarkDao.saveCustomerRemarks(customerRemarks);

        //3.通过线索，活动中间表创建联系人，活动中间表
        List<ClueActivityRelation> carList = clueActivityRelationDao.findRelationListByClueId(c.getId());

        //容器
        List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();

        if( carList.size() > 0 && carList != null){
            //遍历carList
            for (ClueActivityRelation car : carList) {
                //将car转换为联系人和市场活动的对象
                ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelation.setActivityId(paramap.get("activityId"));
                contactsActivityRelation.setContactsId(con.getId());

                //封装到容器中
                contactsActivityRelationList.add(contactsActivityRelation);
            }

            //批量插入
            contactsActivityRelationDao.saveContactsActivityRelations(contactsActivityRelationList);
        }

        //4.根据flag值判断是否创建交易和交易历史
        String flag=paramap.get("flag");
        if("true".equals(flag)){
            Tran tran=new Tran();
            tran.setId(UUIDUtil.getUUID());
            tran.setOwner(u.getName());
            tran.setMoney(paramap.get("money"));
            tran.setName(paramap.get("name"));
            tran.setExpectedDate(paramap.get("expectedDate"));
            tran.setCustomerId(ct.getId());
            tran.setStage(paramap.get("stage"));
            String actId=paramap.get("activityId");
            tran.setSource(actDao.getActNameById(actId));
            tran.setActivityId(actId);
            tran.setContactsId(ct.getId());
            tran.setCreateBy(u.getName());
            tran.setCreateTime(DateTimeUtil.getSysTime());
            tranDao.saveTran(tran);

            TranHistory th = new TranHistory();
            th.setId(UUIDUtil.getUUID());
            th.setCreateBy(u.getName());
            th.setCreateTime(DateTimeUtil.getSysTime());
            th.setExpectedDate(paramap.get("expectedDate"));
            th.setMoney(paramap.get("money"));
            th.setStage(paramap.get("stage"));
            th.setTranId(tran.getId());
            tranHistoryDao.saveTranHistory(th);

        }

        //5.删除线索活动中间表中的内容
        clueActivityRelationDao.deleteRelationByClueId(c.getId());
        //6.删除线索备注
        clueRemarkDao.deleteClueRemarksByClueId(c.getId());
        //7.删除线索
        clueDao.deleteClueById(c.getId());
    }
}
