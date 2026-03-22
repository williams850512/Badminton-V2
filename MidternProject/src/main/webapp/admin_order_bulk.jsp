<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>批次新增訂單 — 營運加速模式</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            padding: 30px 16px;
            color: #e0e0e0;
        }
        .container { max-width: 1080px; margin: 0 auto; }
        .back-btn {
            display: inline-flex; align-items: center; gap: 6px;
            color: #53d8fb; text-decoration: none; font-size: 0.85rem;
            margin-bottom: 20px; transition: opacity .2s;
        }
        .back-btn:hover { opacity: .7; }
        .header-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        h1 { color: #f1c40f; font-size: 1.6rem; }
        
        .admin-badge {
            display: inline-block;
            font-size: 0.75rem; 
            background: linear-gradient(135deg, #e74c3c, #c0392b); 
            color: white; 
            padding: 4px 10px; 
            border-radius: 8px; 
            font-weight: bold; 
            letter-spacing: 1px; 
            box-shadow: 0 2px 8px rgba(231,76,60,0.4);
            margin-left: 10px;
            vertical-align: middle;
            border: none;
        }

        /* 訂單大區塊 */
        .order-card {
            background: rgba(255,255,255,.05);
            border: 2px solid rgba(241,196,15,.3);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
            position: relative;
        }
        .order-header {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 1px solid rgba(241,196,15,.2);
            padding-bottom: 12px; margin-bottom: 16px;
        }
        .order-title { font-size: 1.1rem; color: #f1c40f; font-weight: bold; }
        .del-order-btn {
            background: rgba(231,76,60,.15); color: #e74c3c; border: 1px solid #e74c3c;
            padding: 5px 12px; border-radius: 6px; cursor: pointer; font-size: 0.8rem;
        }
        .del-order-btn:hover { background: rgba(231,76,60,.4); }

        /* 表單網格 */
        .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 16px; }
        label { display: block; font-size: .75rem; color: #a0c4d8; margin-bottom: 4px; }
        input, select {
            width: 100%; padding: 7px 10px; background: rgba(255,255,255,.08);
            border: 1px solid rgba(83,216,251,.25); border-radius: 6px; color: #e0e0e0; font-size: .85rem;
        }
        input:focus, select:focus { outline: none; border-color: #53d8fb; }
        select option { background: #1a1a2e; }

        /* 商品明細列 */
        .items-area { background: rgba(0,0,0,.15); padding: 12px; border-radius: 8px; }
        .item-row {
            display: grid; grid-template-columns: 0.8fr 2fr 0.8fr 1fr 1fr auto;
            gap: 8px; align-items: end; margin-bottom: 8px;
        }
        .subtotal-display {
            background: rgba(83,216,251,.08); border: 1px solid rgba(83,216,251,.2);
            border-radius: 6px; padding: 7px 10px; color: #2ed573; font-weight: bold; font-size: .85rem;
        }
        .add-item-btn {
            background: transparent; color: #53d8fb; border: 1px dashed #53d8fb;
            padding: 5px 12px; border-radius: 6px; cursor: pointer; font-size: 0.8rem; margin-top: 5px;
        }
        
        /* 底部操作區 */
        .action-bar {
            position: sticky; bottom: 20px;
            background: rgba(15, 52, 96, 0.95); backdrop-filter: blur(10px);
            border: 1px solid rgba(83,216,251,.3); border-radius: 12px;
            padding: 16px 24px; display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5); z-index: 100;
        }
        .add-order-btn {
            background: rgba(241,196,15,.2); color: #f1c40f; border: 1px solid #f1c40f;
            padding: 10px 20px; border-radius: 8px; font-weight: bold; cursor: pointer;
        }
        .submit-btn {
            background: linear-gradient(90deg, #2ed573, #0f3460); border: none;
            color: white; padding: 10px 30px; border-radius: 8px; font-weight: bold; font-size: 1.1rem; cursor: pointer;
        }
        .submit-btn:disabled { background: #555; cursor: not-allowed; }
    </style>
</head>
<body>
<div class="container">
    <a href="<%=request.getContextPath()%>/orderList" class="back-btn">◀ 返回訂單管理中心</a>
    
    <div class="header-bar">
        <h1>⚡ 批次新增訂單 <span class="admin-badge">後台管理員專用</span></h1>
        <div style="color:#a0c4d8; font-size:0.9rem;">
            目前總單數：<span id="globalOrderCount" style="color:#f1c40f; font-size:1.4rem; font-weight:bold;">0</span>
        </div>
    </div>

    <form action="<%=request.getContextPath()%>/adminBulkCheckout" method="post" id="bulkOrderForm">
        
        <input type="hidden" name="activeOrderIndices" id="activeOrderIndices" value="">

        <div id="ordersContainer">
            </div>

        <div class="action-bar">
            <button type="button" class="add-order-btn" onclick="addOrder()">➕ 新增下一張訂單</button>
            <button type="submit" class="submit-btn" id="submitBtn" disabled>🚀 批次送出全部訂單</button>
        </div>
    </form>
</div>

<script>
let globalOrderIdx = 0;
let activeOrders = []; // 存放存活的訂單編號

function addOrder() {
    globalOrderIdx++;
    activeOrders.push(globalOrderIdx);
    
    const container = document.getElementById('ordersContainer');
    const orderCard = document.createElement('div');
    orderCard.className = 'order-card';
    orderCard.id = 'orderCard-' + globalOrderIdx;
    
    orderCard.innerHTML = 
        '<div class="order-header">' +
            '<div class="order-title">📝 訂單作業區 #' + globalOrderIdx + '</div>' +
            '<button type="button" class="del-order-btn" onclick="removeOrder(' + globalOrderIdx + ')">🗑 刪除此單</button>' +
        '</div>' +
        '<div class="grid">' +
            '<div><label>會員 ID *</label><input type="number" name="memberId_' + globalOrderIdx + '" min="1" required></div>' +
            '<div><label>付款方式 *</label>' +
                '<select name="paymentType_' + globalOrderIdx + '" required>' +
                    '<option value="">選擇付款方式</option><option value="現金">現金</option><option value="LinePay">LinePay</option><option value="信用卡">信用卡</option><option value="轉帳">轉帳</option>' +
                '</select>' +
            '</div>' +
            '<div><label>訂單狀態</label>' +
                '<select name="status_' + globalOrderIdx + '">' +
                    '<option value="PENDING">待付款</option><option value="PAID">已付款</option><option value="COMPLETED">已完成</option>' +
                '</select>' +
            '</div>' +
            '<div><label>訂單總計</label><input type="text" id="totalDisplay_' + globalOrderIdx + '" value="$0" readonly style="background:transparent; border:none; color:#2ed573; font-weight:bold; font-size:1.1rem; padding:0;">' +
            '<input type="hidden" name="totalAmount_' + globalOrderIdx + '" id="totalAmount_' + globalOrderIdx + '" value="0"></div>' +
            '<div style="grid-column: 1/-1;"><label>備註</label><input type="text" name="note_' + globalOrderIdx + '" placeholder="選填"></div>' +
        '</div>' +
        '<div class="items-area">' +
            '<div id="itemsContainer_' + globalOrderIdx + '"></div>' +
            '<button type="button" class="add-item-btn" onclick="addItem(' + globalOrderIdx + ')">＋ 新增此單明細</button>' +
        '</div>';
        
    container.appendChild(orderCard);
    addItem(globalOrderIdx); // 預設給他一個商品列
    updateGlobalState();
}

let globalItemCounter = 0; // 用來綁定唯一 ID，避免重複

function addItem(orderIdx) {
    globalItemCounter++;
    const container = document.getElementById('itemsContainer_' + orderIdx);
    const div = document.createElement('div');
    div.className = 'item-row';
    div.id = 'itemRow-' + globalItemCounter;
    
    // 注意 name 的命名法：productId_1 (代表第 1 張單的商品陣列)
    div.innerHTML = 
        '<div><label>商品 ID</label><input type="number" name="productId_' + orderIdx + '" id="pid-' + globalItemCounter + '" min="1" required onchange="fetchProduct(' + globalItemCounter + ', ' + orderIdx + ')"></div>' +
        '<div><label>商品名稱</label><input type="text" id="pname-' + globalItemCounter + '" readonly style="background:rgba(0,0,0,.2);"></div>' +
        '<div><label>數量</label><input type="number" name="quantity_' + orderIdx + '" id="qty-' + globalItemCounter + '" min="1" value="1" oninput="calcSub(' + globalItemCounter + ', ' + orderIdx + ')"></div>' +
        '<div><label>單價</label><input type="number" name="unitPrice_' + orderIdx + '" id="price-' + globalItemCounter + '" min="0" value="0" oninput="calcSub(' + globalItemCounter + ', ' + orderIdx + ')"></div>' +
        '<div><label>小計</label><div class="subtotal-display" id="sub-' + globalItemCounter + '">$0</div><input type="hidden" name="subtotal_' + orderIdx + '" id="subtotal-' + globalItemCounter + '" class="sub_class_' + orderIdx + '" value="0"></div>' +
        '<div><label>&nbsp;</label><button type="button" class="del-order-btn" onclick="removeItem(' + globalItemCounter + ', ' + orderIdx + ')">✕</button></div>';
        
    container.appendChild(div);
}

// 呼叫 API 查詢商品
function fetchProduct(itemCounter, orderIdx) {
    const val = document.getElementById('pid-' + itemCounter).value;
    if (!val) return;
    fetch('<%=request.getContextPath()%>/api/productQuery?id=' + val)
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                document.getElementById('pname-' + itemCounter).value = data.product.name;
                document.getElementById('price-' + itemCounter).value = data.product.price;
                calcSub(itemCounter, orderIdx);
            } else { alert("找不到該商品ID！"); }
        });
}

function calcSub(itemCounter, orderIdx) {
    const qty = parseInt(document.getElementById('qty-' + itemCounter).value) || 0;
    const price = parseInt(document.getElementById('price-' + itemCounter).value) || 0;
    const sub = qty * price;
    
    document.getElementById('sub-' + itemCounter).textContent = '$' + sub;
    document.getElementById('subtotal-' + itemCounter).value = sub;
    
    // 計算單筆訂單的總金額
    let orderTotal = 0;
    document.querySelectorAll('.sub_class_' + orderIdx).forEach(el => { orderTotal += parseInt(el.value)||0; });
    document.getElementById('totalDisplay_' + orderIdx).value = '$' + orderTotal;
    document.getElementById('totalAmount_' + orderIdx).value = orderTotal;
}

function removeItem(itemCounter, orderIdx) {
    document.getElementById('itemRow-' + itemCounter).remove();
    calcSub(itemCounter, orderIdx); // 重新計算該訂單總計
}

function removeOrder(orderIdx) {
    document.getElementById('orderCard-' + orderIdx).remove();
    activeOrders = activeOrders.filter(id => id !== orderIdx);
    updateGlobalState();
}

function updateGlobalState() {
    document.getElementById('globalOrderCount').textContent = activeOrders.length;
    document.getElementById('activeOrderIndices').value = activeOrders.join(',');
    document.getElementById('submitBtn').disabled = (activeOrders.length === 0);
}

// 預設給他開第一張單
document.addEventListener('DOMContentLoaded', addOrder);

// ✨ CQT 要求：送出前的確認彈窗
document.getElementById('bulkOrderForm').addEventListener('submit', function(e) {
    e.preventDefault(); // 先擋下來
    
    const count = activeOrders.length;
    if(count === 0) return;

    // 簡單的防呆檢查
    let isValid = true;
    activeOrders.forEach(idx => {
        const total = parseInt(document.getElementById('totalAmount_' + idx).value);
        if(total <= 0) {
            alert('⚠️ 訂單作業區 #' + idx + ' 的總金額為 0，請檢查商品！');
            isValid = false;
        }
    });

    if(isValid) {
        // ✨ 精準彈出批次作業確認視窗！
        if(confirm('⚡ 系統提示：即將批次新增 ' + count + ' 筆訂單，確定送出嗎？')) {
            this.submit(); // 確認後才真正放行表單
        }
    }
});
</script>
</body>
</html>