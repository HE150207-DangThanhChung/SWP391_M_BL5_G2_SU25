package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO {

    private static Connection con;
    private static PreparedStatement ps;
    private static ResultSet rs;

    public Category getCategoryById(int id) {
        Category c = new Category();
        String sql = """
            SELECT [CategoryId],
                   [CategoryName],
                   [Description],
                   [Status]
            FROM [SWP391_M_BL5_G2_SU25].[dbo].[Category]
            WHERE CategoryId = ?
        """;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                c.setCategoryId(rs.getInt("CategoryId"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setDescription(rs.getString("Description"));
                c.setStatus(rs.getString("Status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return c;
    }

    public boolean addCategory(String name, String description, String status) {
        String sql = """
            INSERT INTO Category (CategoryName, Description, Status)
            VALUES (?, ?, ?)
        """;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setString(3, status);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return false;
    }

    public boolean editCategory(int categoryId, String name, String description, String status) {
        String sql = """
            UPDATE Category
            SET CategoryName = ?, Description = ?, Status = ?
            WHERE CategoryId = ?
        """;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setString(3, status);
            ps.setInt(4, categoryId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return false;
    }

    public List<Category> GetAllCategoryWithPagingAndFilter(String searchKey, String status, int offset, int limit) {
        List<Category> catList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT [CategoryId],
                   [CategoryName],
                   [Description],
                   [Status]
            FROM [SWP391_M_BL5_G2_SU25].[dbo].[Category]
            WHERE 1=1
        """);

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (CategoryName LIKE ? OR Description LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ? ");
        }
        sql.append(" ORDER BY CategoryId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (searchKey != null && !searchKey.trim().isEmpty()) {
                String pattern = "%" + searchKey.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);

            rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("CategoryId"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setDescription(rs.getString("Description"));
                c.setStatus(rs.getString("Status"));
                catList.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return catList;
    }

    public int countCategoriesWithFilter(String searchKey, String status) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) AS total
            FROM [SWP391_M_BL5_G2_SU25].[dbo].[Category]
            WHERE 1=1
        """);

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (CategoryName LIKE ? OR Description LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ? ");
        }

        int total = 0;
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (searchKey != null && !searchKey.trim().isEmpty()) {
                String pattern = "%" + searchKey.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return total;
    }

    public boolean isNameExisted(String name) {
        return isFieldValueExisted("CategoryName", name);
    }

    private boolean isFieldValueExisted(String columnName, String value) {
        String sql = "SELECT 1 FROM Category WHERE " + columnName + " = ?";
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, value);

            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return false;
    }
}
