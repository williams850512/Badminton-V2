package com.badminton.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.badminton.model.BookingsBean;

public class BookingsDAOImpl implements BookingsDAO {

	@Override
	public int insert(BookingsBean booking) {
		int result = 0;// 用來記錄成功新增了幾筆資料
		String sql = "INSERT INTO Bookings(member_id, court_id, booking_date, start_time, end_time, total_amount, note) "
				+ "VALUES(?,?,?,?,?,?,?)";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, booking.getMemberId());
			stmt.setInt(2, booking.getCourtId());
			stmt.setDate(3, booking.getBookingDate());
			stmt.setTime(4, booking.getStartTime());
			stmt.setTime(5, booking.getEndTime());
			stmt.setBigDecimal(6, booking.getTotalAmount());
			stmt.setString(7, booking.getNote());
			
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
	public int updateStatus(int bookingId, String status) {
		int result = 0;
		String sql = "UPDATE Bookings SET status = ? WHERE booking_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setString(1, status);
			stmt.setInt(2, bookingId);
			
			result = stmt.executeUpdate();
			
		} catch (NamingException | SQLException e) {
			e.printStackTrace();
		} finally {
			if (stmt != null) {
				try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
			if (conn != null) {
				try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
		}
		
		return result;
	}

	@Override
	public List<BookingsBean> findByMemberId(int memberId) {
		List<BookingsBean> list = new ArrayList<>();
		String sql = "SELECT b.*, m.full_name AS member_name FROM Bookings b JOIN Members m ON b.member_id = m.member_id WHERE b.member_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds =(DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, memberId);
			
			rs = stmt.executeQuery();
			
			while(rs.next()) {
				BookingsBean booking = new BookingsBean();
				
				booking.setBookingId(rs.getInt("booking_id"));
				booking.setMemberId(rs.getInt("member_id"));
				booking.setCourtId(rs.getInt("court_id"));
				booking.setBookingDate(rs.getDate("booking_date"));
				booking.setStartTime(rs.getTime("start_time"));
				booking.setEndTime(rs.getTime("end_time"));
				booking.setStatus(rs.getString("status"));
				booking.setTotalAmount(rs.getBigDecimal("total_amount"));
				booking.setNote(rs.getString("note"));
				booking.setCreatedAt(rs.getTimestamp("created_at"));
				booking.setMemberName(rs.getString("member_name"));
				
				list.add(booking);
				
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
	public List<BookingsBean> findByCourtIdAndDate(int courtId, Date bookingDate) {
		List<BookingsBean> list = new ArrayList<>();
		// 找出該場地、該日期並且狀態不是「已取消」的所有預約紀錄
		String sql = "SELECT b.*, m.full_name AS member_name FROM Bookings b JOIN Members m ON b.member_id = m.member_id WHERE b.court_id = ? AND b.booking_date = ? AND b.status != '已取消'";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, courtId);
			stmt.setDate(2, bookingDate);
			
			rs = stmt.executeQuery();
			
			while(rs.next()) {
				BookingsBean booking = new BookingsBean();
				
				booking.setBookingId(rs.getInt("booking_id"));
				booking.setMemberId(rs.getInt("member_id"));
				booking.setCourtId(rs.getInt("court_id"));
				booking.setBookingDate(rs.getDate("booking_date"));
				booking.setStartTime(rs.getTime("start_time"));
				booking.setEndTime(rs.getTime("end_time"));
				booking.setStatus(rs.getString("status"));
				booking.setTotalAmount(rs.getBigDecimal("total_amount"));
				booking.setNote(rs.getString("note"));
				booking.setCreatedAt(rs.getTimestamp("created_at"));
				booking.setMemberName(rs.getString("member_name"));
				
				list.add(booking);
			}
			
		} catch (NamingException | SQLException e) {
			e.printStackTrace();
		} finally {
			if(rs != null) {
				try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
			if(stmt != null) {
				try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
			if(conn != null) {
				try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
		}
		
		return list;
	}

	@Override
	public List<BookingsBean> getAll() {
		
		List<BookingsBean> list = new ArrayList<>();
		String sql = "SELECT b.*, m.full_name AS member_name FROM Bookings b JOIN Members m ON b.member_id = m.member_id ORDER BY b.booking_id DESC";
		
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
				BookingsBean booking = new BookingsBean();
				
				booking.setBookingId(rs.getInt("booking_id"));
				booking.setMemberId(rs.getInt("member_id"));
				booking.setCourtId(rs.getInt("court_id"));
				booking.setBookingDate(rs.getDate("booking_date"));
				booking.setStartTime(rs.getTime("start_time"));
				booking.setEndTime(rs.getTime("end_time"));
				booking.setStatus(rs.getString("status"));
				booking.setTotalAmount(rs.getBigDecimal("total_amount"));
				booking.setNote(rs.getString("note"));
				booking.setCreatedAt(rs.getTimestamp("created_at"));
				booking.setMemberName(rs.getString("member_name"));
				
				list.add(booking);
			}
			
		} catch (NamingException | SQLException e) {
			e.printStackTrace();
		} finally {
			if(rs != null) {
				try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
			if(stmt != null) {
				try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
			if(conn != null) {
				try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
		}
		return list;
	}
	

}
