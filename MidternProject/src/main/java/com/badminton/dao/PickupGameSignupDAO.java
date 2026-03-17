package com.badminton.dao;

import java.util.List;

import com.badminton.model.PickupGameSignupBean;

public interface PickupGameSignupDAO {
    
    // 1. 建立報名紀錄：當使用者按下「我要報名」時呼叫
    boolean insert(PickupGameSignupBean signup);
    
    // 2. 查詢單場活動的所有報名者：讓主辦人看誰來參加了
    List<PickupGameSignupBean> findByGameId(Integer gameId);
    
    // 3. 查詢某位會員的所有報名紀錄：讓會員在「我的活動」頁面查看
    List<PickupGameSignupBean> findByMemberId(Integer memberId);
    
    // 4. 更新報名狀態：例如從「已報名」改為「取消」或「已報到」
    boolean updateStatus(Integer signupId, String status);
    
    // 5. 刪除報名：撤銷報名資訊
    boolean delete(Integer signupId);
    // 檢查某人是否已經報過這場球了 (對應 SQL 的 UNIQUE 約束)
    boolean isAlreadySignedUp(Integer gameId, Integer memberId);
}