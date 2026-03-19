<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 發起羽球臨打揪團</title>
<style>
    body { font-family: "Microsoft JhengHei", sans-serif; background-color: #f0f2f5; padding: 40px; }
    .form-container { 
        max-width: 450px; margin: auto; background: white; 
        padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
    }
    h2 { color: #1a73e8; text-align: center; margin-bottom: 25px; font-size: 24px; }
    .form-group { margin-bottom: 18px; }
    label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; }
    select, input { 
        width: 100%; padding: 12px; border: 1px solid #ccd0d5; 
        border-radius: 10px; box-sizing: border-box; font-size: 16px;
    }
    input:focus, select:focus { border-color: #1a73e8; outline: none; box-shadow: 0 0 5px rgba(26,115,232,0.3); }
    .btn-submit { 
        width: 100%; background: linear-gradient(135deg, #28a745, #218838); color: white; border: none; 
        padding: 15px; border-radius: 10px; font-size: 18px; cursor: pointer;
        transition: 0.3s; font-weight: bold; margin-top: 10px;
    }
    .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(40,167,69,0.4); }
    .note { font-size: 0.85em; color: #666; margin-top: 5px; background: #e8f0fe; padding: 10px; border-radius: 5px; }
</style>
</head>
<body>

<div class="form-container">
    <h2>🏸 發起新揪團</h2>
    
    <form action="${pageContext.request.contextPath}/CreateGameServlet" method="post">
        
        <div class="form-group">
            <label>選擇球場：</label>
            <select name="courtId" required>
                <option value="1">總館 - A場</option>
                <option value="2">總館 - B場</option>
                <option value="3">中壢分館 - C場</option>
            </select>
        </div>

        <div class="form-group">
            <label>活動日期：</label>
            <input type="date" name="gameDate" required value="2026-03-20">
        </div>

        <div class="form-group">
            <label>開始時間：</label>
            <select name="startTime" required>
                <option value="18:00">18:00</option>
                <option value="19:00">19:00</option>
                <option value="20:00">20:00</option>
            </select>
        </div>

        <div class="form-group">
            <label>預計結束：</label>
            <select name="endTime" required>
                <option value="20:00">20:00</option>
                <option value="21:00">21:00</option>
                <option value="22:00">22:00</option>
            </select>
        </div>

        <div class="form-group">
   			 <label>徵求球友人數 (不含主揪)：</label>
    		 <select name="neededPlayers" required>
       		 <option value="1">1 位 (總計 2 人)</option>
       		 <option value="2">2 位 (總計 3 人)</option>
       		 <option value="3">3 位 (總計 4 人)</option>
       		 <option value="4">4 位 (總計 5 人)</option>
       		 <option value="5">5 位 (總計 6 人)</option>
      		  <option value="6">6 位 (總計 7 人)</option>
       		 <option value="7" selected>7 位 (總計 8 人)</option>
   			 </select>
   		 <div class="note">
     	   ※ 系統會自動將您計入名單，選 7 位即代表該團上限為 8 人。
    </div>
</div>

        <button type="submit" class="btn-submit">確認發起，立馬開團！</button>
    </form>
</div>

</body>
</html>