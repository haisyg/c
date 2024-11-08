package com.example.demo1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;

@WebServlet(urlPatterns = "/MessageServlet")
public class MessageServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        // 在 ServletContext 中初始化消息列表
        List<Message> globalMessages = new ArrayList<>();
        getServletContext().setAttribute("globalMessages", globalMessages);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 从 ServletContext 获取共享的消息列表
        List<Message> globalMessages = (List<Message>) getServletContext().getAttribute("globalMessages");

        // 获取当前用户
        HttpSession session = request.getSession(false);
        String currentUser = (session != null) ? (String) session.getAttribute("username") : null;

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        List<Message> filteredMessages = new ArrayList<>();
        if (currentUser != null) {
            // 过滤消息，只保留发给当前用户或发送者是当前用户的消息
            for (Message message : globalMessages) {
                if (message.getRecipient().equals(currentUser) ||
                        message.getRecipient().equals("所有人") ||
                        message.getSender().equals(currentUser)) {
                    filteredMessages.add(message);
                }
            }
        } else {
            // 如果用户未登录，可以选择返回空消息列表
            filteredMessages = globalMessages; // 可根据需求修改
        }

        out.print(new Gson().toJson(filteredMessages)); // 返回过滤后的消息列表
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String sender = (String) session.getAttribute("username"); // 从会话中获取发送者用户名

        if (sender == null || sender.isEmpty()) {
            response.getWriter().write("{\"success\": false, \"error\": \"用户未登录\"}");
            return;
        }

        String jsonData = request.getReader().readLine();
        MessageData data = new Gson().fromJson(jsonData, MessageData.class);

        if (data.message != null && !data.message.trim().isEmpty()) {
            List<Message> globalMessages = (List<Message>) getServletContext().getAttribute("globalMessages");

            synchronized (globalMessages) {
                Message newMessage = new Message(sender, data.recipient, data.message);
                globalMessages.add(newMessage); // 将新消息添加到全局消息列表中
            }

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false, \"error\": \"消息不能为空\"}");
        }
    }

    private static class MessageData {
        String message;
        String recipient;
    }

    private static class Message {
        private String sender;
        private String recipient;
        private String content;

        public Message(String sender, String recipient, String content) {
            this.sender = sender;
            this.recipient = recipient.isEmpty() ? "所有人" : recipient;
            this.content = content;
        }

        public String getSender() {
            return sender;
        }

        public String getRecipient() {
            return recipient;
        }

        public String getContent() {
            return content;
        }
    }
}
