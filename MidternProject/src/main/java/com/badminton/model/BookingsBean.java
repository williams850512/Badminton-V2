package com.badminton.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class BookingsBean implements java.io.Serializable {
	private static final long serialVersionUID = 1L;
	
	private Integer bookingId;
	private Integer memberId;
	private Integer courtId;
	private Date bookingDate;
	private Time startTime;
	private Time endTime;
	private String status;
	private BigDecimal totalAmount;
	private String note;
	private Timestamp createdAt;
	private String memberName; // 為了關聯顯示會員姓名加上的屬性
	private String venueName;  // 為了關聯顯示球館名稱加上的屬性
	private String courtName;  // 為了關聯顯示場地名稱加上的屬性
	
	public BookingsBean() {	
	}

	public Integer getBookingId() {return bookingId;}
	public Integer getMemberId() {return memberId;}
	public Integer getCourtId() {return courtId;}
	public Date getBookingDate() {return bookingDate;}
	public Time getStartTime() {return startTime;}
	public Time getEndTime() {return endTime;}
	public String getStatus() {return status;}
	public BigDecimal getTotalAmount() {return totalAmount;}
	public String getNote() {return note;}
	public Timestamp getCreatedAt() {return createdAt;}
	public String getMemberName() {return memberName;}
	public String getVenueName() {return venueName;}
	public String getCourtName() {return courtName;}

	public void setBookingId(Integer bookingId) {this.bookingId = bookingId;}
	public void setMemberId(Integer memberId) {this.memberId = memberId;}
	public void setCourtId(Integer courtId) {this.courtId = courtId;}
	public void setBookingDate(Date bookingDate) {this.bookingDate = bookingDate;}
	public void setStartTime(Time startTime) {this.startTime = startTime;}
	public void setEndTime(Time endTime) {this.endTime = endTime;}
	public void setStatus(String status) {this.status = status;}
	public void setTotalAmount(BigDecimal totalAmount) {this.totalAmount = totalAmount;}
	public void setNote(String note) {this.note = note;}
	public void setCreatedAt(Timestamp createdAt) {this.createdAt = createdAt;}
	public void setMemberName(String memberName) {this.memberName = memberName;}
	public void setVenueName(String venueName) {this.venueName = venueName;}
	public void setCourtName(String courtName) {this.courtName = courtName;}

	@Override
	public String toString() {
		return "BookingsBean [bookingId=" + bookingId + ", memberId=" + memberId + ", courtId=" + courtId
				+ ", bookingDate=" + bookingDate + ", startTime=" + startTime + ", endTime=" + endTime + ", status="
				+ status + ", totalAmount=" + totalAmount + ", note=" + note + ", createdAt=" + createdAt + "]";
	}

}
