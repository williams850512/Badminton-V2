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
		VenuesBean venues = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource) context.lookup("java:/comp/env/jdbc/BadmintonDB");
			 conn = ds.getConnection();
			 stmt = conn.prepareStatement(sql);
			 rs = stmt.executeQuery();
			 
			 while(rs.next()) {
				 VenuesBean venue = new VenuesBean();
				 
				 venue.setVenueId(rs.getInt("venueId"));
				 venue.setVenueName(rs.getString("venueName"));
				 
			 }
			 
			
		} catch (NamingException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public int insert(VenuesBean venue) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int update(VenuesBean venue) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public VenuesBean findById(Integer venuesId) {
		// TODO Auto-generated method stub
		return null;
	}
	
	
}
