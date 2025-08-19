/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Ward;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tayho
 */
public class WardDAO {
// --- Row mapper ---

    private Ward mapRow(ResultSet rs) throws SQLException {
        Ward w = new Ward();
        w.setWardId(rs.getInt("WardId"));
        w.setWardName(rs.getString("WardName"));
        // CityId might be present depending on query; guard in case it isn't selected
        try {
            w.setCityId(rs.getInt("CityId"));
        } catch (SQLException ignore) {
        }
        return w;
    }

    /**
     * Get all wards belonging to a city, ordered by name (for cascading
     * dropdown).
     */
    public List<Ward> getByCityId(int cityId) {
        String sql = """
            SELECT WardId, WardName, CityId
            FROM dbo.Ward
            WHERE CityId = ?
            ORDER BY WardName
            """;
        List<Ward> list = new ArrayList<>();
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, cityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get a single ward by its id.
     */
    public Ward getById(int wardId) {
        String sql = """
            SELECT WardId, WardName, CityId
            FROM dbo.Ward
            WHERE WardId = ?
            """;
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, wardId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Validation helper: check that a ward belongs to a given city. Useful when
     * saving Customer to prevent tampered submissions.
     */
    public boolean existsInCity(int wardId, int cityId) {
        String sql = """
            SELECT 1
            FROM dbo.Ward
            WHERE WardId = ? AND CityId = ?
            """;
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, wardId);
            ps.setInt(2, cityId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // on error, fail closed in controller as needed
        }
    }
}
