package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.badminton.model.CourtBean;
import com.badminton.model.TimeSlotBean;

public class SystemOptionDAOImpl implements SystemOptionDAO {

    private Connection getConnection() throws Exception {
        InitialContext ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/BadmintonDB");
        return ds.getConnection();
    }

    @Override
    public List<CourtBean> getAllCourts() {
        List<CourtBean> list = new ArrayList<>();
        String sql = "SELECT c.court_id, c.court_name, c.venue_id, v.venue_name " +
                     "FROM Courts c JOIN Venues v ON c.venue_id = v.venue_id " +
                     "ORDER BY v.venue_name, c.court_name";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                CourtBean bean = new CourtBean();
                bean.setCourtId(rs.getInt("court_id"));
                bean.setCourtName(rs.getString("court_name"));
                bean.setVenueId(rs.getInt("venue_id"));
                bean.setVenueName(rs.getString("venue_name"));
                list.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<TimeSlotBean> getAllTimeSlots() {
        List<TimeSlotBean> list = new ArrayList<>();
        String sql = "SELECT start_time, end_time, label FROM BadmintonDB.dbo.TimeSlots ORDER BY start_time ASC";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                TimeSlotBean bean = new TimeSlotBean();
                bean.setStartTime(rs.getString("start_time"));
                bean.setEndTime(rs.getString("end_time"));
                bean.setLabel(rs.getString("label"));
                list.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
