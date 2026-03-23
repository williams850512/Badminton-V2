package com.badminton.service;

import java.util.List;
import com.badminton.dao.PickupGameDAO;
import com.badminton.dao.PickupGameDAOImpl;
import com.badminton.dao.PickupGameSignupDAO;
import com.badminton.dao.PickupGameSignupDAOImpl;
import com.badminton.dao.SystemOptionDAO;
import com.badminton.dao.SystemOptionDAOImpl;
import com.badminton.model.CourtBean;
import com.badminton.model.PickupGameBean;
import com.badminton.model.PickupGameSignupBean;
import com.badminton.model.TimeSlotBean;

public class PickupGameSignupServiceImpl implements PickupGameSignupService {
    private PickupGameSignupDAO signupDAO = new PickupGameSignupDAOImpl();
    private PickupGameDAO gameDAO = new PickupGameDAOImpl();
    private SystemOptionDAO systemOptionDAO = new SystemOptionDAOImpl();

    @Override
    public List<PickupGameBean> getAllOpenGames() {
        return signupDAO.findAllOpenGames();
    }

    @Override
    public List<PickupGameBean> getAllGames() {
        return gameDAO.getAll();
    }

    @Override
    public Integer getLatestGameId() {
        return signupDAO.getLatestGameId();
    }

    @Override
    public String registerString(Integer gameId, Integer memberId) {
        if(signupDAO.isAlreadySignedUp(gameId, memberId)) return "您已經報名過囉。";
        // 檢查該會員在同一時段是否已經有其他場次
        if(signupDAO.hasMemberTimeConflict(memberId, gameId)) return "該時段您已有其他場次，無法重複報名。";
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
        // 檢查同場地同時段是否已有團
        if (signupDAO.isCourtTimeConflict(courtId, gameDate, startTime, endTime)) {
            return false;
        }
        
        // 檢查該主揪在同時段是否已經有開團或參加其他團 (防止影分身)
        if (signupDAO.hasTimeConflict(hostId, gameDate, startTime, endTime)) {
            return false;
        }
        int newGameId = signupDAO.insertNewGame(hostId, courtId, gameDate, startTime, endTime, maxPlayers);
        if (newGameId > 0) {
            PickupGameSignupBean hostSignup = new PickupGameSignupBean();
            hostSignup.setGameId(newGameId);
            hostSignup.setMemberId(hostId);
            hostSignup.setStatus("host");
            return signupDAO.insert(hostSignup);
        }
        return false;
    }

    @Override
    public List<CourtBean> getAllCourts() {
        return systemOptionDAO.getAllCourts();
    }

    @Override
    public List<TimeSlotBean> getAllTimeSlots() {
        return systemOptionDAO.getAllTimeSlots();
    }

    @Override
    public String kickMember(int gameId, int hostId, int targetMemberId) {
        // 確認操作者是主揪
        List<PickupGameSignupBean> list = signupDAO.findByGameId(gameId, false);
        boolean isHost = false;
        for (PickupGameSignupBean s : list) {
            if (s.getMemberId().equals(hostId) && "host".equals(s.getStatus())) {
                isHost = true;
                break;
            }
        }
        if (!isHost) return "您不是主揪，無法踢除成員。";
        return signupDAO.removeSignup(gameId, targetMemberId) ? "已將該成員移除。" : "移除失敗。";
    }

    @Override
    public String cancelGame(int gameId, int hostId) {
        // 驗證是主揪
        List<PickupGameSignupBean> list = signupDAO.findByGameId(gameId, false);
        boolean isHost = false;
        for (PickupGameSignupBean s : list) {
            if (s.getMemberId().equals(hostId) && "host".equals(s.getStatus())) {
                isHost = true;
                break;
            }
        }
        if (!isHost) return "您不是主揪，無法取消。";
        return signupDAO.cancelGame(gameId) ? "已取消此揪團。" : "取消失敗。";
    }

    @Override
    public String withdrawFromGame(int gameId, int memberId) {
        return signupDAO.withdrawSignup(gameId, memberId) ? "已退出此場次。" : "退出失敗（您可能是主揪或尚未報名）。";
    }
}