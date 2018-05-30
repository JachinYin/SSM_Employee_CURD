<%@ page import="org.springframework.web.context.request.RequestScope" %><%--
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
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.js"></script>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>

    <%
        pageContext.setAttribute("App_Path", request.getContextPath());
    %>
</head>
<body>

<!-- 添加员工模态框 -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="addEmpName" class="col-sm-2 control-label">Name</label>
                        <div class="col-sm-10">
                            <input name="empName" type="text" class="form-control" id="addEmpName" placeholder="请输入姓名">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="addEmpEmail" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input name="email" type="email" class="form-control" id="addEmpEmail" placeholder="email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="addEmpGender1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="addEmpGender2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="addEmp">Add</button>
            </div>
        </div>
    </div>
</div>


<!-- 修改员工模态框 -->
<div class="modal fade" id="editEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="editEmpName" class="col-sm-2 control-label">Name</label>
                        <div class="col-sm-10">
                            <input name="empName" type="text" class="form-control" id="editEmpName" placeholder="请输入姓名">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="editEmpEmail" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="editEmpEmail"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="editEmpGender1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="editEmpGender2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="editEmp">Update</button>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <%-- title --%>
    <div class="row">
        <div class="col-md-12">
            <h1>员工管理</h1>
        </div>
    </div>

    <%-- Function --%>
    <div class="row">
        <div class="col-md-12 col-md-offset-10">
            <button class="btn btn-primary" id="btn_addEmployeeModal">new</button>
            <button class="btn btn-danger" id="btn_delete_Emp">delete</button>
        </div>
    </div>
    <br>

    <%-- table --%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover table-striped" id="emps_tab">
                <thead>
                <tr>
                    <th><input type="checkbox" id="check_all"/></th>
                    <th>#</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Gender</th>
                    <th>Department</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <%-- page --%>
    <div class="row">
        <center>
            <div class="col-md-6" id="page_info"></div>
            <div class="col-md-6" id="page_navg"></div>
        </center>
    </div>
    <%--<a href="emp" class="btn btn-info" role="button">Add New Employee</a>--%>
</div>

<script type="text/javascript">

    var currtentPage;

    <%-- 页面加载完成，发送 Ajax --%>
    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        // 调用 jq 的 ajax 函数发起 ajax 请求
        $.ajax({
            url: "${App_Path}/emps", // 请求的 url
            data: "pn=" + pn,    // 请求的 url 中的参数
            type: "GET",     // 请求的类型
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
                // console.log(result);
                build_table_data(result);
                build_page_info(result);
                build_page_nvag(result);
            }
        });
    }

    // 构建表格的函数
    function build_table_data(result) {
        // 在添加数据前先清空表格中的原有数据
        $("#emps_tab tbody").empty();
        var emps = result.extendInfo.pageInfo.list;
        $.each(emps, function (index, item) {

            var checkbox = $("<td><input type='checkbox' class='check_item' /></td>")

            var id = $("<td></td>").append(item.empId);
            var name = $("<td></td>").append(item.empName);
            var gender = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
            var email = $("<td></td>").append(item.email);
            var department = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<td></td>")
                .append($("<button></button>")
                    .addClass("btn btn-info btn-sm")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                    .append(" Edit"));
            var deleteBtn = $("<td></td>")
                .append($("<button></button>")
                    .addClass("btn btn-danger btn-sm")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                    .append(" Delete"));
            // TODO 编辑按钮事件
            editBtn.click(function () {
                editEmpInfo(this);
            });
            deleteBtn.click(function () {
                deleteEmp(this);
            });
            $("<tr></tr>")
                .append(checkbox)
                .append(id)
                .append(name)
                .append(email)
                .append(gender)
                .append(department)
                .append(editBtn)
                .append(deleteBtn)
                .appendTo("#emps_tab tbody");
        });
    }

    // 构建 分页信息的函数
    function build_page_info(result) {
        // 清空数据
        $("#page_info").empty();
        var pageInfoNode = result.extendInfo.pageInfo;
        $("#page_info").append("当前第 " + pageInfoNode.pageNum + " 页. " +
            "总共 " + pageInfoNode.pages + " 页. " +
            "一共 " + pageInfoNode.total + " 条记录");
        currtentPage = pageInfoNode.pageNum
    }

    // 构建 分页条的函数
    function build_page_nvag(result) {
        $("#page_navg").empty();
        var temp = result.extendInfo.pageInfo;

        var ulNode = $("<ul></ul>").addClass("pagination");

        // 首页节点 和 前一页节点
        var firstPageNode = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        var prePageNode = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if (!temp.hasPreviousPage) {
            firstPageNode.addClass("disabled");
            prePageNode.addClass("disabled");
        }else {
            // 为节点添加点击事件
            firstPageNode.click(function () {
                to_page(1);
            });
            prePageNode.click(function () {
                to_page(temp.prePage);
            });
        }

        ulNode.append(firstPageNode).append(prePageNode);
        $.each(temp.navigatepageNums, function (index, item) {
            var numNode = $("<li></li>").append($("<a></a>").append(item));
            if (temp.pageNum == item) numNode.addClass("active");
            numNode.click(function () {
                to_page(item);
            });
            ulNode.append(numNode);
        });

        var nextPageNode = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageNode = $("<li></li>").append($("<a></a>").append("尾页").attr("href", "#"));
        if (!temp.hasNextPage) {
            nextPageNode.addClass("disabled");
            lastPageNode.addClass("disabled");
        }else {
            // 为节点添加点击事件
            lastPageNode.click(function () {
                to_page(temp.pages);
            });
            nextPageNode.click(function () {
                to_page(temp.nextPage);
            });
        }

        ulNode.append(nextPageNode).append(lastPageNode);

        $("#page_navg").append($("<nav></nav>").append(ulNode));
    }

    // 编辑员工信息按钮事件
    function editEmpInfo(ele) {
        var empId = $($(ele).parent().find("td")[1]).text();

        // 弹出模态框前应该发送 Ajax 请求从数据库获取部门信息
        getDeptName("#editEmployeeModal select");

        // 获取员工信息
        getEmp("#editEmployeeModal",empId);
        //弹出模态框
        // 传递员工 ID
        $("#editEmp").attr("empId",empId);
        $("#editEmployeeModal").modal({
            backdrop:"static"
        })
    }

    // 删除员工信息按钮事件
    function deleteEmp(ele) {
        var empId = $($(ele).parent().find("td")[1]).text();

        if(confirm("确认删除【" + empId + "】号员工？")){
            $.ajax({
                url: "${App_Path}/emp/"+empId,
                type: "DELETE",
                success: function (result) {
                    alert(result.info);
                    to_page(currtentPage);
                }
            })

        }else return false;
    }

    // 表单重置功能，包括内容和样式和提示信息
    function reset_form(ele){
        // 内容
        $(ele)[0].reset();
        // 样式
        $(ele).find("*").removeClass("has-error has-success");
        // 提示信息
        $(ele).find(".help-block").text("");
    }
    // 点击新增按钮事件
    $("#btn_addEmployeeModal").click(function () {
        // 表单重置工作
        reset_form("#addEmployeeModal form")

        // 弹出模态框前应该发送 Ajax 请求从数据库获取部门信息
        getDeptName("#addEmployeeModal select");

        // 弹出模态框
        $("#addEmployeeModal").modal({
            show:true,
            backdrop:"static"
        });
    });

    //发送 Ajax 请求获取部门信息显示在下拉列表中
    function getDeptName(ele) {
        // 清空之前添加的下拉框信息
        $(ele).empty();
        $.ajax({
            url: "${App_Path}/depts", // 请求的 url
            type: "GET",     // 请求的类型
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
                // console.log(result);
                $.each(result.extendInfo.depts, function (index, item) {
                    var opNode = $("<option></option>").append(item.deptName).attr("value",item.deptId);
                    $(ele).append(opNode);
                })
            }
        });
    }

    //发送 Ajax 请求获取员工信息显示回显在模态框中
    function getEmp(ele,id) {
        // 清空之前添加的下拉框信息
        //$(ele).empty();
        $.ajax({
            url: "${App_Path}/emp/"+id, // 请求的 url
            type: "GET",     // 请求的类型
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
                //console.log(result.extendInfo.emp);
                var empData = result.extendInfo.emp;
                $("#editEmpName").val(empData.empName);
                $("#editEmpEmail").text(empData.email);
                $("#editEmployeeModal input[name='gender']").val([empData.gender]);
                $("#editEmployeeModal select").val([empData.dId]);
            }
        });
    }

    // 数据格式校验
    function validate_formData(ele){
        var empName = $("#addEmpName").val();
        var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
        if(!regName.test(empName)){
            // alert("用户名可以是2-5位汉字或3-16位字母数字组合");
            show_validate("#addEmpName","error","用户名可以是2-5位汉字或3-16位字母数字组合");
            return false;
        }else{
            show_validate("#addEmpName","success","");
        }
        var email = $("#addEmpEmail").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            // alert("邮箱格式不正确");
            show_validate("#addEmpEmail","error","邮箱格式不正确");
            return false;
        }else{
            show_validate("#addEmpEmail","success","");
        }
        return true;
    }
    //数据校验情况美化处理
    function show_validate(ele, stat, msg) {
        $(ele).parent().removeClass("has-success has-error");
        if("success"==stat){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text("");
        }else{
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    // 邮箱校验重复
    $("#addEmpEmail").change(function () {
        // 内容发生改变，发送 ajax 获取数据进行校验
        $.ajax({
            url: "${App_Path}/checkEamil", // 请求的 url
            type: "GET",     // 请求的类型
            data:"email="+this.value,
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
                if(result.statusCode==100){
                    show_validate("#addEmpEmail","success","邮箱可用");
                    $("#addEmp").attr("ajax_email","success");
                }else{
                    show_validate("#addEmpEmail","error",result.extendInfo.isEmail);
                    $("#addEmp").attr("ajax_email","error");
                }
            }
        });
    });

    // 点击提交按钮实现新增用户
    $("#addEmp").click(function () {
        // 在创建用户之前要验证数据合法性
        if(!validate_formData()){
            return false;
        }
        // 在创建邮箱之前判断邮箱存在已否的校验结果
        if($(this).attr("ajax_email")=="error"){
            return false;
        }

        var info = $("#addEmployeeModal form").serialize();
        $.ajax({
            url: "${App_Path}/emp", // 请求的 url
            type: "POST",     // 请求的类型
            data:info,
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
                if(result.statusCode==100){
                    // 如果后台数据校验成功，则执行以下操作
                    alert(result.info);
                    // 关闭模态框
                    $("#addEmployeeModal").modal("hide");
                    // 去末页
                    to_page(99999);
                }else{ // 否则显示校验错误信息
                    console.log(result)
                    // .extendInfo.errorInfo
                    if(undifined != result.extendInfo.errorInfo.email){
                        // 显示邮箱错误信息
                        show_validate("#addEmpEmail","error",result.extendInfo.errorInfo.email)
                    }
                    if(undifined != result.extendInfo.errorInfo.empName){
                        // 显示邮箱错误信息
                        show_validate("#addEmpName","error",result.extendInfo.errorInfo.empName)
                    }
                }

            }
        });
    })

    // 点击提交按钮实现信息修改
    $("#editEmp").click(function () {
        // 1.用户名数据格式校验
        var empName = $("#editEmpName").val();
        var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
        if(!regName.test(empName)){
            // alert("用户名可以是2-5位汉字或3-16位字母数字组合");
            show_validate("#editEmpName","error","用户名可以是2-5位汉字或3-16位字母数字组合");
            return false;
        }else{
            show_validate("#editEmpName","success","");
        }

        // 2.发送 Ajax 完成更新
        var info = $("#editEmployeeModal form").serialize();
        $.ajax({
            url: "${App_Path}/emp/"+$(this).attr("empId"), // 请求的 url
            type: "PUT",     // 请求的类型
            data:info,
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
                //alert(result.info);
                // 1.关闭模态框
                $("#editEmployeeModal").modal("hide");
                // 2.回到本页
                to_page(currtentPage)
            }
        })
    })

    // 首列 checkBox 的全选和全不选
    $("#check_all").click(function () {
        $(".check_item").prop("checked",$(this).prop("checked"));
    })
    // 所有的 check_item 被框选后
    $(document).on("click",".check_item",function () {
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked",flag);
    });

    // 批量删除功能
    $("#btn_delete_Emp").click(function () {
        var empIds = "";
        $.each($(".check_item:checked"), function () {
            empIds += $(this).parents("tr").find("td:eq(1)").text() + ", ";
        });
        empIds = empIds.substring(0,empIds.length-2);
        if(confirm("确认删除以下号码的员工？\n"+empIds)){
            console.log(empIds);
            $.ajax({
                url: "${App_Path}/emp/"+empIds,
                type: "DELETE",
                success: function (result) {
                    alert(result.info);
                    to_page(currtentPage);
                }
            })
        }
    })

</script>
</body>
</html>
