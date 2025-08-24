/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.*;
import java.sql.*;
import java.util.*;

/**
 *
 * @author tayho
 */
public class OrderDAO {

    private static Connection con;
    private static PreparedStatement ps;
    private static ResultSet rs;

    public static void main(String[] args) {
        OrderDAO oDao = new OrderDAO();
        System.out.println(oDao.getCompletedOrders("", 100, 0).size());
    }
    
    // Lấy danh sách đơn hàng
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.OrderId, o.OrderDate, o.Status, "
                + "c.CustomerId, c.FirstName AS CFirstName, c.MiddleName AS CMiddleName, c.LastName AS CLastName, c.Phone AS CPhone, c.Email AS CEmail, c.Gender AS CGender, c.Address AS CAddress, c.Status AS CStatus, c.TaxCode AS CTaxCode, c.WardId AS CWardId, c.Dob AS CDob, "
                + "cr.EmployeeId AS CreatedById, cr.FirstName AS CrFirstName, cr.MiddleName AS CrMiddleName, cr.LastName AS CrLastName, cr.Phone AS CrPhone, cr.Email AS CrEmail, cr.Gender AS CrGender, cr.Address AS CrAddress, cr.Status AS CrStatus, cr.RoleId AS CrRoleId, cr.StoreId AS CrStoreId, cr.WardId AS CrWardId, cr.Dob AS CrDob, "
                + "sl.EmployeeId AS SaleById, sl.FirstName AS SlFirstName, sl.MiddleName AS SlMiddleName, sl.LastName AS SlLastName, sl.Phone AS SlPhone, sl.Email AS SlEmail, sl.Gender AS SlGender, sl.Address AS SlAddress, sl.Status AS SlStatus, sl.RoleId AS SlRoleId, sl.StoreId AS SlStoreId, sl.WardId AS SlWardId, sl.Dob AS SlDob, "
                + "s.StoreId, s.StoreName, s.Address AS SAddress, s.Phone AS SPhone, s.Status AS SStatus "
                + "FROM [Order] o "
                + "LEFT JOIN Customer c ON o.CustomerId = c.CustomerId "
                + "LEFT JOIN Employee cr ON o.CreatedBy = cr.EmployeeId "
                + "LEFT JOIN Employee sl ON o.SaleBy = sl.EmployeeId "
                + "LEFT JOIN Store s ON o.StoreId = s.StoreId "
                + "ORDER BY o.OrderId DESC";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setStatus(rs.getString("Status"));

                // Customer
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("CustomerId"));
                customer.setFirstName(rs.getString("CFirstName"));
                customer.setMiddleName(rs.getString("CMiddleName"));
                customer.setLastName(rs.getString("CLastName"));
                customer.setPhone(rs.getString("CPhone"));
                customer.setEmail(rs.getString("CEmail"));
                customer.setGender(rs.getString("CGender"));
                customer.setAddress(rs.getString("CAddress"));
                customer.setStatus(rs.getString("CStatus"));
                customer.setTaxCode(rs.getString("CTaxCode"));
                customer.setWardId((Integer) rs.getObject("CWardId"));
                customer.setDob(rs.getDate("CDob"));
                order.setCustomer(customer);

                // CreatedBy Employee
                Employee createdBy = new Employee();
                createdBy.setEmployeeId(rs.getInt("CreatedById"));
                createdBy.setFirstName(rs.getString("CrFirstName"));
                createdBy.setMiddleName(rs.getString("CrMiddleName"));
                createdBy.setLastName(rs.getString("CrLastName"));
                createdBy.setPhone(rs.getString("CrPhone"));
                createdBy.setEmail(rs.getString("CrEmail"));
                createdBy.setGender(rs.getString("CrGender"));
                createdBy.setAddress(rs.getString("CrAddress"));
                createdBy.setStatus(rs.getString("CrStatus"));
                createdBy.setRoleId(rs.getInt("CrRoleId"));
                createdBy.setStoreId(rs.getInt("CrStoreId"));
                createdBy.setWardId((Integer) rs.getObject("CrWardId"));
                createdBy.setDob(rs.getDate("CrDob"));
                order.setCreatedBy(createdBy);

                // SaleBy Employee
                Employee saleBy = new Employee();
                saleBy.setEmployeeId(rs.getInt("SaleById"));
                saleBy.setFirstName(rs.getString("SlFirstName"));
                saleBy.setMiddleName(rs.getString("SlMiddleName"));
                saleBy.setLastName(rs.getString("SlLastName"));
                saleBy.setPhone(rs.getString("SlPhone"));
                saleBy.setEmail(rs.getString("SlEmail"));
                saleBy.setGender(rs.getString("SlGender"));
                saleBy.setAddress(rs.getString("SlAddress"));
                saleBy.setStatus(rs.getString("SlStatus"));
                saleBy.setRoleId(rs.getInt("SlRoleId"));
                saleBy.setStoreId(rs.getInt("SlStoreId"));
                saleBy.setWardId((Integer) rs.getObject("SlWardId"));
                saleBy.setDob(rs.getDate("SlDob"));
                order.setSaleBy(saleBy);

                // Store
                Store store = new Store();
                store.setStoreId(rs.getInt("StoreId"));
                store.setStoreName(rs.getString("StoreName"));
                store.setAddress(rs.getString("SAddress"));
                store.setPhone(rs.getString("SPhone"));
                store.setStatus(rs.getString("SStatus"));
                order.setStore(store);

                // Lấy danh sách chi tiết đơn hàng cho mỗi order
                order.setOrderDetails(getOrderDetails(order.getOrderId()));
                orders.add(order);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllOrders() failed", e);
        }
        return orders;
    }

    // Lấy chi tiết đơn hàng theo ID
    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = "SELECT o.OrderId, o.OrderDate, o.Status, o.CustomerId, o.CreatedBy, o.SaleBy, o.StoreId, "
                + "c.FirstName AS CFirstName, c.MiddleName AS CMiddleName, c.LastName AS CLLastName, c.Phone AS CPhone, c.Email AS CEmail, c.Gender AS CGender, c.Address AS CAddress, c.Status AS CStatus, c.TaxCode AS CTaxCode, c.WardId AS CWardId, c.Dob AS CDob, "
                + "cr.EmployeeId AS CreatedById, cr.FirstName AS CrFirstName, cr.MiddleName AS CrMiddleName, cr.LastName AS CrLastName, cr.Phone AS CrPhone, cr.Email AS CrEmail, cr.Gender AS CrGender, cr.Address AS CrAddress, cr.Status AS CrStatus, cr.RoleId AS CrRoleId, cr.StoreId AS CrStoreId, cr.WardId AS CrWardId, cr.Dob AS CrDob, "
                + "sl.EmployeeId AS SaleById, sl.FirstName AS SlFirstName, sl.MiddleName AS SlMiddleName, sl.LastName AS SlLastName, sl.Phone AS SlPhone, sl.Email AS SlEmail, sl.Gender AS SlGender, sl.Address AS SlAddress, sl.Status AS SlStatus, sl.RoleId AS SlRoleId, sl.StoreId AS SlStoreId, sl.WardId AS SlWardId, sl.Dob AS SlDob, "
                + "s.StoreId, s.StoreName, s.Address AS SAddress, s.Phone AS SPhone, s.Status AS SStatus "
                + "FROM [Order] o "
                + "LEFT JOIN Customer c ON o.CustomerId = c.CustomerId "
                + "LEFT JOIN Employee cr ON o.CreatedBy = cr.EmployeeId "
                + "LEFT JOIN Employee sl ON o.SaleBy = sl.EmployeeId "
                + "LEFT JOIN Store s ON o.StoreId = s.StoreId "
                + "WHERE o.OrderId = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setOrderId(rs.getInt("OrderId"));
                    order.setOrderDate(rs.getDate("OrderDate"));
                    order.setStatus(rs.getString("Status"));

                    // Customer
                    Customer customer = null;
                    if (rs.getObject("CustomerId") != null) {
                        customer = new Customer();
                        customer.setCustomerId(rs.getInt("CustomerId"));
                        customer.setFirstName(rs.getString("CFirstName"));
                        customer.setMiddleName(rs.getString("CMiddleName"));
                        customer.setLastName(rs.getString("CLLastName"));
                        customer.setPhone(rs.getString("CPhone"));
                        customer.setEmail(rs.getString("CEmail"));
                        customer.setGender(rs.getString("CGender"));
                        customer.setAddress(rs.getString("CAddress"));
                        customer.setStatus(rs.getString("CStatus"));
                        customer.setTaxCode(rs.getString("CTaxCode"));
                        customer.setWardId((Integer) rs.getObject("CWardId"));
                        customer.setDob(rs.getDate("CDob"));
                    }
                    order.setCustomer(customer);

                    // CreatedBy Employee
                    Employee createdBy = null;
                    if (rs.getObject("CreatedById") != null) {
                        createdBy = new Employee();
                        createdBy.setEmployeeId(rs.getInt("CreatedById"));
                        createdBy.setFirstName(rs.getString("CrFirstName"));
                        createdBy.setMiddleName(rs.getString("CrMiddleName"));
                        createdBy.setLastName(rs.getString("CrLastName"));
                        createdBy.setPhone(rs.getString("CrPhone"));
                        createdBy.setEmail(rs.getString("CrEmail"));
                        createdBy.setGender(rs.getString("CrGender"));
                        createdBy.setAddress(rs.getString("CrAddress"));
                        createdBy.setStatus(rs.getString("CrStatus"));
                        createdBy.setRoleId(rs.getInt("CrRoleId"));
                        createdBy.setStoreId(rs.getInt("CrStoreId"));
                        createdBy.setWardId((Integer) rs.getObject("CrWardId"));
                        createdBy.setDob(rs.getDate("CrDob"));
                    }
                    order.setCreatedBy(createdBy);

                    // SaleBy Employee
                    Employee saleBy = null;
                    if (rs.getObject("SaleById") != null) {
                        saleBy = new Employee();
                        saleBy.setEmployeeId(rs.getInt("SaleById"));
                        saleBy.setFirstName(rs.getString("SlFirstName"));
                        saleBy.setMiddleName(rs.getString("SlMiddleName"));
                        saleBy.setLastName(rs.getString("SlLastName"));
                        saleBy.setPhone(rs.getString("SlPhone"));
                        saleBy.setEmail(rs.getString("SlEmail"));
                        saleBy.setGender(rs.getString("SlGender"));
                        saleBy.setAddress(rs.getString("SlAddress"));
                        saleBy.setStatus(rs.getString("SlStatus"));
                        saleBy.setRoleId(rs.getInt("SlRoleId"));
                        saleBy.setStoreId(rs.getInt("SlStoreId"));
                        saleBy.setWardId((Integer) rs.getObject("SlWardId"));
                        saleBy.setDob(rs.getDate("SlDob"));
                    }
                    order.setSaleBy(saleBy);

                    // Store
                    Store store = null;
                    if (rs.getObject("StoreId") != null) {
                        store = new Store();
                        store.setStoreId(rs.getInt("StoreId"));
                        store.setStoreName(rs.getString("StoreName"));
                        store.setAddress(rs.getString("SAddress"));
                        store.setPhone(rs.getString("SPhone"));
                        store.setStatus(rs.getString("SStatus"));
                    }
                    order.setStore(store);
                }
            }
            if (order != null) {
                // Lấy chi tiết sản phẩm của đơn hàng
                order.setOrderDetails(getOrderDetails(orderId));
            }
        } catch (Exception e) {
            throw new RuntimeException("getOrderById() failed", e);
        }
        return order;
    }

    // Lấy danh sách chi tiết đơn hàng
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetail WHERE OrderId = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setOrderId(rs.getInt("OrderId"));
                    detail.setProductVariantId(rs.getInt("ProductVariantId"));
                    detail.setProductName(rs.getString("ProductName"));
                    detail.setPrice(rs.getDouble("Price"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    detail.setDiscount(rs.getObject("Discount") != null ? rs.getDouble("Discount") : null);
                    detail.setTaxRate(rs.getObject("TaxRate") != null ? rs.getDouble("TaxRate") : null);
                    detail.setTotalAmount(rs.getDouble("TotalAmount"));
                    detail.setStatus(rs.getString("Status"));
                    details.add(detail);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("getOrderDetails() failed", e);
        }
        return details;
    }

    // Tạo mới đơn hàng
    public boolean createOrder(Order order) {
        String sqlOrder = "INSERT INTO [Order] (OrderDate, Status, CustomerId, CreatedBy, SaleBy, StoreId) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO OrderDetail (OrderId, ProductVariantId, ProductName, Price, Quantity, Discount, TaxRate, TotalAmount, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;
        try {
            con = DBContext.getConnection();
            con.setAutoCommit(false);
            psOrder = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setDate(1, order.getOrderDate());
            psOrder.setString(2, order.getStatus());
            psOrder.setInt(3, order.getCustomer().getCustomerId());
            psOrder.setInt(4, order.getCreatedBy().getEmployeeId());
            psOrder.setInt(5, order.getSaleBy().getEmployeeId());
            psOrder.setInt(6, order.getStore().getStoreId());
            int affectedRows = psOrder.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }
            rs = psOrder.getGeneratedKeys();
            int newOrderId = -1;
            if (rs.next()) {
                newOrderId = rs.getInt(1);
            }
            // Thêm chi tiết đơn hàng
            psDetail = con.prepareStatement(sqlDetail);
            for (OrderDetail detail : order.getOrderDetails()) {
                psDetail.setInt(1, newOrderId);
                psDetail.setInt(2, detail.getProductVariantId());
                psDetail.setString(3, detail.getProductName());
                psDetail.setDouble(4, detail.getPrice());
                psDetail.setInt(5, detail.getQuantity());
                if (detail.getDiscount() != null) {
                    psDetail.setDouble(6, detail.getDiscount());
                } else {
                    psDetail.setNull(6, Types.FLOAT);
                }
                if (detail.getTaxRate() != null) {
                    psDetail.setDouble(7, detail.getTaxRate());
                } else {
                    psDetail.setNull(7, Types.FLOAT);
                }
                psDetail.setDouble(8, detail.getTotalAmount());
                psDetail.setString(9, detail.getStatus());
                psDetail.addBatch();
            }
            psDetail.executeBatch();
            con.commit();
            return true;
        } catch (Exception e) {
            if (con != null) try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw new RuntimeException("createOrder() failed", e);
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(psOrder);
            DBContext.closeConnection(psDetail);
            DBContext.closeConnection(con);
        }
    }

    // Cập nhật đơn hàng (chỉ cho phép khi trạng thái là pending)
    public boolean updateOrder(Order order) {
        String sqlCheck = "SELECT Status FROM [Order] WHERE OrderId = ?";
        String sqlUpdateOrder = "UPDATE [Order] SET OrderDate = ?, Status = ?, CustomerId = ?, CreatedBy = ?, SaleBy = ?, StoreId = ? WHERE OrderId = ?";
        String sqlDeleteDetails = "DELETE FROM OrderDetail WHERE OrderId = ?";
        String sqlInsertDetail = "INSERT INTO OrderDetail (OrderId, ProductVariantId, ProductName, Price, Quantity, Discount, TaxRate, TotalAmount, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement psCheck = null, psUpdateOrder = null, psDeleteDetails = null, psInsertDetail = null;
        ResultSet rs = null;
        try {
            con = DBContext.getConnection();
            con.setAutoCommit(false);
            // Kiểm tra trạng thái
            psCheck = con.prepareStatement(sqlCheck);
            psCheck.setInt(1, order.getOrderId());
            rs = psCheck.executeQuery();
            if (rs.next()) {
                String status = rs.getString("Status");
                if (!"Pending".equalsIgnoreCase(status)) {
                    return false; // Chỉ cho phép cập nhật khi trạng thái là pending
                }
            } else {
                return false; // Không tìm thấy đơn hàng
            }
            // Cập nhật đơn hàng
            psUpdateOrder = con.prepareStatement(sqlUpdateOrder);
            psUpdateOrder.setDate(1, order.getOrderDate());
            psUpdateOrder.setString(2, order.getStatus());
            psUpdateOrder.setInt(3, order.getCustomer().getCustomerId());
            psUpdateOrder.setInt(4, order.getCreatedBy().getEmployeeId());
            psUpdateOrder.setInt(5, order.getSaleBy().getEmployeeId());
            psUpdateOrder.setInt(6, order.getStore().getStoreId());
            psUpdateOrder.setInt(7, order.getOrderId());
            psUpdateOrder.executeUpdate();
            // Xóa chi tiết cũ
            psDeleteDetails = con.prepareStatement(sqlDeleteDetails);
            psDeleteDetails.setInt(1, order.getOrderId());
            psDeleteDetails.executeUpdate();
            // Thêm chi tiết mới
            psInsertDetail = con.prepareStatement(sqlInsertDetail);
            for (OrderDetail detail : order.getOrderDetails()) {
                psInsertDetail.setInt(1, order.getOrderId());
                psInsertDetail.setInt(2, detail.getProductVariantId());
                psInsertDetail.setString(3, detail.getProductName());
                psInsertDetail.setDouble(4, detail.getPrice());
                psInsertDetail.setInt(5, detail.getQuantity());
                if (detail.getDiscount() != null) {
                    psInsertDetail.setDouble(6, detail.getDiscount());
                } else {
                    psInsertDetail.setNull(6, Types.FLOAT);
                }
                if (detail.getTaxRate() != null) {
                    psInsertDetail.setDouble(7, detail.getTaxRate());
                } else {
                    psInsertDetail.setNull(7, Types.FLOAT);
                }
                psInsertDetail.setDouble(8, detail.getTotalAmount());
                psInsertDetail.setString(9, detail.getStatus());
                psInsertDetail.addBatch();
            }
            psInsertDetail.executeBatch();
            con.commit();
            return true;
        } catch (Exception e) {
            if (con != null) try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw new RuntimeException("updateOrder() failed", e);
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(psCheck);
            DBContext.closeConnection(psUpdateOrder);
            DBContext.closeConnection(psDeleteDetails);
            DBContext.closeConnection(psInsertDetail);
            DBContext.closeConnection(con);
        }
    }

    public List<Order> getCompletedOrders(String searchKey, int limit, int offset) {
        List<Order> odList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.[OrderId], o.[OrderDate], o.[Status], o.[CustomerId], "
                + "       o.[CreatedBy], o.[SaleBy], o.[StoreId], "
                + "       (c.FirstName + ' ' + ISNULL(c.MiddleName, '') + ' ' + c.LastName) AS CustomerName, "
                + "       (e.FirstName + ' ' + ISNULL(e.MiddleName, '') + ' ' + e.LastName) AS SaleName, "
                + "       s.StoreName "
                + "FROM [SWP391_M_BL5_G2_SU25].[dbo].[Order] o "
                + "JOIN [SWP391_M_BL5_G2_SU25].[dbo].[Customer] c ON o.CustomerId = c.CustomerId "
                + "JOIN [SWP391_M_BL5_G2_SU25].[dbo].[Employee] e ON o.SaleBy = e.EmployeeId "
                + "JOIN [SWP391_M_BL5_G2_SU25].[dbo].[Store] s ON o.StoreId = s.StoreId "
                + "WHERE o.Status = 'Completed' "
        );

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append("AND ( (c.FirstName + ' ' + ISNULL(c.MiddleName, '') + ' ' + c.LastName) LIKE ? ")
                    .append("   OR (e.FirstName + ' ' + ISNULL(e.MiddleName, '') + ' ' + e.LastName) LIKE ? ")
                    .append("   OR s.StoreName LIKE ? ) ");
        }

        sql.append("ORDER BY o.OrderDate DESC ")
                .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (searchKey != null && !searchKey.trim().isEmpty()) {
                String likeKey = "%" + searchKey.trim() + "%";
                ps.setString(paramIndex++, likeKey);
                ps.setString(paramIndex++, likeKey);
                ps.setString(paramIndex++, likeKey);
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);

            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setStatus(rs.getString("Status"));

                Customer c = new Customer();
                c.setCustomerId(rs.getInt("CustomerId"));
                order.setCustomer(c);

                Employee e = new Employee();
                e.setEmployeeId(rs.getInt("CreatedBy"));
                order.setCreatedBy(e);

                Employee es = new Employee();
                es.setEmployeeId(rs.getInt("SaleBy"));
                order.setSaleBy(es);

                Store s = new Store();
                s.setStoreId(rs.getInt("StoreId"));
                order.setStore(s);

                odList.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ignore) {
            }
        }

        return odList;
    }

}
