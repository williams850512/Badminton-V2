package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.badminton.model.PickupGameSignupBean;

public class PickupGameSignupDAOImpl implements PickupGameSignupDAO {
	
	//取得連線
	private Connection getConnection()throws Exception{
		InitialContext ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/BadmintonDB");
		return ds.getConnection();
	}
	//報名活動
	@Override
	public boolean insert(PickupGameSignupBean signup) {
		String sql="INSERT INTO PickupGameSignups (game_id, user_id, signup_time, status) "
				+ "VALUES (?, ?, NOW(), ?)";
		try (Connection con = getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setInt(1, signup.getGameId());
            pstmt.setInt(2, signup.getUserId());
            pstmt.setString(3, signup.getStatus()); 
            
            int count = pstmt.executeUpdate();
            return count >0;
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
	}
	//查詢某場活動的所有報名者 
	@Override
	public List<PickupGameSignupBean> findByGameId(Integer gameId) {
		List<PickupGameSignupBean> list = new ArrayList();
		String sql = "SELECT * FROM PickupGameSignup WHERE game_id = ?"
				+ " ORDER BY signup_time ASC";
		return null;
	}

	@Override
	public List<PickupGameSignupBean> findByMemberId(Integer memberId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean updateStatus(Integer signupId, String status) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(Integer signupId) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isAlreadySignedUp(Integer gameId, Integer memberId) {
		// TODO Auto-generated method stub
		return false;
	}
	
}
