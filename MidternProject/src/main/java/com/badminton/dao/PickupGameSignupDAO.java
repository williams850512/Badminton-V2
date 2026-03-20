package com.badminton.dao;

import java.util.List;
import com.badminton.model.PickupGameBean;
import com.badminton.model.PickupGameSignupBean;

public interface PickupGameSignupDAO {
    // 新增：取得所有開放場次
    List<PickupGameBean> findAllOpenGames();
    
    // 取得最新一場 ID
    Integer getLatestGameId();

    // 既有功能
    int insertNewGame(int hostId, int courtId, String gameDate, String startTime, String endTime, int maxPlayers);
    boolean insert(PickupGameSignupBean signup);
    List<PickupGameSignupBean> findByGameId(Integer gameId, boolean isNewestFirst);
    boolean isAlreadySignedUp(Integer gameId, Integer memberId);

    // 新增：場地時段衝突檢查（同場地同時段不能重複開團）
    boolean isCourtTimeConflict(int courtId, String gameDate, String startTime, String endTime);

    // 新增：會員時間衝突檢查（加入團時）
    boolean hasMemberTimeConflict(int memberId, int gameId);

    // 新增：檢查會員在特定時段是否已有活動（發起揪團時使用）
    boolean hasTimeConflict(int memberId, String gameDate, String startTime, String endTime);

    // 新增：移除報名（主揪踢人用）
    boolean removeSignup(int gameId, int memberId);

    // 新增：主揪取消開團
    boolean cancelGame(int gameId);

    // 新增：成員退出
    boolean withdrawSignup(int gameId, int memberId);
}