package com.badminton.service;

import java.util.List;

import com.badminton.dao.AnnouncementDao;
import com.badminton.model.AnnouncementBean;

public class AnnouncementService {

    // 宣告一個 DAO 物件，讓 Service 可以指派任務給 DAO
    private AnnouncementDao dao;

    // 建構子
    public AnnouncementService() {
        this.dao = new AnnouncementDao();
    }

    // 新增
    public boolean addAnnouncement(AnnouncementBean bean) {
        // 確保標題和內容不是空白的，才允許呼叫 DAO 存入資料庫
        if (bean.getTitle() == null || bean.getTitle().trim().isEmpty()) {
            System.out.println("新增失敗：公告標題不能為空白！");
            return false;
        }
        if (bean.getContent() == null || bean.getContent().trim().isEmpty()) {
            System.out.println("新增失敗：公告內容不能為空白！");
            return false;
        }
        
        // 驗證通過，交給 DAO 執行 Insert
        return dao.addAnnouncement(bean);
    }

    // 查詢所有
    public List<AnnouncementBean> getAllAnnouncements() {
        // 這裡目前沒有特別的邏輯，直接跟 DAO 拿資料回傳即可
        return dao.getAllAnnouncements();
    }

    // 查詢單筆
    public AnnouncementBean getAnnouncementById(int id) {
        if (id <= 0) {
            System.out.println("查詢失敗：不合法的公告 ID！");
            return null;
        }
        return dao.getAnnouncementById(id);
    }
    
    // 搜尋框的查詢功能
    public List<AnnouncementBean> searchAnnouncements(String keyword) {
        // 如果沒打字就按搜尋，就直接回傳全部資料
        if (keyword == null || keyword.trim().isEmpty()) {
            return dao.getAllAnnouncements();
        }
        return dao.searchAnnouncements(keyword);
    }

    // 修改 (加入邏輯驗證)
    public boolean updateAnnouncement(AnnouncementBean bean) {
        // 修改時，一樣要確保必填欄位有值，且 ID 必須存在
        if (bean.getAnnouncementId() == null || bean.getAnnouncementId() <= 0) {
            System.out.println("修改失敗：找不到公告 ID！");
            return false;
        }
        if (bean.getTitle() == null || bean.getTitle().trim().isEmpty()) {
            System.out.println("修改失敗：公告標題不能為空！");
            return false;
        }
        
        return dao.updateAnnouncement(bean);
    }

    // 刪除
    public boolean deleteAnnouncement(int id) {
        if (id <= 0) {
            System.out.println("刪除失敗：不合法的公告 ID！");
            return false;
        }
        return dao.deleteAnnouncement(id);
    }
}