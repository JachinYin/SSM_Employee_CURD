#SSM 整合之员工管理

该项目整合 Spring、SpringMVC、以及 MyBatis 三大框架，完成员工的管理。

## 1 需求分析

1. 分页显示所有员工的信息：包括 id、姓名、邮箱、性别、所在部门
2. 添加新的员工：要求邮箱不能重复，进行数据校验
3. 修改员工：要求邮箱无法修改，进行姓名数据校验
4. 删除员工：包括单个删除和批量删除

## 2 技术要点

- 前台设计：BootStrap 框架
- 前台请求处理：SpringMVC 框架处理所有请求，将静态资源请求交给 Tomcat 服务器
- 后台：使用 Spring 容器进行管理
- 数据库：使用 Mysql，数据交互使用 MyBatis 框架，并使用 MBG 生成接口文件。

## 3 页面设计

### 3.1 主页面：

![main](image\ssm_crud_main.png)

### 3.2 新增员工：

![add](image\ssm_srud_add.png)

### 3.3 修改员工:

![edit](image\ssm_crud_edit.png)



## 4 分页查询

使用国人的开源项目： Mybatis 的一款插件 pagehelper 可以快速方便的实现分页的功能。

[官方文档](https://pagehelper.github.io/docs/howtouse/)

简单的使用可以参考另一份笔记。

MyBatis 逆向工程生成的 Mapper 文件中提供了按顺序查询，使用方法：

service 层方法，获取全部员工

```java
@Autowired
private EmployeeMapper employeeMapper;
public List<Employee> getAll() {
        EmployeeExample employeeExample = new EmployeeExample();
        employeeExample.setOrderByClause("emp_Id");// 按员工 id 排序
        List<Employee> employees = 
            employeeMapper.selectByExampleWithDept(employeeExample);
        return employees;
    }
```



##5 Ajax 请求获取数据

该功能需要通过发送 Ajax 请求给服务器，服务器返回一个 JSON 格式字符串，客户端拿到 JSON 数据后进行解析，通过 jQuery 进行 DOM 操作，将解析的数据显示在页面上。 

**要点：**

- 使用 Ajax 发起请求：比如这个是去相应页面的 Ajax 请求

  ```javascript
  function to_page(pn) {
      $.ajax({
          url: "${App_Path}/emps", // 请求的 url
          data: "pn=" + pn,    // 请求的 url 中的参数
          type: "GET",     // 请求的类型
          success: function (result) { // result 为服务器响应请求发送给客户端的数据
              build_table_data(result); // 对返回的数据进行解析，添加到页面上
              build_page_info(result);
              build_page_nvag(result);
          }
      });
  }
  ```

- 返回 JSON 格式的数据：

  首先需要自定义一个信息封装类，然后在控制器的处理方法上使用 @ResponseBody 注解来生成 JSON 数据，并将该方法的返回类型设置为 自定义的信息封装类。

### **5.1 该功能实现的完整实例：**

该功能实现使用了 MyBatis 的 pageHelper 插件

#### 1.自定义信息类：

```java
public class Msg {
    // 响应状态码,100-成功，200-失败
    private int statusCode;

    // 响应信息
    private String info;

    // 响应返回给客户端的数据
    private Map<String, Object> extendInfo = new HashMap<>();

    // 设置成功状态码
    public static Msg success(){
        Msg result = new Msg();
        result.setStatusCode(100);
        result.setInfo("成功");
        return result;
    }
    // 设置失败状态码
    public static Msg fail(){
        Msg result = new Msg();
        result.setStatusCode(200);
        result.setInfo("失败");
        return result;
    }

    // 设置添加拓展信息的方法
    public Msg add(String key, Object value){
        this.getExtendInfo().put(key, value);
        return this;
    }

    // setter getter 方法 这里省略
    ...
}
```



#### 2.控制器方法：

将会返回 JSON 格式字符串给客户端

```java
    @RequestMapping(value = "/emps", method = RequestMethod.GET)
    @ResponseBody
    public Msg listAllWithJSON(@RequestParam(required = false, defaultValue = "1",
            value = "pn")Integer pn){
        PageHelper.startPage(pn,7);
        List<Employee> employees = employeeServicce.getAll();
        PageInfo pageInfo = new PageInfo<>(employees,5);
        return Msg.success().add("pageInfo",pageInfo);
    }
```



#### 3.客户端页面显示

客户端在前台解析数据，并将解析的数据显示在页面上，该部分涉及大量的 jQuery 使用， DOM 操作。

注意：这里的 ajax 请求函数里一共使用了 3 个函数来分别完成数据表格，分页信息，和分页条的数据显示，而在这三个函数的首行，必须先清空它们对应元素的数据。

前台 jsp 页面：

```jsp
<%@ page import="org.springframework.web.context.request.RequestScope" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>所有员工</title>
    <!-- Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" 
          href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va
                     +PmSTsz/K68vbdEjh4u" 
          crossorigin="anonymous">

    <!-- 引入 jQuery -->
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.js"></script>
</head>
<body>
<!-- 页面分四个部分：标题，两个功能按钮，表格数据，分页信息和分页条 -->
<div class="container">
    <%-- 1.title --%>
    <div class="row">
        <div class="col-md-12">
            <h1>Information</h1>
        </div>
    </div>

    <%-- 2.Function --%>
    <div class="row">
        <div class="col-md-12 col-md-offset-10">
            <button class="btn btn-primary">new</button>
            <button class="btn btn-danger">delete</button>
        </div>
    </div>
    <br>

    <%-- 3.table --%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover table-striped" id="emps_tab">
                <thead>
                <tr>
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

    <%-- 4.page --%>
    <div class="row">
        <center>
            <div class="col-md-6" id="page_info"></div>
            <div class="col-md-6" id="page_navg"></div>
        </center>
    </div>
</div>

<!-- js 加载，用来发起 Ajax 请求，以及显示数据 -->
<script type="text/javascript">
    <%-- 页面加载完成，发送 Ajax --%>
    $(function () {
        to_page(1); // 调用函数发起 Ajax 请求，去首页
    });

    function to_page(pn) {
        // 调用 ajax 函数发起 ajax 请求
        $.ajax({
            url: "${App_Path}/emps", // 请求的 url
            data: "pn=" + pn,    // 请求的 url 中的参数
            type: "GET",     // 请求的类型
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
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
        // 分析 json 数据，添加到表格节点中
        var emps = result.extendInfo.pageInfo.list;
        $.each(emps, function (index, item) {
            var id = $("<td></td>").append(item.empId);
            var name = $("<td></td>").append(item.empName);
            var gender = $("<td></td>").append(item.gender == 'M' ? "Male" : "Female");
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
            $("<tr></tr>")
                .append(id)
                .append(name)
                .append(email)
                .append(gender)
                .append(department)
                .append(editBtn)
                .append(deleteBtn)
                .appendTo("#emps_tab tbody");// 将带有数据的节点添加到页面元素中
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

</script>
</body>
</html>
```



## 6 新增员工

使用 bootstrap 框架的模态对话框来完成该功能。

[BootStrap 的 js 插件](https://v3.bootcss.com/javascript/#modals)

注意：当使用模态静态框时出现该错误 `Uncaught TypeError: $(...).modal is not a function`

，请查看 js 文件的用用顺序：正确如下：

```jsp
<!-- jQuery -->
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<!-- BS JavaScript -->
<script type="text/javascript" src="js/bootstrap.js"></script>
<!-- Have fun using Bootstrap JS -->
<script type="text/javascript">
    $(window).load(function() {
        $('#prizePopup').modal('show');
    });
</script>
```



### 6.1 一个添加员工的模态对话框：

```jsp
<!-- 添加员工模态框 -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1" role="dialog" aria-
     labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-
                        label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
            </div>
            <!-- 模态框主体 -->
            <div class="modal-body">
                <!-- 一个表单 -->
                <form class="form-horizontal">
                    <!-- 姓名 -->
                    <div class="form-group">
                        <label for="addEmpName" 
                               class="col-sm-2 control-label">Name</label>
                        <div class="col-sm-10">
                            <input name="empName" type="text" 
                                   class="form-control" 
                                   id="addEmpName" 
                                   placeholder="请输入姓名">
                        </div>
                    </div>
                    <!-- 邮箱 -->
                    <div class="form-group">
                        <label for="addEmpEmail" 
                               class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input name="email" type="email" class="form-control" 
                                   id="addEmpEmail" placeholder="email@qq.com">
                        </div>
                    </div>
                    <!-- 性别 -->
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" 
                                       id="addEmpGender1" value="M" 
                                       checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" 
                                       id="addEmpGender2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <!-- 部门 -->
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
                <button type="button" class="btn btn-default" data-
                        dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Add</button>
            </div>
        </div>
    </div>
</div>
```

### 6.2 使用 js 调用模态框

当点击按钮时，弹出模态框：

```JSP
....
<!-- 定义一个按钮 -->
<button type="button" class="btn btn-default">Close</button>

<script type="text/javascript">
....
<!-- 在 js 中绑定按钮和模态框 -->
$("#btn_addEmployeeModal").click(function () {
        $("#addEmployeeModal").modal({
            show:true,
            backdrop:"static"
        });
    })
</script>
```



## 7 数据校验

数据校验有几种：

- 格式校验
- 内容校验
- 合法校验

格式校验：

```
用户名：/^[a-z0-9_-]{3,16}$/
密码：/^[a-z0-9_-]{6,18}$/
邮箱：1./^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
	 2./^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/
汉字：/^[\u2E80-\u9FFF]+$/
```

内容校验：

检查输入内容是否重复

### 7.1 示例：

Bootstrap 对表单控件的校验状态，如 error、warning 和 success 状态，都定义了样式。使用时，添加 `.has-warning`、`.has-error`或 `.has-success` 类到这些控件的**父元素**即可。任何包含在此元素之内的 `.control-label`、`.form-control` 和 `.help-block` 元素都将接受这些校验状态的样式。

所以只需要在用到数据校验的表单输入中的 \<input> 标签下添加一个 

`\ <span class="help-block">helper info.</span>`

就可以提供错误时的提示信息了。

#### 1.前端 JS 数据校验功能

下面是数据格式的校验，使用 js 的实现：

```javascript
// 数据格式校验
    function validate_formData(){
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
        return true;
    }
```



#### 2.前端 JS 邮箱重复校验

下面是邮箱重复的校验：

```javascript
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
                    show_validate("#addEmpEmail","error","邮箱已存在！");
                    $("#addEmp").attr("ajax_email","error");
                }
            }
        });
    });
```

#### 3.后端控制器处理方法

对于这个验证的 Ajax 请求的处理方法如下：

```java
@RequestMapping(value = "/checkEamil", method = RequestMethod.GET)
    @ResponseBody
    public Msg checkEmail(@RequestParam(value = "email") String email){
        boolean flag = employeeServicce.isEmail(email);
        if(flag)
            return Msg.fail();
        else
            return Msg.success();
    }
```

#### 4.后端 service 层方法

而 service 层的校验方法则是这样的：

```java
public boolean isEmail(String email){
        boolean flag = true;
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmailEqualTo(email);// 添加查询规则
        if(employeeMapper.countByExample(employeeExample)==0) flag=false;
        return flag;
    }
```

#### 5.前后端统一问题

可以发现，经过上面的处理后，就可以进行异步的数据校验了，当邮箱已存在时会提醒用户邮箱已存在，需要注意的一点是，前后端必须要统一的问题：

前后端统一问题：前端使用正则表达是校验邮箱格式，后端仅仅使用 Ajax 请求的方式校验邮箱存在的话，就会存在一个差异性，那就是在输入邮箱时，邮箱的格式不正确，但是后端校验肯定是不存在这个格式有问题的邮箱的，所以这时候就会提示用户邮箱可用，但实际上它的格式是有问题的，所以在提交表单时就会出现邮箱格式不正确的提示，因此产生了矛盾，这就是前后端统一问题。

该问题的解决方案：

在后端也进行正则表达式的判断，改写控制器的处理方法如下：

```java
    @RequestMapping(value = "/checkEamil", method = RequestMethod.GET)
    @ResponseBody
    public Msg checkEmail(@RequestParam(value = "email") String email){
        String regEmail = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
        // 后端进行正则表达式判断
        if(!regEmail.matches(email)){
            return Msg.fail().add("isEamil","邮箱格式不正确");
        }

        boolean flag = employeeServicce.isEmail(email);
        if(flag)
            return Msg.fail().add("isEmail", "邮箱已存在");
        else
            return Msg.success();
    }
```

前端页面需要修改以下错误信息的显示，邮箱重复校验部分：

```javascript
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
                    // 这里进行了修改
                    show_validate("#addEmpEmail","error", 
                                  result.extendInfo.isEmail);
                    $("#addEmp").attr("ajax_email","error");
                }
            }
        });
    });
```

### 7.2 JSR303 校验补充

前面的方法中，进行了大量的数据校验，实际上仍然存在安全隐患，因为对于前端校验，用户可以使用浏览器开发工具，在数据不合法的情况下，修改校验信息，达到非法输入的目的。

所以对于所有敏感数据，都必须要有前端、后端、数据库约束的三重校验以确保数据的安全性。

JSR303 校验是一个规范，使用它可以很方便的进行后端校验，实现的框架有很多，一般常用的有 Hibernate-Validator 框架。使用该框架建议使用 Tomcat7.0 及以上的版本，避免 EL 表达式带来的奇怪问题。

Maven 仓库：

```xml
<!-- JSR303 校验 -->
<!-- https://mvnrepository.com/artifact/org.hibernate/hibernate-validator -->
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.0.10.Final</version>
</dependency>
```

#### JSR303 使用

只需要在需要进行数据校验的 bean 类字段上使用数据校验的注解就可以进行数据的校验了。

@Pattern

```java
@Pattern(regexp="(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5}$)",
                message = "用户名可以是2-5位汉字或3-16位字母数字组合")
    private String empName;
```

- regexp="" 表示的是正则表达式的匹配规则。
- message 表示校验出现错误时的信息

基本上其他的校验注解都有以上两个属性，用法也一样。

包括但不限于：@Length，@Number，@Email。。。



取出校验错误信息：

只需要在使用了 Bean 类的地方加上 @Valid 注解就可以开启校验了，而开启校验之后，总会有成功或失败，这时候需要在后面跟上一个 BindingResult 对象来获取校验结果的信息：

```java
    // 新增员工
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg save(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            // 校验有失败信息，应该将数据传送到前端去显示出来
            // 使用一个 map 对象来封装发生错误的字段以及对应的信息
            Map<String, Object> map = new  HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for(FieldError e: errors){
                map.put(e.getField(),e.getDefaultMessage());
            }
            // 将封装了错误信息的 map 对象传到前端
            return Msg.fail().add("errorInfo",map);
        } else {
            employeeServicce.save(employee); // 开启校验之前后端只有这俩行代码，
            return Msg.success();			// 所以安全性不高
        }
    }
```

后端开启校验之后，在前段使用校验失败的信息:

```JavaScript
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
```



## 8 编辑员工

### 8.1 信息回显

使用 Ajax 发送请求（"/emp/{id}", GET），获取指定  id 的员工信息。

```javascript
    //发送 Ajax 请求获取员工信息显示回显在模态框中
    function getEmp(ele,id) {
        // 清空之前添加的下拉框信息
        //$(ele).empty();
        $.ajax({
            url: "${App_Path}/emp/"+id, // 请求的 url
            type: "GET",     // 请求的类型
            success: function (result) { // result 为服务器响应请求发送给客户端的数据
                // 将数据显示在模态框中
                var empData = result.extendInfo.emp;
                $("#editEmpName").val(empData.empName);
                $("#editEmpEmail").text(empData.email);
                $("#editEmployeeModal input[name='gender']").val([empData.gender]);
                $("#editEmployeeModal select").val([empData.dId]);
            }
        });
    }
```



### 8.2 修改信息

修改后模态框中的提交按钮事件，通过发送一个 Ajax 请求（/emp/{empId}, PUT）来完成信息的修改。

表单中的数据会被附加在 url 中发送到后台，但是 rest  风格的 url 在这里会出现一些问题。

首先，更新数据使用的是 PUT 方法，有两种形式的请求：

**第一种**：在 data 中附加上 "&_method='PUT'" 用来指定 PUT 请求，该形式不会出现问题。

```javascript
var info = $("#editEmployeeModal form").serialize() + "&_method='PUT'";
$.ajax({
	url: "${App_Path}/emp/"+$(this).attr("empId"), // 请求的 url
    type: "POST",     // 请求的类型
    data:info,
    success: function (result) { // result 为服务器响应请求发送给客户端的数据
    	alert(result.info);
    }
})
```



**第二种**：直接发送类型为 PUT 的 Ajax 请求，也就是 type 为 PUT

```javascript
var info = $("#editEmployeeModal form").serialize();
$.ajax({
	url: "${App_Path}/emp/"+$(this).attr("empId"), // 请求的 url
    type: "PUT",     // 请求的类型
    data:info,
    success: function (result) { // result 为服务器响应请求发送给客户端的数据
    	alert(result.info);
    }
})
```

该方法会导致严重的后果：封装在请求体中的 用户的信息无法映射到对应的 员工 POJO 上，原因就是，Tomcat 服务器处理 Ajax 请求时，发现请求类型为 PUT ，则不会封装请求体中的数据，它只有在请求类型为 POST 时才会封装请求体中的数据到 POJO 对象中。

### 8.3 解决 Ajax 发送 PUT 的问题

这个问题的解决方法可以使用 SpringMVC 中的一个过滤器 **HttpPutFormContentFilter** 来解决，只需要在 web.xml 中配置上该过滤器就可以了：

web.xml

```xml
    <!-- 配置该过滤器，可以直接使用 Ajax 发送 PUT 请求 -->
    <filter>
        <filter-name>HttpPutFormContentFilter</filter-name>
        <filter-class>org.springframework.web.filter.HttpPutFormContentFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>HttpPutFormContentFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```

## 9 删除员工

删除员工，可以是删除单个的员工，也可以是批量勾选后进行删除。

![delete](image\ssm_crud_delete.png)

该功能实现主要分为前后台的处理，客户端发送统一的 Ajax 请求，服务器端对统一的请求进行分析处理，分别由控制器实现单个删除和批量删除。

### 9.1 实例：

- 前台：点击 delete 按钮时，发送 ajax 请求到后台，对于单个删除和批量删除，这个请求都是一样的（/emp/ids），不同在于 ids 的数据：

  - 单个删除：ids 为单一的 id 值，如："2"
  - 批量删除： ids 为多个 id 值的字符串，如："2, 3, 4, 5"

  ```javascript
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
  ```

  ​

- 后台：分为了控制器的处理方法和 service 层的处理方法：

  - 控制器处理：该方法分析前台发送的请求中 ids 的值，判断使用 **service 层**的单个删除方法还是批量删除方法

    ```java
     	// 删除员工
        // 包括单个员工的删除和批量的删除
        @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
        @ResponseBody
        public Msg deleteById(@PathVariable("ids") String ids){
            if(ids.contains(",")){ // 如果是多个 id 值，则批量删除
                List<Integer> list = new ArrayList<>();
                String[] str_ids = ids.split(", ");
                for(String id : str_ids){
                    list.add(Integer.parseInt(id));
                }
                employeeServicce.deleteEmpBatch(list);
            }else{ // 如果为单个 id 值，则进行单个删除处理
                int id = Integer.parseInt(ids);
                employeeServicce.deleteEmp(id);
            }
            return Msg.success();
        }
    ```

  - service 层方法：该层方法分为单个处理和批量处理

    ```java
    	// 单个删除   
        public void deleteEmp(Integer id) {
            employeeMapper.deleteByPrimaryKey(id);
        }
        // 批量删除
        public void deleteEmpBatch(List<Integer> ids) {
            EmployeeExample employeeExample = new EmployeeExample();
            EmployeeExample.Criteria criteria = 
                employeeExample.createCriteria();
            criteria.andEmpIdIn(ids);// 自定义删除条件, sql 语句如下：
            //delete from xxx where id in(x, x, ,x )
            employeeMapper.deleteByExample(employeeExample);
        }
    ```

    ​

## 10 项目总结

该项目使用 SSM 整合实现了员工管理模块最基本的功能：增删查改。

### 10.1 技术细节：

我遇见的问题及解决：

1.数据校验：

问题：只有前台校验时，用户可以通过浏览器的开发者工具，修改页面的代码，绕过前台数据校验，向服务器端发送非法数据。

解决：只有前台的数据校验是不完整并且不安全的，数据的校验应该贯穿整个项目，从客户端到服务器端到数据库，都应该使用数据校验，确保数据的安全性

2.Ajax 请求问题：

问题：使用 REST 风格的 URL 设计，就会使用到 PUT 和 DELETE 类型的请求，而在使用 Tomcat 服务器时，它不会将 PUT 请求体中的参数和 POJO 对象进行映射，导致控制器的更新数据处理方法传入一个各个字段皆为 null 的 POJO 对象，从而引发更改信息失败。

解决：SpringMVC 针对 Tomcat 服务器的这个问题，实现了一个 HttpPutFormContentFilter 过滤器，只需要在 web.xml 配置文件中配置该过滤器，并让它处理所有的请求，即可解决这个问题。

3.MyBatis Generator：

问题：生成的 Mapper 文件都是基于单表操作的

解决：改写逆向工程生成的 Mapper 文件，自定义 basic_column，加入需要联表查询的列，并仿写其中一些方法，实现联表操作。

4.前台设计：

问题：对于 BootStrap 框架的使用，特别陌生，需要在官方文档的帮助下一步步实现的，而且对于 jQuery 的使用，总是需要花费大量时间去进行一些很简单的数据获取，文档处理

解决：这一问题只能是靠多用、多查、多看，加上时间的积累了吧（笑）。

5.三大框架的配置文件以及整合

问题：这是我的第一个 SSM 整合项目，在框架的两两整合间，多个地方显得特别迷惑，项目在实现过程中，出现了需要编辑配置文件才能解决的问题时，经常需要愣一会才想到需要修改哪一个配置文件。

6.Spring 的单元测试

问题：该项目没能使用上 Spring 的单元测试工具进行开发中的测试，是一大缺憾，原因是我没有掌握该工具的使用，为了节省项目的时间成本以及减少学习投入，放弃了该技术的使用。

### 10.2 项目技术结构图

![tech](image\ssm_crud_tech.png)

End

Date[2018-05-27 22:43]

Jachin