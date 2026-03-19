<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>購物車結帳 — 羽球專題</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            padding: 40px 20px;
            color: #e0e0e0;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        h1 {
            text-align: center;
            color: #53d8fb;
            font-size: 2rem;
            margin-bottom: 30px;
            letter-spacing: 2px;
        }
        h1 span { color: #fff; }
        .card {
            background: rgba(255,255,255,0.07);
            border: 1px solid rgba(83,216,251,0.2);
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 24px;
            backdrop-filter: blur(10px);
        }
        .card h2 {
            color: #53d8fb;
            font-size: 1.1rem;
            margin-bottom: 18px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(83,216,251,0.2);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        .form-row.full { grid-template-columns: 1fr; }
        label {
            display: block;
            font-size: 0.85rem;
            color: #a0c4d8;
            margin-bottom: 6px;
        }
        input, select, textarea {
            width: 100%;
            padding: 10px 14px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(83,216,251,0.25);
            border-radius: 8px;
            color: #fff;
            font-size: 0.95rem;
            transition: border 0.2s;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #53d8fb;
        }
        select option { background: #1a1a2e; color: #fff; }
        textarea { resize: vertical; min-height: 70px; }

        /* 商品明細區塊 */
        #items-container .item-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 36px;
            gap: 10px;
            margin-bottom: 12px;
            align-items: end;
        }
        .remove-btn {
            background: rgba(231,76,60,0.2);
            border: 1px solid #e74c3c;
            color: #e74c3c;
            border-radius: 8px;
            cursor: pointer;
            padding: 10px;
            font-size: 0.9rem;
            transition: background 0.2s;
        }
        .remove-btn:hover { background: rgba(231,76,60,0.4); }
        .add-btn {
            background: rgba(83,216,251,0.1);
            border: 1px dashed rgba(83,216,251,0.5);
            color: #53d8fb;
            border-radius: 8px;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 0.9rem;
            width: 100%;
            transition: background 0.2s;
            margin-top: 4px;
        }
        .add-btn:hover { background: rgba(83,216,251,0.2); }

        /* 總金額顯示 */
        .total-section {
            text-align: right;
            padding: 14px 0 0;
            border-top: 1px solid rgba(83,216,251,0.2);
            margin-top: 14px;
        }
        .total-section span {
            font-size: 1.4rem;
            font-weight: bold;
            color: #53d8fb;
        }

        /* 送出按鈕 */
        .submit-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(90deg, #53d8fb, #0f3460);
            border: none;
            border-radius: 10px;
            color: #fff;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.1s;
            letter-spacing: 1px;
        }
        .submit-btn:hover { opacity: 0.9; transform: translateY(-1px); }
        .submit-btn:active { transform: translateY(0); }

        .nav-link {
            display: inline-block;
            color: #a0c4d8;
            text-decoration: none;
            font-size: 0.9rem;
            margin-bottom: 20px;
        }
        .nav-link:hover { color: #53d8fb; }
    </style>
</head>
<body>
<div class="container">
    <a href="<%=request.getContextPath()%>/orderList" class="nav-link">← 查看我的訂單</a>
    <h1>🏸 <span>購物車</span>結帳</h1>

    <form id="checkoutForm" action="<%=request.getContextPath()%>/checkout" method="post">

        <!-- 訂購人資訊 -->
        <div class="card">
            <h2>👤 訂購人資訊</h2>
            <div class="form-row">
                <div>
                    <label for="memberId">會員 ID</label>
                    <input type="number" id="memberId" name="memberId" value="1" min="1" required>
                </div>
                <div>
                    <label for="paymentType">付款方式</label>
                    <select id="paymentType" name="paymentType" required>
                        <option value="信用卡">信用卡</option>
                        <option value="ATM轉帳">ATM 轉帳</option>
                        <option value="超商代碼">超商代碼</option>
                        <option value="貨到付款">貨到付款</option>
                    </select>
                </div>
            </div>
            <div class="form-row full">
                <div>
                    <label for="note">備註（選填）</label>
                    <textarea id="note" name="note" placeholder="例如：請在週末前出貨"></textarea>
                </div>
            </div>
        </div>

        <!-- 商品明細 -->
        <div class="card">
            <h2>🛒 商品明細</h2>
            <div id="items-container">
                <!-- 欄位標題 -->
                <div style="display:grid; grid-template-columns:2fr 1fr 1fr 1fr 36px; gap:10px; margin-bottom:6px;">
                    <label>商品 ID（product_id）</label>
                    <label>數量</label>
                    <label>單價（元）</label>
                    <label>小計（元）</label>
                    <span></span>
                </div>
                <!-- 預設一列商品 -->
                <div class="item-row" id="item-0">
                    <input type="number" name="productId" placeholder="商品 ID" min="1" required onchange="calcTotal()">
                    <input type="number" name="quantity" placeholder="數量" min="1" value="1" required oninput="calcRow(this); calcTotal()">
                    <input type="number" name="unitPrice" placeholder="單價" min="0" required oninput="calcRow(this); calcTotal()">
                    <input type="number" name="subtotal" placeholder="小計" min="0" readonly>
                    <button type="button" class="remove-btn" onclick="removeRow(this)">✕</button>
                </div>
            </div>
            <button type="button" class="add-btn" onclick="addRow()">＋ 新增商品</button>

            <!-- 總金額 -->
            <input type="hidden" id="totalAmountInput" name="totalAmount" value="0">
            <div class="total-section">
                總金額：<span id="totalDisplay">$0</span>
            </div>
        </div>

        <!-- 送出 -->
        <button type="submit" class="submit-btn" onclick="return confirmSubmit()">✅ 確認結帳</button>
    </form>
</div>

<script>
    let rowCount = 1;

    function addRow() {
        const container = document.getElementById('items-container');
        const div = document.createElement('div');
        div.className = 'item-row';
        div.id = 'item-' + rowCount++;
        div.innerHTML = `
            <input type="number" name="productId" placeholder="商品 ID" min="1" required onchange="calcTotal()">
            <input type="number" name="quantity" placeholder="數量" min="1" value="1" required oninput="calcRow(this); calcTotal()">
            <input type="number" name="unitPrice" placeholder="單價" min="0" required oninput="calcRow(this); calcTotal()">
            <input type="number" name="subtotal" placeholder="小計" min="0" readonly>
            <button type="button" class="remove-btn" onclick="removeRow(this)">✕</button>`;
        container.appendChild(div);
    }

    function removeRow(btn) {
        const rows = document.querySelectorAll('.item-row');
        if (rows.length <= 1) { alert('至少要保留一項商品！'); return; }
        btn.closest('.item-row').remove();
        calcTotal();
    }

    function calcRow(input) {
        const row = input.closest('.item-row');
        const qty = parseFloat(row.querySelector('[name="quantity"]').value) || 0;
        const price = parseFloat(row.querySelector('[name="unitPrice"]').value) || 0;
        row.querySelector('[name="subtotal"]').value = qty * price;
    }

    function calcTotal() {
        let total = 0;
        document.querySelectorAll('[name="subtotal"]').forEach(el => {
            total += parseFloat(el.value) || 0;
        });
        document.getElementById('totalDisplay').textContent = '$' + total.toLocaleString();
        document.getElementById('totalAmountInput').value = total;
    }

    function confirmSubmit() {
        const total = parseInt(document.getElementById('totalAmountInput').value);
        if (total <= 0) { alert('請填寫商品資料，總金額不能為 0！'); return false; }
        return confirm('確認結帳？總金額為 $' + total.toLocaleString());
    }
</script>
</body>
</html>
