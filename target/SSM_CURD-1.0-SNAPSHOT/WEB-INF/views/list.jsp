<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2018/5/18
  Time: 12:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>所有员工</title>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.js"></script>
    <%--<script type="text/javascript" src="../scripts/jquery-1.9.1.min.js"></script>--%>
    <script type="text/javascript">
        $(function () {
            $(".delete").click(function () {
                var href = $(this).attr("href");
                $("form").attr("action", href).submit();
                return false;
            });
        })
    </script>
</head>
<body>
<form action="" method="POST">
    <input type="hidden" name="_method" value="DELETE"/>
</form>

<div class="container">
    <%-- title --%>
    <div class="row">
        <div class="col-md-12">
            <h1>Information</h1>
        </div>
    </div>

    <%-- Function --%>
    <div class="row">
        <div class="col-md-12 col-md-offset-10">
            <button class="btn btn-primary">new</button> <button class="btn btn-danger">delete</button>
        </div>
    </div>
        <br>
    <%-- table --%>
    <div class="row">
         <div class="col-md-12">
             <c:if test="${empty pageInfo.list }">
                 <h2>没有任何员工信息.</h2>
             </c:if>
             <c:if test="${!empty pageInfo.list }">
                 <table class="table table-hover table-striped">
                     <tr>
                         <th>#</th>
                         <th>Name</th>
                         <th>Email</th>
                         <th>Gender</th>
                         <th>Department</th>
                         <th>Edit</th>
                         <th>Delete</th>
                     </tr>

                     <c:forEach items="${pageInfo.list }" var="emp">
                         <tr>
                             <td>${emp.empId }</td>
                             <td>${emp.empName }</td>
                             <td>${emp.email }</td>
                             <td>${emp.gender == 'F' ? 'Female' : 'Male' }</td>
                             <td>${emp.department.deptName }</td>
                             <td><a href="emp/${emp.empId}" class="btn btn-info btn-sm glyphicon glyphicon-pencil" role="button"> Edit</a></td>
                             <td><a href="emp/${emp.empId}" class="delete btn btn-danger btn-sm glyphicon glyphicon-trash" role="button">  Delete</a></td>
                         </tr>
                     </c:forEach>
                 </table>
             </c:if>
         </div>
    </div>

    <%-- page --%>
    <div class="row">
        <center>
        <div class="col-md-6">
            当前第 ${pageInfo.pageNum} 页.总共 ${pageInfo.pages} 页.一共 ${pageInfo.total} 条记录
        </div>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">

                    <li><a href="${pageContext.request.contextPath}/emps?pn=1" class="btn btn-info" role="button">首页</a></li>

                    <!--上一页-->
                    <li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <a href="${pageContext.request.contextPath}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous" class="btn btn-info" role="button">
                                <span aria-hidden="true">«</span>
                            </a>
                        </c:if>
                    </li>

                    <!--循环遍历连续显示的页面，若是当前页就高亮显示，并且没有链接-->
                    <c:forEach items="${pageInfo.navigatepageNums}" var="page_num">
                        <c:if test="${page_num == pageInfo.pageNum}">
                            <li class="active"><a href="#" class="btn btn-info" role="button">${page_num}</a></li>
                        </c:if>
                        <c:if test="${page_num != pageInfo.pageNum}">
                            <li><a href="${pageContext.request.contextPath}/emps?pn=${page_num}" class="btn btn-info" role="button">${page_num}</a></li>
                        </c:if>
                    </c:forEach>

                    <!--下一页-->
                    <li>
                        <c:if test="${pageInfo.hasNextPage}">
                            <a href="${pageContext.request.contextPath}/emps?pn=${pageInfo.pageNum+1}"
                               aria-label="Next" class="btn btn-info" role="button">
                                <span aria-hidden="true">»</span>
                            </a>
                        </c:if>
                    </li>

                    <li><a href="${pageContext.request.contextPath}/emps?pn=${pageInfo.pages}" class="btn btn-info" role="button">尾页</a></li>
                </ul>
            </nav>
        </div>
        </center>
    </div>
    <%--<a href="emp" class="btn btn-info" role="button">Add New Employee</a>--%>
</div>
</body>
</html>
