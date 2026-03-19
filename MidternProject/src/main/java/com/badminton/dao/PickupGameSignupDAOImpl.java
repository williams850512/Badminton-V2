package com.badminton.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.badminton.model.PickupGameSignupBean;

public class PickupGameSignupDAOImpl implements PickupGameSignupDAO {

	// 取得連線 (從 db.properties 外部檔案讀取)
    public Connection getConnection() throws Exception {
        java.util.Properties props = new java.util.Properties();
        
        // 1. 使用 ClassLoader 讀取 ClassPath 下的 db.properties
        try (java.io.InputStream in = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                // 如果找不到檔案，會噴出警告。這叫「隨時覺察」
                throw new RuntimeException("找不到 db.properties！請確認檔案放在 src/main/resources 裡。");
            }
            props.load(in);
        }

        // 2. 加載驅動並從 props 中取出資料
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String pass = props.getProperty("db.password");

        // 3. 正式與資料庫感應連線
        return DriverManager.getConnection(url, user, pass);
    }

	// 報名活動
	@Override
	public boolean insert(PickupGameSignupBean signup) {
		String sql = "INSERT INTO BadmintonDB.dbo.PickupGameSignups (game_id, member_id, status, signed_up_at)"
				+ " VALUES (?, ?, ?, ?)";
		try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, signup.getGameId());
			pstmt.setInt(2, signup.getMemberId());
			pstmt.setString(3, signup.getStatus());
			pstmt.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));

			int count = pstmt.executeUpdate();
			return count > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

	}

	// 查詢某場活動的所有報名者(主辦人)
	@Override
	public List<PickupGameSignupBean> findByGameId(Integer gameId, boolean isNewestFirst) {
		List<PickupGameSignupBean> list = new ArrayList<>(); // 加上泛型 <> 比較嚴謹

		// 1. 決定排序邏輯：最新報名的在上面
		String sortOrder = isNewestFirst ? "DESC" : "ASC";

		String sql = "SELECT * FROM BadmintonDB.dbo.PickupGameSignups WHERE game_id = ?" + " ORDER BY signed_up_at "
				+ sortOrder;
		try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, gameId);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					PickupGameSignupBean bean = new PickupGameSignupBean();

					bean.setSignupId(rs.getInt("signup_id"));
					bean.setGameId(rs.getInt("game_id"));
					bean.setMemberId(rs.getInt("member_id"));
					bean.setSignedUpAt(rs.getTimestamp("signed_up_at"));
					bean.setStatus(rs.getString("status"));

					list.add(bean);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 3. 查詢某位會員的所有報名紀錄：讓會員在「我的活動」頁面查看
	@Override
	public List<PickupGameSignupBean> findByMemberId(Integer memberId, boolean isNewestFirst) {
		List<PickupGameSignupBean> list = new ArrayList<>();

		// 根據參數決定排序：通常會員想看最新的活動，所以預設可以用 DESC
		String sortOrder = isNewestFirst ? "DESC" : "ASC";

		// SQL 語法：對應您的資料庫欄位 member_id 與 signed_up_at
		String sql = "SELECT * FROM BadmintonDB.dbo.PickupGameSignups WHERE member_id = ? " + "ORDER BY signed_up_at "
				+ sortOrder;

		try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			// 將會員 ID 塞進問號中
			pstmt.setInt(1, memberId);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {

					PickupGameSignupBean bean = new PickupGameSignupBean();

					bean.setSignupId(rs.getInt("signup_id"));
					bean.setGameId(rs.getInt("game_id"));
					bean.setMemberId(rs.getInt("member_id"));
					bean.setSignedUpAt(rs.getTimestamp("signed_up_at"));
					bean.setStatus(rs.getString("status"));

					list.add(bean);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// 狀態變更
	@Override
	public boolean updateStatus(Integer signupId, String status) {
		// 1. SQL 語法：根據唯一的 signup_id 來精準修改 status
		String sql = "UPDATE BadmintonDB.dbo.PickupGameSignups " + "SET status = ? WHERE signup_id = ?";

		try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			// 2. 填入參數 (注意順序：第一個問號是 status，第二個是 ID)
			pstmt.setString(1, status); // 要改成的狀態 (例如 "cancelled")
			pstmt.setInt(2, signupId); // 哪一筆報名資料

			// 3. 執行更新
			int count = pstmt.executeUpdate();

			// 4. 如果影響的筆數大於 0，代表修改成功
			return count > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 防止同一場活動重復報名
	@Override
	public boolean isAlreadySignedUp(Integer gameId, Integer memberId) {
		boolean exists = false;

		// 使用完全限定名，確保 sa 帳號能精準找到表
		String sql = "SELECT * FROM BadmintonDB.dbo.PickupGameSignups " + "WHERE game_id = ? AND member_id = ?";

		try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, gameId);
			pstmt.setInt(2, memberId);

			try (ResultSet rs = pstmt.executeQuery()) {
				// 只要 rs.next() 為 true，就代表資料庫裡已經存在這筆「因果」了
				exists = rs.next();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return exists;
	}
}