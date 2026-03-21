package com.badminton.service;

import java.util.List;
import com.badminton.dao.MembersAdminDAO;
import com.badminton.model.MembersAdminBean;

public class MembersAdminService {
    
    private MembersAdminDAO adminDAO = new MembersAdminDAO();

    /**
     * 管理員登入
     * 已在 DAO 層加入 COLLATE 強制區分大小寫
     */
    public MembersAdminBean login(String username, String password) {
        if (username == null || password == null) return null;
        return adminDAO.login(username, password);
    }

    /**
     * 檢查管理員帳號是否重複 (不區分大小寫)
     */
    public boolean isAdminExists(String username) {
        if (username == null || username.trim().isEmpty()) return false;
        return adminDAO.isAdminExists(username.trim());
    }

    /**
     * 取得所有管理員清單
     */
    public List<MembersAdminBean> getAllAdmins() {
        return adminDAO.getAllAdmins();
    }

    /**
     * 根據 ID 取得特定管理員資料
     */
    public MembersAdminBean getAdminById(int id) {
        return adminDAO.getAdminById(id);
    }

    /**
     * 新增管理員
     * 🛡️ 加入安全檢查：若帳號已存在則拒絕新增
     */
    public boolean addAdmin(MembersAdminBean admin) {
        if (admin == null || admin.getUsername() == null) return false;
        
        // 1. 先檢查帳號是否已經被註冊 (不分大小寫)
        if (isAdminExists(admin.getUsername())) {
            System.out.println("新增失敗：帳號 [" + admin.getUsername() + "] 已存在。");
            return false;
        }
        
        // 2. 帳號可用，執行新增
        return adminDAO.addAdmin(admin);
    }

    /**
     * 更新管理員資料
     */
    public boolean updateAdmin(MembersAdminBean admin) {
        if (admin == null) return false;
        return adminDAO.updateAdmin(admin);
    }

    /**
     * 更新管理員備註
     */
    public boolean updateAdminNote(int id, String note) {
        String safeNote = (note == null) ? "" : note;
        return adminDAO.updateAdminNote(id, safeNote);
    }

    /**
     * 根據關鍵字搜尋管理員
     */
    public List<MembersAdminBean> searchAdmins(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return adminDAO.getAllAdmins();
        }
        return adminDAO.searchAdmins(keyword.trim());
    }

    /**
     * 刪除管理員
     */
    public boolean deleteAdmin(int id) {
        return adminDAO.deleteAdmin(id);
    }
}