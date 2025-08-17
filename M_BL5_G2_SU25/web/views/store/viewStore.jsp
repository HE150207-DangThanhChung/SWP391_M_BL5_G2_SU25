<%-- 
    Document   : viewStore
    Created on : Aug 15, 2025, 10:12:03 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết Cửa hàng</title>
        <style>
            .detail-container {
                max-width: 800px;
                margin: 30px auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 12px;
            }
            
            .detail-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #eee;
            }
            
            .detail-content {
                margin-top: 20px;
            }
            
            .detail-row {
                display: flex;
                margin-bottom: 15px;
                border-bottom: 1px solid #eee;
                padding: 10px 0;
            }
            
            .detail-label {
                width: 150px;
                font-weight: bold;
                color: #555;
            }
            
            .detail-value {
                flex: 1;
            }
            
            .status-badge {
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 14px;
                color: white;
                display: inline-block;
            }
            
            .status-active {
                background-color: #28a745;
            }
            
            .status-inactive {
                background-color: #dc3545;
            }
            
            .button-group {
                display: flex;
                gap: 10px;
            }
            
            .btn {
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                text-decoration: none;
                color: white;
                display: inline-block;
            }
            
            .btn-edit {
                background-color: #F28705;
            }
            
            .btn-delete {
                background-color: #dc3545;
            }
            
            .btn-back {
                background-color: #6c757d;
            }

            .store-image {
                width: 150px;
                height: 150px;
                border-radius: 10px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="detail-container">
            <div class="detail-header">
                <h2>Chi tiết Cửa hàng</h2>
                <div class="button-group">
                    <a href="${pageContext.request.contextPath}/stores/edit/${store.storeId}" class="btn btn-edit">
                        <i class="fas fa-edit"></i> Chỉnh sửa
                    </a>
                    <a href="${pageContext.request.contextPath}/stores/delete/${store.storeId}" 
                       class="btn btn-delete"
                       onclick="return confirm('Bạn có chắc chắn muốn xóa cửa hàng này?')">
                        <i class="fas fa-trash"></i> Xóa
                    </a>
                    <a href="${pageContext.request.contextPath}/stores" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
            
            <div class="detail-content">
                <img src="${pageContext.request.contextPath}/img/logo2.jpg" alt="Store Image" class="store-image"/>
                
                <div class="detail-row">
                    <div class="detail-label">Mã cửa hàng:</div>
                    <div class="detail-value">${store.storeId}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Tên cửa hàng:</div>
                    <div class="detail-value">${store.storeName}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Địa chỉ:</div>
                    <div class="detail-value">${store.address}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Số điện thoại:</div>
                    <div class="detail-value">${store.phone}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Trạng thái:</div>
                    <div class="detail-value">
                        <span class="status-badge ${store.status == 'Active' ? 'status-active' : 'status-inactive'}">
                            ${store.status == 'Active' ? 'Hoạt động' : 'Ngừng hoạt động'}
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
