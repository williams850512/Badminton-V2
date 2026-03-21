<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* 全域設定 */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    body { background-color: #f4f7f6; color: #333; }
    
    /* 佈局容器 */
    .app-container { display: flex; height: 100vh; overflow: hidden; }
    
    /* 左側選單 */
    .sidebar { width: 15%; background-color: #2c3e50; color: #fff; display: flex; flex-direction: column; transition: all 0.3s; }
    .sidebar-logo { padding: 20px; font-size: 22px; font-weight: bold; text-align: center; border-bottom: 1px solid #34495e; letter-spacing: 2px;}
    .sidebar-menu { list-style: none; padding: 10px 0; margin: 0; }
    .sidebar-menu li { padding: 15px 25px; cursor: pointer; border-left: 4px solid transparent; transition: 0.2s; }
    .sidebar-menu li:hover { background-color: #34495e; border-left: 4px solid #3498db; }
    .sidebar-menu li.active { background-color: #34495e; border-left: 4px solid #3498db; color: #3498db; font-weight: bold;}
    .sidebar-menu a { text-decoration: none; color: inherit; display: block; }
    
    /* 右側主要區域 */
    .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    
    /* 上方導覽列 */
    .top-header { height: 60px; background-color: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; z-index: 10; }
    .header-title { font-size: 18px; font-weight: bold; color: #555; }
    .user-info { font-size: 14px; color: #666; }
    
    /* 內容區域 */
    .content-body { flex: 1; padding: 20px; overflow-y: auto; }
    
    /* 卡片風格 */
    .card { background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 20px;}
    
    /* 共用表格風格 */
    .table-custom { width: 100%; border-collapse: collapse; margin-top: 15px; }
    .table-custom th, .table-custom td { border-bottom: 1px solid #eee; padding: 12px 15px; text-align: left; }
    .table-custom th { background-color: #f8f9fa; color: #555; font-weight: bold; }
    .table-custom tr:hover { background-color: #f1f4f8; }
    
    /* 共用按鈕風格 */
    .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: 0.2s; }
    .btn-primary { background-color: #3498db; color: white; }
    .btn-primary:hover { background-color: #2980b9; }
    .btn-danger { background-color: #e74c3c; color: white; }
    .btn-danger:hover { background-color: #c0392b; }
    .btn-warning { background-color: #f1c40f; color: #333; }
    
    /* 表單輸入框風格 */
    .form-control { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; outline: none; transition: 0.2s; }
    .form-control:focus { border-color: #3498db; box-shadow: 0 0 5px rgba(52, 152, 219, 0.3); }
</style>