<%-- 
    Document   : viewCoupon
    Created on : Aug 15, 2025, 10:11:03 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết Mã khuyến mãi</title>
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
                display:flex;
                align-items: center;
                justify-content:flex-start;  
                text-align:left;             
                white-space:pre-wrap;
                word-break:break-word;
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
                display: block !important;
                text-align: left !important;
            }
        </style>
    </head>
    <body>
        <c:set var="ctx" value="${pageContext.request.contextPath}"/>

        <section class="card">
            <div class="card__header">Chi tiết Mã khuyến mãi</div>

            <c:choose>
                <c:when test="${empty coupon}">
                    <div class="section">
                        <div class="value" style="justify-content:center;">Không tìm thấy mã khuyến mãi.</div>
                        <div class="actions">
                            <a class="btn btn--ghost" href="${ctx}/coupon?action=list">Quay lại danh sách</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="section">
                        <div class="row">
                            <label>Mã khuyến mãi</label>
                            <div class="value">${coupon.couponCode}</div>
                        </div>

                        <div class="row">
                            <label>Phần trăm giảm</label>
                            <div class="value">
                                <fmt:formatNumber value="${coupon.discountPercent}" maxFractionDigits="2"/>% 
                            </div>
                        </div>

                        <div class="row">
                            <label>Giảm tối đa</label>
                            <div class="value">
                                <fmt:formatNumber value="${coupon.maxDiscount}" type="number" maxFractionDigits="0"/> (VND)
                            </div>
                        </div>

                        <div class="row">
                            <label>Yêu cầu áp dụng</label>
                            <div class="value">${coupon.requirement}</div>
                        </div>

                        <div class="row">
                            <label>Tổng tối thiểu</label>
                            <div class="value">
                                <fmt:formatNumber value="${coupon.minTotal}" type="number" maxFractionDigits="0"/> (VND)
                            </div>
                        </div>

                        <div class="row">
                            <label>Số SP tối thiểu</label>
                            <div class="value">${coupon.minProduct}</div>
                        </div>

                        <div class="row">
                            <label>Giới hạn sử dụng</label>
                            <div class="value">${coupon.applyLimit}</div>
                        </div>

                        <div class="row">
                            <label>Từ ngày</label>
                            <div class="value"><fmt:formatDate value="${coupon.fromDate}" pattern="yyyy-MM-dd"/></div>
                        </div>

                        <div class="row">
                            <label>Đến ngày</label>
                            <div class="value"><fmt:formatDate value="${coupon.toDate}" pattern="yyyy-MM-dd"/></div>
                        </div>

                        <div class="row">
                            <label>Trạng thái</label>
                            
                            <div class="value">${coupon.status eq 'Active' ? 'Đang hoạt động' : 'Đã ngừng'}</div>
                        </div>

                        <div class="actions">
                            <a class="btn btn--ghost" href="${ctx}/coupon?action=list">Quay lại danh sách</a>

                            <form method="get" action="${ctx}/coupon" style="display:inline;">
                                <input type="hidden" name="action" value="editForm"/>
                                <input type="hidden" name="couponId" value="${coupon.couponId}"/>
                                <button type="submit" class="btn">Chỉnh sửa</button>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </body>
</html>
