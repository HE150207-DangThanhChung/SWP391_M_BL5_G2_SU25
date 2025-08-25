<%-- 
    Document   : header
    Created on : Aug 14, 2025, 9:12:51 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Header Page</title>
        <style>
            :root{
                --bar-bg:#cfe6ff;         /* light blue */
                --chip-bg:#fff7b1;        /* pale yellow */
                --chip-text:#1b1c1d;
                --btn-bg:#9b5cf1;         /* purple */
                --btn-text:#ffffff;
                --ring:#8bb7ff;           /* outline ring */
                --radius:16px;
                --shadow:0 8px 20px rgba(0,0,0,.08);
            }

            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                padding:32px;
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;
                color:#222;
                background:#f7fafc;
            }

            /* Wrapper just for demo spacing */
            .demo{
                display:grid;
                gap:40px
            }

            /* NAVBAR */
            .navbar{
                background:var(--bar-bg);
                /*border-radius:22px;  slightly rounder than inside chips */
                padding:14px 20px;
                box-shadow:var(--shadow);
                border:2px solid #b9d6ff;
                display:flex;
                align-items:center;
                gap:20px;
            }

            .brand{
                font-weight:700;
                font-size:20px;
                padding:8px 12px;
                background:var(--chip-bg);
                color:var(--chip-text);
                border-radius:10px;
                white-space:nowrap;
            }

            /* centered menu */
            .menu{
                list-style:none;
                margin:0;
                padding:0;
                display:flex;
                gap:28px;
                align-items:center;
                flex:1;
                justify-content:center;
            }

            .menu > li{
                position:relative;
            }

            .chip{
                display:inline-block;
                padding:10px 14px;
                background:var(--chip-bg);
                color:var(--chip-text);
                border-radius:8px;
                font-weight:500;
                text-decoration:none;
                transition:transform .15s ease;
            }
            .chip:hover{
                transform:translateY(-1px);
            }

            /* dropdown under a top-level item */
            .submenu{
                position:absolute;
                left:0;
                top:100%;
                margin-top:8px;
                min-width:160px;
                background:var(--chip-bg);
                border-radius:10px;
                border:1px solid #efe39a;
                box-shadow:var(--shadow);
                display:grid;
                gap:6px;
                padding:10px;
                opacity:0;
                pointer-events:none;
                transform:translateY(6px);
                transition:opacity .15s ease, transform .15s ease;
                z-index:10;
            }
            .menu > li:hover > .submenu{
                opacity:1;
                pointer-events:auto;
                transform:translateY(0);
            }

            .submenu a{
                text-decoration:none;
                color:#222;
                padding:8px 10px;
                border-radius:8px;
                display:block;
            }
            .submenu a:hover{
                background:#fff3a1;
            }

            /* Right action button with stacked dropdown */
            .action{
                margin-left:auto;
                position:relative;
            }
            .btn{
                background:var(--btn-bg);
                color:var(--btn-text);
                border:none;
                cursor:pointer;
                font-weight:700;
                padding:14px 24px;
                border-radius:20px;
                outline:2px solid #7f49e8;
                outline-offset:0;
                box-shadow:var(--shadow);
            }

            .action-menu{
                position:absolute;
                right:0;
                top:100%;
                margin-top:10px;
                display:flex;
                flex-direction:column;
                gap:10px;
                opacity:0;
                pointer-events:none;
                transform:translateY(6px);
                transition:opacity .15s ease, transform .15s ease;
                z-index:12;
            }

            .action:has(:hover), .action:hover{
                isolation:isolate;
            }
            .action:hover .action-menu{
                opacity:1;
                pointer-events:auto;
                transform:translateY(0);
            }

            .action-item{
                background:var(--btn-bg);
                color:var(--btn-text);
                border-radius:18px;
                padding:14px 22px;
                min-width:180px;
                text-align:center;
                box-shadow:var(--shadow);
            }

            /* Make each successive item align like a stacked popover under the button */
            .action-menu .action-item:nth-child(1){
                margin-right:0;
            }
            .action-menu .action-item:nth-child(2){
            }
            .action-menu .action-item:nth-child(3){
            }

            /* Responsive tweaks */
            @media (max-width: 900px){
                .menu{
                    gap:16px;
                }
            }
            @media (max-width: 720px){
                .navbar{
                    flex-wrap:wrap;
                    row-gap:12px;
                }
                .menu{
                    order:3;
                    flex:1 1 100%;
                    justify-content:flex-start;
                }
                .action{
                    order:2;
                    margin-left:0;
                }
            }
            .dropbtn {
                background-color: blue;
                color: white;
                padding: 16px;
                font-size: 16px;
                border: none;
                cursor: pointer;
            }

            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 160px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
            }

            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
            }

            .dropdown-content a:hover {
                background-color: #f1f1f1
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }

            .dropdown:hover .dropbtn {
                background-color: #B266FF;
            }
        </style>
    </head>
    <body>
        <div class="demo">

            <nav class="navbar">
                <div class="dropdown">
                    <h4><%
                        // Lay username tu trong session
                        String username = (String) session.getAttribute("tendangnhap");
                        if (session != null) {
                            out.print("Xin chào " + username);
                        } else {
                            // Neu chua dang nhap thi se la khach
                            out.print("Xin chào quý khách");
                        }
                        %>
                    </h4>                           
                </div>
                <div style="margin-left:auto; display:flex; align-items:center; gap:24px;">
                    <c:if test="${sessionScope.authUser != null && sessionScope.authUser.roleId == 1}">
                        <div id="header-notification-bell" style="position:relative; margin-right:16px; cursor:pointer;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="color:#2563eb;">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                            </svg>
                            <span id="header-notification-count" style="position:absolute;top:-6px;right:-6px;background:#dc2626;color:white;border-radius:50%;padding:2px 7px;font-size:12px;font-weight:bold;min-width:22px;text-align:center;display:none;">0</span>
                            
                            <!-- Dropdown thông báo -->
                            <div id="header-notification-dropdown" style="display:none; position:absolute; right:0; top:100%; margin-top:10px; width:320px; background:white; border:1px solid #e5e7eb; border-radius:8px; box-shadow:0 10px 15px -3px rgba(0, 0, 0, 0.1); z-index:50;">
                                <div style="padding:12px; border-bottom:1px solid #e5e7eb; font-weight:600; color:#374151;">Yêu cầu mới hôm nay</div>
                                <div id="header-notification-content">
                                    <!-- Nội dung thông báo sẽ được load bằng JavaScript -->
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <ul class="menu">
                    <li>
                        <div class="dropdown">
                            <button class="dropbtn">Cửa Hàng</button>
                            <div class="dropdown-content">
                                <a href="#">Chi Nhánh</a>
                                <a href="#">Doanh Thu</a>
                                <a href="#">Phản Hồi</a>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="dropdown">
                            <button class="dropbtn">Sản Phẩm</button>
                            <div class="dropdown-content">
                                <a href="#">Nhãn Hàng</a>
                                <a href="#">Danh Mục</a>
                                <a href="#">Nhà Phân Phối</a>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="dropdown">
                            <button class="dropbtn">Nhân Viên</button>
                            <div class="dropdown-content">
                                <a href="#">Hồ Sơ</a>
                                <a href="#">Tiến Độ</a>

                            </div>
                        </div>
                    </li>

                </ul>
                <div class="dropdown">
                    <button class="dropbtn">Hồ Sơ</button>
                    <div class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/profile">Cá Nhân</a>
                        <a href="#">Cài Đặt</a>
                        <c:url var="logoutUrl" value="/logout"/>
                        <a href="${logoutUrl}">Đăng Xuất</a>

                    </div>
                </div>
            </nav>
        </div>
        
        <!-- JavaScript cho thông báo header -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script>
            $(document).ready(function() {
                // Load thông báo khi trang được tải
                loadHeaderNotifications();
                
                // Xử lý click vào chuông thông báo
                $('#header-notification-bell').on('click', function(e) {
                    e.stopPropagation();
                    $('#header-notification-dropdown').toggle();
                    
                    // Đánh dấu đã xem thông báo
                    markHeaderNotificationsAsSeen();
                });
                
                // Đóng dropdown khi click ra ngoài
                $(document).on('click', function() {
                    $('#header-notification-dropdown').hide();
                });
                
                // Load lại thông báo mỗi 2 phút
                setInterval(function() {
                    loadHeaderNotifications();
                }, 120000); // 2 minutes
            });
            
            // Load thông báo từ server
            function loadHeaderNotifications() {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/header-notifications.jsp',
                    method: 'GET',
                    success: function(data) {
                        updateHeaderNotificationUI(data);
                    },
                    error: function() {
                        // Ignore errors
                    }
                });
            }
            
            // Cập nhật giao diện thông báo
            function updateHeaderNotificationUI(data) {
                var count = data.count || 0;
                var requests = data.requests || [];
                
                var countBadge = $('#header-notification-count');
                var content = $('#header-notification-content');
                var bell = $('#header-notification-bell svg');
                
                // Cập nhật số đếm
                if (count > 0) {
                    countBadge.text(count).show();
                    
                    // Kiểm tra xem có thông báo mới không
                    var lastSeenTime = localStorage.getItem('headerLastSeenNotificationTime') || '0';
                    var hasNewNotifications = false;
                    
                    for (var i = 0; i < requests.length; i++) {
                        var requestTime = new Date(requests[i].createdAt).getTime();
                        if (requestTime > parseInt(lastSeenTime)) {
                            hasNewNotifications = true;
                            break;
                        }
                    }
                    
                    // Thêm animation nếu có thông báo mới
                    if (hasNewNotifications) {
                        bell.css('animation', 'bounce 1s infinite');
                    } else {
                        bell.css('animation', 'none');
                    }
                } else {
                    countBadge.hide();
                    bell.css('animation', 'none');
                }
                
                // Cập nhật nội dung dropdown
                var html = '';
                if (requests.length > 0) {
                    for (var i = 0; i < requests.length; i++) {
                        var req = requests[i];
                        html += '<div style="padding:12px; border-bottom:1px solid #f3f4f6; hover:background:#f9fafb;">' +
                            '<div style="display:flex; justify-content:space-between; align-items:center;">' +
                            '<div>' +
                            '<span style="font-weight:500; color:#1f2937;">#' + req.id + '</span>' +
                            '<span style="margin-left:8px; color:#6b7280;">' + req.description + '</span>' +
                            '</div>' +
                            '<a href="${pageContext.request.contextPath}/management/form-requests/view?id=' + req.id + '" style="color:#3b82f6; text-decoration:none; font-size:14px;">Xem</a>' +
                            '</div>' +
                            '</div>';
                    }
                } else {
                    html = '<div style="padding:16px; text-align:center; color:#6b7280;">Không có yêu cầu mới hôm nay</div>';
                }
                content.html(html);
            }
            
            // Đánh dấu đã xem thông báo
            function markHeaderNotificationsAsSeen() {
                var currentTime = new Date().getTime();
                localStorage.setItem('headerLastSeenNotificationTime', currentTime.toString());
                
                // Tắt animation
                $('#header-notification-bell svg').css('animation', 'none');
            }
            
            // CSS animation cho bounce effect
            $('<style>').prop('type', 'text/css').html(`
                @keyframes bounce {
                    0%, 20%, 53%, 80%, 100% {
                        animation-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);
                        transform: translate3d(0,0,0);
                    }
                    40%, 43% {
                        animation-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);
                        transform: translate3d(0, -8px, 0);
                    }
                    70% {
                        animation-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);
                        transform: translate3d(0, -4px, 0);
                    }
                    90% {
                        transform: translate3d(0,-1px,0);
                    }
                }
            `).appendTo('head');
        </script>
    </body>
</html>
