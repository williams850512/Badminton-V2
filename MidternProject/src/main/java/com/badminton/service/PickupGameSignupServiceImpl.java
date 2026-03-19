package com.badminton.service;

import java.util.List;
import com.badminton.dao.PickupGameSignupDAO;
import com.badminton.dao.PickupGameSignupDAOImpl;
import com.badminton.model.PickupGameBean;
import com.badminton.model.PickupGameSignupBean;

public class PickupGameSignupServiceImpl implements PickupGameSignupService {
    private PickupGameSignupDAO signupDAO = new PickupGameSignupDAOImpl();

    @Override
    public List<PickupGameBean> getAllOpenGames() {
        return signupDAO.findAllOpenGames();
    }

    @Override
    public Integer getLatestGameId() {
        return signupDAO.getLatestGameId();
    }

    @Override
    public String registerString(Integer gameId, Integer memberId) {
        if(signupDAO.isAlreadySignedUp(gameId, memberId)) return "您已經報名過囉。";
        PickupGameSignupBean bean = new PickupGameSignupBean();
        bean.setGameId(gameId);
        bean.setMemberId(memberId);
        bean.setStatus("joined");
        return signupDAO.insert(bean) ? "報名成功！" : "報名失敗。";
    }

    @Override
    public List<PickupGameSignupBean> getSignupListByGame(Integer gameId, boolean isNewestFirst) {
        return signupDAO.findByGameId(gameId, isNewestFirst);
    }

    @Override
    public boolean createAndJoin(int hostId, int courtId, String gameDate, String startTime, String endTime, int maxPlayers) {
        int newGameId = signupDAO.insertNewGame(hostId, courtId, gameDate, startTime, endTime, maxPlayers);
        if (newGameId > 0) {
            PickupGameSignupBean hostSignup = new PickupGameSignupBean();
            hostSignup.setGameId(newGameId);
            hostSignup.setMemberId(hostId);
            hostSignup.setStatus("joined");
            return signupDAO.insert(hostSignup);
        }
        return false;
    }
}