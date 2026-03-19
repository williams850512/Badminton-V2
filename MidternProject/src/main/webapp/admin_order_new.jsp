<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理員新增訂單 — 羽球專題</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            padding: 30px 16px;
            color: #e0e0e0;
        }
        .container { max-width: 860px; margin: 0 auto; }
        .back-btn {
            display: inline-flex; align-items: center; gap: 6px;
            color: #53d8fb; text-decoration: none; font-size: 0.85rem;
            margin-bottom: 20px; transition: opacity .2s;
        }
        .back-btn:hover { opacity: .7; }
        h1 { color: #53d8fb; font-size: 1.6rem; margin-bottom: 24px; }

        /* Card */
        .card {
            background: rgba(255,255,255,.07);
            border: 1px solid rgba(83,216,251,.2);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 20px;
        }
        .card h2 { font-size: 1rem; color: #53d8fb; margin-bottom: 18px; border-bottom: 1px solid rgba(83,216,251,.15); padding-bottom: 10px; }

        /* Form Grid */
        .grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
        .full { grid-column: 1/-1; }
        label { display: block; font-size: .8rem; color: #a0c4d8; margin-bottom: 6px; }
        input, select, textarea {
            width: 100%;
            padding: 9px 12px;
            background: rgba(255,255,255,.08);
            border: 1px solid rgba(83,216,251,.25);
            border-radius: 8px;
            color: #e0e0e0;
            font-size: .9rem;
        }
        input:focus, select:focus, textarea:focus {
            outline: none; border-color: #53d8fb;
        }
        select option { background: #1a1a2e; }
        textarea { resize: vertical; min-height: 72px; }

        /* 商品列 */
        .item-row {
            display: grid;
            grid-template-columns: 2fr 1.2fr 1fr 1fr auto;
            gap: 10px;
            align-items: end;
            padding: 12px;
            background: rgba(0,0,0,.2);
            border-radius: 10px;
            margin-bottom: 10px;
        }
        .item-row label { margin-bottom: 4px; }
        .subtotal-display {
            background: rgba(83,216,251,.08);
            border: 1px solid rgba(83,216,251,.2);
            border-radius: 8px;
            padding: 9px 12px;
            color: #2ed573;
            font-weight: bold;
            font-size: .9rem;
        }
        .remove-btn {
            background: rgba(231,76,60,.12);
            border: 1px solid #e74c3c;
            color: #e74c3c;
            border-radius: 6px;
            padding: 8px 12px;
            cursor: pointer;
            font-size: .85rem;
            transition: background .2s;
        }
        .remove-btn:hover { background: rgba(231,76,60,.3); }
        .add-btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 9px 18px;
            background: rgba(83,216,251,.1);
            border: 1px dashed #53d8fb;
            color: #53d8fb;
            border-radius: 8px;
            cursor: pointer;
            font-size: .85rem;
            transition: background .2s;
            margin-top: 4px;
        }
        .add-btn:hover { background: rgba(83,216,251,.2); }

        /* Total */
        .total-bar {
            display: flex; justify-content: flex-end; align-items: center; gap: 16px;
            padding: 14px 0;
            border-top: 1px solid rgba(83,216,251,.15);
            margin-top: 8px;
        }
        .total-bar span { color: #a0c4d8; }
        .total-bar strong { color: #2ed573; font-size: 1.4rem; }

        /* Submit */
        .submit-btn {
            display: block; width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, #53d8fb, #0f3460);
            border: none; border-radius: 10px;
            color: #fff; font-size: 1rem; font-weight: bold;
            cursor: pointer; transition: opacity .2s;
        }
        .submit-btn:hover { opacity: .85; }

        .admin-badge {
            display: inline-block;
            background: rgba(241,196,15,.15);
            border: 1px solid #f1c40f;
            color: #f1c40f;
            border-radius: 20px;
            padding: 3px 12px;
            font-size: .75rem;
            font-weight: bold;
            margin-left: 10px;
            vertical-align: middle;
        }

        @media (max-width: 640px) {
            .grid { grid-template-columns: 1fr; }
            .item-row { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="<%=request.getContextPath()%>/orderList" class="back-btn">◀ 返回訂單管理中心</a>
    <h1>🛒 新增訂單 <span class="admin-badge">👤 管理員模式</span></h1>

    <form action="<%=request.getContextPath()%>/checkout" method="post" id="adminOrderForm">

        <!-- ── 訂單基本資訊 ── -->
        <div class="card">
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
        <div class="card">
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

        <button type="submit" class="submit-btn">✅ 確認新增訂單</button>
    </form>
</div>

<script>
let itemIdx = 0;

function addItem() {
    itemIdx++;
    const container = document.getElementById('itemsContainer');
    const div = document.createElement('div');
    div.className = 'item-row';
    div.id = 'item-' + itemIdx;
    div.innerHTML = `
        <div>
            <label>商品 ID</label>
            <input type="number" name="productId[]" min="1" placeholder="商品 ID"
                   oninput="calcSubtotal(${itemIdx})">
        </div>
        <div>
            <label>數量</label>
            <input type="number" name="quantity[]" id="qty-${itemIdx}" min="1" value="1"
                   oninput="calcSubtotal(${itemIdx})">
        </div>
        <div>
            <label>單價（元）</label>
            <input type="number" name="unitPrice[]" id="price-${itemIdx}" min="0" value="0"
                   oninput="calcSubtotal(${itemIdx})">
        </div>
        <div>
            <label>小計（元）</label>
            <div class="subtotal-display" id="sub-${itemIdx}">$0</div>
            <input type="hidden" name="subtotal[]" id="subtotal-${itemIdx}" value="0">
        </div>
        <div>
            <label>&nbsp;</label>
            <button type="button" class="remove-btn" onclick="removeItem(${itemIdx})">✕</button>
        </div>
    `;
    container.appendChild(div);
    updateTotal();
}

function removeItem(idx) {
    const el = document.getElementById('item-' + idx);
    if (el) el.remove();
    updateTotal();
}

function calcSubtotal(idx) {
    const qty   = parseInt(document.getElementById('qty-'   + idx)?.value) || 0;
    const price = parseInt(document.getElementById('price-' + idx)?.value) || 0;
    const sub   = qty * price;
    if (document.getElementById('sub-' + idx))
        document.getElementById('sub-' + idx).textContent = '$' + sub.toLocaleString();
    if (document.getElementById('subtotal-' + idx))
        document.getElementById('subtotal-' + idx).value = sub;
    updateTotal();
}

function updateTotal() {
    let total = 0;
    document.querySelectorAll('input[name="subtotal[]"]').forEach(el => {
        total += parseInt(el.value) || 0;
    });
    document.getElementById('totalDisplay').textContent = '$' + total.toLocaleString();
    document.getElementById('totalAmount').value = total;
}

// 預設一列
document.addEventListener('DOMContentLoaded', addItem);

// 送出前驗證
document.getElementById('adminOrderForm').addEventListener('submit', function(e) {
    const rows = document.querySelectorAll('input[name="productId[]"]');
    if (rows.length === 0) {
        e.preventDefault();
        alert('⚠️ 請至少新增一項商品！');
        return;
    }
    const total = parseInt(document.getElementById('totalAmount').value);
    if (total <= 0) {
        e.preventDefault();
        alert('⚠️ 訂單總金額必須大於 0，請檢查商品數量與單價。');
    }
});
</script>
</body>
</html>
