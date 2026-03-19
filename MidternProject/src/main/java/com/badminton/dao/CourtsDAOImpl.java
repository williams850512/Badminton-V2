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



import com.badminton.model.CourtsBean;

public class CourtsDAOImpl implements CourtsDAO{

	@Override
	public int insert(CourtsBean court) {
		int result = 0;// 用來記錄成功新增了幾筆資料
		String sql = "INSERT INTO Courts(venue_id, court_name) VALUES(?,?)";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, court.getVenueId());
			stmt.setString(2, court.getCourtName());
			
			
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
	public int update(CourtsBean court) {
		int result = 0 ;
		String sql = "UPDATE Courts SET venue_id = ?, court_name = ?, is_active = ? WHERE court_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1,court.getVenueId());
			stmt.setString(2,court.getCourtName());
			stmt.setBoolean(3,court.getIsActive() != null ? court.getIsActive() : true);
			stmt.setInt(4,court.getCourtId());
			
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
	public List<CourtsBean> findByVenueId(Integer venueId) {
		List<CourtsBean> list = new ArrayList<CourtsBean>();
		String sql = "SELECT * FROM Courts WHERE venue_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds =(DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1,venueId);
			
			rs = stmt.executeQuery();
			
			while(rs.next()) {
				CourtsBean court = new CourtsBean();
				
				court.setCourtId(rs.getInt("court_id"));//要跟SQL欄位名稱一模一樣
				court.setVenueId(rs.getInt("venue_id"));
				court.setCourtName(rs.getString("court_name"));
				court.setIsActive(rs.getBoolean("is_active"));
				
				list.add(court);
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
		
		return list;
	}

	@Override
	public CourtsBean findById(Integer courtId) {
		CourtsBean court = null;
		String sql = "SELECT * FROM Courts WHERE court_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1,courtId);
			
			rs = stmt.executeQuery();
			
			if(rs.next()) {
				court = new CourtsBean();
				
				court.setCourtId(rs.getInt("court_id"));
				court.setVenueId(rs.getInt("venue_id"));
				court.setCourtName(rs.getString("court_name"));
				court.setIsActive(rs.getBoolean("is_active"));
				
				
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
		return court;
	}

	@Override
	public List<CourtsBean> getAll() {
		
		List<CourtsBean> list = new ArrayList<CourtsBean>();
		String sql = "SELECT * FROM Courts";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds  = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			while(rs.next()) {
				CourtsBean court = new CourtsBean();
				
				court.setCourtId(rs.getInt("court_id"));//要跟SQL欄位名稱一模一樣
				court.setVenueId(rs.getInt("venue_id"));
				court.setCourtName(rs.getString("court_name"));
				court.setIsActive(rs.getBoolean("is_active"));
				
				list.add(court);
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
		return list;
	}
	

}
