package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;



import com.badminton.model.OrderBean;
import com.badminton.util.DBConnection;

public class OrderDAO {
	
	/*
	 *  新增一筆訂單
	 */
	public boolean insert(OrderBean order) {
		
		String actualSql = "INSERT INTO orders (member_id, total_amount, status, payment_type, note) VALUES (?,?,?,?,?)";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(actualSql, Statement.RETURN_GENERATED_KEYS)){
			
			ps.setInt(1, order.getMemberId());
			ps.setInt(2, order.getTotalAmount() !=null ? order.getTotalAmount() : 0);
			ps.setString(3, order.getStatus() !=null ? order.getStatus() : "PENDING");
			ps.setString(4, order.getPaymentType());
			ps.setString(5, order.getNote());
			
			int affectedRows = ps.executeUpdate();
			
			if (affectedRows > 0) {
				try (ResultSet rs = ps.getGeneratedKeys()){
					if (rs.next()) {
						order.setOrderId(rs.getInt(1));
					}
				}
				return true;
			}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return false;
	}
			
			/*
			 *  查詢所有訂單
			 */
			
			public List<OrderBean> findAll(){
				List<OrderBean> list = new ArrayList<>();
				String sql = "SELECT * FROM orders ORDER BY created_at DESC";
						
						try(Connection conn = DBConnection.getConnection();
								PreparedStatement ps = conn.prepareStatement(sql);
								ResultSet rs = ps.executeQuery()){
							
							while (rs.next()) {
								OrderBean o = new OrderBean();
								o.setOrderId(rs.getInt("id"));
								o.setMemberId(rs.getInt("member_id"));
								if(rs.getTimestamp("order_date") !=null) {
									o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
								}
								o.setTotalAmount(rs.getInt("total_amount"));
								o.setStatus(rs.getString("status"));
								o.setPaymentType(rs.getString("payment_type"));
								o.setNote(rs.getString("note"));
								if(rs.getTimestamp("created_at") !=null) {
									o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
								}
								list.add(o);
							}
						} catch (SQLException e) {
							e.printStackTrace();
						}
				        return list;
			}
				        
				        
				        /*
				         *  依據 ID 查詢單筆訂筆 
				         */
				        
				        public OrderBean findById(int orderId) {
				        	String sql = "SELECT * FROM orders WHERE id=?";
				        	try (Connection conn = DBConnection.getConnection());
				        			PreparedStatement ps = conn.prepareStatement(sql)){
				        				
				        				ps.setInt(1, orderId);
				        				try (ResultSet rs = ps.executeQuery()){
				        					
				        					if (rs.next()) {
				        						OrderBean o = new OrderBean();
				        						o.setOrderId(rs.getInt("id"));
				        						o.setMemberId(rs.getInt("member_id"));
				        						if (rs.getTimestamp("order_date") !=null) {
				        							o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
				        						}
				        						o.setTotalAmount(rs.getInt("total_amount"));
				        						o.setStatus(rs.getString("status"));
				        						o.setPaymentType(rs.getString("payment_type"));
				        						o.setNote(rs.getString("note"));
				        						if(rs.getTimestamp("created_at") != null ) {
				        							o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
				        						
				        						}
				        					     return o;
				        					        					
				        				}
				        				
				        				}
				        				
			
				        				
				        				
				        			} catch (SQLException e) {
				        				e.printStackTrace();
				        			}
				        			return null;
				        }
				        			
				        			
				        			/*
				        			 * 更新訂單狀態 (例如: 付款完成、取消訂單)
				        			 * 
				        			 */
				        			public boolean updateStatus(int orderId, String status) {
				        				String sql = "UPDATE orders SET status = ? WHERE id =?";
				        				try(Connection conn = DBConnection.getConnection();
				        						PreparedStatement ps = conn.prepareStatement(sql)){
				        					ps.setString(1, status);
				        					ps.setInt(2, orderId);
				        					return ps.executeUpdate() > 0;
				        				} catch (SQLException e) {
				        					e.printStackTrace();
				        				}
				        				return false;
				        			}
				        			
				        			
				        			/*
				        			 * 刪除訂單
				        			 */
				        			public boolean delete(int orderId) {
				        				String sql = "DELETE FROM orders WHERE id = ?";
				        				try(Connection conn = DBConnection.getConnection();
				        						PreparedStatement ps = conn.prepareStatement(sql)){
				        					ps.setInt(1, orderId);
				        					return ps.executeUpdate() >0 ;
				        				} catch (SQLException e) {
				        					e.printStackTrace();
				        				}
				        				return false;
				        			}
				        	
							
								
								
								
			}
		
			
			
		
	


