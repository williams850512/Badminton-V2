package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.badminton.model.TimeSlotsBean;

public class TimeSlotsDAOImpl implements TimeSlotsDAO{

	@Override
	public List<TimeSlotsBean> getAll() {
		
		List<TimeSlotsBean> list = new ArrayList<>();
		String sql = "SELECT * FROM TimeSlots";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource) context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			while(rs.next()) {
				TimeSlotsBean slot = new TimeSlotsBean();
				
				slot.setSlotId(rs.getInt("slot_id"));
				slot.setStartTime(rs.getTime("start_time"));
				slot.setEndTime(rs.getTime("end_time"));
				slot.setLabel(rs.getString("label"));
				
				list.add(slot);
			}
			
		} catch (NamingException | SQLException e) {
			
			e.printStackTrace();
		}finally {
			if (rs != null) { try {rs.close();} catch (SQLException e) {e.printStackTrace();}}
			if (stmt != null) { try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if (conn != null) { try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } }
		}
		
		return list;
	}

}
