package com.badminton.controller;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.badminton.model.CourtBean;
import com.badminton.model.PickupGameBean;
import com.badminton.model.PickupGameSignupBean;
import com.badminton.model.MembersBean;
import com.badminton.model.MembersAdminBean;
import com.badminton.service.PickupGameSignupService;
import com.badminton.service.PickupGameSignupServiceImpl;
@WebServlet("/pickup")
public class PickupGameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // 將 Service 統一宣告在這裡
    private PickupGameSignupService gameService = new PickupGameSignupServiceImpl();
    // ================== 輔助與驗證方法 (移至最上方避免漏拷貝) ==================
    /**
     * 狀態排序權重：開放中(1) > 已額滿(2) > 其他(3) > 已取消(4)
     * 加上 static 確保任何編譯器在 Lambda 中調用皆安全
     */
    private static int getStatusWeight(String status) {
        if (status == null) return 3;
        if ("open".equals(status)) return 1;
        if ("full".equals(status)) return 2;
        if ("cancelled".equals(status)) return 4;
        return 3;
    }
    /**
     * 獲取目前登入系統的操作者 ID (支援後台管理員 / 前台會員)
     */
    private static Integer getLoggedInMemberId(HttpSession session) {
        // 第一順位：檢查是否為後台管理員登入 (MembersAdminBean)
        MembersAdminBean admin = (MembersAdminBean) session.getAttribute("adminUser");
        if (admin != null) {
            return admin.getAdminId(); // 以管理員的身分 (ID) 來操作揪團/報名
        }
        
        // 第二順位：萬一前台也共用這個 Servlet，檢查一般會員登入
        MembersBean user = (MembersBean) session.getAttribute("user");
        if (user != null) {
            return user.getMemberId();
        }
        
        // 保留測試期 fallback
        return (Integer) session.getAttribute("memberId");
    }
    /**
     * 驗證是否為系統管理員登入
     */
    private static boolean isAdminLoggedIn(HttpSession session) {
        MembersAdminBean admin = (MembersAdminBean) session.getAttribute("adminUser");
        // 如果想要嚴格限制只有經理(manager)才能代客報名，可改為 return admin != null && "manager".equals(admin.getRole());
        return admin != null;
    }
    /**
     * 【修正】未登入時，重導向至「後台管理員的登入頁面」
     */
    private void redirectForLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin");
    }
    // ================== Controller 主邏輯 ==================
    // doGet 與 doPost 互相呼叫，統一處理邏輯
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doPost(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. 取得前端傳來的 action 參數，決定要做什麼事
        String action = request.getParameter("action");
        // 處理一次性訊息 (Flash Message)，並且在取出後立刻刪除
        HttpSession session = request.getSession();
        String sessionMsg = (String) session.getAttribute("msg");
        if (sessionMsg != null) {
            request.setAttribute("msg", sessionMsg);
            session.removeAttribute("msg");
        }
        // 2. 如果沒有 action，或是 action 為 list，預設導向首頁，顯示全部場次列表
        if (action == null || action.isEmpty() || "list".equals(action)) {
            List<PickupGameBean> allGames = gameService.getAllGames();
            
            // 排序：開放中(open) > 已額滿(full) > 已取消(cancelled)，同狀態按建立時間較早的在前面
            allGames.sort((g1, g2) -> {
                int statusWeight1 = getStatusWeight(g1.getStatus());
                int statusWeight2 = getStatusWeight(g2.getStatus());
                if (statusWeight1 != statusWeight2) {
                    return Integer.compare(statusWeight1, statusWeight2);
                }
                // 同狀態：建立時間越早越後面
                return g1.getGameDate().compareTo(g2.getGameDate());
            });
            request.setAttribute("allGames", allGames);
            request.getRequestDispatcher("/WEB-INF/views/pickup_main.jsp").forward(request, response);
            return;
        }
        // 3. 根據 action 分發到對應的方法
        try {
            switch (action) {
                case "goCreateGame":
                    goCreateGame(request, response);
                    break;
                case "createGame":
                    createGame(request, response);
                    break;
                case "getAllGames":
                    getAllGames(request, response);
                    break;
                case "addSignup":
                    addSignup(request, response);
                    break;
                case "getSignupList":
                    getSignupList(request, response);
                    break;
                case "kickMember":
                    kickMember(request, response);
                    break;
                case "cancelGame":
                    cancelGame(request, response);
                    break;
                case "withdrawSignup":
                    withdrawSignup(request, response);
                    break;
                case "adminAddPlayer":
                    adminAddPlayer(request, response);
                    break;
                default:
                    // 找不到對應的動作，回首頁
                    response.sendRedirect(request.getContextPath() + "/pickup");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "系統發生錯誤：" + e.getMessage());
        }
    }
    // ================== Action 處理方法 ==================
    private void goCreateGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer hostId = getLoggedInMemberId(session);
        
        // 沒登入就踢回後台管理員登入畫面
        if (hostId == null) {
            redirectForLogin(request, response);
            return;
        }
        request.getSession().removeAttribute("msg");
        request.removeAttribute("msg");
        List<CourtBean> courts = gameService.getAllCourts();
        request.setAttribute("courts", courts);
        request.setAttribute("timeSlots", gameService.getAllTimeSlots());
        
        // ===== 關鍵字模糊查詢會員功能 =====
        String searchKeyword = request.getParameter("searchKeyword");
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            com.badminton.service.MembersService memberService = new com.badminton.service.MembersService();
            List<MembersBean> foundMembers = memberService.searchMembers(searchKeyword.trim());
            
            if (foundMembers != null && !foundMembers.isEmpty()) {
                request.setAttribute("foundMembers", foundMembers);
                request.setAttribute("searchMsg", "搜尋成功：找到 " + foundMembers.size() + " 位符合的會員，請在下方確認並選取。");
            } else {
                request.setAttribute("searchMsg", "找不到符合該關鍵字的會員！");
            }
        }
        // ==================================
        
        request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
    }
    private void createGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer hostId = getLoggedInMemberId(session);
        
        if (hostId == null) {
            redirectForLogin(request, response);
            return;
        }
        try {
            // 從表單接收主揪會員ID
            String hostMemberIdStr = request.getParameter("hostMemberId");
            int actualHostId;
            if (hostMemberIdStr != null && !hostMemberIdStr.trim().isEmpty()) {
                actualHostId = Integer.parseInt(hostMemberIdStr.trim());
            } else {
                actualHostId = hostId; // fallback 用登入者本人
            }
            
            int courtId = Integer.parseInt(request.getParameter("courtId"));
            String gameDate = request.getParameter("gameDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            int neededPlayers = Integer.parseInt(request.getParameter("neededPlayers"));
            int totalMaxPlayers = neededPlayers + 1;
            if (startTime.compareTo(endTime) >= 0) {
                request.setAttribute("courts", gameService.getAllCourts());
                request.setAttribute("timeSlots", gameService.getAllTimeSlots());
                request.setAttribute("msg", "發起失敗：結束時間必須晚於開始時間！");
                request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
                return;
            }
            // 使用從表單取得的主揪會員 ID 建立揪團
            boolean success = gameService.createAndJoin(actualHostId, courtId, gameDate, startTime, endTime, totalMaxPlayers);
            if (success) {
                Integer latestGameId = gameService.getLatestGameId();
                response.sendRedirect(request.getContextPath() + "/pickup?action=getSignupList&gameId=" + latestGameId);
            } else {
                request.setAttribute("courts", gameService.getAllCourts());
                request.setAttribute("timeSlots", gameService.getAllTimeSlots());
                request.setAttribute("msg", "發起失敗，該場地同時段已被預約，或您在該時段也已有其他活動！");
                request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "格式錯誤：" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
        }
    }
    private void getAllGames(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PickupGameBean> allGames = gameService.getAllOpenGames();
        request.setAttribute("allGames", allGames);
        request.getRequestDispatcher("/WEB-INF/views/game_list.jsp").forward(request, response);
    }
    private void addSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer memberId = getLoggedInMemberId(session);
        
        if (memberId == null) {
            session.setAttribute("msg", "請先登入後台後再進行操作！");
            redirectForLogin(request, response);
            return;
        }String gameIdStr = request.getParameter("gameId");
        if (gameIdStr != null) {
            try {
                Integer gameId = Integer.parseInt(gameIdStr);
                String resultMsg = gameService.registerString(gameId, memberId);
                request.setAttribute("msg", resultMsg);
            } catch (NumberFormatException e) {
                request.setAttribute("msg", "活動編號格式錯誤");
            }
        } else {
            request.setAttribute("msg", "找不到活動編號");
        }
        getSignupList(request, response);
    }
    private void getSignupList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gameIdStr = request.getParameter("gameId");
        Integer gameId = null;
        if (gameIdStr != null && !gameIdStr.isEmpty()) {
            gameId = Integer.parseInt(gameIdStr);
        } else {
            gameId = gameService.getLatestGameId();
        }
        
        final Integer finalGameId = gameId;
        if (gameId != null) {
            PickupGameBean game = gameService.getAllGames().stream()
                    .filter(g -> g.getGameId().equals(finalGameId))
                    .findFirst().orElse(null);
                    
            if (game != null) {
                request.setAttribute("gameStatus", game.getStatus());
            }
            
            List<PickupGameSignupBean> list = gameService.getSignupListByGame(gameId, true);
            request.setAttribute("signupList", list);
            request.setAttribute("currentGameId", gameId);
            request.setAttribute("playerCount", list.size());
            for (PickupGameSignupBean s : list) {
                if ("host".equals(s.getStatus())) {
                    request.setAttribute("hostMemberId", s.getMemberId());
                    request.setAttribute("hostName", s.getMemberName());
                    request.setAttribute("hostPhone", s.getMemberPhone());
                    break;
                }
            }
        } else {
            request.setAttribute("msg", "目前系統中尚無任何球賽活動。");
        }
        // 把當前登入者的 memberId 傳回 JSP
        HttpSession session = request.getSession();
        request.setAttribute("sessionMemberId", getLoggedInMemberId(session));
        
        // ===== 代客報名用：關鍵字模糊查詢會員 =====
        String searchKeyword = request.getParameter("searchKeyword");
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            com.badminton.service.MembersService memberService = new com.badminton.service.MembersService();
            List<com.badminton.model.MembersBean> foundMembers = memberService.searchMembers(searchKeyword.trim());
            if (foundMembers != null && !foundMembers.isEmpty()) {
                request.setAttribute("proxyFoundMembers", foundMembers);
                request.setAttribute("proxySearchMsg", "搜尋成功：找到 " + foundMembers.size() + " 位符合的會員");
            } else {
                request.setAttribute("proxySearchMsg", "找不到符合該關鍵字的會員！");
            }
        }
        // ========================================
        
        request.getRequestDispatcher("/WEB-INF/views/signup_list.jsp").forward(request, response);
    }
    // 主揪踢人 (管理員也可以踢)
    private void kickMember(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer operatorId = getLoggedInMemberId(session);
        
        if (operatorId == null) {
            redirectForLogin(request, response);
            return;
        }
        String gameIdStr = request.getParameter("gameId");
        String targetIdStr = request.getParameter("targetMemberId");
        if (gameIdStr != null && targetIdStr != null) {
            int gameId = Integer.parseInt(gameIdStr);
            int targetMemberId = Integer.parseInt(targetIdStr);
            
            // 如果是管理員，用真實的主揪 ID 來操作，繞過主揪驗證
            int effectiveHostId = operatorId;
            if (isAdminLoggedIn(session)) {
                // 找出該場次的真實主揪 ID
                List<PickupGameSignupBean> signups = gameService.getSignupListByGame(gameId, false);
                for (PickupGameSignupBean s : signups) {
                    if ("host".equals(s.getStatus())) {
                        effectiveHostId = s.getMemberId();
                        break;
                    }
                }
            }
            
            String resultMsg = gameService.kickMember(gameId, effectiveHostId, targetMemberId);
            request.setAttribute("msg", resultMsg);
        }
        getSignupList(request, response);
    }
    // 管理員代為報名
    private void adminAddPlayer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // ✨ 使用專屬驗證方法判斷是不是管理員！
        boolean isAdmin = isAdminLoggedIn(session);
        String gameIdStr = request.getParameter("gameId");
        String targetMemberIdStr = request.getParameter("targetMemberId");
        if (isAdmin && gameIdStr != null && targetMemberIdStr != null && !targetMemberIdStr.isEmpty()) {
            try {
                int gameId = Integer.parseInt(gameIdStr);
                int targetMemberId = Integer.parseInt(targetMemberIdStr);
                String resultMsg = gameService.registerString(gameId, targetMemberId);
                request.setAttribute("msg", "代報結果: " + resultMsg);
            } catch (NumberFormatException e) {
                request.setAttribute("msg", "會員 ID 格式錯誤，請輸入數字。");
            }
        } else {
            request.setAttribute("msg", "登入狀態失效、權限不足或缺少會員資訊。");
        }
        
        getSignupList(request, response);
    }
    // 主揪或管理員取消開團
    private void cancelGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer operatorId = getLoggedInMemberId(session);
        
        if (operatorId == null) {
            redirectForLogin(request, response);
            return;
        }
        String gameIdStr = request.getParameter("gameId");
        if (gameIdStr != null) {
            int gameId = Integer.parseInt(gameIdStr);
            
            // 如果是管理員，用真實的主揪 ID 來操作，繞過主揪驗證
            int effectiveHostId = operatorId;
            if (isAdminLoggedIn(session)) {
                List<PickupGameSignupBean> signups = gameService.getSignupListByGame(gameId, false);
                for (PickupGameSignupBean s : signups) {
                    if ("host".equals(s.getStatus())) {
                        effectiveHostId = s.getMemberId();
                        break;
                    }
                }
            }
            
            String resultMsg = gameService.cancelGame(gameId, effectiveHostId);
            session.setAttribute("msg", resultMsg); 
        }
        response.sendRedirect(request.getContextPath() + "/pickup");
    }
    // 成員退出活動
    private void withdrawSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer memberId = getLoggedInMemberId(session);
        
        if (memberId == null) {
            redirectForLogin(request, response);
            return;
        }
        String gameIdStr = request.getParameter("gameId");
        if (gameIdStr != null) {
            int gameId = Integer.parseInt(gameIdStr);
            String resultMsg = gameService.withdrawFromGame(gameId, memberId);
            request.setAttribute("msg", resultMsg);
        }
        getSignupList(request, response);
    }
}