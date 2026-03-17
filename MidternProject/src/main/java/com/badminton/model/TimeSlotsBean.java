package com.badminton.model;

import java.sql.Time;

public class TimeSlotsBean implements java.io.Serializable {
	private static final long serialVersionUID = 1L;
	
	private Integer slotId;
	private Time startTime;
	private Time endTime;
	private String label;
	
	public TimeSlotsBean() {
	}

	public Integer getSlotId() { return slotId; }
	public Time getStartTime() { return startTime; }
	public Time getEndTime() { return endTime; }
	public String getLabel() { return label; }

	public void setSlotId(Integer slotId) { this.slotId = slotId; }
	public void setStartTime(Time startTime) { this.startTime = startTime; }
	public void setEndTime(Time endTime) { this.endTime = endTime; }
	public void setLabel(String label) { this.label = label; }


	@Override
	public String toString() {
		return "TimeSlotsBean [slotId=" + slotId + ", startTime=" + startTime + ", endTime=" + endTime + ", label="
				+ label + "]";
	}
	
	

}

