package com.badminton.dao;

import java.util.List;

import com.badminton.model.VenuesBean;

public interface VenuesDAO {
	
	//1.新增球館
	int insert(VenuesBean venue);
	
	//2.修改球館資料
	int update(VenuesBean venue);
	
	//3.根據 ID 查詢單一球館
	VenuesBean findById(Integer venuesId);
	
	//4.查詢所有球館
	List<VenuesBean> getAll();
	
	

}
