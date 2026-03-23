package com.badminton.service;

import java.util.List;
import com.badminton.dao.MembersDAO;
import com.badminton.model.MembersBean;

public class MembersService {
    private MembersDAO dao = new MembersDAO();

    /**
     * 1. 會員登入
     * DAO 已處理 COLLATE，登入時帳號密碼皆需完全符合大小寫
     */
    public MembersBean login(String username, String password) {
        if (username == null || password == null) return null;
        return dao.login(username, password);
    }

    /**
     * ✨ 2. 會員註冊 / 新增會員
     * 🛡️ 加入安全檢查：若帳號已存在 (不分大小寫) 則拒絕新增
     */
    public boolean register(MembersBean m) {
        if (m == null || m.getUsername() == null) return false;

        // 檢查帳號是否已經被使用 (不論大小寫組合)
        if (isUsernameExists(m.getUsername())) {
            System.err.println("註冊失敗：帳號 [" + m.getUsername() + "] 已被佔用。");
            return false;
        }

        return dao.register(m);
    }

    /**
     * ✨ 新增：檢查會員帳號是否存在
     */
    public boolean isUsernameExists(String username) {
        if (username == null || username.trim().isEmpty()) return false;
        return dao.isUsernameExists(username.trim());
    }

    /**
     * 3. 根據 ID 取得單一會員資料
     */
    public MembersBean getMemberById(int id) {
        return dao.getMemberById(id);
    }

    /**
     * 4. 取得所有會員清單
     */
    public List<MembersBean> getAllMembers() {
        return dao.getAllMembers();
    }

    /**
     * 5. 搜尋會員 (支援關鍵字查詢)
     */
    public List<MembersBean> searchMembers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return dao.getAllMembers();
        }
        return dao.searchMembers(keyword.trim());
    }

    /**
     * 6. 修改個人資料
     */
    public boolean updateProfile(MembersBean m) {
        if (m == null) return false;
        return dao.updateMember(m);
    }

    /**
     * 7. 管理員修改會員
     */
    public boolean updateMember(MembersBean m) {
        if (m == null) return false;
        return dao.updateMember(m);
    }

    /**
     * 8. 專門更新會員備註 (快速更新功能)
     */
    public boolean updateNote(int id, String note) {
        String safeNote = (note == null) ? "" : note;
        return dao.updateNote(id, safeNote);
    }

    /**
     * 9. 刪除會員
     */
    public boolean deleteMember(int id) {
        return dao.deleteMember(id);
    }
}