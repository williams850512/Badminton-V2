package com.badminton.Courts.model;

public class CourtsBean implements java.io.Serializable {
	private static final long serialVersionUID = 1L;
	
	private Integer courtId;
	private Integer venueId;
	private String courtName;
	private Boolean isActive;
	
	public CourtsBean() {
		}
	
	public Integer getCourtId() { return courtId; }
	public Integer getVenueId() { return venueId; }
	public String getCourtName() { return courtName; }
	public Boolean getIsActive() { return isActive; }
	
	public void setCourtId(Integer courtId) { this.courtId = courtId; }
	public void setVenueId(Integer venueId) { this.venueId = venueId; }
	public void setCourtName(String courtName) { this.courtName = courtName; }
	public void setIsActive(Boolean isActive) { this.isActive = isActive; }
	
	@Override
	public String toString() {
		return "CourtBean [courtId=" + courtId + ", venueId=" + venueId + ", courtName=" + courtName + ", isActive="
				+ isActive + "]";
	}
	
}
