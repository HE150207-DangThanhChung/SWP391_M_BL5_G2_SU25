<%-- 
    Document   : addCoupon
    Created on : Aug 14, 2025, 8:40:55 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm Mã Khuyến Mãi</title>
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
            form{
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
            input[type=text], input[type=number], input[type=date], textarea, select{
                width:100%;
                padding:10px 12px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:#fff;
                outline:none;
            }
            input:focus, textarea:focus, select:focus{
                box-shadow:0 0 0 4px rgba(127,199,255,.35);
                border-color:#7fc7ff;
            }
            textarea{
                min-height:72px;
                resize:vertical
            }
            .hint{
                font-size:12px;
                color:#4a5568;
                margin-top:4px
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
            .errors{
                background:#fff3f3;
                border:2px solid #ffb8b8;
                color:#a10000;
                border-radius:10px;
                padding:10px 14px;
                margin:0 26px 18px 26px;
                list-style:disc inside;
            }
            @media (max-width:680px){
                .row{
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <c:set var="ctx" value="${pageContext.request.contextPath}"/>

        <section class="card">
            <div class="card__header">Thêm Mã Khuyến Mãi</div>

            <!-- Validation errors from controller (optional) -->
            <c:if test="${not empty errors}">
                <ul class="errors">
                    <c:forEach items="${errors}" var="e"><li>${e}</li></c:forEach>
                    </ul>
            </c:if>

            <form action="${ctx}/coupon" method="post" accept-charset="UTF-8">
                <input type="hidden" name="action" value="addCoupon"/>

                <div class="row">
                    <label for="code">Mã coupon</label>
                    <input id="code" name="couponCode" type="text"
                           style="text-transform:uppercase;"
                           value="${param.couponCode}" required />
                </div>

                <div class="row">
                    <label for="discountPercent">Phần trăm giảm</label>
                    <input id="discountPercent" name="discountPercent" type="number" step="0.01" min="0" max="100"
                           value="${param.discountPercent}" required />
                </div>

                <div class="row">
                    <label for="maxDiscount">Giảm tối đa</label>
                    <input id="maxDiscount" name="maxDiscount" type="text"
                           placeholder="Ví dụ: 500,000" value="${param.maxDiscount}" required />
                </div>

                <div class="row">
                    <label for="requirement">Yêu cầu áp dụng</label>
                    <textarea id="requirement" name="requirement">${param.requirement}</textarea>
                </div>

                <div class="row">
                    <label for="minTotal">Tổng tối thiểu</label>
                    <input id="minTotal" name="minTotal" type="text"
                           placeholder="Ví dụ: 1,000,000" value="${param.minTotal}" required />
                </div>

                <div class="row">
                    <label for="minProduct">Số SP tối thiểu</label>
                    <input id="minProduct" name="minProduct" type="number" step="1" min="0"
                           value="${empty param.minProduct ? 1 : param.minProduct}" />
                </div>

                <div class="row">
                    <label for="applyLimit">Giới hạn sử dụng</label>
                    <input id="applyLimit" name="applyLimit" type="number" step="1" min="0"
                           value="${empty param.applyLimit ? 100 : param.applyLimit}" />
                </div>

                <div class="row">
                    <label for="fromDate">Từ ngày</label>
                    <input id="fromDate" name="fromDate" type="date" value="${param.fromDate}" required />
                </div>

                <div class="row">
                    <label for="toDate">Đến ngày</label>
                    <input id="toDate" name="toDate" type="date" value="${param.toDate}" required />
                </div>

                <div class="row">
                    <label for="status">Trạng thái</label>
                    <select id="status" name="status">
                        <option value="Active"     ${param.status == 'Active' || empty param.status ? 'selected' : ''}>Hoạt động</option>
                        <option value="Deactivate" ${param.status == 'Deactivate' ? 'selected' : ''}>Ngừng hoạt động</option>
                    </select>
                </div>

                <div class="actions">
                    <button class="btn" type="submit">Thêm</button>
                    <a class="btn btn--ghost" href="${ctx}/coupon?action=list">Hủy</a>
                </div>
            </form>
        </section>
    </body>
</html>
