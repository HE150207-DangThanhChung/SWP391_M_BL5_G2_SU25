<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <c:if test="${not empty error}">
        <div style="color:red;">${error}</div>
    </c:if>
    <c:if test="${not empty order}">
        <table>
            <tr><th>Mã đơn hàng</th><td>${order.orderId}</td></tr>
            <tr><th>Ngày đặt</th><td>${order.orderDate}</td></tr>
            <tr><th>Trạng thái</th><td>${order.status}</td></tr>
            <tr><th>Khách hàng</th>
                <td>
                    <c:choose>
    <c:when test="${order.customer != null}">
        ${order.customer.fullName}
    </c:when>
    <c:otherwise>
        Không có thông tin khách hàng
    </c:otherwise>
</c:choose>
                </td>
            </tr>
            <tr><th>Người tạo</th>
                <td>
                   <c:choose>
    <c:when test="${order.createdBy != null}">
        ${order.createdBy.fullName}
    </c:when>
    <c:otherwise>
        Không có thông tin người tạo
    </c:otherwise>
</c:choose>
                </td>
            </tr>
            <tr><th>Người bán</th>
                <td>
                    <c:choose>
                        <c:when test="${order.saleBy != null}">
                            ${order.saleBy.fullName}
                        </c:when>
                        <c:otherwise>
                            Không có thông tin người bán
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr><th>Cửa hàng</th>
                <td>
                    <c:choose>
                        <c:when test="${order.store != null}">
                            ${order.store.storeName}
                        </c:when>
                        <c:otherwise>
                            Không có thông tin cửa hàng
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>

        <h3>Danh sách sản phẩm</h3>
        <table>
            <tr>
                <th>Mã biến thể</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Giảm giá</th>
                <th>Thuế</th>
                <th>Thành tiền</th>
                <th>Trạng thái</th>
            </tr>
            <c:forEach var="detail" items="${order.orderDetails}">
                <tr>
                    <td>${detail.productVariantId}</td>
                    <td>${detail.productName}</td>
                    <td>${detail.price}</td>
                    <td>${detail.quantity}</td>
                    <td>${detail.discount}</td>
                    <td>${detail.taxRate}</td>
                    <td>${detail.totalAmount}</td>
                    <td>${detail.status}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty order}">
        <table>
            <tr><th>Mã đơn hàng</th><td>${order.orderId}</td></tr>
            <tr><th>Ngày đặt</th><td>${order.orderDate}</td></tr>
            <tr><th>Trạng thái</th><td>${order.status}</td></tr>
            
            <!-- Khách hàng -->
            <tr><th>Khách hàng</th>
                <td>
                    <c:choose>
                        <c:when test="${order.customer != null}">
                            ${order.customer.fullName}
                        </c:when>
                        <c:otherwise>
                            Không có thông tin khách hàng
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <!-- Người tạo -->
            <tr><th>Người tạo</th>
                <td>
                    <c:choose>
                        <c:when test="${order.createdBy != null}">
                            ${order.createdBy.fullName}
                        </c:when>
                        <c:otherwise>
                            Không có thông tin người tạo
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <!-- Người bán -->
            <tr><th>Người bán</th>
                <td>
                    <c:choose>
                        <c:when test="${order.saleBy != null}">
                            ${order.saleBy.fullName}
                        </c:when>
                        <c:otherwise>
                            Không có thông tin người bán
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <!-- Cửa hàng -->
            <tr><th>Cửa hàng</th>
                <td>
                    <c:choose>
                        <c:when test="${order.store != null}">
                            ${order.store.storeName}
                        </c:when>
                        <c:otherwise>
                            Không có thông tin cửa hàng
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>

        <h3>Danh sách sản phẩm</h3>
        <table>
            <tr>
                <th>Mã biến thể</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Giảm giá</th>
                <th>Thuế</th>
                <th>Thành tiền</th>
                <th>Trạng thái</th>
            </tr>
            <c:forEach var="detail" items="${order.orderDetails}">
                <tr>
                    <td>${detail.productVariantId}</td>
                    <td>${detail.productName}</td>
                    <td>${detail.price}</td>
                    <td>${detail.quantity}</td>
                    <td>${detail.discount}</td>
                    <td>${detail.taxRate}</td>
                    <td>${detail.totalAmount}</td>
                    <td>${detail.status}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <a href="${pageContext.request.contextPath}/orders">Quay lại danh sách đơn hàng</a>
</body>
</html>
