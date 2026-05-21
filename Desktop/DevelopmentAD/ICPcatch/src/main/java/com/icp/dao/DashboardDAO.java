package com.icp.dao;

import com.icp.util.DbConfig;
import java.sql.*;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDAO {

    public int getTotalItems() {
        return countQuery("SELECT COUNT(*) FROM items");
    }

    public int getTotalUsers() {
        return countQuery("SELECT COUNT(*) FROM users WHERE role='STUDENT'");
    }

    public int getActiveClaims() {
        return countQuery("SELECT COUNT(*) FROM claims WHERE status='PENDING'");
    }

    public int getResolvedItems() {
        return countQuery("SELECT COUNT(*) FROM items WHERE status='RESOLVED'");
    }

    public String getSuccessRate() {
        int total = getTotalItems();
        int resolved = getResolvedItems();
        if (total == 0) return "0%";
        int rate = (resolved * 100) / total;
        return rate + "%";
    }

    public Map<String, Integer> getCategoryStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = "SELECT c.category_name, COUNT(i.item_id) as total " +
                     "FROM categories c LEFT JOIN items i ON c.category_id = i.category_id " +
                     "GROUP BY c.category_name ORDER BY total DESC";
        try (Connection conn = DbConfig.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                stats.put(rs.getString("category_name"), rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Integer> getItemTypeStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("LOST", countQuery("SELECT COUNT(*) FROM items WHERE item_type='LOST'"));
        stats.put("FOUND", countQuery("SELECT COUNT(*) FROM items WHERE item_type='FOUND'"));
        return stats;
    }

    private int countQuery(String sql) {
        try (Connection conn = DbConfig.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}