package com.badminton.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.sql.Date; // 必須匯入這個，用來對應資料庫的 DATE 欄位

public class MembersBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int memberId;
    private String username;
    private String password;
    private String name;
    private String phone;
    private String email;
    private String role;
    private String gender;    // 新增：性別
    private Date birthday;    // 新增：生日
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public MembersBean() {}

    // --- Getters and Setters ---

    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // 新增：性別的 Getter/Setter
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    // 新增：生日的 Getter/Setter
    public Date getBirthday() { return birthday; }
    public void setBirthday(Date birthday) { this.birthday = birthday; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}