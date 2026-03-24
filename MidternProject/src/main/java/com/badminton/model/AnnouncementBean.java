package com.badminton.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class AnnouncementBean  implements Serializable{
	private static final long serialVersionUID = 1L;
	/*	把資料庫裡的每一筆紀錄
	 *  包裝成一個一個的 Java 物件（Object）
	 *  這樣在網頁（JSP）和伺服器（Servlet）之間
	 *  傳遞資料時就會非常方便
	 */
	
	// 變數宣告 (對應SQL欄位)
    private Integer announcementId;   // 公告 ID (對應 announcement_id)
    private String title;             // 標題
    private String content;           // 內容
    private String status;            // 狀態 (draft, published, archived)
    private Boolean isPinned;         // 是否置頂 (對應 is_pinned)
    private Timestamp createdAt;      // 建立時間 (對應 created_at)
    private String category;          // 分類 (緊急/活動/一般)
    private Integer viewCount;        // 點閱數 (對應 view_count)
    private Timestamp publishAt;      // 排程發布時間 (對應 publish_at)
    private Timestamp expireAt;       // 自動下架時間 (對應 expire_at)
    private Timestamp updatedAt;      // 修改時間 (對應 updated_at)
	
    // 無參數的建構子
    public AnnouncementBean() {
		
	}


	public Integer getAnnouncementId() {
		return announcementId;
	}


	public void setAnnouncementId(Integer announcementId) {
		this.announcementId = announcementId;
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
	}


	public Boolean getIsPinned() {
		return isPinned;
	}


	public void setIsPinned(Boolean isPinned) {
		this.isPinned = isPinned;
	}


	public Timestamp getCreatedAt() {
		return createdAt;
	}


	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}


	public String getCategory() {
		return category;
	}


	public void setCategory(String category) {
		this.category = category;
	}


	public Integer getViewCount() {
		return viewCount;
	}


	public void setViewCount(Integer viewCount) {
		this.viewCount = viewCount;
	}


	public Timestamp getPublishAt() {
		return publishAt;
	}


	public void setPublishAt(Timestamp publishAt) {
		this.publishAt = publishAt;
	}


	public Timestamp getExpireAt() {
		return expireAt;
	}


	public void setExpireAt(Timestamp expireAt) {
		this.expireAt = expireAt;
	}


	public Timestamp getUpdatedAt() {
		return updatedAt;
	}


	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}


	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    
    @Override
    public String toString() {
        return "AnnouncementBean ["
                + "announcementId=" + announcementId 
                + ", title=" + title 
                + ", category=" + category 
                + ", status=" + status 
                + ", isPinned=" + isPinned 
                + "]";
    }
	
    
}
