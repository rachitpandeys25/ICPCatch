package com.icp.dao;

import com.icp.model.Claim;
import com.icp.util.DbConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClaimDAO {

    public boolean submitClaim(Claim claim) {
        String sql = "INSERT INTO claims (item_id, claimant_id, proof_details) VALUES (?,?,?)";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, claim.getItemId());
            ps.setInt(2, claim.getClaimantId());
            ps.setString(3, claim.getProofDetails());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Claim> getClaimsByUser(int userId) {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT cl.*, i.title as item_title, u.full_name as claimant_name " +
                     "FROM claims cl " +
                     "JOIN items i ON cl.item_id = i.item_id " +
                     "JOIN users u ON cl.claimant_id = u.user_id " +
                     "WHERE cl.claimant_id = ? ORDER BY cl.claimed_at DESC";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) claims.add(mapClaim(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return claims;
    }

    public List<Claim> getAllClaims() {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT cl.*, i.title as item_title, u.full_name as claimant_name " +
                     "FROM claims cl " +
                     "JOIN items i ON cl.item_id = i.item_id " +
                     "JOIN users u ON cl.claimant_id = u.user_id " +
                     "ORDER BY cl.claimed_at DESC";
        try (Connection conn = DbConfig.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) claims.add(mapClaim(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return claims;
    }

    public List<Claim> getPendingClaims() {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT cl.*, i.title as item_title, u.full_name as claimant_name " +
                     "FROM claims cl " +
                     "JOIN items i ON cl.item_id = i.item_id " +
                     "JOIN users u ON cl.claimant_id = u.user_id " +
                     "WHERE cl.status = 'PENDING' ORDER BY cl.claimed_at DESC";
        try (Connection conn = DbConfig.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) claims.add(mapClaim(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return claims;
    }

    public Claim getClaimById(int claimId) {
        String sql = "SELECT cl.*, i.title as item_title, u.full_name as claimant_name " +
                     "FROM claims cl " +
                     "JOIN items i ON cl.item_id = i.item_id " +
                     "JOIN users u ON cl.claimant_id = u.user_id " +
                     "WHERE cl.claim_id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapClaim(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateClaimStatus(int claimId, String status, String remarks) {
        String sql = "UPDATE claims SET status=?, admin_remarks=?, resolved_at=? WHERE claim_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ps.setInt(4, claimId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean alreadyClaimed(int itemId, int userId) {
        String sql = "SELECT claim_id FROM claims WHERE item_id=? AND claimant_id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, userId);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Claim mapClaim(ResultSet rs) throws SQLException {
        Claim claim = new Claim();
        claim.setClaimId(rs.getInt("claim_id"));
        claim.setItemId(rs.getInt("item_id"));
        claim.setItemTitle(rs.getString("item_title"));
        claim.setClaimantId(rs.getInt("claimant_id"));
        claim.setClaimantName(rs.getString("claimant_name"));
        claim.setProofDetails(rs.getString("proof_details"));
        claim.setStatus(rs.getString("status"));
        claim.setAdminRemarks(rs.getString("admin_remarks"));
        claim.setClaimedAt(rs.getTimestamp("claimed_at"));
        claim.setResolvedAt(rs.getTimestamp("resolved_at"));
        return claim;
    }
}