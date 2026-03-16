package com.badminton.PickupGames;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.sql.Date;
import java.sql.Time;

public class PickupGameBean implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private Integer gameId;        // INT IDENTITY
    private Integer hostId;        // INT
    private Integer courtId;       // INT
    private Date gameDate;         // DATE
    private Time startTime;        // TIME
    private Time endTime;          // TIME
    private Integer maxPlayers;    // INT
    private Integer currentPlayers;// INT
    private String skillLevel;     // NVARCHAR
    private BigDecimal feePerPerson; // DECIMAL
    private String description;    // NVARCHAR
    private String status;         // NVARCHAR
    private Timestamp createdAt;   // DATETIME

    public PickupGameBean() {
    }
	public Integer getGameId() {
		return gameId;
	}
	public void setGameId(Integer gameId) {
		this.gameId = gameId;
	}
	public Integer getHostId() {
		return hostId;
	}
	public void setHostId(Integer hostId) {
		this.hostId = hostId;
	}
	public Integer getCourtId() {
		return courtId;
	}
	public void setCourtId(Integer courtId) {
		this.courtId = courtId;
	}
	public Date getGameDate() {
		return gameDate;
	}
	public void setGameDate(Date gameDate) {
		this.gameDate = gameDate;
	}
	public Time getStartTime() {
		return startTime;
	}
	public void setStartTime(Time startTime) {
		this.startTime = startTime;
	}
	public Time getEndTime() {
		return endTime;
	}
	public void setEndTime(Time endTime) {
		this.endTime = endTime;
	}
	public Integer getMaxPlayers() {
		return maxPlayers;
	}
	public void setMaxPlayers(Integer maxPlayers) {
		this.maxPlayers = maxPlayers;
	}
	public Integer getCurrentPlayers() {
		return currentPlayers;
	}
	public void setCurrentPlayers(Integer currentPlayers) {
		this.currentPlayers = currentPlayers;
	}
	public String getSkillLevel() {
		return skillLevel;
	}
	public void setSkillLevel(String skillLevel) {
		this.skillLevel = skillLevel;
	}
	public BigDecimal getFeePerPerson() {
		return feePerPerson;
	}
	public void setFeePerPerson(BigDecimal feePerPerson) {
		this.feePerPerson = feePerPerson;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
