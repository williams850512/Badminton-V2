<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理員新增訂單 — 羽球專題</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
    <style>
        /* ===== 新增訂單表單專用 CSS ===== */
        .order-form-container { max-width: 960px; margin: 0 auto; }

        .order-card-dark {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            border: 1px solid rgba(83,216,251,.2);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 20px;
            color: #e0e0e0;
        }
        .order-card-dark h2 { font-size: 1rem; color: #53d8fb; margin-bottom: 18px; border-bottom: 1px solid rgba(83,216,251,.15); padding-bottom: 10px; }

        .grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
        .full { grid-column: 1/-1; }
        .order-card-dark label { display: block; font-size: .8rem; color: #a0c4d8; margin-bottom: 6px; }
        .order-card-dark input, .order-card-dark select, .order-card-dark textarea {
            width: 100%; padding: 9px 12px;
            background: rgba(255,255,255,.08);
            border: 1px solid rgba(83,216,251,.25);
            border-radius: 8px; color: #e0e0e0; font-size: .9rem;
        }
        .order-card-dark input:focus, .order-card-dark select:focus, .order-card-dark textarea:focus {
            outline: none; border-color: #53d8fb;
        }
        .order-card-dark select option { background: #1a1a2e; }
        .order-card-dark textarea { resize: vertical; min-height: 72px; }

        .item-row {
            display: grid;
            grid-template-columns: 0.8fr 2fr 0.8fr 1.2fr 1.2fr auto;
            gap: 10px; align-items: end; padding: 12px;
            background: rgba(0,0,0,.2); border-radius: 10px; margin-bottom: 10px;
        }
        .item-row label { margin-bottom: 4px; }
        .subtotal-display {
            background: rgba(83,216,251,.08);
            border: 1px solid rgba(83,216,251,.2);
            border-radius: 8px; padding: 9px 12px;
            color: #2ed573; font-weight: bold; font-size: .9rem;
        }
        .remove-btn {
            background: rgba(231,76,60,.12); border: 1px solid #e74c3c; color: #e74c3c;
            border-radius: 6px; padding: 8px 12px; cursor: pointer; font-size: .85rem; transition: background .2s;
        }
        .remove-btn:hover { background: rgba(231,76,60,.3); }
        .add-btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 9px 18px; background: rgba(83,216,251,.1);
            border: 1px dashed #53d8fb; color: #53d8fb;
            border-radius: 8px; cursor: pointer; font-size: .85rem; transition: background .2s; margin-top: 4px;
        }
        .add-btn:hover { background: rgba(83,216,251,.2); }

        .total-bar {
            display: flex; justify-content: flex-end; align-items: center; gap: 16px;
            padding: 14px 0; border-top: 1px solid rgba(83,216,251,.15); margin-top: 8px;
        }
        .total-bar span { color: #a0c4d8; }
        .total-bar strong { color: #2ed573; font-size: 1.4rem; }

        .submit-btn {
            display: block; width: 100%; padding: 14px;
            background: linear-gradient(90deg, #53d8fb, #0f3460);
            border: none; border-radius: 10px;
            color: #fff; font-size: 1rem; font-weight: bold;
            cursor: pointer; transition: opacity .2s, background .2s;
        }
        .submit-btn:hover:not(:disabled) { opacity: .85; }
        .submit-btn:disabled { background: #444; color: #888; cursor: not-allowed; }

        .admin-badge {
            display: inline-block; font-size: 0.75rem;
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white; padding: 4px 10px; border-radius: 8px;
            font-weight: bold; letter-spacing: 1px;
            box-shadow: 0 2px 8px rgba(231,76,60,0.4);
            margin-left: 10px; vertical-align: middle; border: none;
        }

        @media (max-width: 640px) {
            .grid { grid-template-columns: 1fr; }
            .item-row { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>

<div class="app-container">

    <jsp:include page="/WEB-INF/backendSidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/backendHeader.jsp" />

        <div class="content-body">
            <div class="order-form-container">
                <a href="<%=request.getContextPath()%>/orderList" class="btn btn-warning" style="margin-bottom: 15px;">◀ 返回訂單管理中心</a>
                <h2 style="color: #2c3e50; margin-bottom: 20px;">🛒 新增訂單 <span class="admin-badge">後台管理員專用</span></h2>

                <form action="<%=request.getContextPath()%>/adminCheckout" method="post" id="adminOrderForm"> 

                    <!-- ── 訂單基本資訊 ── -->
                    <div class="order-card-dark">
                        <h2>📋 訂單資訊</h2>
                        <div class="grid">
                            <div>
                                <label>會員 ID <span style="color:#e74c3c">*</span></label>
                                <input type="number" name="memberId" id="memberId" min="1" required placeholder="輸入會員 ID">
                            </div>
                            <div>
                                <label>付款方式 <span style="color:#e74c3c">*</span></label>
                                <select name="paymentType" required>
                                    <option value="">— 請選擇 —</option>
                                    <option value="信用卡">💳 信用卡</option>
                                    <option value="現金">💵 現金</option>
                                    <option value="轉帳">🏦 銀行轉帳</option>
                                    <option value="LinePay">📱 LINE Pay</option>
                                    <option value="街口支付">📱 街口支付</option>
                                </select>
                            </div>
                            <div>
                                <label>訂單狀態</label>
                                <select name="status">
                                    <option value="PENDING">⏳ 待付款 (PENDING)</option>
                                    <option value="PAID">✅ 已付款 (PAID)</option>
                                    <option value="SHIPPED">🚚 已出貨 (SHIPPED)</option>
                                    <option value="CANCELLED">❌ 已取消 (CANCELLED)</option>
                                </select>
                            </div>
                            <div>
                                <label>管理員備註</label>
                                <input type="text" name="note" placeholder="選填：管理人員補充說明">
                            </div>
                        </div>
                    </div>

                    <!-- ── 商品明細 ── -->
                    <div class="order-card-dark">
                        <h2>📦 商品明細</h2>
                        <div id="itemsContainer">
                            <!-- 由 JS 動態產生 -->
                        </div>
                        <button type="button" class="add-btn" onclick="addItem()">＋ 新增商品列</button>
                        <div class="total-bar">
                            <span>訂單總金額：</span>
                            <strong id="totalDisplay">$0</strong>
                            <input type="hidden" name="totalAmount" id="totalAmount" value="0">
                        </div>
                    </div>

                    <button type="submit" class="submit-btn" id="submitBtn" disabled>✅ 確認新增訂單</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
let itemIdx = 0;

// 解決 JSP EL 與 JS Template Literal 衝突問題：改用字串拼接
function addItem() {
    itemIdx++;
    console.log("Adding item index: " + itemIdx);
    const container = document.getElementById('itemsContainer');
    const div = document.createElement('div');
    div.className = 'item-row';
    div.id = 'item-' + itemIdx;
    
    // 注意：這裡不使用 ${} 以避免 JSP 解析錯誤
    div.innerHTML = 
        '<div>' +
            '<label>商品 ID</label>' +
            '<input type="number" name="productId" id="pid-' + itemIdx + '" min="1" placeholder="ID" ' +
                   'onchange="fetchProductInfo(' + itemIdx + ', \'id\')">' +
        '</div>' +
        '<div>' +
            '<label>商品名稱</label>' +
            '<input type="text" name="productName" id="pname-' + itemIdx + '" placeholder="商品名稱" ' +
                   'onchange="fetchProductInfo(' + itemIdx + ', \'name\')">' +
        '</div>' +
        '<div>' +
            '<label>數量</label>' +
            '<input type="number" name="quantity" id="qty-' + itemIdx + '" min="1" value="1" ' +
                   'oninput="calcSubtotal(' + itemIdx + ')">' +
        '</div>' +
        '<div>' +
            '<label>單價（元）</label>' +
            '<input type="number" name="unitPrice" id="price-' + itemIdx + '" min="0" value="0" ' +
                   'oninput="calcSubtotal(' + itemIdx + ')">' +
        '</div>' +
        '<div>' +
            '<label>小計（元）</label>' +
            '<div class="subtotal-display" id="sub-' + itemIdx + '">$0</div>' +
            '<input type="hidden" name="subtotal" id="subtotal-' + itemIdx + '" value="0">' +
        '</div>' +
        '<div>' +
            '<label>&nbsp;</label>' +
            '<button type="button" class="remove-btn" onclick="removeItem(' + itemIdx + ')">✕</button>' +
        '</div>';
        
    container.appendChild(div);
    updateTotal();
}

function fetchProductInfo(idx, type) {
    const inputEl = document.getElementById(type === 'id' ? 'pid-' + idx : 'pname-' + idx);
    const val = inputEl ? inputEl.value : "";
    console.log("Fetching product info for idx: " + idx + ", type: " + type + ", val: " + val);
    
    if (!val) return;

    let url = '<%=request.getContextPath()%>/api/productQuery?';
    url += (type === 'id') ? 'id=' + val : 'name=' + encodeURIComponent(val);

    console.log("Request URL: " + url);

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("HTTP error " + response.status);
            return response.json();
        })
        .then(data => {
            console.log("Received data:", data);
            if (data.success) {
                document.getElementById('pid-' + idx).value = data.product.id;
                document.getElementById('pname-' + idx).value = data.product.name;
                document.getElementById('price-' + idx).value = data.product.price;
                calcSubtotal(idx);
            } else {
                console.warn("Product not found: " + data.message);
                alert("找不到該商品，請檢查 ID 或名稱是否正確。");
            }
        })
        .catch(err => {
            console.error('Error fetching product info:', err);
            alert("查詢商品失敗，請確認伺服器已編譯且 ProductQueryServlet 已啟動。");
        });
}

function removeItem(idx) {
    const el = document.getElementById('item-' + idx);
    if (el) el.remove();
    updateTotal();
}

function calcSubtotal(idx) {
    const qtyEl = document.getElementById('qty-' + idx);
    const priceEl = document.getElementById('price-' + idx);
    const qty   = parseInt(qtyEl ? qtyEl.value : 0) || 0;
    const price = parseInt(priceEl ? priceEl.value : 0) || 0;
    const sub   = qty * price;
    
    console.log("Calculating subtotal for idx: " + idx + ", qty: " + qty + ", price: " + price + " = " + sub);
    
    const subDisplay = document.getElementById('sub-' + idx);
    const subHidden = document.getElementById('subtotal-' + idx);
    
    if (subDisplay) subDisplay.textContent = '$' + sub.toLocaleString();
    if (subHidden) subHidden.value = sub;
    
    updateTotal();
}

function updateTotal() {
    let total = 0;
    const subtotals = document.querySelectorAll('input[name="subtotal"]');
    subtotals.forEach(el => {
        total += parseInt(el.value) || 0;
    });
    
    console.log("Updating total: " + total);
    
    document.getElementById('totalDisplay').textContent = '$' + total.toLocaleString();
    document.getElementById('totalAmount').value = total;
    
    // 總金額 > 0 才能按下按鈕
    const submitBtn = document.getElementById('submitBtn');
    if (submitBtn) submitBtn.disabled = (total <= 0);
}

// 預設一列
document.addEventListener('DOMContentLoaded', function() {
    addItem();
});

// 送出前驗證
// 送出前驗證與成功提示
document.getElementById('adminOrderForm').addEventListener('submit', function(e) {
    const rows = document.querySelectorAll('input[name="productId"]');
    let hasEmptyId = false;
    rows.forEach(row => { if(!row.value) hasEmptyId = true; });

    if (rows.length === 0) {
        e.preventDefault();
        alert('⚠️ 請至少新增一項商品！');
        return;
    }
    if (hasEmptyId) {
        e.preventDefault();
        alert('⚠️ 請確保所有商品 ID 已填寫！');
        return;
    }
    const total = parseInt(document.getElementById('totalAmount').value);
    if (total <= 0) {
        e.preventDefault();
        alert('⚠️ 訂單總金額必須大於 0，請檢查商品數量與單價。');
        return; // 這裡補上 return 防止繼續執行
    }
    
    // ✨ 驗證全數通過，準備送出前跳出提醒視窗！
    alert('✅ 管理員新增一筆訂單，準備送出！');
    // 按下確定後，表單就會自然把資料送到 Servlet 囉！
});
</script>
</body>
</html>
