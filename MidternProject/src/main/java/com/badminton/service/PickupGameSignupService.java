package com.badminton.service;

import java.util.List;

import com.badminton.model.PickupGameSignupBean;

public interface PickupGameSignupService {
	String registerString(Integer gameId,Integer memberId);
	List<PickupGameSignupBean>getSignupListByGame(Integer gameId,boolean isNewestFirst);
	boolean createAndJoin(int hostId, int courtId, String gameDate, String startTime, String endTime, int maxPlayers);
	
}
