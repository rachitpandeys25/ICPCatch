package com.icp.dao;

import com.icp.model.User;
import com.icp.util.DbConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, password_hash, " +
                     "student_id, program, year, phone, role, status) " +
                     "VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getStudentId());
            ps.setString(5, user.getProgram());
            ps.setInt(6, user.getYear());
            ps.setString(7, user.getPhone());
            ps.setString(8, user.getRole());
            ps.setString(9, user.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves a user from the database by their unique user ID.
     *
     * @param userId The primary key of the user
     * @return User object if found, null otherwise
     */
    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves all registered users ordered by registration date.
     * Used by Admin for user management dashboard.
     *
     * @return List of all User objects, empty list if none found
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DbConfig.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) users.add(mapUser(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Updates a user's profile information in the database.
     * Only updates mutable fields: name, phone, program, year.
     *
     * @param user User object with updated information
     * @return true if update successful, false otherwise
     */
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET full_name=?, phone=?, " +
                     "program=?, year=? WHERE user_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getProgram());
            ps.setInt(4, user.getYear());
            ps.setInt(5, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates a user's password hash in the database.
     * Called after password change verification in ProfileServlet.
     *
     * @param userId The ID of the user changing password
     * @param newHash The new BCrypt hashed password
     * @return true if update successful, false otherwise
     */
    public boolean updatePassword(int userId, String newHash) {
        String sql = "UPDATE users SET password_hash=? WHERE user_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates a user's account status (ACTIVE, SUSPENDED, PENDING).
     * Used by Admin to activate or suspend student accounts.
     *
     * @param userId The ID of the user to update
     * @param status The new status value
     * @return true if update successful, false otherwise
     */
    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status=? WHERE user_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Permanently deletes a user account from the database.
     * Admin-only operation. Cannot be undone.
     *
     * @param userId The ID of the user to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if an email address is already registered in the system.
     * Used during registration to prevent duplicate accounts.
     *
     * @param email The email to check
     * @return true if email exists, false otherwise
     */
    public boolean emailExists(String email) {
        String sql = "SELECT user_id FROM users WHERE email=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if a student ID is already registered in the system.
     * Used during registration to ensure unique student IDs.
     *
     * @param studentId The student ID to check
     * @return true if student ID exists, false otherwise
     */
    public boolean studentIdExists(String studentId) {
        String sql = "SELECT user_id FROM users WHERE student_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Maps a ResultSet row to a User object.
     * Private helper method to avoid code duplication across query methods.
     *
     * @param rs ResultSet positioned at the row to map
     * @return Populated User object
     * @throws SQLException if column access fails
     */
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setStudentId(rs.getString("student_id"));
        user.setProgram(rs.getString("program"));
        user.setYear(rs.getInt("year"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}