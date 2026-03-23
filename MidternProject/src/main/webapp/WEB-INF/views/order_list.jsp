<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.badminton.model.OrderBean, com.badminton.model.OrderItemBean" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>訂單管理中心 — 羽球館管理系統</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* =========================================
       1. 全域 UI 設定 (無印風)
       ========================================= */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    body { background-color: #f4f7f6; color: #333; }
    .app-container { display: flex; height: 100vh; overflow: hidden; }
    
    .sidebar { width: 15%; background-color: #2c3e50; color: #fff; display: flex; flex-direction: column; transition: all 0.3s; }
    .sidebar-logo { padding: 20px; font-size: 22px; font-weight: bold; text-align: center; border-bottom: 1px solid #34495e; letter-spacing: 2px;}
    .sidebar-menu { list-style: none; padding: 10px 0; margin: 0; }
    .sidebar-menu li { padding: 15px 25px; cursor: pointer; border-left: 4px solid transparent; transition: 0.2s; }
    .sidebar-menu li:hover, .sidebar-menu li.active { background-color: #34495e; border-left: 4px solid #3498db; }
    .sidebar-menu li.active { color: #3498db; font-weight: bold;}
    .sidebar-menu a { text-decoration: none; color: inherit; display: block; }
    
    .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .top-header { height: 60px; background-color: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; z-index: 10; }
    .header-title { font-size: 18px; font-weight: bold; color: #555; }
    .user-info { font-size: 14px; color: #666; }
    
    .content-body { flex: 1; padding: 20px; overflow-y: auto; }
    .card { background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 20px;}
    
    .table-custom { width: 100%; border-collapse: collapse; margin-top: 5px; background: #fff; }
    .table-custom th, .table-custom td { border-bottom: 1px solid #eee; padding: 12px 15px; text-align: left; vertical-align: middle; }
    .table-custom th { background-color: #f8f9fa; color: #555; font-weight: bold; white-space: nowrap; }
    .table-custom tr.main-row:hover { background-color: #f1f4f8; cursor: pointer; }
    
    .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: 0.2s; font-weight: bold;}
    .btn-primary { background-color: #3498db; color: white; }
    .btn-primary:hover { background-color: #2980b9; }
    .btn-danger { background-color: #e74c3c; color: white; }
    .btn-danger:hover { background-color: #c0392b; }
    .btn-warning { background-color: #f1c40f; color: #333; }
    .btn-success { background-color: #28a745; color: white; }
    
    /* 正方形按鈕與等寬按鈕 */
    .btn-icon { width: 28px; height: 28px; padding: 0; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; margin-right: 4px; }
    .btn-icon:last-child { margin-right: 0; }
    
    /* ✨ 黃金比例：按鈕寬度調成 120px 看起來最大器 */
    .btn-fixed { width: 120px; text-align: center; }

    .form-control { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; outline: none; transition: 0.2s; width: 100%;}
    .form-control:focus { border-color: #3498db; box-shadow: 0 0 5px rgba(52, 152, 219, 0.3); }
    .form-control[readonly] { background-color: #e9ecef; cursor: not-allowed; color: #666; font-weight: bold; }

    .input-xs { width: 70px; padding: 6px; }
    .input-sm { width: 100px; padding: 6px; }

    /* =========================================
       2. 訂單模組專屬 CSS
       ========================================= */
    .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
    .stats { display: grid; grid-template-columns: repeat(6, 1fr); gap: 10px; margin-bottom: 20px; }
    .stat-card { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 14px; text-align: center; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
    .stat-card .num { font-size: 1.5rem; font-weight: bold; color: #2c3e50; }
    .stat-card .label { font-size: 0.75rem; color: #666; margin-top: 3px; }
    
    .badge { display: inline-block; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; }
    .bg-P { background: #fff3cd; color: #856404; }
    .bg-PR { background: #d1ecf1; color: #0c5460; }
    .bg-R { background: #cce5ff; color: #004085; }
    .bg-CPL { background: #d4edda; color: #155724; }
    .bg-C { background: #f8d7da; color: #721c24; }

    tr.detail-row { display: none; }
    tr.detail-row.open { display: table-row; }
    .detail-cell { background: #f8f9fa; padding: 0 !important; border-top: 1px solid #eee; }
    .detail-inner { padding: 24px 24px 30px 50px; }
    .order-edit-panel { background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    .expand-arrow { display: inline-block; transition: transform 0.2s; color: #999; font-size: 0.72rem; margin-right: 5px; }
    .expanded .expand-arrow { transform: rotate(90deg); color: #3498db; }

    .items-tbl { width: 100%; border-collapse: collapse; font-size: 0.85rem; background: #fff; border: 1px solid #ddd; }
    .items-tbl th { background-color: #e9ecef; color: #495057; padding: 10px; border-bottom: 1px solid #ddd; }
    .items-tbl td { padding: 10px; border-bottom: 1px solid #eee; }
    
    .toast{position:fixed;top:18px;right:18px;padding:12px 24px;border-radius:6px;font-weight:bold;font-size:0.88rem;display:none;z-index:9999;box-shadow:0 4px 12px rgba(0,0,0,0.15);}
    .toast.success{background:#28a745;color:#fff;}
    .toast.info{background:#17a2b8;color:#fff;}
    .toast.error{background:#dc3545;color:#fff;}
</style>
</head>
<body>

<%
List<OrderBean> orderList = (List<OrderBean>) request.getAttribute("orderList");
Map<Integer, List<OrderItemBean>> itemMap = (Map<Integer, List<OrderItemBean>>) request.getAttribute("itemMap");
String curStatus = request.getAttribute("statusFilter") != null ? (String)request.getAttribute("statusFilter") : "";
String curKeyword = request.getAttribute("keyword") != null ? (String)request.getAttribute("keyword") : "";

// 日期格式化 (無 T 版本)
DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm");

int total=0, pending=0, processing=0, ready=0, completed=0, cancelled=0; long revenue=0;
if (orderList != null) {
    total = orderList.size();
    for (OrderBean o : orderList) {
        String s = o.getStatus();
        if ("PENDING".equals(s)) pending++;
        else if ("PROCESSING".equals(s)) processing++;
        else if ("READY".equals(s)) ready++;
        else if ("COMPLETED".equals(s)) completed++;
        else if ("CANCELLED".equals(s)) cancelled++;
        if (o.getTotalAmount()!=null && !"CANCELLED".equals(s)) revenue+=o.getTotalAmount();
    }
}
%>

<div class="toast" id="toast"></div>

<div class="app-container">

    <div class="sidebar">
        <div class="sidebar-logo">Badminton</div>
        <ul class="sidebar-menu">
            <li><a href="#">會員管理</a></li>
            <li><a href="#">預約管理</a></li>
            <li><a href="#">臨打管理</a></li>
            <li><a href="#">商品管理</a></li>
            <li class="active"><a href="<%=request.getContextPath()%>/orderList">訂單管理</a></li>
            <li><a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list">公告管理</a></li>
        </ul>
    </div>

    <div class="main-content">
        
        <% String empName = session.getAttribute("empName") != null ? (String) session.getAttribute("empName") : "管理員"; %>
        <div class="top-header">
            <div class="header-title">羽球館管理系統 / 訂單管理</div>
            <div class="user-info">
                HI! <%= empName %> | <a href="<%=request.getContextPath()%>/LogoutServlet" style="color: #e74c3c; text-decoration: none;">登出</a>
            </div>
        </div>

        <div class="content-body">
            
            <div class="header-actions">
                <h2>📋 訂單列表</h2>
                <a href="<%=request.getContextPath()%>/admin_order_bulk.jsp" class="btn btn-warning" style="font-weight:bold;">⚡ 新增訂單 (支援批次)</a>
            </div>

            <div class="stats">
                <div class="stat-card"><div class="num"><%=total%></div><div class="label">篩選結果</div></div>
                <div class="stat-card"><div class="num" style="color:#f1c40f"><%=pending%></div><div class="label">⏳ 待處理</div></div>
                <div class="stat-card"><div class="num" style="color:#17a2b8"><%=processing%></div><div class="label">📦 理貨中</div></div>
                <div class="stat-card"><div class="num" style="color:#007bff"><%=ready%></div><div class="label">🏪 待取貨</div></div>
                <div class="stat-card"><div class="num" style="color:#28a745"><%=completed%></div><div class="label">✅ 已完成</div></div>
                <div class="stat-card"><div class="num">$<%=String.format("%,d",revenue)%></div><div class="label">有效總金額</div></div>
            </div>

            <div class="card" style="padding: 15px 25px;">
                <form action="<%=request.getContextPath()%>/orderList" method="get" id="searchForm" style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                    <input type="hidden" name="status" value="<%=curStatus%>">
                    <label style="font-weight:bold; color:#555;">全能搜尋：</label>
                    <input type="text" name="keyword" class="form-control" style="flex:1; min-width:200px;" placeholder="輸入訂單ID、會員ID或商品名稱..." value="<%=curKeyword%>">
                    <button type="submit" class="btn btn-primary">🔍 搜尋</button>
                    <% if (!curKeyword.isEmpty() || !curStatus.isEmpty()) { %>
                        <a href="<%=request.getContextPath()%>/orderList" class="btn" style="background:#eee; color:#555;">清除</a>
                    <% } %>
                </form>
            </div>

            <%-- ✨ 專業級批次操作工具列 (統一靠左，新增分隔線，視覺動線完美) --%>
<div style="display: flex; align-items: center; gap: 15px; margin-bottom: 15px; background: #fff; padding: 12px 20px; border-radius: 6px; border: 1px solid #e1e4e8; box-shadow: 0 1px 2px rgba(0,0,0,0.02);">
    <span style="font-weight: bold; color: #2c3e50; font-size: 0.95rem;">🛠️ 批次操作：</span>
    
    <select id="bulkStatusSelect" class="form-control" style="width: 180px;">
        <option value="" disabled selected>-- 選擇目標狀態 --</option>
        <option value="PENDING">⏳ 待處理</option>
        <option value="PROCESSING">📦 理貨中</option>
        <option value="READY">🏪 待取貨</option>
        <option value="COMPLETED">✅ 已完成</option>
    </select>
    <button type="button" class="btn btn-primary" onclick="executeBulkUpdateStatus()">✨ 批次更改狀態</button>
    
    <%-- 視覺緩衝分隔線 --%>
    <div style="width: 1px; height: 24px; background-color: #ddd; margin: 0 5px;"></div>
    
    <button type="button" class="btn btn-danger" onclick="executeBulkDelete()">🗑 批次刪除訂單</button>
</div>

            <%-- ✨ 精準對齊「訂單 ID」的提示文字 --%>
            <div style="text-align: left; margin-left: 15px; font-size: 0.85rem; color: #888; margin-bottom: 5px; font-weight: bold;">
                💡 小提示：按三角形符號 (▶) 即可展開完整訂單
            </div>
            
            <div class="card" style="padding: 0; overflow: hidden;">
                <% if (orderList == null || orderList.isEmpty()) { %>
                    <div style="text-align:center; padding: 40px; color:#999;">📭 沒有符合條件的訂單</div>
                <% } else { %>
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th width="40"><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                            <th width="40"></th>
                            <th>訂單 ID</th>
                            <th>會員 ID</th>
                            <th>總金額</th>
                            <th>付款方式</th>
                            <th>狀態</th>
                            <th>建立時間</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (OrderBean order : orderList) {
                        String st = order.getStatus()!=null ? order.getStatus() : "PENDING";
                        String badgeCls = "PENDING".equals(st)?"bg-P":"PROCESSING".equals(st)?"bg-PR":"READY".equals(st)?"bg-R":"COMPLETED".equals(st)?"bg-CPL":"bg-C";
                        String stLabel = "PENDING".equals(st)?"待處理":"PROCESSING".equals(st)?"理貨中":"READY".equals(st)?"待取貨":"COMPLETED".equals(st)?"已完成":"已取消";
                        String did = "d" + order.getOrderId();
                    %>
                    <tr class="main-row" id="row-<%=order.getOrderId()%>" onclick="toggleDetail('<%=did%>',this)">
                        <td style="text-align: center;" onclick="event.stopPropagation();"><input type="checkbox" class="order-checkbox" value="<%=order.getOrderId()%>"></td>
                        <td style="text-align: center;"><span class="expand-arrow" id="arr-<%=order.getOrderId()%>">▶</span></td>
                        <td style="font-weight:bold; color:#3498db;">#<%=order.getOrderId()%></td>
                        <td><%=order.getMemberId()%></td>
                        <td style="font-weight:bold; color:#28a745;">$<%=String.format("%,d", order.getTotalAmount())%></td>
                        <td id="td-pay-<%=order.getOrderId()%>"><%=order.getPaymentType()%></td>
                        <td><span class="badge <%=badgeCls%>" id="badge-<%=order.getOrderId()%>"><%=stLabel%></span></td>
                        <td style="font-size: 0.8rem; color:#666;"><%=order.getCreatedAt() != null ? order.getCreatedAt().format(df) : "-"%></td>
                    </tr>
                    
                    <%-- 展開明細 --%>
                    <tr class="detail-row" id="<%=did%>">
                        <td class="detail-cell" colspan="8">
                            <div class="detail-inner">
                                <%-- 編輯面板 --%>
                                <div class="order-edit-panel">
                                    <h4 style="color:#2c3e50; margin-bottom:15px; font-weight:bold;">✏️ 編輯訂單 #<%=order.getOrderId()%> 主資訊</h4>
                                    
                                    <%-- ✨ 黃金比例 CSS Grid 排版：完美切分 15% | 15% | 彈性長度 | 固定按鈕區 --%>
                                    <div style="display: grid; grid-template-columns: 15% 15% auto 260px; gap: 20px; align-items: flex-end; width: 100%;">
                                        
                                        <div>
                                            <label style="font-size:0.8rem; color:#666; display:block; margin-bottom:5px; font-weight:bold;">狀態</label>
                                            <select class="form-control" id="sel-status-<%=order.getOrderId()%>">
                                                <option value="PENDING" <%="PENDING".equals(st)?"selected":""%>>待處理</option>
                                                <option value="PROCESSING" <%="PROCESSING".equals(st)?"selected":""%>>理貨中</option>
                                                <option value="READY" <%="READY".equals(st)?"selected":""%>>待取貨</option>
                                                <option value="COMPLETED" <%="COMPLETED".equals(st)?"selected":""%>>已完成</option>
                                                <option value="CANCELLED" <%="CANCELLED".equals(st)?"selected":""%>>已取消</option>
                                            </select>
                                        </div>

                                        <div>
                                            <label style="font-size:0.8rem; color:#666; display:block; margin-bottom:5px; font-weight:bold;">付款狀態</label>
                                            <select class="form-control" id="sel-pay-<%=order.getOrderId()%>">
                                                <option value="現金" <%="現金".equals(order.getPaymentType())?"selected":""%>>💵 現金</option>
                                                <option value="信用卡" <%="信用卡".equals(order.getPaymentType())?"selected":""%>>💳 信用卡</option>
                                                <option value="轉帳" <%="轉帳".equals(order.getPaymentType())?"selected":""%>>🏦 轉帳</option>
                                                <option value="LinePay" <%="LinePay".equals(order.getPaymentType())?"selected":""%>>📱 LINE Pay</option>
                                                <%--
                                                <option value="街口支付" <%="街口支付".equals(order.getPaymentType())?"selected":""%>>📱 街口</option>
                                                --%>
                                            </select>
                                        </div>

                                        <div>
                                            <label style="font-size:0.8rem; color:#666; display:block; margin-bottom:5px; font-weight:bold;">備註 (點擊右側按鈕解鎖修改)</label>
                                            <div style="display: flex; gap: 5px;">
                                                <input type="text" class="form-control" id="inp-note-<%=order.getOrderId()%>" value="<%=order.getNote()!=null?order.getNote():""%>" readonly>
                                                <button type="button" class="btn btn-warning btn-icon" title="解鎖編輯備註" onclick="enableNoteEdit(<%=order.getOrderId()%>)">✏️</button>
                                            </div>
                                        </div>

                                        <div style="display: flex; gap: 10px; justify-content: flex-end;">
                                            <button class="btn btn-primary btn-fixed" onclick="updateOrder(<%=order.getOrderId()%>)">✅ 儲存修改</button>
                                            <%-- ✨ 刪除訂單文字更改，維持等寬和諧比例 --%>
                                            <button type="button" class="btn btn-danger btn-fixed" onclick="deleteOrder(<%=order.getOrderId()%>, event)">🗑 刪除訂單</button>
                                        </div>
                                    </div>
                                </div>
                                
                                <%-- 內部商品明細 --%>
                                <div style="display: flex; justify-content: flex-start; align-items: baseline; gap: 15px; margin-bottom: 10px;">
    <h4 style="color:#2c3e50; font-weight:bold; margin: 0;">📦 商品明細</h4>
    <div style="font-size: 0.85rem; color: #888; font-weight: bold;">💡 小提示：修改「商品ID」或「數量」，系統將自動為您變更明細並存檔</div>
</div>
                                
                                <table class="items-tbl" id="items-<%=order.getOrderId()%>">
                                    <thead>
                                        <tr>
                                            <th width="40">#</th>
                                            <th width="120">商品 ID</th>
                                            <th>商品名稱 <span style="font-size:0.7rem;color:#999;">(自動)</span></th>
                                            <th width="100">單價 <span style="font-size:0.7rem;color:#999;">(唯讀)</span></th>
                                            <th width="90">數量</th>
                                            <th width="120">小計 <span style="font-size:0.7rem;color:#999;">(自動)</span></th>
                                            <th width="50">操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% int ino=1; 
                                           List<OrderItemBean> items = itemMap!=null ? itemMap.get(order.getOrderId()) : null;
                                           if(items != null && !items.isEmpty()) { 
                                               for(OrderItemBean item : items) { 
                                        %>
                                        <tr id="irow-<%=item.getItemId()%>">
                                            <td style="color:#999; font-weight:bold; text-align:center;"><%=ino++%></td>
                                            <%-- ✨ 綁定 onchange 觸發 fetchProductInfoList --%>
                                            <td><input type="number" class="form-control input-sm" id="inp-pid-<%=item.getItemId()%>" value="<%=item.getProductId()%>" onchange="fetchProductInfoList(this, <%=item.getItemId()%>, <%=order.getOrderId()%>)"></td>
                                            <td><input type="text" class="form-control" id="inp-pname-<%=item.getItemId()%>" value="<%=item.getProductName()%>" readonly></td>
                                            <td><input type="number" class="form-control input-sm" id="inp-price-<%=item.getItemId()%>" value="<%=item.getUnitPrice()%>" readonly></td>
                                            <%-- ✨ 綁定 onchange 觸發算錢和背景存檔 --%>
                                            <td><input type="number" class="form-control input-xs" id="inp-qty-<%=item.getItemId()%>" value="<%=item.getQuantity()%>" min="1" onchange="calculateSubtotalList(this, <%=item.getItemId()%>); saveItem(<%=item.getItemId()%>, <%=order.getOrderId()%>);"></td>
                                            <td><input type="text" class="form-control input-sm" id="inp-subtotal-<%=item.getItemId()%>" value="<%=String.format("%,d", item.getSubtotal())%>" style="color:#28a745; font-weight:bold;" readonly></td>
                                            <td style="text-align: center;">
                                                <%-- ✨ 綠色更新鈕已移除，只留下完美的正方形紅叉叉 --%>
                                                <button type="button" class="btn btn-danger btn-icon" title="刪除此列" onclick="deleteItem(<%=item.getItemId()%>, <%=order.getOrderId()%>)">✕</button>
                                            </td>
                                        </tr>
                                        <% } } else { %>
                                        <tr><td colspan="7" style="text-align:center; color:#999; padding: 20px;">此訂單目前沒有商品明細</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>

        </div> 
    </div> 
</div> 

<script>
function toggleAll(source) {
    const checkboxes = document.querySelectorAll('.order-checkbox');
    checkboxes.forEach(cb => cb.checked = source.checked);
}

function executeBulkDelete() {
    const checkedBoxes = document.querySelectorAll('.order-checkbox:checked');
    if (checkedBoxes.length === 0) { alert("⚠️ 請至少選擇一筆要刪除的訂單！"); return; }
    if (!confirm("🚨 警告：確定要永久刪除這 " + checkedBoxes.length + " 筆訂單嗎？\n此動作無法復原！")) return;

    const formData = new URLSearchParams();
    checkedBoxes.forEach(cb => formData.append('orderIds', cb.value));

    fetch('<%=request.getContextPath()%>/api/bulkDeleteOrders', {
        method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: formData.toString()
    }).then(res => res.json()).then(data => {
        if (data.success) { alert("✅ " + data.message); location.reload(); } else { alert("❌ 錯誤：" + data.message); }
    });
}

function executeBulkUpdateStatus() {
    const checkedBoxes = document.querySelectorAll('.order-checkbox:checked');
    const targetStatus = document.getElementById('bulkStatusSelect').value;
    if (checkedBoxes.length === 0) { alert("⚠️ 請至少選擇一筆！"); return; }
    if (!targetStatus) { alert("⚠️ 請選擇目標狀態！"); return; }
    if (!confirm("✨ 確定修改這 " + checkedBoxes.length + " 筆訂單狀態嗎？")) return;

    const formData = new URLSearchParams();
    checkedBoxes.forEach(cb => formData.append('orderIds', cb.value));
    formData.append('status', targetStatus); 

    fetch('<%=request.getContextPath()%>/api/bulkUpdateStatus', {
        method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: formData.toString()
    }).then(res => res.json()).then(data => {
        if (data.success) { alert("✅ " + data.message); location.reload(); } else { alert("❌ 錯誤：" + data.message); }
    });
}

function toggleDetail(did, row) {
    const tr = document.getElementById(did);
    const arr = document.getElementById('arr-' + did.replace('d',''));
    if (!tr) return;
    const open = tr.classList.toggle('open');
    row.classList.toggle('expanded', open);
    if (arr) arr.textContent = open ? '▼' : '▶';
}

function showToast(msg, type='success') {
    const t = document.getElementById('toast');
    t.textContent = msg; t.className = 'toast ' + type; t.style.display = 'block';
    setTimeout(() => { t.style.opacity='0'; setTimeout(()=>{t.style.display='none';t.style.opacity='1';},300); }, 2800);
}

function enableNoteEdit(orderId) {
    const noteEl = document.getElementById('inp-note-' + orderId);
    if (noteEl) {
        noteEl.removeAttribute('readonly');
        noteEl.focus();
        noteEl.style.backgroundColor = '#fff';
        noteEl.style.borderColor = '#f1c40f';
    }
}

function updateOrder(orderId) {
    const status = document.getElementById('sel-status-' + orderId)?.value;
    const paymentType = document.getElementById('sel-pay-' + orderId)?.value; 
    const noteEl = document.getElementById('inp-note-' + orderId);
    const note = noteEl?.value;
    
    const fd = new FormData();
    fd.append('action', 'updateOrder'); 
    fd.append('orderId', orderId); 
    fd.append('status', status); 
    fd.append('paymentType', paymentType); 
    fd.append('note', note || '');

    fetch('<%=request.getContextPath()%>/orderAction', { method:'POST', body:fd })
    .then(() => {
        const badgeMap = {
            'PENDING': {cls: 'bg-P', txt: '待處理'}, 'PROCESSING': {cls: 'bg-PR', txt: '理貨中'},
            'READY': {cls: 'bg-R', txt: '待取貨'}, 'COMPLETED': {cls: 'bg-CPL', txt: '已完成'}, 'CANCELLED': {cls: 'bg-C', txt: '已取消'}
        };
        const badgeEl = document.getElementById('badge-' + orderId);
        if (badgeEl && badgeMap[status]) {
            badgeEl.className = 'badge ' + badgeMap[status].cls; badgeEl.textContent = badgeMap[status].txt;
        }
        
        const payTd = document.getElementById('td-pay-' + orderId);
        if (payTd) payTd.textContent = paymentType;

        if (noteEl) {
            noteEl.setAttribute('readonly', 'true');
            noteEl.style.backgroundColor = '';
            noteEl.style.borderColor = '';
        }

        showToast('✅ 訂單 #' + orderId + ' 已更新', 'success');
    });
}

function deleteOrder(orderId, event) {
    event.stopPropagation();
    if (!confirm('❗ 確定刪除訂單 #' + orderId + '？\n此操作不可復原！')) return;
    const fd = new FormData(); fd.append('action', 'delete'); fd.append('orderId', orderId);
    fetch('<%=request.getContextPath()%>/orderAction', { method:'POST', body:fd })
    .then(() => {
        const mainRow = document.getElementById('row-' + orderId); const detailRow = document.getElementById('d' + orderId);
        if (mainRow) mainRow.remove(); if (detailRow) detailRow.remove();
        showToast('🗑 訂單 #' + orderId + ' 已徹底刪除', 'success');
    });
}

function calculateSubtotalList(element, itemId) {
    const price = parseFloat(document.getElementById('inp-price-' + itemId).value) || 0;
    const qty = parseInt(document.getElementById('inp-qty-' + itemId).value) || 0;
    document.getElementById('inp-subtotal-' + itemId).value = (price * qty).toLocaleString('en-US'); 
}

// ✨ 自動抓價並自動呼叫背景存檔
function fetchProductInfoList(inputEl, itemId, orderId) {
    const productId = inputEl.value.trim();
    const nameInput = document.getElementById('inp-pname-' + itemId);
    const priceInput = document.getElementById('inp-price-' + itemId);

    if (!productId) {
        nameInput.value = ''; priceInput.value = 0; calculateSubtotalList(inputEl, itemId); return;
    }

    nameInput.value = '讀取中...';
    
    fetch('<%=request.getContextPath()%>/api/productQuery?id=' + productId)
    .then(r => r.json())
    .then(data => {
        if (data.success && data.product) {
            nameInput.value = data.product.name;
            priceInput.value = data.product.price;
            inputEl.style.borderColor = '#28a745'; 
            calculateSubtotalList(inputEl, itemId);
            // ✨ 商品確認無誤後，自動發送背景儲存！
            saveItem(itemId, orderId);
        } else {
            nameInput.value = '❌ 找不到商品';
            priceInput.value = 0;
            inputEl.style.borderColor = '#dc3545'; 
            calculateSubtotalList(inputEl, itemId);
        }
    }).catch(err => {
        nameInput.value = '❌ 系統錯誤'; priceInput.value = 0; calculateSubtotalList(inputEl, itemId);
    });
}

// ✨ 被隱藏的存檔功能，改由 JS 在背後默默幫你做
function saveItem(itemId, orderId) {
    const productId = document.getElementById('inp-pid-' + itemId).value;
    const quantity = document.getElementById('inp-qty-' + itemId).value;
    const unitPrice = document.getElementById('inp-price-' + itemId).value;
    const pname = document.getElementById('inp-pname-' + itemId).value;

    if (pname.includes('❌') || pname === '讀取中...') return; // 沒抓到商品就不存

    const fd = new FormData();
    fd.append('action', 'updateItem');
    fd.append('itemId', itemId);
    fd.append('productId', productId);
    fd.append('quantity', quantity);
    fd.append('unitPrice', unitPrice);

    fetch('<%=request.getContextPath()%>/orderItemAction', {method:'POST', body:fd})
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            showToast('✅ 明細 #' + itemId + ' 自動更新成功', 'info');
        } else {
            showToast('❌ ' + data.message, 'error');
        }
    })
    .catch(err => showToast('❌ 發生錯誤！', 'error'));
}

function deleteItem(itemId, orderId) {
    if (!confirm('確定刪除此商品明細？\n此操作無法復原。')) return;
    const fd = new FormData();
    fd.append('action', 'deleteItem');
    fd.append('itemId', itemId);

    fetch('<%=request.getContextPath()%>/orderItemAction', {method:'POST', body:fd})
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            const row = document.getElementById('irow-' + itemId);
            if (row) row.remove();
            showToast('🗑 明細已刪除', 'success');
        } else {
            showToast('❌ ' + data.message, 'error');
        }
    })
    .catch(err => showToast('❌ 發生錯誤！', 'error'));
}
</script>
</body>
</html>