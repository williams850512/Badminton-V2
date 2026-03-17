package com.badminton.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class PickupGameSignupBean implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    // 1. 私有屬性：對應 SQL 欄位
    private Integer signupId;     // signup_id (PK)
    private Integer gameId;       // game_id (FK)
    private Integer memberId;     // member_id (FK)
    private String status;        // status (預設 'joined')
    private Timestamp signedUpAt; // signed_up_at (DATETIME)

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
}
