package com.badminton.model;

public class CourtBean {
    private int courtId;
    private String courtName;
    private int venueId;
    private String venueName; // 從 Venues JOIN 取得

    public CourtBean() {}

    public int getCourtId() { return courtId; }
    public void setCourtId(int courtId) { this.courtId = courtId; }

    public String getCourtName() { return courtName; }
    public void setCourtName(String courtName) { this.courtName = courtName; }

    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }

    public String getVenueName() { return venueName; }
    public void setVenueName(String venueName) { this.venueName = venueName; }

    // 提供一個方便的顯示名稱，例如 "總館 - A場"
    public String getDisplayName() {
        return venueName + " - " + courtName;
    }
}
