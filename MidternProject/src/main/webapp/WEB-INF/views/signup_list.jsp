<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 羽球活動報名名單</title>
<style>
    body { font-family: "Microsoft JhengHei", sans-serif; background-color: #f8f9fa; padding: 30px; }
    .container { max-width: 850px; margin: auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
    
    /* 人數進度 */
    .progress-bar { text-align: center; margin: 15px 0; font-size: 18px; color: #333; }
    .progress-bar span { font-weight: bold; color: #28a745; font-size: 22px; }
    
    /* 主揪資訊卡 */
    .host-info { background: #e8f4fd; border-left: 4px solid #007bff; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; }
    .host-info .label { font-weight: bold; color: #007bff; }
    .host-info .phone { font-size: 18px; font-weight: bold; color: #333; letter-spacing: 1px; }
    
    /* 表格 */
    table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    th { background-color: #007bff; color: white; padding: 12px; }
    td { border-bottom: 1px solid #ddd; padding: 12px; text-align: center; }
    tr:hover { background-color: #f5f5f5; }
    
    .status-host { color: #d9534f; font-weight: bold; }
    .status-player { color: #5cb85c; font-weight: bold; }
    .empty-msg { text-align: center; color: #888; padding: 50px; }
    
    /* 訊息 */
    .alert-msg { background-color: #d4edda; color: #155724; padding: 15px; margin-bottom: 20px; border-radius: 8px; text-align: center; font-weight: bold; border: 1px solid #c3e6cb; }
    
    /* 按鈕 */
    .btn-kick { background: #dc3545; color: white; border: none; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; }
    .btn-kick:hover { background: #c82333; }
    .btn-withdraw { background: #ffc107; color: #333; border: none; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; font-weight: bold; }
    .btn-withdraw:hover { background: #e0a800; }
    .btn-cancel { background: #dc3545; color: white; border: none; padding: 15px 30px; border-radius: 10px; cursor: pointer; font-size: 16px; text-decoration: none; display: inline-block; font-weight: bold; margin-top: 15px; }
    .btn-cancel:hover { background: #c82333; }
    
    .actions-area { text-align: center; margin-top: 25px; padding-top: 15px; border-top: 2px solid #eee; }
    .back-link { text-decoration: none; color: #666; font-weight: bold; display: inline-block; margin-top: 15px; }
    .back-link:hover { color: #333; }
</style>
</head>
<body>

<div class="container">

    <!-- 判斷是否為管理員 (假設 memberId=4 是管理員，或是從 session 取出特定屬性) -->
    <c:set var="isAdmin" value="${sessionMemberId == 4}" />
    <!-- 是主揪或管理員 -->
    <c:set var="isHostOrAdmin" value="${sessionMemberId == hostMemberId || isAdmin}" />

    <!-- ===== 主揪/管理員 視圖 ===== -->
    <c:if test="${isHostOrAdmin}">
        <h2>
            <c:if test="${isAdmin}">👑 [管理員模式] </c:if>
            <c:if test="${!isAdmin}">👑 我的揪團管理 </c:if>
            (場次 ID: ${currentGameId})
        </h2>
        
        <div class="progress-bar">
            目前人數：<span>${playerCount}</span> 人
            <!-- 顯示狀態避免已經取消的還顯示綠色 -->
            <c:if test="${gameStatus == 'cancelled'}">
                <span style="color:#dc3545; font-size:16px;">(已取消)</span>
            </c:if>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert-msg">🙏 ${msg}</div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>稱呼</th>
                    <th>電話</th>
                    <th>角色</th>
                    <th>報名時間</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="signup" items="${signupList}">
                <tr>
                    <td>${signup.memberName}</td>
                    <td>${signup.memberPhone}</td>
                    <td>
                        <c:choose>
                            <c:when test="${signup.status == 'host'}"><span class="status-host">👑 主揪</span></c:when>
                            <c:otherwise><span class="status-player">🏸 成員</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>${signup.signedUpAt}</td>
                    <td>
                        <!-- 不能踢主揪，如果系統已取消也不需要踢人了 -->
                        <c:if test="${signup.status != 'host' && gameStatus != 'cancelled'}">
                            <a href="${pageContext.request.contextPath}/pickup?action=kickMember&gameId=${currentGameId}&targetMemberId=${signup.memberId}" 
                               class="btn-kick"
                               onclick="return confirm('確定要將 ${signup.memberName} 踢出嗎？')">
                               ❌ 踢除
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty signupList}">
                <tr><td colspan="5" class="empty-msg">目前尚無報名紀錄</td></tr>
            </c:if>
            </tbody>
        </table>

        <!-- 管理員代客報名區塊 -->
        <c:if test="${isAdmin && gameStatus != 'cancelled'}">
            <div style="margin-top: 25px; background: #fff3cd; padding: 15px; border-radius: 8px; border: 1px solid #ffeeba; text-align: center;">
                <h4 style="margin-top: 0; color: #856404;">🛠️ 代客報名 (管理員專用)</h4>
                <form action="${pageContext.request.contextPath}/pickup?action=adminAddPlayer" method="post" style="margin-bottom: 0;">
                    <input type="hidden" name="gameId" value="${currentGameId}">
                    <input type="number" name="targetMemberId" placeholder="輸入要加入的會員 ID" required style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; width: 180px;">
                    <button type="submit" style="background: #28a745; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold;">
                        ➕ 強制加入
                    </button>
                    <p style="font-size: 13px; color: #666; margin: 8px 0 0 0;">※ 輸入會員編號即可幫該會員報名本場次。如果已有時段衝突仍會阻擋。</p>
                </form>
            </div>
        </c:if>

        <div class="actions-area">
            <!-- 只有開放中的場次才可以取消開團 -->
            <c:if test="${gameStatus != 'cancelled'}">
                <a href="${pageContext.request.contextPath}/pickup?action=cancelGame&gameId=${currentGameId}" 
                   class="btn-cancel"
                   onclick="return confirm('確定要取消此揪團嗎？所有成員都會失去報名資格！')">
                   🚫 取消開團
                </a>
                <br>
            </c:if>
            <a href="${pageContext.request.contextPath}/pickup" class="back-link">← 返回首頁</a>
        </div>
    </c:if>

    <!-- ===== 一般成員視圖 ===== -->
    <c:if test="${!isHostOrAdmin}">
        <h2>🏸 場次報名名單 (場次 ID: ${currentGameId})</h2>
        
        <div class="progress-bar">
            目前人數：<span>${playerCount}</span> 人
            <c:if test="${gameStatus == 'cancelled'}">
                <span style="color:#dc3545; font-size:16px;">(已取消)</span>
            </c:if>
        </div>

        <c:set var="hasJoined" value="false" />
        <c:forEach var="s" items="${signupList}">
            <c:if test="${s.memberId == sessionMemberId}">
                <c:set var="hasJoined" value="true" />
            </c:if>
        </c:forEach>

        <!-- 主揪聯絡資訊 (僅已加入成員可見完整電話，如果已經取消則無須聯絡) -->
        <c:choose>
            <c:when test="${hasJoined && gameStatus != 'cancelled'}">
                <div class="host-info">
                    <span class="label">📞 主揪聯絡方式：</span><br>
                    <span>${hostName}</span> ─ <span class="phone">${hostPhone}</span>
                </div>
            </c:when>
            <c:when test="${gameStatus == 'cancelled'}">
                <div class="host-info" style="background: #f8d7da; border-left: 4px solid #dc3545; color: #721c24;">
                    <span class="label" style="color:#721c24;">⚠️ 此活動已取消</span><br>
                    <span>無需聯絡主揪</span>
                </div>
            </c:when>
            <c:otherwise>
                <div class="host-info" style="background: #f8f9fa; border-left: 4px solid #adb5bd; color: #6c757d;">
                    <span class="label" style="color:#6c757d;">📞 主揪聯絡方式：</span><br>
                    <span>${hostName}</span> ─ <span class="phone" style="font-size:15px;">🔒 報名後即可查看主揪電話</span>
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty msg}">
            <div class="alert-msg">🙏 ${msg}</div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>稱呼</th>
                    <th>角色</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="signup" items="${signupList}">
                <tr>
                    <td>${signup.memberName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${signup.status == 'host'}"><span class="status-host">👑 主揪</span></c:when>
                            <c:otherwise><span class="status-player">🏸 成員</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <!-- 只有自己那行才有退出按鈕 -->
                        <c:if test="${signup.memberId == sessionMemberId && signup.status != 'host'}">
                            <a href="${pageContext.request.contextPath}/pickup?action=withdrawSignup&gameId=${currentGameId}" 
                               class="btn-withdraw"
                               onclick="return confirm('確定要退出此場次嗎？')">
                               🚪 退出活動
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty signupList}">
                <tr><td colspan="3" class="empty-msg">目前尚無報名紀錄</td></tr>
            </c:if>
            </tbody>
        </table>

        <div class="actions-area">
            <a href="${pageContext.request.contextPath}/pickup" class="back-link">← 返回首頁</a>
        </div>
    </c:if>

</div>

</body>
</html>