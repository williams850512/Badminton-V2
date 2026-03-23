package com.badminton.dao;

import java.util.List;

import com.badminton.model.PickupGameBean;

public interface PickupGameDAO {
    
    // 1. 新增活動：傳入一個填好資料的 Bean，回傳是否成功
    boolean insert(PickupGameBean game);
    
    // 2. 查詢全部：回傳一個裝滿 Bean 的清單，供 JSP 顯示清單頁面
    List<PickupGameBean> getAll();
    
    // 3. 單筆查詢：根據 ID 抓取特定活動，供「活動詳情頁」使用
    PickupGameBean findById(Integer gameId);
    
    // 4. 修改活動：更新活動資訊
    boolean update(PickupGameBean game);
    
    // 5. 刪除活動：根據 ID 刪除（或改變 status 狀態）
    boolean delete(Integer gameId);
}