<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.badminton.model.OrderBean, com.badminton.model.OrderItemBean" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>訂單管理中心 — 羽球館管理系統</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* =========================================
       1. 同學提供的全域 UI 設定 (原封不動保留)
       ========================================= */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    body { background-color: #f4f7f6; color: #333; }
    .app-container { display: flex; height: 100vh; overflow: hidden; }
    
    /* 左側選單 */
    .sidebar { width: 15%; background-color: #2c3e50; color: #fff; display: flex; flex-direction: column; transition: all 0.3s; }
    .sidebar-logo { padding: 20px; font-size: 22px; font-weight: bold; text-align: center; border-bottom: 1px solid #34495e; letter-spacing: 2px;}
    .sidebar-menu { list-style: none; padding: 10px 0; margin: 0; }
    .sidebar-menu li { padding: 15px 25px; cursor: pointer; border-left: 4px solid transparent; transition: 0.2s; }
    .sidebar-menu li:hover { background-color: #34495e; border-left: 4px solid #3498db; }
    .sidebar-menu li.active { background-color: #34495e; border-left: 4px solid #3498db; color: #3498db; font-weight: bold;}
    .sidebar-menu a { text-decoration: none; color: inherit; display: block; }
    
    /* 右側主要區域 & 上方導覽列 */
    .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .top-header { height: 60px; background-color: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; z-index: 10; }
    .header-title { font-size: 18px; font-weight: bold; color: #555; }
    .user-info { font-size: 14px; color: #666; }
    
    /* 內容區域 & 卡片 */
    .content-body { flex: 1; padding: 20px; overflow-y: auto; }
    .card { background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 20px;}
    
    /* 共用表格 & 按鈕 (吃同學的設定) */
    .table-custom { width: 100%; border-collapse: collapse; margin-top: 15px; background: #fff; }
    .table-custom th, .table-custom td { border-bottom: 1px solid #eee; padding: 12px 15px; text-align: left; vertical-align: middle; }
    .table-custom th { background-color: #f8f9fa; color: #555; font-weight: bold; white-space: nowrap; }
    .table-custom tr.main-row:hover { background-color: #f1f4f8; cursor: pointer; }
    
    .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: 0.2s; }
    .btn-primary { background-color: #3498db; color: white; }
    .btn-primary:hover { background-color: #2980b9; }
    .btn-danger { background-color: #e74c3c; color: white; }
    .btn-danger:hover { background-color: #c0392b; }
    .btn-warning { background-color: #f1c40f; color: #333; }
    
    .form-control { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; outline: none; transition: 0.2s; }
    .form-control:focus { border-color: #3498db; box-shadow: 0 0 5px rgba(52, 152, 219, 0.3); }

    /* =========================================
       2. 訂單模組專屬 CSS (微調以融入整體)
       ========================================= */
    .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
    .stats { display: grid; grid-template-columns: repeat(6, 1fr); gap: 10px; margin-bottom: 20px; }
    .stat-card { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 14px; text-align: center; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
    .stat-card .num { font-size: 1.5rem; font-weight: bold; color: #2c3e50; }
    .stat-card .label { font-size: 0.75rem; color: #666; margin-top: 3px; }
    
    /* 標籤 Badge */
    .badge { display: inline-block; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; }
    .bg-P { background: #fff3cd; color: #856404; }
    .bg-PR { background: #d1ecf1; color: #0c5460; }
    .bg-R { background: #cce5ff; color: #004085; }
    .bg-CPL { background: #d4edda; color: #155724; }
    .bg-C { background: #f8d7da; color: #721c24; }

    /* 展開明細與編輯面板 */
    tr.detail-row { display: none; }
    tr.detail-row.open { display: table-row; }
    .detail-cell { background: #f8f9fa; padding: 0 !important; border-top: 1px solid #eee; }
    .detail-inner { padding: 24px 24px 30px 50px; }
    .order-edit-panel { background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    .expand-arrow { display: inline-block; transition: transform 0.2s; color: #999; font-size: 0.72rem; margin-right: 5px; }
    .expanded .expand-arrow { transform: rotate(90deg); color: #3498db; }

    /* 內層商品表格 */
    .items-tbl { width: 100%; border-collapse: collapse; font-size: 0.85rem; background: #fff; border: 1px solid #ddd; }
    .items-tbl th { background-color: #e9ecef; color: #495057; padding: 10px; border-bottom: 1px solid #ddd; }
    .items-tbl td { padding: 10px; border-bottom: 1px solid #eee; }
    
    .toast{position:fixed;top:18px;right:18px;padding:12px 24px;border-radius:6px;font-weight:bold;font-size:0.88rem;display:none;z-index:9999;box-shadow:0 4px 12px rgba(0,0,0,0.15);}
    .toast.success{background:#28a745;color:#fff;}
    .toast.info{background:#17a2b8;color:#fff;}
</style>
</head>
<body>

<%-- ===================== 伺服器資料準備 ===================== --%>
<%
List<OrderBean> orderList = (List<OrderBean>) request.getAttribute("orderList");
Map<Integer, List<OrderItemBean>> itemMap = (Map<Integer, List<OrderItemBean>>) request.getAttribute("itemMap");
String curStatus = request.getAttribute("statusFilter") != null ? (String)request.getAttribute("statusFilter") : "";
String curKeyword = request.getAttribute("keyword") != null ? (String)request.getAttribute("keyword") : "";

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

<%-- 提示彈窗 --%>
<div class="toast" id="toast"></div>

<%-- ===================== 系統大框架開始 ===================== --%>
<div class="app-container">

    <%-- 1. 左側選單 (Sidebar) --%>
    <div class="sidebar">
        <div class="sidebar-logo">Badminton</div>
        <ul class="sidebar-menu">
            <li><a href="#">會員管理</a></li>
            <li><a href="#">預約管理</a></li>
            <li><a href="#">臨打管理</a></li>
            <li><a href="#">商品管理</a></li>
            <%-- ✨ 關鍵修改：把你這頁變成 active 亮起來！ --%>
            <li class="active"><a href="<%=request.getContextPath()%>/orderList">訂單管理</a></li>
            <li><a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list">公告管理</a></li>
        </ul>
    </div>

    <%-- 2. 右側主要區域 --%>
    <div class="main-content">
        
        <%-- 2-1. 上方導覽列 --%>
        <% String empName = session.getAttribute("empName") != null ? (String) session.getAttribute("empName") : "管理員"; %>
        <div class="top-header">
            <div class="header-title">羽球館管理系統 / 訂單管理</div>
            <div class="user-info">
                HI! <%= empName %> | <a href="<%=request.getContextPath()%>/LogoutServlet" style="color: #e74c3c; text-decoration: none;">登出</a>
            </div>
        </div>

        <%-- 2-2. 內容區域 (塞入你的心血結晶) --%>
        <div class="content-body">
            
            <%-- 上方按鈕列 --%>
            <div class="header-actions">
                <h2>📋 訂單列表</h2>
                <a href="<%=request.getContextPath()%>/admin_order_bulk.jsp" class="btn btn-warning" style="font-weight:bold;">⚡ 新增訂單 (支援批次)</a>
            </div>

            <%-- 統計卡片 --%>
            <div class="stats">
                <div class="stat-card"><div class="num"><%=total%></div><div class="label">篩選結果</div></div>
                <div class="stat-card"><div class="num" style="color:#f1c40f"><%=pending%></div><div class="label">⏳ 待處理</div></div>
                <div class="stat-card"><div class="num" style="color:#17a2b8"><%=processing%></div><div class="label">📦 理貨中</div></div>
                <div class="stat-card"><div class="num" style="color:#007bff"><%=ready%></div><div class="label">🏪 待取貨</div></div>
                <div class="stat-card"><div class="num" style="color:#28a745"><%=completed%></div><div class="label">✅ 已完成</div></div>
                <div class="stat-card"><div class="num">$<%=String.format("%,d",revenue)%></div><div class="label">有效總金額</div></div>
            </div>

            <%-- 搜尋列 (套用 card 風格) --%>
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

            <%-- 批次操作區 --%>
            <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                <div style="display: flex; gap: 10px;">
                    <select id="bulkStatusSelect" class="form-control">
                        <option value="" disabled selected>-- 選擇目標狀態 --</option>
                        <option value="PENDING">⏳ 待處理</option>
                        <option value="PROCESSING">📦 理貨中</option>
                        <option value="READY">🏪 待取貨</option>
                        <option value="COMPLETED">✅ 已完成</option>
                    </select>
                    <button type="button" class="btn btn-primary" onclick="executeBulkUpdateStatus()">✨ 批次更改狀態</button>
                </div>
                <button type="button" class="btn btn-danger" onclick="executeBulkDelete()">🗑 批次刪除所選</button>
            </div>

            <%-- 主表格 (套用 card 與同學的 table-custom) --%>
            <div class="card" style="padding: 0; overflow: hidden;">
                <% if (orderList == null || orderList.isEmpty()) { %>
                    <div style="text-align:center; padding: 40px; color:#999;">📭 沒有符合條件的訂單</div>
                <% } else { %>
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th width="40"><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                            <th width="50">展開</th>
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
                        <td style="text-align: center;" onclick="event.stopPropagation();">
                            <input type="checkbox" class="order-checkbox" value="<%=order.getOrderId()%>">
                        </td>
                        <td><span class="expand-arrow" id="arr-<%=order.getOrderId()%>">▶</span></td>
                        <td style="font-weight:bold; color:#3498db;">#<%=order.getOrderId()%></td>
                        <td><%=order.getMemberId()%></td>
                        <td style="font-weight:bold; color:#28a745;">$<%=String.format("%,d", order.getTotalAmount())%></td>
                        <td id="td-pay-<%=order.getOrderId()%>"><%=order.getPaymentType()%></td>
                        <td><span class="badge <%=badgeCls%>" id="badge-<%=order.getOrderId()%>"><%=stLabel%></span></td>
                        <td style="font-size: 0.8rem; color:#666;"><%=order.getCreatedAt().toString().substring(0,16)%></td>
                    </tr>
                    
                    <%-- 展開明細 --%>
                    <tr class="detail-row" id="<%=did%>">
                        <td class="detail-cell" colspan="9">
                            <div class="detail-inner">
                                <%-- 編輯面板 --%>
                                <div class="order-edit-panel">
                                    <h4 style="color:#2c3e50; margin-bottom:15px; font-weight:bold;">✏️ 編輯訂單 #<%=order.getOrderId()%></h4>
                                    <div style="display: flex; gap: 20px; align-items: flex-end; width: 100%;">
                                        <div style="flex: 1;">
                                            <label style="font-size:0.8rem; color:#666; display:block; margin-bottom:5px;">狀態</label>
                                            <select class="form-control" id="sel-status-<%=order.getOrderId()%>" style="width:100%;">
                                                <option value="PENDING" <%="PENDING".equals(st)?"selected":""%>>待處理</option>
                                                <option value="PROCESSING" <%="PROCESSING".equals(st)?"selected":""%>>理貨中</option>
                                                <option value="READY" <%="READY".equals(st)?"selected":""%>>待取貨</option>
                                                <option value="COMPLETED" <%="COMPLETED".equals(st)?"selected":""%>>已完成</option>
                                                <option value="CANCELLED" <%="CANCELLED".equals(st)?"selected":""%>>已取消</option>
                                            </select>
                                        </div>
                                        <div style="flex: 2;">
                                            <label style="font-size:0.8rem; color:#666; display:block; margin-bottom:5px;">備註</label>
                                            <input type="text" class="form-control" id="inp-note-<%=order.getOrderId()%>" value="<%=order.getNote()!=null?order.getNote():""%>" style="width:100%;">
                                        </div>
                                        <div style="display: flex; gap: 10px;">
                                            <button class="btn btn-primary" onclick="updateOrder(<%=order.getOrderId()%>)">✅ 儲存修改</button>
                                            <button type="button" class="btn btn-danger" onclick="deleteOrder(<%=order.getOrderId()%>, event)">🗑 刪除</button>
                                        </div>
                                    </div>
                                </div>
                                
                                <%-- 內部商品明細表格 --%>
                                <h4 style="color:#2c3e50; margin-bottom:10px; font-weight:bold;">📦 商品明細</h4>
                                <table class="items-tbl">
                                    <thead><tr><th>商品名稱</th><th>單價</th><th>數量</th><th>小計</th></tr></thead>
                                    <tbody>
                                        <% List<OrderItemBean> items = itemMap!=null ? itemMap.get(order.getOrderId()) : null;
                                           if(items != null) { for(OrderItemBean item : items) { %>
                                        <tr>
                                            <td><%=item.getProductName()%></td>
                                            <td>$<%=String.format("%,d", item.getUnitPrice())%></td>
                                            <td><%=item.getQuantity()%></td>
                                            <td style="color:#28a745; font-weight:bold;">$<%=String.format("%,d", item.getSubtotal())%></td>
                                        </tr>
                                        <% } } %>
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

        </div> <%-- end content-body --%>
    </div> <%-- end main-content --%>
</div> <%-- end app-container --%>

<%-- ===================== JavaScript 區塊 (維持原來的邏輯) ===================== --%>
<script>
//全選 / 取消全選
function toggleAll(source) {
    const checkboxes = document.querySelectorAll('.order-checkbox');
    checkboxes.forEach(cb => cb.checked = source.checked);
}

// 執行批次刪除
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

// 執行批次修改狀態
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

/* ── Toggle Detail Row ── */
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

function updateOrder(orderId) {
    const status = document.getElementById('sel-status-' + orderId)?.value;
    const note = document.getElementById('inp-note-' + orderId)?.value;
    const fd = new FormData();
    fd.append('action', 'updateOrder'); fd.append('orderId', orderId); fd.append('status', status); fd.append('note', note || '');

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
</script>
</body>
</html>