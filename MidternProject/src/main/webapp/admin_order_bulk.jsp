<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>批次新增訂單 — 羽球館管理系統</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* =========================================
       1. 全域 UI 設定 (無印風)
       ========================================= */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    body { background-color: #f4f7f6; color: #333; }
    .app-container { display: flex; height: 100vh; overflow: hidden; }
    
    .sidebar { width: 15%; background-color: #2c3e50; color: #fff; display: flex; flex-direction: column; }
    .sidebar-logo { padding: 20px; font-size: 22px; font-weight: bold; text-align: center; border-bottom: 1px solid #34495e; letter-spacing: 2px;}
    .sidebar-menu { list-style: none; padding: 10px 0; margin: 0; }
    .sidebar-menu li { padding: 15px 25px; cursor: pointer; border-left: 4px solid transparent; transition: 0.2s; }
    .sidebar-menu li:hover, .sidebar-menu li.active { background-color: #34495e; border-left: 4px solid #3498db; }
    .sidebar-menu li.active { color: #3498db; font-weight: bold;}
    .sidebar-menu a { text-decoration: none; color: inherit; display: block; }
    
    .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .top-header { height: 60px; background-color: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; z-index: 10; }
    .header-title { font-size: 18px; font-weight: bold; color: #555; }
    
    .content-body { flex: 1; padding: 20px; overflow-y: auto; }
    
    .order-card { background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 25px; border: 1px solid #e1e4e8; border-left: 5px solid #3498db; position: relative;}
    .order-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
    
    .table-custom { width: 100%; border-collapse: collapse; margin-top: 10px; }
    .table-custom th, .table-custom td { border-bottom: 1px solid #eee; padding: 8px 6px; text-align: left; vertical-align: middle; }
    .table-custom th { background-color: #f8f9fa; color: #555; font-weight: bold; white-space: nowrap; font-size: 0.85rem;}
    
    .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; display: inline-block; transition: 0.2s; font-weight: bold; }
    .btn-primary { background-color: #3498db; color: white; }
    .btn-primary:hover { background-color: #2980b9; }
    .btn-danger { background-color: #e74c3c; color: white; }
    .btn-warning { background-color: #f1c40f; color: #333; }
    .btn-success { background-color: #28a745; color: white; }
    
    /* ✨ 完美正方形小圖示按鈕 */
    .btn-icon {
        width: 28px; height: 28px; padding: 0; display: inline-flex;
        align-items: center; justify-content: center; font-size: 0.85rem; margin-right: 4px;
    }
    .btn-icon:last-child { margin-right: 0; }
    
    .form-control { padding: 8px 8px; border: 1px solid #ccc; border-radius: 4px; font-size: 0.85rem; outline: none; width: 100%; }
    .form-control:focus { border-color: #3498db; }
    .form-control[readonly] { background-color: #e9ecef; color: #666; font-weight: bold; border-color: #ddd;}

    /* 控制輸入框寬度 */
    .input-xs { width: 70px; }
    .input-sm { width: 100px; }
    .input-md { width: 150px; }
    .input-note { width: 350px; }

    .toast { position: fixed; top: 18px; right: 18px; padding: 12px 24px; border-radius: 6px; font-weight: bold; font-size: 0.88rem; display: none; z-index: 9999; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
    .toast.error { background: #dc3545; color: #fff; }
</style>
</head>
<body>

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
        <div class="top-header">
            <div class="header-title">羽球館管理系統 / 批次新增多筆訂單</div>
        </div>

        <div class="content-body">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2 style="color: #2c3e50;">⚡ 建立新訂單 (支援多單多明細)</h2>
                <a href="<%=request.getContextPath()%>/orderList" class="btn btn-warning">⬅ 返回訂單列表</a>
            </div>

            <div id="ordersContainer">
                </div>

            <div style="text-align: center; margin-top: 30px; margin-bottom: 50px; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                <button type="button" class="btn btn-primary" style="font-size: 1.1rem; padding: 12px 30px; margin-right: 15px;" onclick="addOrderBlock()">➕ 再新增一張訂單</button>
                <button type="button" class="btn btn-success" style="font-size: 1.1rem; padding: 12px 50px;" onclick="submitAllOrders()">🚀 確認送出所有訂單</button>
            </div>
        </div>
    </div>
</div>

<script>
let orderCounter = 0;

window.onload = function() {
    addOrderBlock();
};

function showError(msg) {
    const t = document.getElementById('toast');
    t.textContent = msg; t.style.display = 'block';
    setTimeout(() => { t.style.display = 'none'; }, 3000);
}

function addOrderBlock() {
    orderCounter++;
    const container = document.getElementById('ordersContainer');
    const orderId = 'order_' + Date.now(); 

    const cardHtml = `
        <div class="order-card" id="` + orderId + `">
            <div class="order-header">
                <h3 style="color: #3498db; margin: 0;">📦 訂單號次：#<span class="display-order-num">` + orderCounter + `</span></h3>
                <button type="button" class="btn btn-danger" style="padding: 5px 10px; font-size: 0.8rem;" onclick="removeOrderBlock('` + orderId + `')">🗑 刪除整張訂單</button>
            </div>
            
            <div style="display: flex; gap: 15px; align-items: flex-end; margin-bottom: 20px; background: #f8f9fa; padding: 15px; border-radius: 6px;">
                <div>
                    <label style="font-weight:bold; font-size:0.85rem; color:#555;">會員 ID <span style="color:red">*</span></label>
                    <input type="number" class="form-control input-sm o-member" placeholder="輸入ID" required>
                </div>
                <div>
                    <label style="font-weight:bold; font-size:0.85rem; color:#555;">付款方式</label>
                    <select class="form-control input-md o-pay">
                        <option value="現金" selected>💵 現金</option>
                        <option value="信用卡">💳 信用卡</option>
                        <option value="轉帳">🏦 轉帳</option>
                        <option value="LinePay">📱 LINE Pay</option>
                    </select>
                </div>
                <div>
                    <label style="font-weight:bold; font-size:0.85rem; color:#555;">備註 (選填)</label>
                    <input type="text" class="form-control input-note o-note" placeholder="例如：急件、包裝仔細...">
                </div>
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                <h4 style="color: #555;">商品明細</h4>
                <button type="button" class="btn btn-primary" style="padding: 4px 10px; font-size: 0.8rem;" onclick="addItemRow('` + orderId + `')">➕ 加入商品</button>
            </div>

            <table class="table-custom">
                <thead>
                    <tr>
                        <th width="40">#</th>
                        <th width="100">商品 ID</th>
                        <th>商品名稱 <span style="font-size:0.7rem;color:#999;">(自動)</span></th>
                        <th width="100">單價 <span style="font-size:0.7rem;color:#999;">(唯讀)</span></th>
                        <th width="80">數量</th>
                        <th width="120">小計 <span style="font-size:0.7rem;color:#999;">(自動)</span></th>
                        <th width="80">操作</th> 
                    </tr>
                </thead>
                <tbody class="items-body">
                    </tbody>
            </table>
        </div>
    `;
    
    container.insertAdjacentHTML('beforeend', cardHtml);
    addItemRow(orderId);
    recalculateOrderNumbers();
}

function removeOrderBlock(orderId) {
    const cards = document.querySelectorAll('.order-card');
    if (cards.length <= 1) {
        alert('⚠️ 至少需要保留一張訂單！'); return;
    }
    document.getElementById(orderId).remove();
    recalculateOrderNumbers();
}

function recalculateOrderNumbers() {
    const cards = document.querySelectorAll('.order-card');
    cards.forEach((card, index) => {
        card.querySelector('.display-order-num').textContent = index + 1;
    });
}

// ✨ 自動更新該訂單內的所有「商品項次 (1, 2, 3...)」
function updateItemRowNumbers(orderId) {
    const rows = document.querySelectorAll('#' + orderId + ' .item-row');
    rows.forEach((row, index) => {
        const numCell = row.querySelector('.row-num');
        if (numCell) numCell.textContent = index + 1;
    });
}

function addItemRow(orderId) {
    const tbody = document.querySelector('#' + orderId + ' .items-body');
    const tr = document.createElement('tr');
    tr.className = 'item-row';
    
    tr.innerHTML = `
        <td class="row-num" style="color: #999; font-weight: bold; text-align: center;"></td>
        <td><input type="number" class="form-control input-sm i-pid" placeholder="輸入ID" onchange="fetchProductInfo(this)" required></td>
        <td><input type="text" class="form-control i-pname" placeholder="自動帶入" readonly></td>
        <td><input type="number" class="form-control input-sm i-price" placeholder="0" readonly></td>
        <td><input type="number" class="form-control input-xs i-qty" value="1" min="1" oninput="calculateSubtotal(this)" required></td>
        <td><input type="text" class="form-control input-sm i-subtotal" value="0" style="color:#28a745; font-weight:bold;" readonly></td>
        <td style="white-space: nowrap;">
            <button type="button" class="btn btn-primary btn-icon" title="新增下一筆商品" onclick="addItemRow('` + orderId + `')">➕</button>
            <button type="button" class="btn btn-danger btn-icon" title="刪除此列" onclick="removeItemRow(this, '` + orderId + `')">✕</button>
        </td>
    `;
    tbody.appendChild(tr);
    updateItemRowNumbers(orderId); // 新增完後重新編號
}

function removeItemRow(btn, orderId) {
    const tbody = btn.closest('tbody');
    if (tbody.children.length > 1) {
        btn.closest('tr').remove();
        updateItemRowNumbers(orderId); // 刪除後重新編號
    } else {
        alert('⚠️ 每張訂單至少需要一項商品！');
    }
}

function calculateSubtotal(element) {
    const row = element.closest('tr');
    const price = parseFloat(row.querySelector('.i-price').value) || 0;
    const qty = parseInt(row.querySelector('.i-qty').value) || 0;
    row.querySelector('.i-subtotal').value = (price * qty).toLocaleString('en-US'); 
}

function fetchProductInfo(inputEl) {
    const row = inputEl.closest('tr');
    const productId = inputEl.value.trim();
    const nameInput = row.querySelector('.i-pname');
    const priceInput = row.querySelector('.i-price');

    if (!productId) {
        nameInput.value = ''; priceInput.value = ''; calculateSubtotal(inputEl); return;
    }

    nameInput.value = '讀取中...';
    
    fetch('<%=request.getContextPath()%>/api/productQuery?id=' + productId)
    .then(r => r.json())
    .then(data => {
        if (data.success && data.product) {
            nameInput.value = data.product.name;
            priceInput.value = data.product.price;
            inputEl.style.borderColor = '#28a745'; 
        } else {
            nameInput.value = '❌ 找不到商品';
            priceInput.value = 0;
            inputEl.style.borderColor = '#dc3545'; 
        }
        calculateSubtotal(inputEl);
    }).catch(err => {
        nameInput.value = '❌ 系統錯誤'; priceInput.value = 0; calculateSubtotal(inputEl);
    });
}

function submitAllOrders() {
    const orderCards = document.querySelectorAll('.order-card');
    const formData = new URLSearchParams();
    
    formData.append("action", "createBulkAdvanced"); 

    let hasError = false;

    orderCards.forEach((card, orderIndex) => {
        const memberId = card.querySelector('.o-member').value.trim();
        const pay = card.querySelector('.o-pay').value;
        const note = card.querySelector('.o-note').value.trim();

        if (!memberId) { hasError = true; card.style.borderColor = '#dc3545'; } 
        else { card.style.borderColor = '#e1e4e8'; }

        formData.append("memberIds", memberId);
        formData.append("paymentTypes", pay);
        formData.append("notes", note);

        const items = card.querySelectorAll('.item-row');
        items.forEach(item => {
            const pid = item.querySelector('.i-pid').value.trim();
            const qty = item.querySelector('.i-qty').value.trim();
            const price = item.querySelector('.i-price').value.trim();
            const pname = item.querySelector('.i-pname').value;

            if (!pid || !qty || !price || pname.includes('❌') || pname === '讀取中...') {
                hasError = true; item.style.backgroundColor = '#ffeeba';
            } else {
                item.style.backgroundColor = ''; 
                formData.append("itemOrderIndexes", orderIndex); 
                formData.append("itemProductIds", pid);
                formData.append("itemQuantities", qty);
                formData.append("itemUnitPrices", price);
            }
        });
    });

    if (hasError) {
        showError("⚠️ 有必填欄位漏填，或商品 ID 錯誤，請檢查紅框或黃底區域！");
        return;
    }

    if (!confirm("確定送出 " + orderCards.length + " 筆訂單嗎？")) return;

    fetch('<%=request.getContextPath()%>/orderAction', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            alert("已新增 " + orderCards.length + " 筆訂單!!");
            window.location.href = '<%=request.getContextPath()%>/orderList';
        } else {
            showError("❌ 建立失敗：" + data.message);
        }
    })
    .catch(err => {
        showError("❌ 系統發生錯誤！請檢查後端邏輯。");
    });
}
</script>
</body>
</html>