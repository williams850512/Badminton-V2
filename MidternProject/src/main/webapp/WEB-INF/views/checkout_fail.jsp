<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>結帳失敗</title>
<style>
body{ font-family: Arial, sans-serif; text-align: center; padding: 50px; background:#f5f5f5;}
.box{ background: white; border-radius: 12px; padding: 40px; max-width: 500px; 
      margin: auto; box-shadow: 0 4px 12px rgba(0,0,0,0.1);}
      h1{ color: #e74c3c;}
      .error-msg{color:#c0392b; background: #fde8e8;padding:12px;border-radius;8px; m
       margin: 20px 0;}
       a{ display: inline-block;margin-top:20px; padding: 12px 24px; background:#95a5a6;
        color: wihite; text-decoration:none;boder-radius:8px;}
</style>
</head>
<body>
<div class="box">
<h1>❌ 結帳失敗</h1>
<p>很抱歉，您的訂單處理失敗，請稍後再試。</p>
<div class="error-msg">${errorMsg}</div>
<a href="javascript:history.back()">返回上一頁</a>


</div>

</body>
</html>