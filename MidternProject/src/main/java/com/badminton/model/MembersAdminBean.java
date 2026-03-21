package com.badminton.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.sql.Date;

/**
 * 對應資料庫 Admins 表的實體類 (Bean)
 */
public class MembersAdminBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int adminId;           // admin_id
    private String username;        // username
    private String password;        // password
    private String fullName;        // full_name
    private String profilePicture;  // profile_picture
    private String gender;          // gender
    private Date birthday;          // birthday
    private String phone;           // phone
    private String email;           // email
    private String role;            // role (manager/staff)
    private String status;          // status (active/locked)
    private int failedAttempts;     // failed_attempts
    private String note;            // note
    private Timestamp lastLoginAt;  // last_login_at
    private Timestamp createdAt;    // created_at
    private Timestamp updatedAt;    // updated_at

    // 無參數建構子 (Servlet/JSP 規範必須)
    public MembersAdminBean() {}

    // --- Getters and Setters ---

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getFailedAttempts() {
        return failedAttempts;
    }

    public void setFailedAttempts(int failedAttempts) {
        this.failedAttempts = failedAttempts;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(Timestamp lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}