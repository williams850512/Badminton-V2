<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>批次新增訂單 — 羽球館管理系統</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />

<style>
    /* ===== 訂單模組額外 CSS ===== */
    .order-card { background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 25px; border: 1px solid #e1e4e8; border-left: 5px solid #3498db; position: relative;}
    .order-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
    
    .btn-success { background-color: #28a745; color: white; }
    
    .btn-icon {
        width: 28px; height: 28px; padding: 0; display: inline-flex;
        align-items: center; justify-content: center; font-size: 0.85rem; margin-right: 4px;
    }
    .btn-icon:last-child { margin-right: 0; }
    
    .form-control[readonly] { background-color: #e9ecef; color: #666; font-weight: bold; border-color: #ddd;}

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

    <jsp:include page="/WEB-INF/backendSidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/backendHeader.jsp" />

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
            
            <div style="display: flex; gap: 15px; align-items: flex-end; margin-bottom: 20px; background: #f8f9fa; padding: 15px; border-radius: 6px; flex-wrap: wrap;">
                <div style="min-width: 250px;">
                    <label style="font-weight:bold; font-size:0.85rem; color:#555;">會員名稱 <span style="color:red">*</span></label>
                    <div style="display: flex; gap: 5px; margin-bottom: 5px;">
                        <input type="text" class="form-control o-member-search" placeholder="姓名 / 電話" style="width: 160px;">
                        <button type="button" class="btn btn-primary" style="padding: 6px 10px; font-size: 0.8rem; white-space: nowrap;" onclick="searchMember(this)">🔍</button>
                    </div>
                    <select class="form-control o-member" style="display:none; border-color: #28a745; background-color: #d4edda; width: 220px;" required>
                        <option value="">-- 請先搜尋 --</option>
                    </select>
                    <div class="o-member-msg" style="font-size: 0.75rem; margin-top: 3px; color: #999;"></div>
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
                        <th width="200">商品搜尋</th>
                        <th>商品名稱</th>
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
        <td>
            <div style="display: flex; gap: 3px;">
                <input type="text" class="form-control i-psearch" placeholder="搜尋商品" style="width: 120px; font-size: 0.8rem;">
                <button type="button" class="btn btn-primary btn-icon" title="搜尋" onclick="searchProduct(this)" style="font-size: 0.7rem;">🔍</button>
            </div>
            <select class="form-control i-pid" style="display:none; margin-top: 4px; border-color: #28a745; background-color: #d4edda; font-size: 0.8rem;" onchange="selectProduct(this)" required>
                <option value="">--</option>
            </select>
        </td>
        <td><input type="text" class="form-control i-pname" placeholder="等待搜尋" readonly></td>
        <td><input type="number" class="form-control input-sm i-price" placeholder="0" readonly></td>
        <td><input type="number" class="form-control input-xs i-qty" value="1" min="1" oninput="calculateSubtotal(this)" required></td>
        <td><input type="text" class="form-control input-sm i-subtotal" value="0" style="color:#28a745; font-weight:bold;" readonly></td>
        <td style="white-space: nowrap;">
            <button type="button" class="btn btn-danger btn-icon" title="刪除此列" onclick="removeItemRow(this, '` + orderId + `')">✕</button>
        </td>
    `;
    tbody.appendChild(tr);
    updateItemRowNumbers(orderId);
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

// ===== 會員模糊搜尋 (AJAX) =====
function searchMember(btn) {
    const card = btn.closest('.order-card');
    const searchInput = card.querySelector('.o-member-search');
    const selectEl = card.querySelector('.o-member');
    const msgEl = card.querySelector('.o-member-msg');
    const keyword = searchInput.value.trim();
    
    if (!keyword) { msgEl.textContent = '⚠️ 請輸入關鍵字'; msgEl.style.color = '#e74c3c'; return; }
    
    msgEl.textContent = '搜尋中...'; msgEl.style.color = '#999';
    
    fetch('<%=request.getContextPath()%>/api/productQuery?type=member&keyword=' + encodeURIComponent(keyword))
    .then(r => r.json())
    .then(data => {
        if (data.success && data.members) {
            selectEl.innerHTML = '';
            data.members.forEach(m => {
                const opt = document.createElement('option');
                opt.value = m.id;
                opt.textContent = '👤 ' + m.name + ' (電話: ' + m.phone + ')';
                selectEl.appendChild(opt);
            });
            selectEl.style.display = 'block';
            msgEl.textContent = '✅ 找到 ' + data.members.length + ' 位會員';
            msgEl.style.color = '#28a745';
        } else {
            selectEl.style.display = 'none';
            selectEl.innerHTML = '<option value="">--</option>';
            msgEl.textContent = '❌ 找不到符合的會員';
            msgEl.style.color = '#e74c3c';
        }
    }).catch(err => {
        console.error('Member search error:', err);
        msgEl.textContent = '❌ 系統錯誤：' + err.message; msgEl.style.color = '#e74c3c';
    });
}

// ===== 商品模糊搜尋 (AJAX) =====
function searchProduct(btn) {
    const row = btn.closest('tr');
    const searchInput = row.querySelector('.i-psearch');
    const selectEl = row.querySelector('.i-pid');
    const keyword = searchInput.value.trim();
    
    if (!keyword) { alert('請輸入商品關鍵字'); return; }
    
    searchInput.placeholder = '搜尋中...';
    
    fetch('<%=request.getContextPath()%>/api/productQuery?keyword=' + encodeURIComponent(keyword))
    .then(r => r.json())
    .then(data => {
        if (data.success && data.products) {
            selectEl.innerHTML = '<option value="">-- 請選擇商品 --</option>';
            data.products.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p.id;
                opt.setAttribute('data-name', p.name);
                opt.setAttribute('data-price', p.price);
                opt.textContent = '📦 ' + p.name + ' ($' + p.price + ')';
                selectEl.appendChild(opt);
            });
            selectEl.style.display = 'block';
            searchInput.placeholder = '✅ 找到 ' + data.products.length + ' 項';
        } else {
            selectEl.style.display = 'none';
            selectEl.innerHTML = '<option value="">--</option>';
            searchInput.placeholder = '❌ 找不到商品';
        }
    }).catch(err => {
        console.error('Product search error:', err);
        searchInput.placeholder = '❌ 系統錯誤：' + err.message;
    });
}

// 商品下拉選單選擇後，自動帶入名稱和單價
function selectProduct(selectEl) {
    const row = selectEl.closest('tr');
    const selectedOption = selectEl.options[selectEl.selectedIndex];
    const nameInput = row.querySelector('.i-pname');
    const priceInput = row.querySelector('.i-price');
    
    if (selectedOption && selectedOption.value) {
        nameInput.value = selectedOption.getAttribute('data-name');
        priceInput.value = selectedOption.getAttribute('data-price');
    } else {
        nameInput.value = '';
        priceInput.value = 0;
    }
    calculateSubtotal(selectEl);
}

function fetchProductInfo(inputEl) {
    // 保留相容性（如果有用到的話）
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
        } else {
            nameInput.value = '❌ 找不到商品';
            priceInput.value = 0;
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
            const pidSelect = item.querySelector('.i-pid');
            const pid = pidSelect ? pidSelect.value.trim() : '';
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