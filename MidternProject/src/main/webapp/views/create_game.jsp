<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 發起羽球臨打揪團</title>
<style>
    body { font-family: "Microsoft JhengHei", sans-serif; background-color: #f4f7f6; padding: 40px; }
    .form-container { 
        max-width: 500px; margin: auto; background: white; 
        padding: 30px; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.1); 
    }
    h2 { color: #1a73e8; text-align: center; border-bottom: 2px solid #e8f0fe; padding-bottom: 10px; }
    .form-group { margin-bottom: 20px; }
    label { display: block; margin-bottom: 8px; font-weight: bold; color: #444; }
    select, input { 
        width: 100%; padding: 10px; border: 1px solid #ddd; 
        border-radius: 8px; box-sizing: border-box; font-size: 16px;
    }
    .btn-submit { 
        width: 100%; background-color: #28a745; color: white; border: none; 
        padding: 12px; border-radius: 8px; font-size: 18px; cursor: pointer;
        transition: 0.3s; font-weight: bold;
    }
    .btn-submit:hover { background-color: #218838; transform: translateY(-2px); }
    .note { font-size: 0.85em; color: #888; margin-top: 5px; }
</style>
</head>
<body>

<div class="form-container">
    <h2>🏸 發起新揪團</h2>
    
    <form action="CreateGameServlet" method="post">
        
        <div class="form-group">
            <label>選擇球場：</label>
            <select name="courtId" required>
                <option value="1">總館 - A場</option>
                <option value="2">總館 - B場</option>
                <option value="3">總館 - C場</option>
                <option value="4">二館 - D場</option>
            </select>
        </div>

        <div class="form-group">
            <label>活動日期：</label>
            <input type="date" name="gameDate" required value="2026-03-20">
        </div>

        <div class="form-group">
            <label>開始時間：</label>
            <select name="startTime" required>
                <option value="08:00:00">08:00</option>
                <option value="10:00:00">10:00</option>
                <option value="14:00:00">14:00</option>
                <option value="18:00:00">18:00</option>
                <option value="20:00:00">20:00</option>
            </select>
        </div>

        <div class="form-group">
            <label>預計結束：</label>
            <select name="endTime" required>
                <option value="10:00:00">10:00</option>
                <option value="12:00:00">12:00</option>
                <option value="16:00:00">16:00</option>
                <option value="20:00:00">20:00</option>
                <option value="22:00:00">22:00</option>
            </select>
        </div>

        <div class="form-group">
            <label>人數上限 (含主揪)：</label>
            <input type="number" name="maxPlayers" value="8" min="2" max="12" required>
            <p class="note">※ 系統將自動預留主揪名額，剩餘 7 位開放報名。</p>
        </div>

        <button type="submit" class="btn-submit">確認發起，立馬開團！</button>
    </form>
</div>

</body>
</html>