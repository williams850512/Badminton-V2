package com.badminton.Venus.model;

public class VenuesBean implements java.io.Serializable {
	private static final long serialVersionUID = 1L;
	
	private Integer venueId;     // venue_id
    private String venueName;    // venue_name
    private String address;      // address
    private String phone;        // phone
    private Boolean isActive;    // is_active
    
    public VenuesBean() {
    }
    
	public Integer getVenueId() { return venueId; }
	public String getVenueName() { return venueName; }
	public String getAddress() { return address; }
	public String getPhone() { return phone; }
	public Boolean getIsActive() { return isActive; }
	
	public void setVenueId(Integer venueId) { this.venueId = venueId; }
	public void setVenueName(String venueName) { this.venueName = venueName; }
	public void setAddress(String address) { this.address = address; }
	public void setPhone(String phone) { this.phone = phone; }
	public void setIsActive(Boolean isActive) { this.isActive = isActive; }
	
	@Override
	public String toString() {
		return "VenuesBean [venueId=" + venueId + ", venueName=" + venueName + ", address=" + address + ", phone="
				+ phone + ", isActive=" + isActive + "]";
	}

}
