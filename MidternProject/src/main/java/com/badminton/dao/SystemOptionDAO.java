package com.badminton.dao;

import java.util.List;
import com.badminton.model.CourtBean;
import com.badminton.model.TimeSlotBean;

public interface SystemOptionDAO {
    List<CourtBean> getAllCourts();
    List<TimeSlotBean> getAllTimeSlots();
}
