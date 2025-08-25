<%-- 
    Document   : editCustomer
    Created on : Aug 13, 2025, 8:47:03 AM
    Author     : tayho
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sửa thông tin khách hàng</title>
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
            <div class="card__header">Sửa Khách hàng</div>

            <c:if test="${not empty errors}">
                <ul class="errors">
                    <c:forEach items="${errors}" var="e"><li>${e}</li></c:forEach>
                    </ul>
            </c:if>

            <fmt:formatDate value="${customer.dob}" pattern="yyyy-MM-dd" var="dobFmt"/>

            <form id="editCustomerForm" action="${ctx}/customer" method="post" accept-charset="UTF-8">
                <input type="hidden" name="action" value="edit"/>
                <input type="hidden" name="customerId" value="${customer.customerId}"/>

                <div class="row">
                    <label for="firstName">Họ</label>
                    <input id="firstName" name="firstName" type="text" value="${customer.firstName}" required />
                </div>

                <div class="row">
                    <label for="middleName">Tên đệm</label>
                    <input id="middleName" name="middleName" type="text" value="${customer.middleName}" />
                </div>

                <div class="row">
                    <label for="lastName">Tên</label>
                    <input id="lastName" name="lastName" type="text" value="${customer.lastName}" required />
                </div>

                <div class="row">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" value="${customer.email}" required />
                </div>

                <div class="row">
                    <label for="phone">Điện thoại</label>
                    <input id="phone" name="phone" type="text" value="${customer.phone}" required />
                </div>

                <div class="row">
                    <label for="gender">Giới tính</label>
                    <select id="gender" name="gender" required>
                        <option value="">-- Chọn --</option>
                        <option value="Male"   ${customer.gender == 'Male'   ? 'selected' : ''}>Nam</option>
                        <option value="Female" ${customer.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                        <option value="Other"  ${customer.gender == 'Other'  ? 'selected' : ''}>Khác</option>
                    </select>
                </div>

                <div class="row">
                    <label for="dob">Ngày sinh</label>
                    <input id="dob" name="dob" type="date" value="${dobFmt}" />
                </div>

                <div class="row">
                    <label for="address">Địa chỉ</label>
                    <textarea id="address" name="address" required>${customer.address}</textarea>
                </div>

                <div class="row">
                    <label for="cityId">Tỉnh/Thành</label>
                    <select id="cityId" name="cityId">
                        <option value="">-- Chọn tỉnh/thành --</option>
                        <c:forEach var="ci" items="${cities}">
                            <option value="${ci.cityId}"
                                    ${ci.cityId == selectedCityId ? 'selected' : ''}>${ci.cityName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="row">
                    <label for="wardId">Phường/Xã</label>
                    <select id="wardId" name="wardId">
                        <option value="">-- Chọn phường/xã --</option>
                        <!-- Options will be loaded based on city -->
                    </select>
                </div>

                <div class="row">
                    <label for="taxCode">Mã số thuế</label>
                    <input id="taxCode" name="taxCode" type="text" value="${customer.taxCode}" />
                </div>

                <div class="row">
                    <label for="status">Trạng thái</label>
                    <select id="status" name="status">
                        <option value="Active" ${customer.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                        <option value="Banned" ${customer.status == 'Banned' ? 'selected' : ''}>Bị khóa</option>
                    </select>
                </div>

                <div class="actions">
                    <button class="btn" type="submit">Lưu thay đổi</button>
                    <a class="btn btn--ghost" href="${ctx}/customer?action=list">Hủy</a>
                </div>
            </form>
        </section>

        <script>
            (function () {
                const ctx = '${ctx}';
                const citySel = document.getElementById('cityId');
                const wardSel = document.getElementById('wardId');

                function loadWards(cityId, selectedWardId) {
                    if (!cityId) {
                        wardSel.innerHTML = '<option value="">-- Chọn phường/xã --</option>';
                        return;
                    }
                    fetch(ctx + '/lookup/ward-options?cityId=' + encodeURIComponent(cityId))
                            .then(r => r.text())
                            .then(html => {
                                wardSel.innerHTML = '<option value="">-- Chọn phường/xã --</option>' + html;
                                if (selectedWardId)
                                    wardSel.value = String(selectedWardId);
                            })
                            .catch(() => {
                                wardSel.innerHTML = '<option value="">-- Không tải được phường/xã --</option>';
                            });
                }

                // On load: if server provided selected city/ward, prefill
                const initialCityId = '${selectedCityId}';
                const initialWardId = '${customer.wardId}';
                if (initialCityId)
                    loadWards(initialCityId, initialWardId);

                citySel.addEventListener('change', () => loadWards(citySel.value, null));
            })();
        </script>
    </body>
</html>
