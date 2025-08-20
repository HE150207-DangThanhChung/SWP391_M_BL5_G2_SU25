package dal;

import model.FormRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FormRequestDAO extends DBContext {
    public List<FormRequest> getAll() {
        List<FormRequest> list = new ArrayList<>();
        String sql = "SELECT fr.*, CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) AS EmployeeName " +
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
        String sql = "SELECT fr.*, CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) AS EmployeeName " +
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
            "SELECT fr.*, CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) AS EmployeeName " +
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
            sqlBuilder.append(" AND (fr.Description LIKE ? OR CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) LIKE ?)");
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
        String sql = "SELECT fr.*, CONCAT(e.LastName, ' ', e.MiddleName, ' ', e.FirstName) AS EmployeeName " +
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

//        // 1. Thêm mới
//        FormRequest fr = new FormRequest();
//        fr.setDescription("Request nhập thêm hàng Laptop");
//        fr.setStatus("Pending");
//        fr.setCreatedAt(new Date(System.currentTimeMillis()));
//        fr.setEmployeeId(1); // giả sử có employeeId = 1
//
//        boolean added = dao.add(fr);
//        System.out.println("Add result: " + added);

        // 2. Lấy danh sách
        List<FormRequest> list = dao.getAll();
        System.out.println("=== All Form Requests ===");
        for (FormRequest f : list) {
            System.out.println(f.getFormRequestId() + " - " + f.getDescription()
                    + " - " + f.getStatus());
        }

//        // 3. Lấy theo Id (giả sử lấy cái đầu tiên trong list)
//        if (!list.isEmpty()) {
//            int id = list.get(0).getFormRequestId();
//            FormRequest f = dao.getById(id);
//            System.out.println("Get by id " + id + ": " + f.getDescription());
//        }
//
//        // 4. Update (giả sử update bản ghi đầu tiên)
//        if (!list.isEmpty()) {
//            FormRequest toUpdate = list.get(0);
//            toUpdate.setDescription("Request nhập thêm hàng Desktop");
//            toUpdate.setStatus("Approved");
//            boolean updated = dao.update(toUpdate);
//            System.out.println("Update result: " + updated);
//        }
//
//        // 5. Xóa (giả sử xóa bản ghi đầu tiên)
//        if (!list.isEmpty()) {
//            int idToDelete = list.get(0).getFormRequestId();
//            boolean deleted = dao.delete(idToDelete);
//            System.out.println("Delete result for id " + idToDelete + ": " + deleted);
//        }
//
//        // 6. Lấy theo status
//        List<FormRequest> pending = dao.getByStatus("Pending");
//        System.out.println("=== Pending requests ===");
//        for (FormRequest f : pending) {
//            System.out.println(f.getFormRequestId() + " - " + f.getDescription());
//        }
    }
} 