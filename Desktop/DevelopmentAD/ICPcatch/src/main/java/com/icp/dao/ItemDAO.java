package com.icp.dao;

import com.icp.model.Item;
import com.icp.util.DbConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public boolean postItem(Item item) {
        String sql = "INSERT INTO items (title, category_id, description, item_type, date_occurred, location, image_path, reporter_id) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getTitle());
            ps.setInt(2, item.getCategoryId());
            ps.setString(3, item.getDescription());
            ps.setString(4, item.getItemType());
            ps.setDate(5, item.getDateOccurred());
            ps.setString(6, item.getLocation());
            ps.setString(7, item.getImagePath());
            ps.setInt(8, item.getReporterId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT i.*, c.category_name, u.full_name as reporter_name " +
                     "FROM items i " +
                     "JOIN categories c ON i.category_id = c.category_id " +
                     "JOIN users u ON i.reporter_id = u.user_id " +
                     "ORDER BY i.created_at DESC";
        try (Connection conn = DbConfig.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                items.add(mapItem(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Item> getItemsByUser(int userId) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT i.*, c.category_name, u.full_name as reporter_name " +
                     "FROM items i " +
                     "JOIN categories c ON i.category_id = c.category_id " +
                     "JOIN users u ON i.reporter_id = u.user_id " +
                     "WHERE i.reporter_id = ? ORDER BY i.created_at DESC";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                items.add(mapItem(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public Item getItemById(int itemId) {
        String sql = "SELECT i.*, c.category_name, u.full_name as reporter_name " +
                     "FROM items i " +
                     "JOIN categories c ON i.category_id = c.category_id " +
                     "JOIN users u ON i.reporter_id = u.user_id " +
                     "WHERE i.item_id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapItem(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Item> searchItems(String keyword, String category, 
                                   String type, String dateFrom, String dateTo) {
        List<Item> items = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, c.category_name, u.full_name as reporter_name " +
            "FROM items i " +
            "JOIN categories c ON i.category_id = c.category_id " +
            "JOIN users u ON i.reporter_id = u.user_id WHERE 1=1");

        if (keyword != null && !keyword.trim().isEmpty())
            sql.append(" AND (i.title LIKE ? OR i.description LIKE ?)");
        if (category != null && !category.trim().isEmpty())
            sql.append(" AND c.category_name = ?");
        if (type != null && !type.trim().isEmpty())
            sql.append(" AND i.item_type = ?");
        if (dateFrom != null && !dateFrom.trim().isEmpty())
            sql.append(" AND i.date_occurred >= ?");
        if (dateTo != null && !dateTo.trim().isEmpty())
            sql.append(" AND i.date_occurred <= ?");
        sql.append(" ORDER BY i.created_at DESC");

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx++, "%" + keyword + "%");
            }
            if (category != null && !category.trim().isEmpty())
                ps.setString(idx++, category);
            if (type != null && !type.trim().isEmpty())
                ps.setString(idx++, type);
            if (dateFrom != null && !dateFrom.trim().isEmpty())
                ps.setString(idx++, dateFrom);
            if (dateTo != null && !dateTo.trim().isEmpty())
                ps.setString(idx++, dateTo);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                items.add(mapItem(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean updateItem(Item item) {
        String sql = "UPDATE items SET title=?, category_id=?, description=?, " +
                     "date_occurred=?, location=?, image_path=? WHERE item_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getTitle());
            ps.setInt(2, item.getCategoryId());
            ps.setString(3, item.getDescription());
            ps.setDate(4, item.getDateOccurred());
            ps.setString(5, item.getLocation());
            ps.setString(6, item.getImagePath());
            ps.setInt(7, item.getItemId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateItemStatus(int itemId, String status) {
        String sql = "UPDATE items SET status=? WHERE item_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteItem(int itemId) {
        String sql = "DELETE FROM items WHERE item_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Item mapItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setItemId(rs.getInt("item_id"));
        item.setTitle(rs.getString("title"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setCategoryName(rs.getString("category_name"));
        item.setDescription(rs.getString("description"));
        item.setItemType(rs.getString("item_type"));
        item.setDateOccurred(rs.getDate("date_occurred"));
        item.setLocation(rs.getString("location"));
        item.setImagePath(rs.getString("image_path"));
        item.setStatus(rs.getString("status"));
        item.setReporterId(rs.getInt("reporter_id"));
        item.setReporterName(rs.getString("reporter_name"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        return item;
    }
}