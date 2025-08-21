<%-- 
    Document   : listCustomer
    Created on : Aug 13, 2025, 8:46:45 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách khách hàng</title>
        <style>
            :root{
                --page:#f7fafc;
                --panel:#e6f3ff;
                --chip:#a7f6ff;
                --ink:#0f172a;
                --accent:#ff0e7a;
                --stroke:#2b6777;
                --head:#bcd9ff;
                --shadow:0 8px 20px rgba(0,0,0,.06);
                --radius:12px;
            }
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                padding:28px;
                background:var(--page);
                color:var(--ink);
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif
            }

            .toolbar{
                background:var(--panel);
                border:2px solid #b9d6ff;
                border-radius:16px;
                padding:12px;
                display:flex;
                flex-wrap:wrap;
                gap:12px;
                align-items:center;
                box-shadow:var(--shadow)
            }
            .toolbar input[type=text]{
                flex:1 1 380px;
                min-width:240px;
                padding:10px 14px;
                border:2px solid var(--stroke);
                border-radius:12px;
                background:var(--chip);
                font-weight:600
            }
            .btn{
                background:var(--chip);
                border:2px solid var(--stroke);
                border-radius:12px;
                padding:10px 16px;
                font-weight:700;
                cursor:pointer
            }
            .btn:hover{
                box-shadow:var(--shadow)
            }
            .btn-ghost{
                background:#fff
            }

            .table-wrap{
                margin-top:14px;
                background:#fff;
                border:2px solid #c9d7e3;
                border-radius:10px;
                overflow:hidden
            }
            table{
                width:100%;
                border-collapse:collapse
            }
            thead th{
                background:var(--head);
                text-align:left;
                padding:10px;
                border-bottom:2px solid #a8c6e8
            }
            tbody td{
                padding:12px 10px;
                border-bottom:1px solid #e6eef6
            }

            .col-actions{
                width:140px
            }
            .act{
                display:inline-block;
                min-width:70px;
                text-align:center;
                padding:8px 12px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:var(--chip);
                margin-right:8px
            }
            .act--danger{
                background:#ffd7e2
            }

            .footer-bar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                gap:14px;
                background:var(--panel);
                border:2px solid #b9d6ff;
                border-radius:12px;
                padding:12px 16px;
                margin-top:18px
            }
            .summary{
                font-weight:700
            }

            .pager{
                display:flex;
                align-items:center;
                gap:8px
            }
            .page{
                display:inline-block;
                min-width:32px;
                text-align:center;
                padding:6px 10px;
                border:2px solid var(--stroke);
                border-radius:8px;
                background:#fff;
                text-decoration:none;
                color:inherit
            }
            .page--current{
                background:var(--chip);
                font-weight:800
            }

            /* Responsive */
            @media (max-width: 960px){
                .col-hide-md{
                    display:none
                }
            }
            @media (max-width: 720px){
                .col-hide-sm{
                    display:none
                }
                .toolbar{
                    padding:10px
                }
            }
            .badge{
                display:inline-block;
                padding:4px 10px;
                /*border-radius:999px;*/
                font-weight:700;
                font-size:12px;
                line-height:1;
            }
            .badge--success{
                background:#dcfce7;             /* light green */
                color:#166534 !important;        /* dark green text */
                border:1px solid #86efac;
            }
            .badge--muted{
                background:#e2e8f0;             /* light gray */
                color:#334155 !important;        /* slate text */
                border:1px solid #cbd5e1;
            }


            .status{
                color: inherit !important;
                border: none;
            }
            .filter {
                background-color: #9b5cf1;
                color: white;
                border-radius: 15px;
            }
            body a{

                text-decoration: none;

            }
        </style>
    </head>
    <body>
        <div class="layout-wrapper d-flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content">
                    <c:set var="ctx" value="${pageContext.request.contextPath}"/>

                    <!-- Toolbar / Search & Filters -->
                    <div class="toolbar">
                        <form action="${ctx}/customer" method="get" class="d-flex" style="gap:.5rem;flex-wrap:wrap;">
                            <input type="hidden" name="action" value="list"/>
                            <input type="text" name="search" value="${fn:escapeXml(search)}"
                                   placeholder="Tìm theo tên, email hoặc điện thoại"/>

                            <select name="status" class="filter">
                                <option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="Active" ${status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="Banned" ${status == 'Banned' ? 'selected' : ''}>Bị khóa</option>
                            </select>

                            <select name="size" class="filter">
                                <c:forEach var="s" items="${fn:split('5,10,20,50', ',')}">
                                    <option value="${s}" ${size == s ? 'selected' : ''}>${s}/trang</option>
                                </c:forEach>
                            </select>

                            <button class="btn" type="submit">Tìm kiếm</button>
                            <a class="btn btn-ghost" href="${ctx}/customer?action=list">Đặt lại</a>
                            <a class="btn" href="${ctx}/customer?action=addForm">Thêm mới</a>
                        </form>
                    </div>

                    <!-- Flash message (optional) -->
                    <c:if test="${not empty param.msg}">
                        <div class="alert">
                            <c:choose>
                                <c:when test="${param.msg eq 'added'}">Thêm khách hàng thành công.</c:when>
                                <c:when test="${param.msg eq 'updated'}">Cập nhật khách hàng thành công.</c:when>
                                <c:otherwise>Thao tác đã thực hiện.</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- Data table -->
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>
                                        <c:set var="dirId" value="${(sortBy eq 'id' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=id&sortDir=${dirId}&page=1&size=${size}">
                                            Mã KH
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="dirName" value="${(sortBy eq 'name' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=name&sortDir=${dirName}&page=1&size=${size}">
                                            Họ tên
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="dirEmail" value="${(sortBy eq 'email' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=email&sortDir=${dirEmail}&page=1&size=${size}">
                                            Email
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="dirPhone" value="${(sortBy eq 'phone' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=phone&sortDir=${dirPhone}&page=1&size=${size}">
                                            Điện thoại
                                        </a>
                                    </th>
                                    <th>Giới tính</th>
                                    <th class="col-hide-sm">Địa chỉ</th>
                                    <th class="col-hide-md">Phường/Xã</th>
                                    <th class="col-hide-md">Tỉnh/Thành</th>
                                    <th>
                                        <c:set var="dirDob" value="${(sortBy eq 'dob' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=dob&sortDir=${dirDob}&page=1&size=${size}">
                                            Ngày sinh
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="dirStatus" value="${(sortBy eq 'status' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=status&sortDir=${dirStatus}&page=1&size=${size}">
                                            Trạng thái
                                        </a>
                                    </th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:if test="${empty listCustomers}">
                                    <tr>
                                        <td colspan="12" style="text-align:center;">Không có dữ liệu.</td>
                                    </tr>
                                </c:if>

                                <c:forEach items="${listCustomers}" var="c">
                                    <tr>
                                        <td>${c.customerId}</td>
                                        <td>
                                            <a class="link" href="${ctx}/customer?action=view&customerId=${c.customerId}">
                                                ${c.fullName}
                                            </a>
                                        </td>
                                        <td>${c.email}</td>
                                        <td>${c.phone}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.gender eq 'Male'}">
                                                    <span class="badge badge--success status">Nam</span>
                                                </c:when>
                                                <c:when test="${c.gender eq 'Female'}">
                                                    <span class="badge badge--muted status">Nữ</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge--muted status">Khác</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-hide-sm">${c.address}</td>
                                        <td class="col-hide-md">${empty c.wardName ? '-' : c.wardName}</td>
                                        <td class="col-hide-md">${empty c.cityName ? '-' : c.cityName}</td>
                                        <td><fmt:formatDate value="${c.dob}" pattern="yyyy-MM-dd"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status eq 'Active'}">
                                                    <span class="badge badge--success status">Đang hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge--muted status">Bị khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <!-- Edit (GET), same as Coupon -->
                                            <form method="get" action="${ctx}/customer" style="display:inline;">
                                                <input type="hidden" name="action" value="editForm"/>
                                                <input type="hidden" name="customerId" value="${c.customerId}"/>
                                                <button type="submit" class="act">Sửa</button>
                                            </form>

                                            <!-- Toggle status (POST), same pattern as Coupon -->
                                            <form method="post" action="${ctx}/customer" style="display:inline;"
                                                  onsubmit="return confirm('Xác nhận cập nhật trạng thái?');">
                                                <input type="hidden" name="action" value="updateStatus"/>
                                                <input type="hidden" name="customerId" value="${c.customerId}"/>
                                                <input type="hidden" name="status" value="${c.status eq 'Active' ? 'Banned' : 'Active'}"/>
                                                <button type="submit" class="act act--danger">
                                                    ${c.status eq 'Active' ? 'Khóa' : 'Kích hoạt'}
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Footer: summary & pagination -->
                    <div class="footer-bar">
                        <div class="summary">Tổng có <strong>${totalRecords}</strong> bản ghi</div>
                        <div>Hiển thị <strong>${size}</strong> mỗi trang</div>

                        <c:set var="prev" value="${page > 1 ? page - 1 : 1}"/>
                        <c:set var="next" value="${page < totalPages ? page + 1 : totalPages}"/>

                        <!-- windowed page range -->
                        <c:set var="start" value="${page - 2}"/>
                        <c:if test="${start < 1}"><c:set var="start" value="1"/></c:if>
                        <c:set var="end" value="${start + 4}"/>
                        <c:if test="${end > totalPages}"><c:set var="end" value="${totalPages}"/></c:if>
                        <c:if test="${start > end}"><c:set var="start" value="${end}"/></c:if>

                            <nav class="pager" aria-label="Pagination">
                                <a class="page" href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=1&size=${size}" aria-label="Trang đầu">≪</a>

                            <a class="page" href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=${prev}&size=${size}" aria-label="Trước">‹</a>

                            <c:forEach var="p" begin="${start}" end="${end}">
                                <a class="page ${p == page ? 'page--current' : ''}"
                                   href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                                   &sortBy=${sortBy}&sortDir=${sortDir}&page=${p}&size=${size}">${p}</a>
                            </c:forEach>

                            <a class="page" href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=${next}&size=${size}" aria-label="Sau">›</a>

                            <a class="page" href="${ctx}/customer?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=${totalPages}&size=${size}" aria-label="Cuối">≫</a>
                        </nav>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>
    </body>
</html>
