<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 羽球臨打揪團系統</title>
<style>
    body { font-family: "Microsoft JhengHei", sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .main-container { text-align: center; background: white; padding: 50px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
    h1 { color: #1a73e8; margin-bottom: 40px; }
    .btn-group { display: flex; gap: 30px; }
    .nav-card { 
        width: 220px; padding: 30px; border: 2px solid #e0e0e0; border-radius: 15px; 
        cursor: pointer; transition: 0.3s; text-decoration: none; color: #333;
        display: block;
    }
    .nav-card:hover { border-color: #1a73e8; transform: translateY(-10px); box-shadow: 0 5px 15px rgba(26,115,232,0.2); background-color: #f8fbff; }
    .icon { font-size: 50px; display: block; margin-bottom: 15px; }
    .btn-create { border-bottom: 5px solid #1a73e8; }
    .btn-join { border-bottom: 5px solid #28a745; }
    h3 { margin: 10px 0; color: #333; }
    p { font-size: 14px; color: #666; line-height: 1.5; }
</style>
</head>
<body>

<div class="main-container">
    <h1>🏸 您今天想怎麼打球？</h1>
    <div class="btn-group">
        
        <a href="GoCreateGame" class="nav-card btn-create">
            <span class="icon">📢</span>
            <h3>發起揪團</h3>
            <p>我是主揪，我要開場找球友</p>
        </a>

        <a href="GetAllGamesServlet" class="nav-card btn-join">
            <span class="icon">🙋‍♂️</span>
            <h3>加入臨打</h3>
            <p>看看有哪些場次可以報名</p>
        </a>

    </div>
</div>

</body>
</html>