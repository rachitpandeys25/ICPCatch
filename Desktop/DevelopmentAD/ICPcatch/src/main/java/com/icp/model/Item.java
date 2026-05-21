package com.icp.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Item {
    private int itemId;
    private String title;
    private int categoryId;
    private String categoryName;
    private String description;
    private String itemType;
    private Date dateOccurred;
    private String location;
    private String imagePath;
    private String status;
    private int reporterId;
    private String reporterName;
    private Timestamp createdAt;

    public Item() {}

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getItemType() { return itemType; }
    public void setItemType(String itemType) { this.itemType = itemType; }

    public Date getDateOccurred() { return dateOccurred; }
    public void setDateOccurred(Date dateOccurred) { this.dateOccurred = dateOccurred; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getReporterId() { return reporterId; }
    public void setReporterId(int reporterId) { this.reporterId = reporterId; }

    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}