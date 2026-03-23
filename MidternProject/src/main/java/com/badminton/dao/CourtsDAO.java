package com.badminton.dao;

import java.util.List;

import com.badminton.model.CourtsBean;

public interface CourtsDAO {
	
	//1.新增球場
	int insert(CourtsBean court);
	
	//2.修改球場資料
	int update(CourtsBean court);
	
	//3.根據球館ID查詢場地
	List<CourtsBean> findByVenueId(Integer venueId);
	
	//4.根據ID查球場
	CourtsBean findById(Integer courtId);
	
	//5.查詢所有球場
	List<CourtsBean> getAll();

}
