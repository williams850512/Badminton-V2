package com.badminton.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.badminton.model.PickupGameBean;
import com.badminton.model.PickupGameSignupBean;

public class PickupGameSignupDAOImpl implements PickupGameSignupDAO {

    public Connection getConnection() throws Exception {
        javax.naming.Context ctx = new javax.naming.InitialContext();
        javax.sql.DataSource ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/BadmintonDB");
        return ds.getConnection();
    }

    // --- 1. 找所有開放中的「場次」 (這是在查 PickupGames 資料表) ---
    @Override
    public List<PickupGameBean> findAllOpenGames() {
        List<PickupGameBean> list = new ArrayList<>();
        // 注意：這裡只找球賽，不涉及報名名單
        String sql = "SELECT * FROM BadmintonDB.dbo.PickupGames WHERE status = 'open' ORDER BY game_date ASC";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql); 
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                PickupGameBean bean = new PickupGameBean();
                bean.setGameId(rs.getInt("game_id"));
                bean.setHostId(rs.getInt("host_id"));
                bean.setCourtId(rs.getInt("court_id"));
                bean.setGameDate(rs.getDate("game_date"));
                bean.setStartTime(rs.getTime("start_time"));
                bean.setEndTime(rs.getTime("end_time"));
                bean.setMaxPlayers(rs.getInt("max_players"));
                bean.setCurrentPlayers(rs.getInt("current_players"));
                bean.setStatus(rs.getString("status"));
                list.add(bean);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // --- 2. 找某一場球賽的「報名名單」 (包含 JOIN 會員姓名，這才是妳要的功能) ---
    @Override
    public List<PickupGameSignupBean> findByGameId(Integer gameId, boolean isNewestFirst) {
        List<PickupGameSignupBean> list = new ArrayList<>();
        // 這裡使用 JOIN 才能抓到 member_name
        String sql = "SELECT s.*, m.name as member_name " +
                     "FROM BadmintonDB.dbo.PickupGameSignups s " +
                     "JOIN BadmintonDB.dbo.Members m ON s.member_id = m.member_id " +
                     "WHERE s.game_id = ? ORDER BY s.signed_up_at " + (isNewestFirst ? "DESC" : "ASC");

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    PickupGameSignupBean bean = new PickupGameSignupBean();
                    bean.setSignupId(rs.getInt("signup_id"));
                    bean.setGameId(rs.getInt("game_id"));
                    bean.setMemberId(rs.getInt("member_id"));
                    bean.setMemberName(rs.getString("member_name")); // 動態抓姓名
                    bean.setStatus(rs.getString("status"));
                    bean.setSignedUpAt(rs.getTimestamp("signed_up_at"));
                    list.add(bean);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Integer getLatestGameId() {
        String sql = "SELECT MAX(game_id) FROM BadmintonDB.dbo.PickupGames";
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public int insertNewGame(int hostId, int courtId, String gameDate, String startTime, String endTime, int maxPlayers) {
        String sql = "INSERT INTO BadmintonDB.dbo.PickupGames (host_id, court_id, game_date, start_time, end_time, max_players, current_players, status) VALUES (?, ?, ?, ?, ?, ?, 1, 'open')";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, hostId);
            pstmt.setInt(2, courtId);
            pstmt.setString(3, gameDate);
            pstmt.setString(4, startTime);
            pstmt.setString(5, endTime);
            pstmt.setInt(6, maxPlayers);
            if (pstmt.executeUpdate() > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    @Override
    public boolean insert(PickupGameSignupBean signup) {
        String sql = "INSERT INTO BadmintonDB.dbo.PickupGameSignups (game_id, member_id, status, signed_up_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, signup.getGameId());
            pstmt.setInt(2, signup.getMemberId());
            pstmt.setString(3, signup.getStatus());
            pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean isAlreadySignedUp(Integer gameId, Integer memberId) {
        String sql = "SELECT 1 FROM BadmintonDB.dbo.PickupGameSignups WHERE game_id = ? AND member_id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            pstmt.setInt(2, memberId);
            try (ResultSet rs = pstmt.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}