//package dal;
//
//import model.*;
//import org.junit.Test;
//import static org.junit.Assert.*;
//import java.util.List;
//import java.sql.Date;
//
//public class DAOTest {
//   
//   private ProductDAO productDAO;
//   private OrderDAO orderDAO;
//   private CustomerDAO customerDAO;
//   private CategoryDAO categoryDAO;
//   private SupplierDAO supplierDAO;
//   
//   public DAOTest() {
//       productDAO = new ProductDAO();
//       orderDAO = new OrderDAO();
//       customerDAO = new CustomerDAO();
//       categoryDAO = new CategoryDAO();
//       supplierDAO = new SupplierDAO();
//   }
//   
//   @Test
//   public void testProductDAO() {
//       // Test get all products
//       List<Product> products = productDAO.getAllProducts();
//       assertNotNull("Products list should not be null", products);
//       
//       // Test get product by ID 
//       Product product = productDAO.getProductById(1);
//       assertNotNull("Product should not be null", product);
//       
//       // Test search product
//       List<Product> searchResults = productDAO.searchProducts("test");
//       assertNotNull("Search results should not be null", searchResults);
//   }
//   
//   @Test 
//   public void testOrderDAO() {
//       // Test get all orders
//       List<Order> orders = orderDAO.getAllOrders();
//       assertNotNull("Orders list should not be null", orders);
//       
//       // Test get order by ID
//       Order order = orderDAO.getOrderById(1);
//       assertNotNull("Order should not be null", order);
//       
//       // Test create order
//       Order newOrder = new Order();
//       newOrder.setCustomerId(1);
//       newOrder.setOrderDate(new Date(System.currentTimeMillis()));
//       newOrder.setStatus("Pending");
//       boolean created = orderDAO.createOrder(newOrder);
//       assertTrue("Order should be created successfully", created);
//   }
//   
//   @Test
//   public void testCustomerDAO() {
//       // Test get all customers
//       List<Customer> customers = customerDAO.getAllCustomers();
//       assertNotNull("Customers list should not be null", customers);
//       
//       // Test get customer by ID
//       Customer customer = customerDAO.getCustomerById(1);
//       assertNotNull("Customer should not be null", customer);
//       
//       // Test customer authentication
//       Customer authCustomer = customerDAO.authenticate("test@email.com", "password");
//       assertNotNull("Customer authentication should work", authCustomer);
//   }
//   
//   @Test
//   public void testCategoryDAO() {
//       // Test get all categories
//       List<Category> categories = categoryDAO.getAllCategories();
//       assertNotNull("Categories list should not be null", categories);
//       
//       // Test get category by ID
//       Category category = categoryDAO.getCategoryById(1);
//       assertNotNull("Category should not be null", category);
//   }
//   
//   @Test
//   public void testSupplierDAO() {
//       // Test get all suppliers 
//       List<Supplier> suppliers = supplierDAO.getAllSuppliers();
//       assertNotNull("Suppliers list should not be null", suppliers);
//       
//       // Test get supplier by ID
//       Supplier supplier = supplierDAO.getSupplierById(1);
//       assertNotNull("Supplier should not be null", supplier);
//   }
//}
