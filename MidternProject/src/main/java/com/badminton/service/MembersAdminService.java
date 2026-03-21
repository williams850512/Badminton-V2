package com.badminton.service;

import java.util.List;
import com.badminton.dao.MembersAdminDAO;
import com.badminton.model.MembersAdminBean;

public class MembersAdminService {
    
    private MembersAdminDAO adminDAO = new MembersAdminDAO();

    // 管理員登入
    public MembersAdminBean login(String username, String password) {
        return adminDAO.login(username, password);
    }

    // 取得所有管理員清單
    public List<MembersAdminBean> getAllAdmins() {
        return adminDAO.getAllAdmins();
    }

    // 🔴 補上：根據 ID 取得特定管理員資料 (用於編輯頁面)
    public MembersAdminBean getAdminById(int id) {
        return adminDAO.getAdminById(id);
    }

    // 🔴 補上：新增管理員
    public boolean addAdmin(MembersAdminBean admin) {
        return adminDAO.addAdmin(admin);
    }

    // 🔴 補上：更新管理員資料
    public boolean updateAdmin(MembersAdminBean admin) {
        return adminDAO.updateAdmin(admin);
    }
}