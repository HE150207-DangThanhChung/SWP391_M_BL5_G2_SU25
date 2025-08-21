<%-- 
    Document   : listCoupon
    Created on : Aug 14, 2025, 8:40:49 AM
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
        <title>Mã Khuyến Mãi</title>
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
                /*--radius:12px;*/
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
            body a{
                
                text-decoration: none;
            
            }

            .toolbar{
                background:var(--panel);
                border:2px solid #b9d6ff;
                /*border-radius:16px;*/
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
                /*border-radius:12px;*/
                background:var(--chip);
                font-weight:600
            }
            .btn{
                background:var(--chip);
                border:2px solid var(--stroke);
                /*border-radius:12px;*/
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
                /*border-radius:10px;*/
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
                /*border-radius:12px;*/
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
                /*border-radius:8px;*/
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
            /* 1) Make the page span the viewport height */
            html, body {
                height: 100%;
            }

            body {
                font-family: "Inter", sans-serif;
                background-color: #f9fafb;
                color: #374151;
                margin: 0;
                padding: 0;
            }

            /* 2) Ensure the outer wrapper and right panel are full-height flex columns */
            .layout-wrapper {
                display: flex;
                min-height: 100vh;       /* key */
            }

            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;  /* header | main | footer stacked */
                min-height: 100vh;       /* key */
            }

            /* 3) Let main content grow to fill available space */
            .content {
                width: 100%;
                margin: 0;
                padding-left: 0;
                padding-top: 0;
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;          /* key: pushes footer down */
            }

            /* 4) Footer sits at the bottom by taking remaining space above it */
            .main-panel > .footer,
            .main-panel > footer.footer {
                margin-top: auto;        /* key */
            }
            .content {
                display: flex;
                flex-direction: column;
                flex: 1 1 auto; /* fill vertical space */
            }

            .table-wrap {
                flex: 1 1 auto; /* takes up remaining space before footer-bar */
                overflow-y: auto; /* optional scrolling */
            }

            .footer-bar {
                flex-shrink: 0; /* stay fixed height */
                margin-top: auto; /* push to bottom */
            }
            /* Status badges: readable text on soft backgrounds */
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

            .btn-group {
                display: flex;
                gap: .5rem;
                flex-wrap: nowrap;
            }
            .filter {
                background-color: #9b5cf1;
                color: white;
                border-radius: 15px;
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
                        <form action="${ctx}/coupon" method="get" class="d-flex" style="gap:.5rem;flex-wrap:wrap;">
                            <input type="hidden" name="action" value="list"/>
                            <input type="text" name="search" value="${fn:escapeXml(search)}"
                                   placeholder="Tìm kiếm theo mã hoặc mô tả yêu cầu" />

                            <select name="status" class="filter">
                                <option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="Active" ${status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="Deactivate" ${status == 'Deactivate' ? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>

                            <select name="size" class="filter">
                                <c:forEach var="s" items="${fn:split('5,10,20,50', ',')}">
                                    <option value="${s}" ${size == s ? 'selected' : ''}>${s}/trang</option>
                                </c:forEach>
                            </select>

                            <button class="btn" type="submit">Tìm kiếm</button>
                            <a class="btn btn-ghost" href="${ctx}/coupon?action=list">Đặt lại</a>
                            <a class="btn" href="${ctx}/coupon?action=addForm">Thêm mới</a>
                        </form>
                    </div>

                    <!-- Flash message (optional) -->
                    <c:if test="${not empty param.msg}">
                        <div class="alert">
                            <c:choose>
                                <c:when test="${param.msg eq 'added'}">Thêm coupon thành công.</c:when>
                                <c:when test="${param.msg eq 'updated'}">Cập nhật coupon thành công.</c:when>
                                <c:when test="${param.msg eq 'status'}">Cập nhật trạng thái thành công.</c:when>
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
                                        <c:set var="dirCode" value="${(sortBy eq 'couponCode' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=couponCode&sortDir=${dirCode}&page=1&size=${size}">
                                            Mã coupon
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="dirPct" value="${(sortBy eq 'discountPercent' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=discountPercent&sortDir=${dirPct}&page=1&size=${size}">
                                            % giảm
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="dirMax" value="${(sortBy eq 'maxDiscount' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=maxDiscount&sortDir=${dirMax}&page=1&size=${size}">
                                            Giảm tối đa (VND)
                                        </a>
                                    </th>
                                    <th class="col-hide-sm">Yêu cầu áp dụng</th>
                                    <th class="col-hide-sm col-hide-md">Giá trị đơn tối thiểu (VND)</th>
                                    <th class="col-hide-md">Số sản phẩm tối thiểu</th>
                                    <th class="col-hide-sm">Giới hạn dùng</th>
                                    <th>
                                        <c:set var="dirFrom" value="${(sortBy eq 'fromDate' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=fromDate&sortDir=${dirFrom}&page=1&size=${size}">
                                            Từ ngày
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="dirTo" value="${(sortBy eq 'toDate' and sortDir eq 'ASC') ? 'DESC' : 'ASC'}"/>
                                        <a href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                                           &sortBy=toDate&sortDir=${dirTo}&page=1&size=${size}">
                                            Đến ngày
                                        </a>
                                    </th>
                                    <th>Trạng thái</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:if test="${empty listCoupons}">
                                    <tr>
                                        <td colspan="11" style="text-align:center;">Không có dữ liệu.</td>
                                    </tr>
                                </c:if>

                                <c:forEach items="${listCoupons}" var="c">
                                    <tr>
                                        <td>
                                            <a class="link"
                                               href="${ctx}/coupon?action=viewCoupon&couponId=${c.couponId}">
                                                ${c.couponCode}
                                            </a>
                                        </td>
                                        <td><fmt:formatNumber value="${c.discountPercent}" maxFractionDigits="2"/>%</td>

                                        <fmt:formatNumber value="${c.maxDiscount}" type="number" maxFractionDigits="0" var="maxFmt"/>
                                        <td>${maxFmt}</td>

                                        <td class="col-hide-sm">
                                            <c:choose>
                                                <c:when test="${fn:length(c.requirement) > 60}">
                                                    ${fn:substring(c.requirement,0,60)}…
                                                </c:when>
                                                <c:otherwise>${c.requirement}</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <fmt:formatNumber value="${c.minTotal}" type="number" maxFractionDigits="0" var="minFmt"/>
                                        <td class="col-hide-sm col-hide-md">${minFmt}</td>

                                        <td class="col-hide-md">${c.minProduct}</td>
                                        <td class="col-hide-sm">${c.applyLimit}</td>
                                        <td><fmt:formatDate value="${c.fromDate}" pattern="yyyy-MM-dd"/></td>
                                        <td><fmt:formatDate value="${c.toDate}" pattern="yyyy-MM-dd"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status eq 'Active'}">
                                                    <span class="badge badge--success status">Đang hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge--muted status">Đã ngừng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <form method="get" action="${ctx}/coupon" style="display:inline;">
                                                <input type="hidden" name="action" value="editForm"/>
                                                <input type="hidden" name="couponId" value="${c.couponId}"/>
                                                <button type="submit" class="act">Sửa</button>
                                            </form>

                                            <form method="post" action="${ctx}/coupon" style="display:inline;"
                                                  onsubmit="return confirm('Xác nhận cập nhật trạng thái?');">
                                                <input type="hidden" name="action" value="updateStatus"/>
                                                <input type="hidden" name="couponId" value="${c.couponId}"/>
                                                <input type="hidden" name="status"
                                                       value="${c.status eq 'Active' ? 'Deactivate' : 'Active'}"/>
                                                <button type="submit" class="act act--danger">
                                                    ${c.status eq 'Active' ? 'Ngừng' : 'Kích hoạt'}
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
                                <a class="page" href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=1&size=${size}" aria-label="Trang đầu">≪</a>

                            <a class="page" href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=${prev}&size=${size}" aria-label="Trước">‹</a>

                            <c:forEach var="p" begin="${start}" end="${end}">
                                <a class="page ${p == page ? 'page--current' : ''}"
                                   href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                                   &sortBy=${sortBy}&sortDir=${sortDir}&page=${p}&size=${size}">${p}</a>
                            </c:forEach>

                            <a class="page" href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=${next}&size=${size}" aria-label="Sau">›</a>

                            <a class="page" href="${ctx}/coupon?action=list&search=${fn:escapeXml(search)}&status=${status}
                               &sortBy=${sortBy}&sortDir=${sortDir}&page=${totalPages}&size=${size}" aria-label="Cuối">≫</a>
                        </nav>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>
    </body>
</html>
