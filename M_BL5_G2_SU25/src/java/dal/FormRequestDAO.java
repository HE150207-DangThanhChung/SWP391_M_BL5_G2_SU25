package dal;

import model.FormRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class FormRequestDAO extends DBContext {
    public List<FormRequest> getAll() {
        List<FormRequest> list = new ArrayList<>();
        String sql = "SELECT fr.*, " +
                     "CASE " +
                     "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
                     "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
                     "END AS EmployeeName " +
                     "FROM FormRequest fr JOIN Employee e ON fr.EmployeeId = e.EmployeeId";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<FormRequest> getByStatus(String status) {
        List<FormRequest> list = new ArrayList<>();
        String sql = "SELECT fr.*, " +
                     "CASE " +
                     "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
                     "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
                     "END AS EmployeeName " +
                     "FROM FormRequest fr JOIN Employee e ON fr.EmployeeId = e.EmployeeId WHERE fr.Status = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<FormRequest> getByFilter(String status, String search) {
        List<FormRequest> list = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
            "SELECT fr.*, " +
            "CASE " +
            "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
            "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
            "END AS EmployeeName " +
            "FROM FormRequest fr JOIN Employee e ON fr.EmployeeId = e.EmployeeId WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Add status filter if provided
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND fr.Status = ?");
            params.add(status);
        }
        
        // Add search filter if provided
        if (search != null && !search.isEmpty()) {
            sqlBuilder.append(" AND (fr.Description LIKE ? OR " +
                             "CASE " +
                             "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
                             "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
                             "END LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public FormRequest getById(int id) {
        String sql = "SELECT fr.*, " +
                     "CASE " +
                     "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
                     "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
                     "END AS EmployeeName " +
                     "FROM FormRequest fr JOIN Employee e ON fr.EmployeeId = e.EmployeeId WHERE fr.FormRequestId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(FormRequest fr) {
        String sql = "INSERT INTO FormRequest (Description, Status, CreatedAt, EmployeeId) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fr.getDescription());
            ps.setString(2, fr.getStatus());
            ps.setDate(3, fr.getCreatedAt());
            ps.setInt(4, fr.getEmployeeId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(FormRequest fr) {
        String sql = "UPDATE FormRequest SET Description=?, Status=?, CreatedAt=?, EmployeeId=? WHERE FormRequestId=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fr.getDescription());
            ps.setString(2, fr.getStatus());
            ps.setDate(3, fr.getCreatedAt());
            ps.setInt(4, fr.getEmployeeId());
            ps.setInt(5, fr.getFormRequestId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM FormRequest WHERE FormRequestId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get all form requests by employee ID
     * @param employeeId The ID of the employee
     * @return List of FormRequest objects for the specified employee
     */
    public List<FormRequest> getByEmployeeId(int employeeId) {
        List<FormRequest> list = new ArrayList<>();
        
        // Fixed SQL query to handle potential NULL values in MiddleName
        String sql = "SELECT fr.*, " +
                     "CASE " +
                     "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
                     "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
                     "END AS EmployeeName " +
                     "FROM FormRequest fr JOIN Employee e ON fr.EmployeeId = e.EmployeeId " +
                     "WHERE fr.EmployeeId = ? ORDER BY fr.CreatedAt DESC";
        
        System.out.println("DEBUG: Executing SQL for EmployeeId " + employeeId + ": " + sql);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FormRequest fr = mapRow(rs);
                    list.add(fr);
                    System.out.println("DEBUG: Found FormRequest ID=" + fr.getFormRequestId() + 
                            ", Description=" + fr.getDescription() + 
                            ", Status=" + fr.getStatus() + 
                            ", EmployeeId=" + fr.getEmployeeId());
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR in getByEmployeeId for EmployeeId " + employeeId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: getByEmployeeId(" + employeeId + ") returning " + list.size() + " records");
        return list;
    }
    
    /**
     * Get all form requests by employee ID and status
     * @param employeeId The ID of the employee
     * @param status The status to filter by (Pending, Approved, Rejected)
     * @return Filtered list of FormRequest objects
     */
    public List<FormRequest> getByEmployeeIdAndStatus(int employeeId, String status) {
        List<FormRequest> list = new ArrayList<>();
        
        // Fixed SQL query to handle potential NULL values in MiddleName
        String sql = "SELECT fr.*, " +
                     "CASE " +
                     "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
                     "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
                     "END AS EmployeeName " +
                     "FROM FormRequest fr JOIN Employee e ON fr.EmployeeId = e.EmployeeId " +
                     "WHERE fr.EmployeeId = ? AND fr.Status = ? " +
                     "ORDER BY fr.CreatedAt DESC";
        
        System.out.println("DEBUG: Executing SQL for EmployeeId " + employeeId + " and Status " + status + ": " + sql);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FormRequest fr = mapRow(rs);
                    list.add(fr);
                    System.out.println("DEBUG: Found FormRequest ID=" + fr.getFormRequestId() + 
                            ", Description=" + fr.getDescription() + 
                            ", Status=" + fr.getStatus() + 
                            ", EmployeeId=" + fr.getEmployeeId());
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR in getByEmployeeIdAndStatus for EmployeeId " + employeeId + " and Status " + status + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: getByEmployeeIdAndStatus(" + employeeId + ", " + status + ") returning " + list.size() + " records");
        return list;
    }
    
    /**
     * Get report statistics for a specific employee
     * @param employeeId The ID of the employee
     * @return Map containing counts for total, pending, approved, and rejected reports
     */
    public HashMap<String, Integer> getEmployeeReportStats(int employeeId) {
        HashMap<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("pending", 0);
        stats.put("approved", 0);
        stats.put("rejected", 0);
        
        String sql = "SELECT " +
                    "COUNT(*) AS total, " +
                    "SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS pending, " +
                    "SUM(CASE WHEN Status = 'Approved' THEN 1 ELSE 0 END) AS approved, " +
                    "SUM(CASE WHEN Status = 'Rejected' THEN 1 ELSE 0 END) AS rejected " +
                    "FROM FormRequest " +
                    "WHERE EmployeeId = ?";
        
        System.out.println("DEBUG: Executing stats SQL for EmployeeId " + employeeId + ": " + sql);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("total", rs.getInt("total"));
                    stats.put("pending", rs.getInt("pending"));
                    stats.put("approved", rs.getInt("approved"));
                    stats.put("rejected", rs.getInt("rejected"));
                    
                    System.out.println("DEBUG: Stats for EmployeeId " + employeeId + 
                            ": Total=" + rs.getInt("total") + 
                            ", Pending=" + rs.getInt("pending") + 
                            ", Approved=" + rs.getInt("approved") + 
                            ", Rejected=" + rs.getInt("rejected"));
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR in getEmployeeReportStats for EmployeeId " + employeeId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }

    /**
     * Lấy danh sách yêu cầu mới tạo trong ngày hôm nay
     */
    public List<FormRequest> getTodayNewRequests() {
        List<FormRequest> list = new ArrayList<>();
        String sql = "SELECT fr.*, " +
                "CASE " +
                "    WHEN e.MiddleName IS NULL THEN CONCAT(e.LastName, ' ', e.FirstName) " +
                "    ELSE CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) " +
                "END AS EmployeeName " +
                "FROM FormRequest fr JOIN Employee e ON fr.EmployeeId = e.EmployeeId " +
                "WHERE CONVERT(date, fr.CreatedAt) = CONVERT(date, GETDATE()) ";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private FormRequest mapRow(ResultSet rs) throws SQLException {
        return new FormRequest(
                rs.getInt("FormRequestId"),
                rs.getString("Description"),
                rs.getString("Status"),
                rs.getDate("CreatedAt"),
                rs.getInt("EmployeeId"),
                rs.getString("EmployeeName")
        );
    }
    
    public static void main(String[] args) {
        FormRequestDAO dao = new FormRequestDAO();
        
        System.out.println("\n============= TEST CÁC HÀM MỚI VỚI DỮ LIỆU THỰC TẾ =============");
        
        // Test với các EmployeeId từ database thực tế
        int[] testEmployeeIds = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
        
        for (int employeeId : testEmployeeIds) {
            System.out.println("\n=== TEST EMPLOYEE ID: " + employeeId + " ===");
            
            // Test 1: Lấy tất cả form request của employee
            List<FormRequest> employeeRequests = dao.getByEmployeeId(employeeId);
            System.out.println("Tìm thấy " + employeeRequests.size() + " form request cho employee ID " + employeeId);
            
            if (!employeeRequests.isEmpty()) {
                for (FormRequest fr : employeeRequests) {
                    System.out.println("  - ID: " + fr.getFormRequestId() + 
                            ", Description: " + fr.getDescription() + 
                            ", Status: " + fr.getStatus() + 
                            ", Date: " + fr.getCreatedAt() + 
                            ", Employee: " + fr.getEmployeeName());
                }
                
                // Test thống kê cho employee này
                HashMap<String, Integer> stats = dao.getEmployeeReportStats(employeeId);
                System.out.println("  Stats: Total=" + stats.get("total") + 
                        ", Pending=" + stats.get("pending") + 
                        ", Approved=" + stats.get("approved") + 
                        ", Rejected=" + stats.get("rejected"));
            } else {
                System.out.println("  Không có form request nào cho employee ID " + employeeId);
            }
        }
        
        System.out.println("\n=== TEST TỔNG QUAN ===");
        List<FormRequest> allRequests = dao.getAll();
        System.out.println("Tổng số form request trong hệ thống: " + allRequests.size());
    }
} 