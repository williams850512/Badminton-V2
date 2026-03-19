<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>報名結果</title>
<style>
    .result-card { width: 400px; margin: 100px auto; padding: 40px; border-radius: 15px; background: white; box-shadow: 0 10px 30px rgba(0,0,0,0.1); text-align: center; }
    .msg { font-size: 1.5em; color: #2ecc71; margin-bottom: 25px; font-weight: bold; }
</style>
</head>
<body style="background-color: #ecf0f1;">
    <div class="result-card">
        <div class="msg">${msg}</div>
        <hr>
        <a href="GetSignupListServlet?gameId=1">查看最新名單</a>
    </div>
</body>
</html>