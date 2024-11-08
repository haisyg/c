<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <link rel="stylesheet" href="index.css">
    <title>聊天室</title>
    <style>
        #messageBoard {
            margin: auto;
            border: 2px solid #000;
            width: 850px;
            height: 300px;
            overflow-y: scroll;
            padding: 15px;
            background-color: #f0f0f0;
        }
    </style>
</head>
<body class="bj">
<div id="bcgd">
    <h2>聊天室</h2>
    <div>当前用户: <%= session.getAttribute("username") != null ?
            session.getAttribute("username") : "未登录" %></div>

    <div id="messageBoard"></div>
    <input type="text" id="messageInput" placeholder="输入您的消息" />
    <select id="recipientSelect">
        <option value="">所有人</option> <!-- 发送给所有人 -->
        <%
            session = request.getSession();
            List<String> onlineUsers = (List<String>) session.getAttribute("onlineUsers");
            if (onlineUsers != null && !onlineUsers.isEmpty()) {
                for (String user : onlineUsers) {
        %>
        <option value="<%= user %>"><%= user %></option>
        <%
                }
            }
        %>
    </select>
    <button id="sendButton">发送</button>
    <h2>在线用户列表</h2>
    <div id="onlineUsers">
        <%
            if (onlineUsers != null && !onlineUsers.isEmpty()) {
                for (String user : onlineUsers) {
        %>
        <div><%= user %></div>
        <%
            }
        }
        %>
    </div>
    <button id="logoutButton">退出</button> <!-- 添加退出按钮 -->
</div>
<script>
    var logoutButton = document.getElementById('logoutButton');
    const onlineUsersDiv = document.getElementById('onlineUsers');
    const messageBoard = document.getElementById('messageBoard');
    const sendButton = document.getElementById('sendButton');
    const messageInput = document.getElementById('messageInput');
    const recipientSelect = document.getElementById('recipientSelect');

    sendButton.addEventListener('click', () => {
        const message = messageInput.value;
        const recipient = recipientSelect.value;
        fetch('MessageServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({message, recipient })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    messageInput.value = '';
                    loadMessages();
                } else {
                    alert('发送失败');
                }
            })
            .catch(error => console.error('Error:', error));
    });
    function loadMessages() {
        fetch('MessageServlet')
            .then(response => response.json())
            .then(messages => {
                messageBoard.innerHTML = ''; // 清空消息面板
                messages.forEach(function(msg) {
                    console.log(msg)
                    const div = document.createElement('div');
                    // 使用字符串连接而不是模板字符串
                    div.textContent = msg.sender + " 发给 " + msg.recipient + ": " + msg.content;
                    messageBoard.appendChild(div);
                });
                messageBoard.scrollTop = messageBoard.scrollHeight; // 滚动到底部
            })
            .catch(error => console.error('Error:', error));
    }
    setInterval(loadMessages, 3000); // 每3秒刷新一次消息
    //退出登录
    logoutButton.addEventListener('click', function() {
        window.location.href = 'logout.do';
    });
    function updateOnlineUsers() {
        fetch('login.do')
            .then(response => response.text())
            .then(data => {
                onlineUsersDiv.innerHTML = ''; // 更新在线用户列表
                const onlineUsers = data.split('\n').map(user => user.trim()).filter(Boolean);
                onlineUsers.forEach(user => {
                    const div = document.createElement('div');
                    div.textContent = user;
                    onlineUsersDiv.appendChild(div);
                });
            })
            .catch(error => console.error('There was a problem with the fetch operation:', error));
    }

    function updateRecipientSelect() {
        const recipientSelect = document.getElementById('recipientSelect');
        recipientSelect.innerHTML = '<option value="">所有人</option>'; // 重置下拉框
        fetch('login.do')
            .then(response => response.text())
            .then(data => {
                const onlineUsers = data.split('\n').map(user => user.trim()).filter(Boolean);
                onlineUsers.forEach(user => {
                    const option = document.createElement('option');
                    option.value = user;
                    option.textContent = user;
                    recipientSelect.appendChild(option);
                });
            })
            .catch(error => console.error('There was a problem with the fetch operation:', error));
    }
    setInterval(updateOnlineUsers, 3000); // 每3秒刷新一次消息
    setInterval(updateRecipientSelect,3000)
</script>
</body>
</html>
