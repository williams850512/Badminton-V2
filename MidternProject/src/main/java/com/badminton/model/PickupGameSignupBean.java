package com.badminton.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class PickupGameSignupBean implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    // 1. 私有屬性：對應 SQL 欄位
    private Integer signupId;     // 對應 signup_id
    private Integer gameId;       // 對應 game_id
    private Integer memberId;     // 改名了！對應 member_id
    private String status;        // 對應 status (NVARCHAR)
    private java.sql.Timestamp signedUpAt; //對應 signed_up_at
    private String memberName;

    // 2. 公共無參數建構子
    public PickupGameSignupBean() {
    }

    // 3. 公共 Getter 與 Setter
    public Integer getSignupId() {
        return signupId;
    }

    public void setSignupId(Integer signupId) {
        this.signupId = signupId;
    }

    public Integer getGameId() {
        return gameId;
    }

    public void setGameId(Integer gameId) {
        this.gameId = gameId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getSignedUpAt() {
        return signedUpAt;
    }

    public void setSignedUpAt(Timestamp signedUpAt) {
        this.signedUpAt = signedUpAt;
    }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }

    private String memberPhone;
    public String getMemberPhone() { return memberPhone; }
    public void setMemberPhone(String memberPhone) { this.memberPhone = memberPhone; }
    
}
