package com.badminton.model;

import java.io.Serializable;

public class TimeSlotBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String startTime;
    private String endTime;
    private String label;

    public TimeSlotBean() {}

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        // If the DB returns "08:00:00.0000000" or similar, we only need "08:00"
        if (startTime != null && startTime.length() >= 5) {
            this.startTime = startTime.substring(0, 5);
        } else {
            this.startTime = startTime;
        }
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        if (endTime != null && endTime.length() >= 5) {
            this.endTime = endTime.substring(0, 5);
        } else {
            this.endTime = endTime;
        }
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }
}
