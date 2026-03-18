package com.badminton.service;

import java.util.List;
import com.badminton.dao.MembersDAO;
import com.badminton.model.MembersBean;

public class MembersService {
    private MembersDAO dao = new MembersDAO();

    /**
     * 註冊新會員
     * 接收包含性別、生日的 Bean 並存入資料庫
     */
    public boolean register(MembersBean m) {
        // 這裡可以加入邏輯，例如：檢查帳號是否重複、密碼長度等
        return dao.register(m);
    }

    /**
     * 登入驗證
     * 登入成功後回傳的 Bean 會包含 gender 與 birthday 欄位
     */
    public MembersBean login(String username, String password) {
        return dao.login(username, password);
    }

    /**
     * 修改個人資料或管理員修改會員等級
     * 支援更新姓名、電話、信箱、性別、生日與角色
     */
    public boolean updateProfile(MembersBean m) {
        // 未來若要加入「信箱格式檢查」或「防呆機制」可寫在這裡
        return dao.updateProfile(m);
    }

    /**
     * 刪除會員（僅限管理員調用）
     */
    public boolean deleteMember(int id) {
        return dao.deleteMember(id);
    }

    /**
     * 取得單一會員資料（用於編輯頁面回填）
     */
    public MembersBean getMemberById(int id) {
        return dao.getMemberById(id);
    }

    /**
     * 取得所有會員清單（用於管理後台）
     */
    public List<MembersBean> getAllMembers() {
        return dao.getAllMembers();
    }
}