/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.City;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tayho
 */
public class CityDAO {

    // Row mapper
    private City mapRow(ResultSet rs) throws SQLException {
        return new City(rs.getInt("CityId"), rs.getString("CityName"));
    }

    /**
     * Get all cities, ordered by name (for dropdowns).
     */
    public List<City> getAll() {
        String sql = """
            SELECT CityId, CityName
            FROM dbo.City
            ORDER BY CityName
            """;
        List<City> list = new ArrayList<>();
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get a single city by its id.
     */
    public City getById(int id) {
        String sql = """
            SELECT CityId, CityName
            FROM dbo.City
            WHERE CityId = ?
            """;
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Optional helper: get a city by exact name (useful if needed for lookups).
     */
    public City getByName(String name) {
        String sql = """
            SELECT CityId, CityName
            FROM dbo.City
            WHERE CityName = ?
            """;
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
