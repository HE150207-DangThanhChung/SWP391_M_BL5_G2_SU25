/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Category;
import model.Role;

/**
 *
 * @author hoanganhdev
 */
public class RoleDAO {

    private static Connection con;
    private static PreparedStatement ps;
    private static ResultSet rs;

    public static void main(String[] args) {
        RoleDAO r = new RoleDAO();
        System.out.println(r.getRoleById(1));
    }
    
    public Role getRoleById(int id) {
        Role r = new Role();
        String sql = """
            SELECT *
            FROM [SWP391_M_BL5_G2_SU25].[dbo].[Role]
            WHERE RoleId = ?
        """;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                r.setId(rs.getInt("RoleId"));
                r.setName(rs.getString("RoleName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return r;
    }
}
