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
}