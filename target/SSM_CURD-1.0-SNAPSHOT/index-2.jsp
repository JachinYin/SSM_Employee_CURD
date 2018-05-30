<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2018/5/16
  Time: 16:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<body>
    <%
        pageContext.setAttribute("App_Path",request.getContextPath());
    %>
    <a href="error" class="btn btn-info" role="button">GO</a>
    <a href="${App_Path}/emps" class="btn btn-info" role="button">listAll</a>

</body>
</html>
