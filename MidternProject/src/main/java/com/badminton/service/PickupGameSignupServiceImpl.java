package com.badminton.service;

import java.util.List;
import com.badminton.dao.PickupGameSignupDAO;
import com.badminton.dao.PickupGameSignupDAOImpl;
import com.badminton.model.PickupGameSignupBean;

public class PickupGameSignupServiceImpl implements PickupGameSignupService {

    private PickupGameSignupDAO signupDAO = new PickupGameSignupDAOImpl();

    // --- 1. 隨喜參加 (球友報名) ---
    @Override
    public String registerString(Integer gameId, Integer memberId) {
        if(signupDAO.isAlreadySignedUp(gameId, memberId)) {
            return "您已經報名過囉。";
        }
        
        PickupGameSignupBean bean = new PickupGameSignupBean();
        bean.setGameId(gameId);
        bean.setMemberId(memberId);
        bean.setStatus("joined"); // 直接設定為加入成功
        
        boolean success = signupDAO.insert(bean);
        return success ? "報名成功！" : "報名失敗，請稍後再試。";
    }

    // --- 2. 見證名單 (查看清單) ---
    @Override
    public List<PickupGameSignupBean> getSignupListByGame(Integer gameId, boolean isNewestFirst) {
        return signupDAO.findByGameId(gameId, isNewestFirst);
    }

    // --- 3. 發起揪團 (主揪專用：新增活動並自動加入) ---
    @Override
    public boolean createAndJoin(int hostId, int courtId, String gameDate, String startTime, String endTime, int maxPlayers) {
        try {
            // A. 第一步：先去 PickupGame 表新增一筆活動 (這部分通常會呼叫另一個 DAO)
            // 這裡我們先模擬邏輯：
            // int newGameId = gameDAO.insertAndReturnId(hostId, courtId, gameDate...);
            
            // B. 第二步：拿到新活動 ID 後，自動幫主揪報名
            // PickupGameSignupBean hostSignup = new PickupGameSignupBean();
            // hostSignup.setGameId(newGameId);
            // hostSignup.setMemberId(hostId);
            // hostSignup.setStatus("joined");
            // signupDAO.insert(hostSignup);
            
            System.out.println("主揪 ID " + hostId + " 正在發起 " + gameDate + " 的揪團...");
            return true; 
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
