<%-- 
    Document   : viewCustomer
    Created on : Aug 15, 2025, 10:11:09 AM
    Author     : tayho
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết khách hàng</title>
        <style>
            :root{
                --page:#f7fafc;
                --panel:#d8ead9;   /* mint */
                --header:#cfe2ff;  /* light blue */
                --stroke:#2b6777;
                --btn:#a7f6ff;     /* aqua */
                --accent:#ff0e7a;  /* magenta */
                --shadow:0 8px 22px rgba(0,0,0,.08);
            }
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                background:var(--page);
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;
                color:#102a43;
                display:grid;
                place-items:center;
                min-height:100vh;
                padding:28px
            }
            .card{
                width:min(760px,96vw);
                border:2px solid #aac6c0;
                border-radius:10px;
                box-shadow:var(--shadow);
                overflow:hidden;
                background:var(--panel)
            }
            .card__header{
                background:var(--header);
                padding:14px 18px;
                text-align:center;
                font-weight:800
            }
            .section{
                padding:28px 26px;
                max-width:640px;
                margin:0 auto
            }
            .row{
                display:grid;
                grid-template-columns: 180px 1fr;
                gap:14px 18px;
                align-items:center;
                margin-bottom:16px
            }
            label{
                font-weight:600
            }
            .value{
                width:100%;
                padding:10px 12px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:#fff;
                min-height:42px;

                display: block;
                text-align: left;
                white-space: pre-wrap;
                word-break: break-word;
            }
            .actions{
                display:flex;
                gap:24px;
                margin-top:22px;
                justify-content:center
            }
            .btn{
                min-width:120px;
                text-align:center;
                padding:10px 16px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:var(--btn);
                color:var(--accent);
                font-weight:800;
                cursor:pointer;
                text-decoration:none;
                display:inline-block;
            }
            .btn--ghost{
                background:#fff
            }
            .btn:hover{
                box-shadow:var(--shadow)
            }
            @media (max-width:680px){
                .row{
                    grid-template-columns: 1fr;
                }
            }
            .value--left {
                justify-content: flex-start !important;
                text-align: left !important;
            }
            .value-fix{
                width:100%;
                padding:10px 12px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:#fff;
                min-height:42px;

                display: block;
                text-align: left;/*
                white-space: pre-wrap;*/
                word-break: break-word;
            }
        </style>
    </head>
    <body>
        <c:set var="ctx" value="${pageContext.request.contextPath}"/>

        <section class="card">
            <div class="card__header">Chi tiết Khách hàng</div>

            <c:choose>
                <c:when test="${empty customer}">
                    <div class="section">
                        <div class="value" style="justify-content:center;">Không tìm thấy khách hàng.</div>
                        <div class="actions">
                            <a class="btn btn--ghost" href="${ctx}/customer?action=list">Quay lại danh sách</a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="section">
                        <div class="row">
                            <label>Mã KH</label>
                            <div class="value">${customer.customerId}</div>
                        </div>

                        <div class="row">
                            <label>Họ tên</label>
                            <div class="value">${customer.fullName}</div>
                        </div>

                        <div class="row">
                            <label>Email</label>
                            <div class="value">${customer.email}</div>
                        </div>

                        <div class="row">
                            <label>Số điện thoại</label>
                            <div class="value">${customer.phone}</div>
                        </div>

                        <div class="row">
                            <label>Giới tính</label>
                            <div class="value">${customer.gender}</div>
                        </div>

                        <div class="row">
                            <label>Ngày sinh</label>
                            <div class="value">
                                <c:choose>
                                    <c:when test="${not empty customer.dob}">
                                        <fmt:formatDate value="${customer.dob}" pattern="yyyy-MM-dd"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="row">
                            <label>Địa chỉ</label>
                            <div class="value">${customer.address}</div>
                        </div>

                        <div class="row">
                            <label>Phường/Xã</label>
                            <div class="value">
                                <c:out value="${empty customer.wardName ? '-' : customer.wardName}"/>
                            </div>
                        </div>

                        <div class="row">
                            <label>Tỉnh/Thành</label>
                            <div class="value">
                                <c:out value="${empty customer.cityName ? '-' : customer.cityName}"/>
                            </div>
                        </div>

                        <div class="row">
                            <label>Mã số thuế</label>
                            <div class="value">
                                <c:out value="${empty customer.taxCode ? '-' : customer.taxCode}"/>
                            </div>
                        </div>

                        <div class="row">
                            <label>Trạng thái</label>
                            <div class="value">
                                <c:out value="${customer.status == 'Active' ? 'Đang hoạt động' : 'Bị khóa'}"/>
                            </div>
                        </div>

                        <div class="actions">
                            <a class="btn btn--ghost" href="${ctx}/customer?action=list">Quay lại danh sách</a>

                            <form method="get" action="${ctx}/customer" style="display:inline;">
                                <input type="hidden" name="action" value="editForm"/>
                                <input type="hidden" name="customerId" value="${customer.customerId}"/>
                                <button type="submit" class="btn">Chỉnh sửa</button>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </body>
</html>
