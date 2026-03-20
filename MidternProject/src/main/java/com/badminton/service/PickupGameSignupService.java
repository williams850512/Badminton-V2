package com.badminton.service;

import java.util.List;
import com.badminton.model.CourtBean;
import com.badminton.model.PickupGameBean;
import com.badminton.model.PickupGameSignupBean;
import com.badminton.model.TimeSlotBean;

public interface PickupGameSignupService {
    List<PickupGameBean> getAllOpenGames();
    Integer getLatestGameId();
    String registerString(Integer gameId, Integer memberId);
    List<PickupGameSignupBean> getSignupListByGame(Integer gameId, boolean isNewestFirst);
    boolean createAndJoin(int hostId, int courtId, String gameDate, String startTime, String endTime, int maxPlayers);
    List<CourtBean> getAllCourts();
    List<TimeSlotBean> getAllTimeSlots();
    String kickMember(int gameId, int hostId, int targetMemberId);
    String cancelGame(int gameId, int hostId);
    String withdrawFromGame(int gameId, int memberId);
}