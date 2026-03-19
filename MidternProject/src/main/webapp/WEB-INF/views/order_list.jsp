<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.badminton.model.OrderBean, com.badminton.model.OrderItemBean" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>訂單管理中心 — 管理員</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',sans-serif;background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460);min-height:100vh;padding:24px 16px;color:#e0e0e0}
.container{max-width:1280px;margin:0 auto}

/* ── HEADER ── */
.header{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;flex-wrap:wrap;gap:10px}
h1{color:#53d8fb;font-size:1.6rem;letter-spacing:2px}
.btn-primary{background:linear-gradient(90deg,#53d8fb,#0f3460);color:#fff;text-decoration:none;padding:9px 20px;border-radius:8px;font-weight:bold;font-size:.85rem;white-space:nowrap;transition:opacity .2s}
.btn-primary:hover{opacity:.85}

/* ── STATS ── */
.stats{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;margin-bottom:16px}
.stat-card{background:rgba(255,255,255,.07);border:1px solid rgba(83,216,251,.2);border-radius:12px;padding:14px;text-align:center}
.stat-card .num{font-size:1.7rem;font-weight:bold;color:#53d8fb}
.stat-card .label{font-size:.72rem;color:#a0c4d8;margin-top:3px}

/* ── TOOLBAR ── */
.toolbar{background:rgba(255,255,255,.06);border:1px solid rgba(83,216,251,.15);border-radius:14px;padding:14px 18px;margin-bottom:12px}
.toolbar-row{display:flex;gap:10px;flex-wrap:wrap;align-items:flex-end}
.toolbar label{font-size:.8rem;color:#a0c4d8;display:block;margin-bottom:4px}
.field-select{padding:8px 10px;background:rgba(255,255,255,.08);border:1px solid rgba(83,216,251,.25);border-radius:8px;color:#e0e0e0;font-size:.85rem;cursor:pointer}
.field-select option{background:#1a1a2e}
.kw-input{flex:1;min-width:180px;padding:8px 14px;background:rgba(255,255,255,.08);border:1px solid rgba(83,216,251,.3);border-radius:8px;color:#fff;font-size:.88rem}
.kw-input:focus{outline:none;border-color:#53d8fb}
.search-btn{padding:8px 16px;background:rgba(83,216,251,.15);border:1px solid #53d8fb;color:#53d8fb;border-radius:8px;cursor:pointer;font-size:.83rem;transition:background .2s;white-space:nowrap}
.search-btn:hover{background:rgba(83,216,251,.3)}
.clear-btn{padding:8px 14px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.2);color:#a0c4d8;border-radius:8px;cursor:pointer;font-size:.83rem;text-decoration:none;white-space:nowrap;transition:background .2s}
.clear-btn:hover{background:rgba(255,255,255,.12)}

/* ── SEARCH HISTORY ── */
.history-bar{display:flex;gap:6px;flex-wrap:wrap;margin-top:10px;align-items:center}
.history-label{font-size:.75rem;color:#666}
.hist-chip{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;background:rgba(83,216,251,.08);border:1px solid rgba(83,216,251,.2);border-radius:16px;font-size:.75rem;color:#a0c4d8;cursor:pointer;transition:background .2s}
.hist-chip:hover{background:rgba(83,216,251,.2);color:#53d8fb}
.hist-del{color:#e74c3c;font-size:.7rem;margin-left:2px;cursor:pointer;font-weight:bold}
.hist-del:hover{color:#ff6b6b}

/* ── TABS ── */
.tabs{display:flex;gap:8px;margin-bottom:12px;flex-wrap:wrap}
.tab{padding:6px 15px;border-radius:20px;border:1px solid rgba(255,255,255,.15);background:rgba(255,255,255,.05);color:#a0c4d8;cursor:pointer;font-size:.8rem;text-decoration:none;transition:all .2s}
.tab:hover{background:rgba(83,216,251,.1);color:#53d8fb}
.tab.active{background:rgba(83,216,251,.18);color:#53d8fb;border-color:#53d8fb;font-weight:bold}
.tab.tp.active{background:rgba(241,196,15,.15);color:#f1c40f;border-color:#f1c40f}
.tab.tpaid.active{background:rgba(46,213,115,.15);color:#2ed573;border-color:#2ed573}
.tab.tship.active{background:rgba(83,216,251,.15);color:#53d8fb;border-color:#53d8fb}
.tab.tcanc.active{background:rgba(231,76,60,.15);color:#e74c3c;border-color:#e74c3c}

/* ── TABLE ── */
.table-wrap{background:rgba(255,255,255,.06);border:1px solid rgba(83,216,251,.15);border-radius:16px;overflow:hidden}
table{width:100%;border-collapse:collapse}
thead tr{background:rgba(83,216,251,.1)}
th{padding:12px 13px;text-align:left;font-size:.78rem;font-weight:600;color:#53d8fb;white-space:nowrap}
tbody tr.main-row{border-top:1px solid rgba(255,255,255,.05);transition:background .15s;cursor:pointer}
tbody tr.main-row:hover{background:rgba(83,216,251,.04)}
td{padding:11px 13px;font-size:.85rem;vertical-align:middle}
.expand-arrow{display:inline-block;transition:transform .2s;color:#53d8fb;font-size:.72rem;margin-right:3px}
.expanded .expand-arrow{transform:rotate(90deg)}

/* ── BADGE ── */
.badge{display:inline-block;padding:2px 9px;border-radius:20px;font-size:.74rem;font-weight:bold}
.bg-P{background:rgba(241,196,15,.15);color:#f1c40f;border:1px solid #f1c40f}
.bg-D{background:rgba(46,213,115,.15);color:#2ed573;border:1px solid #2ed573}
.bg-S{background:rgba(83,216,251,.15);color:#53d8fb;border:1px solid #53d8fb}
.bg-C{background:rgba(231,76,60,.15);color:#e74c3c;border:1px solid #e74c3c}

/* ── DETAIL ROW ── */
tr.detail-row{display:none}
tr.detail-row.open{display:table-row}
.detail-cell{background:rgba(0,0,0,.25);padding:0!important}
.detail-inner{padding:18px 24px}

/* ── ORDER EDIT PANEL ── */
.order-edit-panel{background:rgba(83,216,251,.05);border:1px solid rgba(83,216,251,.15);border-radius:10px;padding:16px 20px;margin-bottom:16px}
.order-edit-panel h4{color:#53d8fb;font-size:.85rem;margin-bottom:12px}
.edit-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:12px}
.edit-grid label{font-size:.78rem;color:#a0c4d8;display:block;margin-bottom:4px}
.edit-select,.edit-input{width:100%;padding:7px 10px;background:rgba(255,255,255,.08);border:1px solid rgba(83,216,251,.25);border-radius:7px;color:#e0e0e0;font-size:.85rem}
.edit-select option,.edit-input option{background:#1a1a2e}
.edit-input:focus,.edit-select:focus{outline:none;border-color:#53d8fb}
.btn-confirm-order{padding:8px 20px;background:linear-gradient(90deg,#53d8fb,#0f3460);border:none;border-radius:8px;color:#fff;font-weight:bold;font-size:.82rem;cursor:pointer;transition:opacity .2s}
.btn-confirm-order:hover{opacity:.85}
.btn-del-order{padding:8px 16px;background:rgba(231,76,60,.12);border:1px solid #e74c3c;border-radius:8px;color:#e74c3c;font-size:.82rem;cursor:pointer;transition:background .2s}
.btn-del-order:hover{background:rgba(231,76,60,.3)}
.updated-time{font-size:.75rem;color:#666;margin-left:10px}

/* ── ITEMS TABLE ── */
.items-section h4{color:#53d8fb;font-size:.82rem;margin-bottom:10px;padding-top:4px}
.items-tbl{width:100%;border-collapse:collapse;font-size:.82rem}
.items-tbl th{color:#a0c4d8;padding:6px 10px;border-bottom:1px solid rgba(255,255,255,.08);text-align:left}
.items-tbl td{padding:8px 10px;border-bottom:1px solid rgba(255,255,255,.04)}
.items-tbl tr:hover td{background:rgba(83,216,251,.03)}

/* inline edit mode */
.item-editable{background:transparent;border:1px solid rgba(83,216,251,.3);border-radius:5px;color:#fff;padding:3px 6px;width:90px;font-size:.82rem}
.item-editable:focus{outline:none;border-color:#53d8fb;background:rgba(83,216,251,.08)}

.btn-edit-item{padding:3px 10px;background:rgba(83,216,251,.1);border:1px solid #53d8fb;color:#53d8fb;border-radius:5px;cursor:pointer;font-size:.75rem;transition:background .2s}
.btn-edit-item:hover{background:rgba(83,216,251,.25)}
.btn-save-item{padding:3px 10px;background:rgba(46,213,115,.1);border:1px solid #2ed573;color:#2ed573;border-radius:5px;cursor:pointer;font-size:.75rem;display:none;transition:background .2s}
.btn-save-item:hover{background:rgba(46,213,115,.25)}
.btn-del-item{padding:3px 8px;background:rgba(231,76,60,.1);border:1px solid #e74c3c;color:#e74c3c;border-radius:5px;cursor:pointer;font-size:.75rem;transition:background .2s}
.btn-del-item:hover{background:rgba(231,76,60,.25)}

/* ── SCROLL BUTTONS ── */
.scroll-btns{position:fixed;right:22px;bottom:22px;display:flex;flex-direction:column;gap:10px;z-index:999}
.scroll-btn{width:44px;height:44px;border-radius:50%;border:1px solid rgba(83,216,251,.4);background:rgba(15,52,96,.85);color:#53d8fb;font-size:1.1rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .2s;backdrop-filter:blur(6px)}
.scroll-btn:hover{background:#0f3460;border-color:#53d8fb;transform:scale(1.1)}

/* ── TOAST ── */
.toast{position:fixed;top:18px;right:18px;padding:11px 22px;border-radius:10px;font-weight:bold;font-size:.88rem;display:none;z-index:9999;box-shadow:0 4px 20px rgba(0,0,0,.4);transition:opacity .3s}
.toast.success{background:#2ed573;color:#fff}
.toast.info{background:#53d8fb;color:#1a1a2e}

/* ── EMPTY ── */
.empty-state{text-align:center;padding:60px 20px;color:#a0c4d8}
.empty-state .icon{font-size:3rem;margin-bottom:14px}

@media(max-width:768px){
  .stats{grid-template-columns:repeat(3,1fr)}
  .edit-grid{grid-template-columns:1fr}
  td,th{padding:8px 8px;font-size:.76rem}
}
</style>
</head>
<body>
<%-- ===================== DATA PREP ===================== --%>
<%
List<OrderBean> orderList    = (List<OrderBean>) request.getAttribute("orderList");
Map<Integer, List<OrderItemBean>> itemMap = (Map<Integer, List<OrderItemBean>>) request.getAttribute("itemMap");
String curStatus   = (String) request.getAttribute("statusFilter");
String curKeyword  = (String) request.getAttribute("keyword");
String curField    = (String) request.getAttribute("searchField");
List<String> searchHistory = (List<String>) request.getAttribute("searchHistory");
if (curStatus  == null) curStatus  = "";
if (curKeyword == null) curKeyword = "";
if (curField   == null) curField   = "all";

int total=0, pending=0, paid=0, shipped=0, cancelled=0; long revenue=0;
if (orderList != null) {
    total = orderList.size();
    for (OrderBean o : orderList) {
        String s = o.getStatus();
        if ("PENDING".equals(s)) pending++;
        else if ("PAID".equals(s)) paid++;
        else if ("SHIPPED".equals(s)) shipped++;
        else if ("CANCELLED".equals(s)) cancelled++;
        if (o.getTotalAmount()!=null&&!"CANCELLED".equals(s)) revenue+=o.getTotalAmount();
    }
}
String base = request.getContextPath() + "/orderList";
String kwParam = curKeyword.isEmpty() ? "" : "&keyword="+ java.net.URLEncoder.encode(curKeyword,"UTF-8") + "&searchField="+curField;
%>
<%-- ===================== END DATA PREP ===================== --%>

<div class="toast" id="toast"></div>

<%-- ── Scroll Buttons ── --%>
<div class="scroll-btns">
    <button class="scroll-btn" title="到頁面底部" onclick="window.scrollTo({top:document.body.scrollHeight,behavior:'smooth'})">⬇</button>
    <button class="scroll-btn" title="回到頂部" onclick="window.scrollTo({top:0,behavior:'smooth'})">⬆</button>
</div>

<div class="container">

<%-- ── Header ── --%>
<div class="header">
    <h1>📋 訂單管理中心</h1>
    <a href="<%=request.getContextPath()%>/admin_order_new.jsp" class="btn-primary">👤 管理員新增訂單</a>
</div>

<%-- ── Stats ── --%>
<div class="stats">
    <div class="stat-card"><div class="num"><%=total%></div><div class="label">篩選結果</div></div>
    <div class="stat-card"><div class="num" style="color:#f1c40f"><%=pending%></div><div class="label">⏳ 待付款</div></div>
    <div class="stat-card"><div class="num" style="color:#2ed573"><%=paid%></div><div class="label">✅ 已付款</div></div>
    <div class="stat-card"><div class="num" style="color:#53d8fb"><%=shipped%></div><div class="label">🚚 已出貨</div></div>
    <div class="stat-card"><div class="num">$<%=String.format("%,d",revenue)%></div><div class="label">有效總金額</div></div>
</div>

<%-- ── Toolbar ── --%>
<div class="toolbar">
    <form action="<%=base%>" method="get" id="searchForm">
        <input type="hidden" name="status" value="<%=curStatus%>">
        <div class="toolbar-row">
            <div>
                <label>搜尋欄位</label>
                <select name="searchField" class="field-select" id="fieldSel">
                    <option value="all"         <%="all".equals(curField)?"selected":""%>>🔍 模糊搜尋（全欄）</option>
                    <option value="memberId"    <%="memberId".equals(curField)?"selected":""%>>👤 精準：會員 ID</option>
                    <option value="status"      <%="status".equals(curField)?"selected":""%>>🏷 精準：訂單狀態</option>
                    <option value="paymentType" <%="paymentType".equals(curField)?"selected":""%>>💳 精準：付款方式</option>
                    <option value="note"        <%="note".equals(curField)?"selected":""%>>📝 模糊：備註</option>
                </select>
            </div>
            <div style="flex:1">
                <label>關鍵字 / 值</label>
                <input type="text" name="keyword" class="kw-input" id="kwInput"
                       placeholder="輸入搜尋內容..." value="<%=curKeyword%>">
            </div>
            <button type="submit" class="search-btn">🔍 搜尋</button>
            <% if (!curKeyword.isEmpty()||!curStatus.isEmpty()) { %>
            <a href="<%=base%>" class="clear-btn">✕ 清除</a>
            <% } %>
        </div>
        <%-- 搜尋歷史 --%>
        <% if (searchHistory != null && !searchHistory.isEmpty()) { %>
        <div class="history-bar">
            <span class="history-label">📌 搜尋記錄：</span>
            <% for (int hi=0; hi<searchHistory.size(); hi++) {
                String histEntry = searchHistory.get(hi);
                // parse: [field] keyword
                String hField = "all", hKw = histEntry;
                if (histEntry.startsWith("[")) {
                    int br = histEntry.indexOf("] ");
                    if (br>0) { hField=histEntry.substring(1,br); hKw=histEntry.substring(br+2); }
                }
            %>
            <span class="hist-chip"
                  onclick="applyHistory('<%=hField%>','<%=hKw.replace("'","\\'")%>')">
                <%=histEntry%>
                <span class="hist-del" onclick="event.stopPropagation();deleteHistory(<%=hi%>)">✕</span>
            </span>
            <% } %>
        </div>
        <% } %>
    </form>
</div>

<%-- ── Status Tabs ── --%>
<div class="tabs">
    <a href="<%=base+(kwParam.isEmpty()?"":"?"+kwParam.substring(1))%>"
       class="tab <%=curStatus.isEmpty()?"active":""%>">全部</a>
    <a href="<%=base+"?status=PENDING"+kwParam%>" class="tab tp <%="PENDING".equals(curStatus)?"active":""%>">⏳ 待付款</a>
    <a href="<%=base+"?status=PAID"+kwParam%>"    class="tab tpaid <%="PAID".equals(curStatus)?"active":""%>">✅ 已付款</a>
    <a href="<%=base+"?status=SHIPPED"+kwParam%>" class="tab tship <%="SHIPPED".equals(curStatus)?"active":""%>">🚚 已出貨</a>
    <a href="<%=base+"?status=CANCELLED"+kwParam%>" class="tab tcanc <%="CANCELLED".equals(curStatus)?"active":""%>">❌ 已取消</a>
</div>

<%-- ── Table ── --%>
<div class="table-wrap">
<% if (orderList==null||orderList.isEmpty()) { %>
<div class="empty-state">
    <div class="icon">📭</div>
    <p>沒有符合條件的訂單</p>
    <% if (!curKeyword.isEmpty()||!curStatus.isEmpty()) { %>
    <a href="<%=base%>" class="btn-primary" style="display:inline-block;margin-top:16px">清除篩選</a>
    <% } %>
</div>
<% } else { %>
<table>
<thead><tr>
    <th>▶</th><th>訂單 ID</th><th>會員 ID</th>
    <th>金額（元）</th><th>付款方式</th><th>狀態</th>
    <th>建立時間</th><th>備註</th>
</tr></thead>
<tbody>
<% for (OrderBean order : orderList) {
    String st = order.getStatus()!=null ? order.getStatus() : "PENDING";
    String badgeCls = "PENDING".equals(st)?"bg-P":"PAID".equals(st)?"bg-D":"SHIPPED".equals(st)?"bg-S":"bg-C";
    String stLabel = "PENDING".equals(st)?"⏳ 待付款":"PAID".equals(st)?"✅ 已付款":"SHIPPED".equals(st)?"🚚 已出貨":"❌ 已取消";
    List<OrderItemBean> items = itemMap!=null ? itemMap.get(order.getOrderId()) : null;
    int itemCount = items!=null ? items.size() : 0;
    String did = "d" + order.getOrderId();
%>
<tr class="main-row" onclick="toggleDetail('<%=did%>',this)">
    <td>
        <span class="expand-arrow" id="arr-<%=order.getOrderId()%>">▶</span>
        <span style="color:#666;font-size:.73rem">(<%=itemCount%>)</span>
    </td>
    <td style="color:#53d8fb;font-weight:bold">#<%=order.getOrderId()%></td>
    <td><%=order.getMemberId()%></td>
    <td style="color:#2ed573;font-weight:bold">
        $<%=order.getTotalAmount()!=null?String.format("%,d",order.getTotalAmount()):"0"%>
    </td>
    <td><%=order.getPaymentType()!=null?order.getPaymentType():"-"%></td>
    <td><span class="badge <%=badgeCls%>"><%=stLabel%></span></td>
    <td style="color:#a0c4d8;font-size:.78rem">
        <%=order.getCreatedAt()!=null?order.getCreatedAt().toString().replace("T"," ").substring(0,16):"-"%>
    </td>
    <td style="color:#a0c4d8;max-width:130px;overflow:hidden;text-overflow:ellipsis"
        title="<%=order.getNote()!=null?order.getNote():""%>">
        <%=order.getNote()!=null?order.getNote():"-"%>
    </td>
</tr>

<%-- ── Detail Row ── --%>
<tr class="detail-row" id="<%=did%>">
<td class="detail-cell" colspan="8">
<div class="detail-inner">

    <%-- Order Edit Panel --%>
    <div class="order-edit-panel">
        <h4>✏️ 編輯訂單 #<%=order.getOrderId()%> 主資訊</h4>
        <div class="edit-grid">
            <div>
                <label>訂單狀態</label>
                <select class="edit-select" id="sel-status-<%=order.getOrderId()%>">
                    <option value="PENDING"   <%="PENDING".equals(st)?"selected":""%>>⏳ 待付款</option>
                    <option value="PAID"      <%="PAID".equals(st)?"selected":""%>>✅ 已付款</option>
                    <option value="SHIPPED"   <%="SHIPPED".equals(st)?"selected":""%>>🚚 已出貨</option>
                    <option value="CANCELLED" <%="CANCELLED".equals(st)?"selected":""%>>❌ 已取消</option>
                </select>
            </div>
            <div>
                <label>付款方式</label>
                <select class="edit-select" id="sel-pay-<%=order.getOrderId()%>">
                    <option value="信用卡"  <%="信用卡".equals(order.getPaymentType())?"selected":""%>>💳 信用卡</option>
                    <option value="現金"    <%="現金".equals(order.getPaymentType())?"selected":""%>>💵 現金</option>
                    <option value="轉帳"    <%="轉帳".equals(order.getPaymentType())?"selected":""%>>🏦 銀行轉帳</option>
                    <option value="LinePay" <%="LinePay".equals(order.getPaymentType())?"selected":""%>>📱 LINE Pay</option>
                    <option value="街口支付"<%="街口支付".equals(order.getPaymentType())?"selected":""%>>📱 街口支付</option>
                    <% if (order.getPaymentType()!=null &&
                           !"信用卡".equals(order.getPaymentType()) &&
                           !"現金".equals(order.getPaymentType()) &&
                           !"轉帳".equals(order.getPaymentType()) &&
                           !"LinePay".equals(order.getPaymentType()) &&
                           !"街口支付".equals(order.getPaymentType())) { %>
                    <option value="<%=order.getPaymentType()%>" selected><%=order.getPaymentType()%></option>
                    <% } %>
                </select>
            </div>
            <div>
                <label>備註</label>
                <input type="text" class="edit-input" id="inp-note-<%=order.getOrderId()%>"
                       value="<%=order.getNote()!=null?order.getNote():""%>" placeholder="備註（選填）">
            </div>
        </div>
        <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap">
            <button class="btn-confirm-order"
                    onclick="updateOrder(<%=order.getOrderId()%>)">✅ 確認更新</button>
            <span class="updated-time" id="upd-time-<%=order.getOrderId()%>">
                <%=order.getCreatedAt()!=null?"更新於 "+order.getCreatedAt().toString().replace("T"," ").substring(0,16):""%>
            </span>
            <div style="flex:1"></div>
            <form action="<%=request.getContextPath()%>/orderAction" method="post"
                  onsubmit="return confirm('❗ 確定刪除訂單 #<%=order.getOrderId()%>？\n此操作不可復原！')"
                  onclick="event.stopPropagation()">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="orderId" value="<%=order.getOrderId()%>">
                <button type="submit" class="btn-del-order">🗑 刪除訂單</button>
            </form>
        </div>
    </div>

    <%-- Items Section --%>
    <div class="items-section">
        <h4>📦 商品明細</h4>
        <% if (items==null||items.isEmpty()) { %>
        <p style="color:#666;font-size:.82rem;font-style:italic">此訂單目前沒有商品明細</p>
        <% } else { %>
        <table class="items-tbl" id="items-<%=order.getOrderId()%>">
        <thead><tr>
            <th>#</th><th>商品名稱</th><th>商品 ID</th>
            <th>數量</th><th>單價（元）</th><th>小計（元）</th><th>操作</th>
        </tr></thead>
        <tbody>
        <% int ino=1; for (OrderItemBean item : items) {
            String pName = item.getProductName()!=null ? item.getProductName() : "（已下架）";
        %>
        <tr id="irow-<%=item.getItemId()%>">
            <td style="color:#666"><%=ino++%></td>
            <td id="td-name-<%=item.getItemId()%>"><%=pName%></td>
            <td>
                <span id="td-pid-<%=item.getItemId()%>"><%=item.getProductId()%></span>
                <input class="item-editable" id="inp-pid-<%=item.getItemId()%>"
                       type="number" value="<%=item.getProductId()%>" min="1" style="display:none">
            </td>
            <td>
                <span id="td-qty-<%=item.getItemId()%>"><%=item.getQuantity()%></span>
                <input class="item-editable" id="inp-qty-<%=item.getItemId()%>"
                       type="number" value="<%=item.getQuantity()%>" min="1" style="display:none">
            </td>
            <td>
                <span id="td-price-<%=item.getItemId()%>">$<%=String.format("%,d",item.getUnitPrice())%></span>
                <input class="item-editable" id="inp-price-<%=item.getItemId()%>"
                       type="number" value="<%=item.getUnitPrice()%>" min="0" style="display:none">
            </td>
            <td style="color:#2ed573;font-weight:bold" id="td-sub-<%=item.getItemId()%>">
                $<%=String.format("%,d",item.getSubtotal())%>
            </td>
            <td>
                <div style="display:flex;gap:5px">
                    <button class="btn-edit-item" id="btn-edit-<%=item.getItemId()%>"
                            onclick="startEdit(<%=item.getItemId()%>)">✏ 編輯</button>
                    <button class="btn-save-item" id="btn-save-<%=item.getItemId()%>"
                            onclick="saveItem(<%=item.getItemId()%>,<%=order.getOrderId()%>)">💾 儲存</button>
                    <button class="btn-del-item"
                            onclick="deleteItem(<%=item.getItemId()%>,<%=order.getOrderId()%>)">🗑</button>
                </div>
            </td>
        </tr>
        <% } %>
        </tbody>
        </table>
        <% } %>
    </div>

</div><%-- /detail-inner --%>
</td>
</tr>
<% } %>
</tbody>
</table>
<% } %>
</div><%-- /table-wrap --%>

</div><%-- /container --%>

<script>
/* ── Toggle Detail Row ── */
function toggleDetail(did, row) {
    const tr  = document.getElementById(did);
    const arr = document.getElementById('arr-' + did.replace('d',''));
    if (!tr) return;
    const open = tr.classList.toggle('open');
    row.classList.toggle('expanded', open);
    if (arr) arr.textContent = open ? '▼' : '▶';
}

/* ── Toast ── */
function showToast(msg, type='success') {
    const t = document.getElementById('toast');
    t.textContent = msg;
    t.className = 'toast ' + type;
    t.style.display = 'block';
    setTimeout(() => { t.style.opacity='0'; setTimeout(()=>{t.style.display='none';t.style.opacity='1';},300); }, 2800);
}

/* ── Update Order Header ── */
function updateOrder(orderId) {
    const status      = document.getElementById('sel-status-' + orderId)?.value;
    const paymentType = document.getElementById('sel-pay-'    + orderId)?.value;
    const note        = document.getElementById('inp-note-'   + orderId)?.value;

    const fd = new FormData();
    fd.append('action', 'updateOrder');
    fd.append('orderId', orderId);
    fd.append('status', status);
    fd.append('paymentType', paymentType);
    fd.append('note', note || '');

    fetch('<%=request.getContextPath()%>/orderAction', {method:'POST', body:fd})
    .then(() => {
        const now = new Date().toLocaleString('zh-TW', {hour12:false});
        const timeEl = document.getElementById('upd-time-' + orderId);
        if (timeEl) timeEl.textContent = '更新於 ' + now;
        showToast('✅ 訂單 #' + orderId + ' 已更新', 'success');
        // Update badge in main row — find and update
        setTimeout(() => location.reload(), 1800);
    })
    .catch(err => showToast('❌ 更新失敗：' + err, 'info'));
}

/* ── Item Edit ── */
function startEdit(itemId) {
    alert('💡 提示：可直接在商品 ID、數量、單價欄位內修改，完成後按「💾 儲存」確認更新。');
    ['pid','qty','price'].forEach(field => {
        const span = document.getElementById('td-'  + (field==='pid'?'pid':field==='qty'?'qty':'price') + '-' + itemId);
        const inp  = document.getElementById('inp-' + (field==='pid'?'pid':field==='qty'?'qty':'price') + '-' + itemId);
        if (span) span.style.display = 'none';
        if (inp)  inp.style.display  = 'inline-block';
    });
    document.getElementById('btn-edit-' + itemId).style.display = 'none';
    document.getElementById('btn-save-' + itemId).style.display = 'inline-block';
}

function saveItem(itemId, orderId) {
    const productId = document.getElementById('inp-pid-'   + itemId)?.value;
    const quantity  = document.getElementById('inp-qty-'   + itemId)?.value;
    const unitPrice = document.getElementById('inp-price-' + itemId)?.value;

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
            // Update display spans
            ['pid','qty','price'].forEach(field => {
                const inp  = document.getElementById('inp-'+field+'-'+itemId);
                const span = document.getElementById('td-' +field+'-'+itemId);
                if (span && inp) {
                    span.textContent = field==='price' ? '$'+parseInt(inp.value).toLocaleString() : inp.value;
                    span.style.display = '';
                    inp.style.display  = 'none';
                }
            });
            const subEl = document.getElementById('td-sub-' + itemId);
            if (subEl) subEl.textContent = '$' + data.subtotal.toLocaleString();
            document.getElementById('btn-edit-' + itemId).style.display = '';
            document.getElementById('btn-save-' + itemId).style.display = 'none';
            showToast('✅ 明細 #' + itemId + ' 已更新，小計 $' + data.subtotal.toLocaleString(), 'success');
        } else {
            showToast('❌ ' + data.message, 'info');
        }
    })
    .catch(err => showToast('❌ 發生錯誤：' + err, 'info'));
}

function deleteItem(itemId, orderId) {
    if (!confirm('確定刪除此商品明細 #' + itemId + '？\n此操作無法復原。')) return;
    const fd = new FormData();
    fd.append('action', 'deleteItem');
    fd.append('itemId', itemId);

    fetch('<%=request.getContextPath()%>/orderItemAction', {method:'POST', body:fd})
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            const row = document.getElementById('irow-' + itemId);
            if (row) row.remove();
            showToast('🗑 明細 #' + itemId + ' 已刪除', 'success');
        } else {
            showToast('❌ ' + data.message, 'info');
        }
    })
    .catch(err => showToast('❌ 發生錯誤：' + err, 'info'));
}

/* ── Search History ── */
function applyHistory(field, kw) {
    document.getElementById('fieldSel').value = field;
    document.getElementById('kwInput').value  = kw;
    document.getElementById('searchForm').submit();
}
function deleteHistory(idx) {
    fetch('<%=request.getContextPath()%>/orderList?_delHist=' + idx)  // no-op, handled below
    .catch(() => {});
    // Client-side remove the chip immediately
    const chips = document.querySelectorAll('.hist-chip');
    if (chips[idx]) chips[idx].remove();
    // Proper way: POST to a history-clear endpoint; for now reload with special param
    const url = new URL(location.href);
    url.searchParams.set('_delHist', idx);
    location.href = url.toString();
}
</script>
</body>
</html>
