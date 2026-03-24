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



import com.badminton.model.VenuesBean;

public class VenuesDAOImpl implements VenuesDAO {
	
	@Override
	public List<VenuesBean> getAll(){
		
		List<VenuesBean> list = new ArrayList<>();
		String sql = "SELECT * FROM Venues";
		
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
				 VenuesBean venue = new VenuesBean();
				 
				 venue.setVenueId(rs.getInt("venue_id")); //要跟SQL欄位名稱一模一樣
				 venue.setVenueName(rs.getString("venue_name"));
				 venue.setAddress(rs.getString("address"));
				 venue.setPhone(rs.getString("phone"));
				 venue.setIsActive(rs.getBoolean("is_active"));
				 
				 list.add(venue);
				 
			 }
			 
			
		} catch (NamingException | SQLException e) {
			
			e.printStackTrace();
		}finally {
			if(rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				if(stmt != null) {
					try {
						stmt.close();
					} catch (SQLException e) {						
						e.printStackTrace();
					}
				}
				if(conn != null) {
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
		}
		return list;
	}

	@Override
	public int insert(VenuesBean venue) {
		int result = 0; // 用來記錄成功新增了幾筆資料
		String sql = "INSERT INTO Venues(venue_name, address, phone) VALUES(?,?,?)";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource) context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setString(1,venue.getVenueName());
			stmt.setString(2,venue.getAddress());
			stmt.setString(3,venue.getPhone());
			
			// 注意！執行 新增/修改/刪除 時，要用 executeUpdate() 而不是 executeQuery()
			result = stmt.executeUpdate();
			
		} catch (NamingException | SQLException e) {
			
			e.printStackTrace();
		}finally {
			if(stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					
					e.printStackTrace();
				}
			}
		}if(conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
		}
		
		return result;
	}

	@Override
	public int update(VenuesBean venue) {
		int result = 0;
		String sql = "UPDATE Venues SET venue_name = ?, address = ?, phone = ?, is_active = ? WHERE venue_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource) context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setString(1, venue.getVenueName());
			stmt.setString(2, venue.getAddress());
			stmt.setString(3, venue.getPhone());
			// 防護處理：避免傳入的 boolean 是 null 導致報錯
			stmt.setBoolean(4, venue.getIsActive() != null ? venue.getIsActive() : true);
			
			stmt.setInt(5, venue.getVenueId());
			
			 result = stmt.executeUpdate();
			
		} catch (NamingException | SQLException e) {
			
			e.printStackTrace();
		}finally {
			if (stmt != null) { try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if (conn != null) { try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } }
		}
		
		return result;
	}
		
		
		
		

	@Override
	public VenuesBean findById(Integer venuesId) {
		//將VenuesBean venue = new VenuesBean();拆兩段寫，防止有人打了不存在的ID會傳送一個空venue箱子
		VenuesBean venue = null;
		
		String sql = "SELECT * FROM Venues WHERE venue_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource) context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, venuesId);
			
			rs = stmt.executeQuery();
			
			// 因為主鍵查詢最多只會有一筆，所以不用 while 迴圈，用 if 判斷即可
			if(rs.next()) {
				venue = new VenuesBean();
				
				 venue.setVenueId(rs.getInt("venue_id"));
				 venue.setVenueName(rs.getString("venue_name"));
				 venue.setAddress(rs.getString("address"));
				 venue.setPhone(rs.getString("phone"));
				 venue.setIsActive(rs.getBoolean("is_active"));
			}
			
		} catch (NamingException | SQLException e) {
			
			e.printStackTrace();
		}finally {
			if(rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {e.printStackTrace();}
			}
		}if(stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
		}if(conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
		}
		
		return venue;
	}
	
	
}
