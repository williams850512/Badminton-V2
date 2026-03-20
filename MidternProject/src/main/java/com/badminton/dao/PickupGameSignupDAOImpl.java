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
        // 修正 SQL：因為 Courts 沒有 display_name，所以我們直接 JOIN Venues 來串接完整場地名稱
        String sql = "SELECT g.*, v.venue_name + ' - ' + c.court_name AS court_display " +
                     "FROM BadmintonDB.dbo.PickupGames g " +
                     "JOIN BadmintonDB.dbo.Courts c ON g.court_id = c.court_id " +
                     "JOIN BadmintonDB.dbo.Venues v ON c.venue_id = v.venue_id " +
                     "WHERE g.status = 'open' ORDER BY g.game_date ASC";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql); 
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                PickupGameBean bean = new PickupGameBean();
                bean.setGameId(rs.getInt("game_id"));
                bean.setHostId(rs.getInt("host_id"));
                bean.setCourtId(rs.getInt("court_id"));
                bean.setCourtName(rs.getString("court_display"));
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

    // --- 2. 找某一場球賽的「報名名單」 (JOIN 會員姓名+電話，用 host_id 判斷角色) ---
    @Override
    public List<PickupGameSignupBean> findByGameId(Integer gameId, boolean isNewestFirst) {
        List<PickupGameSignupBean> list = new ArrayList<>();
        // JOIN Members 取得姓名和電話，JOIN PickupGames 取得 host_id 來判斷角色
        String sql = "SELECT s.*, m.name as member_name, m.phone as member_phone, g.host_id AS game_host_id " +
                     "FROM BadmintonDB.dbo.PickupGameSignups s " +
                     "JOIN BadmintonDB.dbo.Members m ON s.member_id = m.member_id " +
                     "JOIN BadmintonDB.dbo.PickupGames g ON s.game_id = g.game_id " +
                     "WHERE s.game_id = ? ORDER BY s.signed_up_at " + (isNewestFirst ? "DESC" : "ASC");

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    PickupGameSignupBean bean = new PickupGameSignupBean();
                    bean.setSignupId(rs.getInt("signup_id"));
                    bean.setGameId(rs.getInt("game_id"));
                    bean.setMemberId(rs.getInt("member_id"));
                    bean.setMemberName(rs.getString("member_name"));
                    bean.setMemberPhone(rs.getString("member_phone"));
                    
                    // 改用別名 game_host_id 確保能正確拿到值
                    int gameHostId = rs.getInt("game_host_id");
                    
                    // 用 member_id == gameHostId 判斷是否為「主揪」
                    if (rs.getInt("member_id") == gameHostId && gameHostId != 0) {
                        bean.setStatus("host");
                    } else {
                        // 回退到原本 DB 的 status，以免誤判
                        String dbStatus = rs.getString("status");
                        bean.setStatus(dbStatus != null && dbStatus.equals("host") ? "host" : "joined");
                    }
                    
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

    // --- 同場地同時段衝突檢查 ---
    @Override
    public boolean isCourtTimeConflict(int courtId, String gameDate, String startTime, String endTime) {
        // 使用 CAST 確保跨資料庫格式與時間處理都能正確進行比較（避免字串比較失敗）
        String sql = "SELECT 1 FROM BadmintonDB.dbo.PickupGames " +
                     "WHERE court_id = ? " +
                     "AND CAST(game_date AS DATE) = CAST(? AS DATE) " +
                     "AND status = 'open' " +
                     "AND CAST(start_time AS TIME) < CAST(? AS TIME) " +
                     "AND CAST(end_time AS TIME) > CAST(? AS TIME)";
                     
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, courtId);
            pstmt.setString(2, gameDate);
            
            // 將 HH:MM 補齊為 HH:MM:00 確保能轉換為 TIME
            String safeEndTime = endTime.length() == 5 ? endTime + ":00" : endTime;
            String safeStartTime = startTime.length() == 5 ? startTime + ":00" : startTime;
            
            pstmt.setString(3, safeEndTime);
            pstmt.setString(4, safeStartTime);
            
            try (ResultSet rs = pstmt.executeQuery()) { 
                return rs.next(); 
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // --- 會員時間衝突檢查（加入團時）---
    @Override
    public boolean hasMemberTimeConflict(int memberId, int gameId) {
        // 先查出目標場次的日期與時間，再查該會員是否在同日期有時間重疊的其他場次
        String sql = "SELECT 1 FROM BadmintonDB.dbo.PickupGameSignups s " +
                     "JOIN BadmintonDB.dbo.PickupGames g ON s.game_id = g.game_id " +
                     "WHERE s.member_id = ? AND s.game_id != ? AND g.status = 'open' " +
                     "AND g.game_date = (SELECT game_date FROM BadmintonDB.dbo.PickupGames WHERE game_id = ?) " +
                     "AND g.start_time < (SELECT end_time FROM BadmintonDB.dbo.PickupGames WHERE game_id = ?) " +
                     "AND g.end_time > (SELECT start_time FROM BadmintonDB.dbo.PickupGames WHERE game_id = ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, gameId);
            pstmt.setInt(3, gameId);
            pstmt.setInt(4, gameId);
            pstmt.setInt(5, gameId);
            try (ResultSet rs = pstmt.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // --- 檢查會員在特定時段是否已有活動（發起揪團時使用）---
    @Override
    public boolean hasTimeConflict(int memberId, String gameDate, String startTime, String endTime) {
        // 強化檢查：直接檢查 PickupGames 表的 host_id，或是 Signup 表中的 member_id
        String sql = "SELECT 1 FROM BadmintonDB.dbo.PickupGames g " +
                     "WHERE (g.host_id = ? OR EXISTS (" +
                     "    SELECT 1 FROM BadmintonDB.dbo.PickupGameSignups s " +
                     "    WHERE s.game_id = g.game_id AND s.member_id = ?" +
                     ")) " +
                     "AND g.status = 'open' " +
                     "AND CAST(g.game_date AS DATE) = CAST(? AS DATE) " +
                     "AND CAST(g.start_time AS TIME) < CAST(? AS TIME) " +
                     "AND CAST(g.end_time AS TIME) > CAST(? AS TIME)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, memberId);
            pstmt.setString(3, gameDate);
            String safeEndTime = endTime.length() == 5 ? endTime + ":00" : endTime;
            String safeStartTime = startTime.length() == 5 ? startTime + ":00" : startTime;
            pstmt.setString(4, safeEndTime);
            pstmt.setString(5, safeStartTime);
            try (ResultSet rs = pstmt.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // --- 移除報名（主揪踢人）---
    @Override
    public boolean removeSignup(int gameId, int memberId) {
        String sql = "DELETE FROM BadmintonDB.dbo.PickupGameSignups WHERE game_id = ? AND member_id = ? AND status != 'host'";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            pstmt.setInt(2, memberId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // --- 主揪取消開團 ---
    @Override
    public boolean cancelGame(int gameId) {
        String sql = "UPDATE BadmintonDB.dbo.PickupGames SET status = 'cancelled' WHERE game_id = ? AND status = 'open'";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // --- 成員退出 ---
    @Override
    public boolean withdrawSignup(int gameId, int memberId) {
        // 只能退出 status='joined' 的報名（主揪不能退出，只能取消）
        String sql = "DELETE FROM BadmintonDB.dbo.PickupGameSignups WHERE game_id = ? AND member_id = ? AND status = 'joined'";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            pstmt.setInt(2, memberId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}