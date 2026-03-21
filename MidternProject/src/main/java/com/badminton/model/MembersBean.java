package com.badminton.model;

import java.io.Serializable;
import java.sql.Date;

public class MembersBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int memberId;
    private String username;
    private String password;
    private String fullName; // 修正為 fullName
    private String profilePicture;
    private String gender;
    private Date birthday;
    private String phone;
    private String email;
    private String membershipLevel;
    private String status;

    public MembersBean() {}

    // Getter & Setter
    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public Date getBirthday() { return birthday; }
    public void setBirthday(Date birthday) { this.birthday = birthday; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMembershipLevel() { return membershipLevel; }
    public void setMembershipLevel(String membershipLevel) { this.membershipLevel = membershipLevel; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}