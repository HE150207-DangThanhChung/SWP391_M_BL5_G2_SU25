//package dal;
//
//import model.OrderCoupon;
//import org.junit.Test;
//import static org.junit.Assert.*;
//import java.sql.Timestamp;
//
//public class OrderCouponDAOTest {
//    private OrderCouponDAO dao = new OrderCouponDAO();
//
//    @Test
//    public void testInsertOrderCoupon() {
//        // Create a new OrderCoupon object
//        OrderCoupon oc = new OrderCoupon();
//        oc.setOrderId(1); // Đảm bảo OrderId này tồn tại trong database
//        oc.setCouponId(1); // Đảm bảo CouponId này tồn tại trong database
//        oc.setAppliedAmount(50000.0); // Giả sử giảm giá 50,000 VND
//        
//        // Test insert
//        boolean result = dao.insert(oc);
//        assertTrue("Insert OrderCoupon should succeed", result);
//        
//        // Verify the inserted data
//        OrderCoupon inserted = dao.getByIds(oc.getOrderId(), oc.getCouponId());
//        assertNotNull("Should be able to retrieve inserted OrderCoupon", inserted);
//        assertEquals("OrderId should match", oc.getOrderId(), inserted.getOrderId());
//        assertEquals("CouponId should match", oc.getCouponId(), inserted.getCouponId());
//        assertEquals("AppliedAmount should match", oc.getAppliedAmount(), inserted.getAppliedAmount(), 0.01);
//        assertNotNull("AppliedAt should be set", inserted.getAppliedAt());
//        
//        // Clean up - delete the test data
//        dao.delete(oc.getOrderId(), oc.getCouponId());
//    }
//
//    @Test
//    public void testInsertDuplicateOrderCoupon() {
//        OrderCoupon oc1 = new OrderCoupon();
//        oc1.setOrderId(1);
//        oc1.setCouponId(1);
//        oc1.setAppliedAmount(50000.0);
//        
//        // Insert first time should succeed
//        boolean firstResult = dao.insert(oc1);
//        assertTrue("First insert should succeed", firstResult);
//        
//        // Try to insert the same OrderCoupon again
//        OrderCoupon oc2 = new OrderCoupon();
//        oc2.setOrderId(1);
//        oc2.setCouponId(1);
//        oc2.setAppliedAmount(60000.0);
//        
//        // Should fail due to primary key constraint
//        boolean secondResult = dao.insert(oc2);
//        assertFalse("Second insert should fail due to duplicate key", secondResult);
//        
//        // Clean up
//        dao.delete(oc1.getOrderId(), oc1.getCouponId());
//    }
//
//    @Test
//    public void testInsertWithInvalidIds() {
//        OrderCoupon oc = new OrderCoupon();
//        oc.setOrderId(-1); // Invalid Order ID
//        oc.setCouponId(-1); // Invalid Coupon ID
//        oc.setAppliedAmount(50000.0);
//        
//        // Should fail due to foreign key constraints
//        boolean result = dao.insert(oc);
//        assertFalse("Insert with invalid IDs should fail", result);
//    }
//}
