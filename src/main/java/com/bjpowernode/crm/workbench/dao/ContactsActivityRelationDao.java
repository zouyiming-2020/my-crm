package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationDao {
    void saveContactsActivityRelations(List<ContactsActivityRelation> contactsActivityRelationList);
}
