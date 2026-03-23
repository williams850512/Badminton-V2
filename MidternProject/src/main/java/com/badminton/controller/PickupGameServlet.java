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
import com.badminton.service.PickupGameSignupService;
import com.badminton.service.PickupGameSignupServiceImpl;

@WebServlet("/pickup")
public class PickupGameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 將 Service 統一宣告在這裡
    private PickupGameSignupService gameService = new PickupGameSignupServiceImpl();

    // doGet 與 doPost 互相呼叫，統一處理邏輯
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 讓 doGet 也能處理 action 參數，並統一交給 doPost 處理
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

        // 2. 如果沒有 action，預設導向首頁 (原本的 PickupMainServlet)
        if (action == null || action.isEmpty()) {
            List<PickupGameBean> allGames = gameService.getAllGames();
            
            // 排序：開放中(open) > 已額滿(full) > 已取消(cancelled)，同狀態按建立時間較早的在前面
            allGames.sort((g1, g2) -> {
                int statusWeight1 = getStatusWeight(g1.getStatus());
                int statusWeight2 = getStatusWeight(g2.getStatus());
                if (statusWeight1 != statusWeight2) {
                    return Integer.compare(statusWeight1, statusWeight2);
                }
                // 同狀態：建立時間越早越後面 (升冪排列 => 舊的在前面, ID越小越前面)
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
                    request.getRequestDispatcher("/WEB-INF/views/pickup_main.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 可以統一處理例外狀況，導向一個錯誤頁面
            response.sendError(500, "系統發生錯誤：" + e.getMessage());
        }
    }

    private void goCreateGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("--- 進入發起揪團表單 ---");
        
        // 進入新表單前清除殘留訊息，防止「取消失敗」等文字出現
        request.getSession().removeAttribute("msg");
        request.removeAttribute("msg");

        // 從資料庫撈取所有球場與時段
        List<CourtBean> courts = gameService.getAllCourts();
        request.setAttribute("courts", courts);
        request.setAttribute("timeSlots", gameService.getAllTimeSlots());
        request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
    }

    private void createGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer hostId = (Integer) session.getAttribute("memberId");
        if (hostId == null) {
            hostId = 4; // 預設為薩拉
        }

        try {
            int courtId = Integer.parseInt(request.getParameter("courtId"));
            String gameDate = request.getParameter("gameDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            int neededPlayers = Integer.parseInt(request.getParameter("neededPlayers"));
            int totalMaxPlayers = neededPlayers + 1;

            // 確保「結束時間」必須晚於「開始時間」
            if (startTime.compareTo(endTime) >= 0) {
                request.setAttribute("courts", gameService.getAllCourts());
                request.setAttribute("timeSlots", gameService.getAllTimeSlots());
                request.setAttribute("msg", "發起失敗：結束時間必須晚於開始時間！");
                request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
                return;
            }

            boolean success = gameService.createAndJoin(hostId, courtId, gameDate, startTime, endTime, totalMaxPlayers);

            if (success) {
                Integer latestGameId = gameService.getLatestGameId();
                // 注意這裡的重定向網址也改為共用的 /pickup 並加上 action
                response.sendRedirect(request.getContextPath() + "/pickup?action=getSignupList&gameId=" + latestGameId);
            } else {
                // 發生錯誤退回表單時，必須重新將 courts 塞回去，否則下拉選單會空白
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
        System.out.println("--- 進入：找球賽清單 ---");
        List<PickupGameBean> allGames = gameService.getAllOpenGames();
        request.setAttribute("allGames", allGames);
        request.getRequestDispatcher("/WEB-INF/views/game_list.jsp").forward(request, response);
    }

    private void addSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gameIdStr = request.getParameter("gameId");
        HttpSession session = request.getSession();
        Integer sessionMemberId = (Integer) session.getAttribute("memberId");
        Integer memberId = (sessionMemberId != null) ? sessionMemberId : 4; // 統一預設為 4

        if (gameIdStr != null) {
            try {
                Integer gameId = Integer.parseInt(gameIdStr);
                System.out.println("準備報名：Game=" + gameId + ", Member=" + memberId);
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
            // 撈出現前該場次的詳細資訊以取得狀態給 JSP 判斷
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

            // 找出主揪資訊，傳給 JSP
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

        // 目前登入的會員 ID
        HttpSession session = request.getSession();
        Integer sessionMemberId = (Integer) session.getAttribute("memberId");
        request.setAttribute("sessionMemberId", sessionMemberId != null ? sessionMemberId : 4);

        request.getRequestDispatcher("/WEB-INF/views/signup_list.jsp").forward(request, response);
    }

    // 主揪踢人
    private void kickMember(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gameIdStr = request.getParameter("gameId");
        String targetIdStr = request.getParameter("targetMemberId");
        HttpSession session = request.getSession();
        Integer hostId = (Integer) session.getAttribute("memberId");
        if (hostId == null)
            hostId = 4;

        if (gameIdStr != null && targetIdStr != null) {
            int gameId = Integer.parseInt(gameIdStr);
            int targetMemberId = Integer.parseInt(targetIdStr);
            String resultMsg = gameService.kickMember(gameId, hostId, targetMemberId);
            request.setAttribute("msg", resultMsg);
        }
        getSignupList(request, response);
    }

    // 管理員代為報名
    private void adminAddPlayer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gameIdStr = request.getParameter("gameId");
        String targetMemberIdStr = request.getParameter("targetMemberId");
        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("memberId");
        
        // 確保是管理員權限才執行
        if (adminId == null) adminId = 4;

        if (adminId == 4 && gameIdStr != null && targetMemberIdStr != null && !targetMemberIdStr.isEmpty()) {
            try {
                int gameId = Integer.parseInt(gameIdStr);
                int targetMemberId = Integer.parseInt(targetMemberIdStr);
                // 呼叫原本寫好的報名邏輯 (此邏輯內部會檢查重複報名與時段衝突)
                String resultMsg = gameService.registerString(gameId, targetMemberId);
                request.setAttribute("msg", "代報結果: " + resultMsg);
            } catch (NumberFormatException e) {
                request.setAttribute("msg", "會員 ID 格式錯誤，請輸入數字。");
            }
        } else {
            request.setAttribute("msg", "權限不足或缺少會員資訊。");
        }
        
        getSignupList(request, response);
    }

    // 主揪取消開團
    private void cancelGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gameIdStr = request.getParameter("gameId");
        HttpSession session = request.getSession();
        Integer hostId = (Integer) session.getAttribute("memberId");
        if (hostId == null)
            hostId = 4;

        if (gameIdStr != null) {
            int gameId = Integer.parseInt(gameIdStr);
            String resultMsg = gameService.cancelGame(gameId, hostId);
            session.setAttribute("msg", resultMsg); // 使用 session 存訊息，因為要 redirect
        }
        // 取消後重定向回列表頁面，確保有重新撈出所有資料
        response.sendRedirect(request.getContextPath() + "/pickup");
    }

    // 成員退出
    private void withdrawSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gameIdStr = request.getParameter("gameId");
        HttpSession session = request.getSession();
        Integer memberId = (Integer) session.getAttribute("memberId");
        if (memberId == null)
            memberId = 4;

        if (gameIdStr != null) {
            int gameId = Integer.parseInt(gameIdStr);
            String resultMsg = gameService.withdrawFromGame(gameId, memberId);
            request.setAttribute("msg", resultMsg);
        }
        getSignupList(request, response);
    }

    // 狀態排序權重：開放中(1) > 已額滿(2) > 其他(3) > 已取消(4)
    private int getStatusWeight(String status) {
        if ("open".equals(status)) return 1;
        if ("full".equals(status)) return 2;
        if ("cancelled".equals(status)) return 4;
        return 3;
    }
}