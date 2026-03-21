package com.badminton.service;

import java.util.List;
import com.badminton.dao.MembersDAO;
import com.badminton.model.MembersBean;

public class MembersService {
    private MembersDAO dao = new MembersDAO();

    // 1. 會員登入
    public MembersBean login(String username, String password) {
        return dao.login(username, password);
    }

    // 2. 會員註冊 (管理員新增會員也可共用此邏輯)
    public boolean register(MembersBean m) {
        return dao.register(m);
    }

    // 3. 取得單一會員資料 (用於 Profile 顯示或 Edit 回填)
    public MembersBean getMemberById(int id) {
        return dao.getMemberById(id);
    }

    // 4. 取得所有會員清單 (管理員 Dashboard 用)
    public List<MembersBean> getAllMembers() {
        return dao.getAllMembers();
    }

    // 🔴 5. 搜尋會員 (新增：支援管理員關鍵字查詢)
    public List<MembersBean> searchMembers(String keyword) {
        return dao.searchMembers(keyword);
    }

    // 6. 修改個人資料 (專供 MembersServlet 呼叫)
    public boolean updateProfile(MembersBean m) {
        // 直接調用底層更新邏輯
        return dao.updateMember(m);
    }

    // 7. 管理員修改會員 (專供 MembersAdminServlet 呼叫)
    public boolean updateMember(MembersBean m) {
        // 指向同一個 DAO 方法，確保兩邊 Servlet 都不會紅叉
        return dao.updateMember(m);
    }

    // 8. 刪除會員
    public boolean deleteMember(int id) {
        return dao.deleteMember(id);
    }
}