package com.example.demo1;

import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "helloServlet", urlPatterns = {"/login.do", "/logout.do"})
public class HelloServlet extends HttpServlet {
    // 使用一个静态列表来存储所有在线用户
    private static final List<String> onlineUsers = Collections.synchronizedList(new ArrayList<>());

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userCaptcha = request.getParameter("verification");
        String captcha = request.getParameter("generatedCaptcha");
        response.setContentType("text/html;charset=UTF-8");
        OutputStream outputStream = response.getOutputStream();
        String responseMessage;
        if (userCaptcha != null && userCaptcha.equals(captcha)) {
            String username = request.getParameter("username");
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            synchronized (onlineUsers) {
                if (onlineUsers.contains(username)) {
                    response.getWriter().write("You are already online");
                } else {
                    onlineUsers.add(username);
                    session.setAttribute("onlineUsers", onlineUsers);
                    response.sendRedirect("chatroom.jsp");
                }
            }
        }else {
            responseMessage = "验证码错误，请重试！";
            outputStream.write(responseMessage.getBytes(StandardCharsets.UTF_8));
            outputStream.flush();
            outputStream.close();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        if ("/logout.do".equals(action)) {
            HttpSession session = request.getSession();
            String username = (String) session.getAttribute("username");

            if (username != null) {
                synchronized (onlineUsers) {
                    onlineUsers.remove(username);
                }
            }
            session.invalidate(); // 使会话失效
            response.sendRedirect("index.jsp");
        } else if ("/login.do".equals(action)) {
            // 返回在线用户列表
            synchronized (onlineUsers) {
                response.setContentType("text/plain");
                for (String user : onlineUsers) {
                    response.getWriter().println(user);
                }
            }
        }
    }
}