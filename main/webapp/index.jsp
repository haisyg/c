<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="index.css" />
    <title>聊天室登录</title>
    <script type="text/javascript">
        function validateForm() {
            var username = document.forms["loginForm"]["username"].value;
            var password = document.forms["loginForm"]["password"].value;
            var verification = document.forms["loginForm"]["verification"].value;

            if (username === "") {
                alert("用户名不能为空！");
                return false;
            }
            if (password === "") {
                alert("密码不能为空！");
                return false;
            }
            if (verification === "") {
                alert("验证码不能为空！");
                return false;
            }
            return true;
        }
        function refreshCaptcha() {
            // 生成新的验证码并更新画布
            let verification = Verification('#canvas', 120, 30);
            document.getElementById('generatedCaptcha').value = verification;
        }
        window.onload = refreshCaptcha;//设置初始验证码
    </script>
</head>
<body>
<div class="zhongjian">
    <h2>聊天室登录页面</h2>
<form name="loginForm" action="login.do" method="post" onsubmit="return validateForm()">
    <table>
        <tr>
            <td>用户名：</td>
            <td><input type="text" name="username"></td>
        </tr>
        <tr>
            <td>密&nbsp;&nbsp;码：</td>
            <td><input type="password" name="password"></td>
        </tr>
        <tr>
            <td>验证码：</td>
            <td><input type="text" name="verification"></td>
            <td>
                <canvas id="canvas" width="120" height="30" style="cursor: pointer;"></canvas>
                <input type="hidden" name="generatedCaptcha" id="generatedCaptcha">
                <script type="text/javascript" src="verification.js"></script>
            </td>
        </tr>
        <tr>
            <td><input type="submit" value="登录"></td>
            <td><input type="reset" value="取消"></td>
        </tr>
    </table>
</form>
</div>
<script>
    // 为画布添加点击事件
    document.getElementById('canvas').addEventListener('click', refreshCaptcha);
</script>
</body>
</html>