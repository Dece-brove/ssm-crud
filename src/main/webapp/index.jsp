<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Brove
  Date: 2020/4/1
  Time: 9:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath %>">
    <meta charset="UTF-8">
    <title>Title</title>
    <%--
        http://localhost:3306/crud
    --%>
    <script src="static/js/jquery.js"></script>
    <link href="static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <script src="static/js/employee/index.js"></script>
</head>
<body>

<!-- 员工添加 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input"
                                   placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_add_input"
                                   placeholder="email@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-10">
                            <%--部门提交部门id--%>
                            <select class="form-control" name="dId" id="dept_add_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%--员工修改--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_update_input"
                                   placeholder="email@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked">男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-10">
                            <%--部门提交部门id--%>
                            <select class="form-control" name="dId" id="dept_update_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>


<%--    搭建显示页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-success" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_del_all_btn">删除</button>
        </div>
    </div>
    <%--表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-striped table-hover" id="emps">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all">
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>operation</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6" id="page_info_area">

        </div>
        <%--    分页条--%>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
<%--<script type="text/javascript">--%>

<%--    let totalRecord;--%>
<%--    let currentPage;--%>

<%--    $(function () {--%>
<%--        to_page(1);--%>

<%--    });--%>

<%--    function to_page(pn) {--%>
<%--        $.ajax({--%>
<%--            url: "emps",--%>
<%--            data: {--%>
<%--                "pn": pn--%>
<%--            },--%>
<%--            type: "get",--%>
<%--            success: function (result) {--%>
<%--                // console.info(result);--%>
<%--                // 0. 将全选框置空--%>
<%--                $("#check_all").prop('checked', false);--%>
<%--                // 1. 解析并显示员工数据--%>
<%--                build_emps_table(result);--%>
<%--                // 2. 解析并显示分页信息--%>
<%--                build_page_info(result);--%>
<%--                // 3. 解析并显示分页条--%>
<%--                build_page_nav(result);--%>
<%--            }--%>
<%--        })--%>
<%--    }--%>

<%--    function build_emps_table(result) {--%>
<%--        let emps = result.extend.pageInfo.list;--%>
<%--        $("#emps tbody").empty();--%>
<%--        $.each(emps, function (index, item) {--%>
<%--            let checkBoxTd = $("<td></td>").append($("<input type='checkbox'>").addClass("check_item"));--%>
<%--            let empIdTd = $("<td></td>").append(item.empId).addClass("form-emp-id");--%>
<%--            let empNameTd = $("<td></td>").append(item.empName).addClass("form-emp-name");--%>
<%--            let genderTd = $("<td></td>").append(item.gender === 'M' ? "男" : "女");--%>
<%--            let emailTd = $("<td></td>").append(item.email);--%>
<%--            let deptNameTd = $("<td></td>").append(item.department.deptName);--%>
<%--            let editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").attr("edit-id", item.empId)--%>
<%--                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))--%>
<%--                .append("编辑");--%>
<%--            let delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").attr("del-id", item.empId)--%>
<%--                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))--%>
<%--                .append("删除");--%>
<%--            let btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);--%>
<%--            let tr = $("<tr></tr>")--%>
<%--                .append(checkBoxTd)--%>
<%--                .append(empIdTd)--%>
<%--                .append(empNameTd)--%>
<%--                .append(genderTd)--%>
<%--                .append(emailTd)--%>
<%--                .append(deptNameTd)--%>
<%--                .append(btnTd)--%>
<%--                .appendTo("#emps tbody");--%>
<%--        })--%>
<%--    }--%>

<%--    function build_page_info(result) {--%>
<%--        let pageInfo = result.extend.pageInfo;--%>
<%--        $("#page_info_area").empty().append("当前页：" + pageInfo.pageNum + "， 总页数：" + pageInfo.pages + "， 总条目数：" + pageInfo.total)--%>
<%--        totalRecord = pageInfo.pages;--%>
<%--        currentPage = pageInfo.pageNum;--%>
<%--    }--%>

<%--    function build_page_nav(result) {--%>
<%--        var pageInfo = result.extend.pageInfo;--%>
<%--        let ul = $("<ul></ul>").addClass("pagination");--%>
<%--        let firstPageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("首页"));--%>
<%--        let prePageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("&laquo;"));--%>
<%--        let nextPageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("&raquo;"));--%>
<%--        let lastPageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("尾页"));--%>
<%--        if (pageInfo.hasPreviousPage == false) {--%>
<%--            firstPageLi.addClass("disabled");--%>
<%--            prePageLi.addClass("disabled");--%>
<%--        } else {--%>
<%--            firstPageLi.click(function () {--%>
<%--                to_page(1);--%>
<%--            });--%>
<%--            prePageLi.click(function () {--%>
<%--                to_page(pageInfo.prePage);--%>
<%--            })--%>
<%--        }--%>
<%--        if (pageInfo.hasNextPage == false) {--%>
<%--            nextPageLi.addClass("disabled");--%>
<%--            lastPageLi.addClass("disabled");--%>
<%--        } else {--%>
<%--            nextPageLi.click(function () {--%>
<%--                to_page(pageInfo.nextPage);--%>
<%--            })--%>
<%--            lastPageLi.click(function () {--%>
<%--                to_page(pageInfo.pages);--%>
<%--            })--%>

<%--        }--%>

<%--        ul.append(firstPageLi).append(prePageLi);--%>
<%--        $.each(pageInfo.navigatepageNums, function (index, item) {--%>
<%--            let numLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append(item));--%>
<%--            if (pageInfo.pageNum == item) {--%>
<%--                numLi.addClass("active");--%>
<%--            }--%>
<%--            numLi.click(function () {--%>
<%--                to_page(item);--%>
<%--            });--%>
<%--            ul.append(numLi);--%>
<%--        });--%>
<%--        ul.append(nextPageLi).append(lastPageLi);--%>
<%--        let navEle = $("<nav></nav>").append(ul);--%>
<%--        $("#page_nav_area").empty().append(navEle);--%>
<%--    }--%>


<%--    // 清空表单样式和内容--%>
<%--    function reset_form(ele) {--%>
<%--        $(ele)[0].reset();--%>
<%--        // 清空表单样式--%>
<%--        $(ele).find("*").removeClass("has-error has-success");--%>
<%--        $(ele).find(".help-block").text("");--%>
<%--    }--%>


<%--    // 点击新增，弹出模态框--%>
<%--    $("#emp_add_modal_btn").click(function () {--%>
<%--        // 清除表单数据(数据、样式)--%>
<%--        reset_form("#empAddModal form");--%>
<%--        // 发送ajax，查出部门信息，显示在下拉列表--%>
<%--        getDepts("#dept_add_select");--%>
<%--        // 弹出--%>
<%--        $("#empAddModal").modal({--%>
<%--            backdrop: "static"--%>
<%--        })--%>
<%--    })--%>

<%--    /**--%>
<%--     * 获得部门信息--%>
<%--     * @param ele  将其显示在ele中--%>
<%--     */--%>
<%--    function getDepts(ele) {--%>
<%--        $.ajax({--%>
<%--            url: "depts",--%>
<%--            type: "GET",--%>
<%--            success: function (result) {--%>
<%--                // console.info(result);--%>
<%--                let depts = result.extend.depts;--%>
<%--                $(ele).empty();--%>
<%--                $.each(depts, function (index, item) {--%>
<%--                    let optionItem = $("<option></option>").append(this.deptName).attr("value", this.deptId);--%>
<%--                    $(ele).append(optionItem);--%>
<%--                })--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    // 添加员工，验证邮箱和姓名是否合法--%>
<%--    function validate_add_form() {--%>
<%--        let empName = $("#empName_add_input").val();--%>
<%--        let regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;--%>
<%--        if (!regName.test(empName)) {--%>
<%--            // alert("用户名不规范！");--%>
<%--            show_validate_msg("#empName_add_input", "error", "用户名不规范！");--%>
<%--            return false;--%>
<%--        } else {--%>
<%--            show_validate_msg("#empName_add_input", "success", "");--%>
<%--        }--%>
<%--        let email = $("#email_add_input").val();--%>
<%--        let regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;--%>
<%--        if (!regEmail.test(email)) {--%>
<%--            // alert("邮箱名不规范！");--%>
<%--            show_validate_msg("#email_add_input", "error", "邮箱名不规范！");--%>
<%--            return false;--%>
<%--        } else {--%>
<%--            show_validate_msg("#email_add_input", "success", "");--%>
<%--        }--%>
<%--        return true;--%>
<%--    }--%>

<%--    // 显示校验结果的提示信息--%>
<%--    function show_validate_msg(ele, status, msg) {--%>
<%--        $(ele).parent().removeClass("has-success has-error");--%>
<%--        $(ele).next("span").text("");--%>
<%--        if ("success" == status) {--%>
<%--            $(ele).parent().addClass("has-success");--%>
<%--            $(ele).next("span").text(msg);--%>
<%--        } else if ("error" == status) {--%>
<%--            $(ele).parent().addClass("has-error");--%>
<%--            $(ele).next("span").text(msg);--%>
<%--        }--%>
<%--    }--%>

<%--    // 姓名验证是否重复--%>
<%--    $("#empName_add_input").change(function () {--%>
<%--        // 发送ajax校验用户名是否可用--%>
<%--        let empName = $(this).val();--%>
<%--        $.ajax({--%>
<%--            url: "checkUser",--%>
<%--            data: {"empName": empName},--%>
<%--            type: "POST",--%>
<%--            success: function (result) {--%>
<%--                if (result.code == 100) {--%>
<%--                    show_validate_msg("#empName_add_input", "success", "用户名可用");--%>
<%--                    $("#emp_save_btn").attr("ajax-validate", "success");--%>
<%--                } else {--%>
<%--                    show_validate_msg("#empName_add_input", "error", result.extend.validate_msg);--%>
<%--                    $("#emp_save_btn").attr("ajax-validate", "error");--%>
<%--                }--%>
<%--            }--%>
<%--        })--%>
<%--    })--%>

<%--    // 点击保存--%>
<%--    $("#emp_save_btn").click(function () {--%>
<%--        // 1. 将模态框中的表单数据提交给服务器--%>
<%--        // 1.5. 验证数据--%>
<%--        // if (!validate_add_form()) {--%>
<%--        //     return;--%>
<%--        // }--%>
<%--        // 1.6 判断是否校验通过--%>
<%--        if ($(this).attr("ajax-validate") === "error") {--%>
<%--            return;--%>
<%--        }--%>
<%--        // 2.发送ajax保存员工--%>
<%--        $.ajax({--%>
<%--            url: "emp",--%>
<%--            type: "POST",--%>
<%--            data: $("#empAddModal form").serialize(),--%>
<%--            success: function (result) {--%>
<%--                // alert(result.msg);--%>
<%--                // 判断--%>
<%--                if (result.code == 100) {--%>
<%--                    // 1. 关闭模块框--%>
<%--                    $("#empAddModal").modal("hide");--%>
<%--                    // 2. 来到最后一页--%>
<%--                    // 发送ajax，显示最后一页--%>
<%--                    // 解决：传入一个足够大的页码，会自动转换成最后一页；--%>
<%--                    to_page(totalRecord);--%>
<%--                } else {--%>
<%--                    // 显示失败信息--%>
<%--                    // console.log(result);--%>
<%--                    if (undefined != result.extend.errorFields.email) {--%>
<%--                        // 显示邮箱错误信息--%>
<%--                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);--%>
<%--                    }--%>
<%--                    if (undefined != result.extend.errorFields.empName) {--%>
<%--                        // 显示员工错误信息--%>
<%--                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);--%>
<%--                    }--%>
<%--                }--%>

<%--            }--%>
<%--        });--%>
<%--    })--%>


<%--    // 更新按钮--%>
<%--    $(document).on('click', ".edit_btn", function () {--%>
<%--        // 0. 查询部门--%>
<%--        getDepts("#dept_update_select");--%>
<%--        // 1. 查询员工信息--%>
<%--        getEmp($(this).attr("edit-id"));--%>
<%--        // 2.显示，把员工id传递给模态框更新按钮--%>
<%--        $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));--%>
<%--        $("#empUpdateModal").modal({--%>
<%--            backdrop: "static"--%>
<%--        });--%>
<%--    });--%>

<%--    // 通过id寻找员工--%>
<%--    function getEmp(id) {--%>
<%--        $.ajax({--%>
<%--            url: "emp/" + id,--%>
<%--            type: "GET",--%>
<%--            success: function (result) {--%>
<%--                // console.info(result);--%>
<%--                let empData = result.extend.emp;--%>
<%--                $("#empName_update_static").text(empData.empName);--%>
<%--                $("#email_update_input").val(empData.email);--%>
<%--                $("#empUpdateModal input[name='gender']").val([empData.gender]);--%>
<%--                $("#empUpdateModal select").val([empData.dId]);--%>
<%--            }--%>
<%--        })--%>
<%--    }--%>

<%--    // 点击更新员工信息--%>
<%--    $("#emp_update_btn").click(function () {--%>
<%--        // 验证邮箱信息是否合法--%>
<%--        let email = $("#email_update_input").val();--%>
<%--        let regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;--%>
<%--        if (!regEmail.test(email)) {--%>
<%--            // alert("邮箱名不规范！");--%>
<%--            show_validate_msg("#email_add_input", "error", "邮箱格式不规范！");--%>
<%--            return false;--%>
<%--        } else {--%>
<%--            show_validate_msg("#email_add_input", "success", "");--%>
<%--        }--%>
<%--        // 发送ajax，保存更新数据--%>
<%--        $.ajax({--%>
<%--            url: "emp/" + $(this).attr("edit-id"),--%>
<%--            type: "PUT",--%>
<%--            data: $("#empUpdateModal form").serialize() + "&_method=PUT",--%>
<%--            success: function (result) {--%>
<%--                alert(result.msg);--%>
<%--                // 1.关闭对话框--%>
<%--                $("#empUpdateModal").modal("hide");--%>
<%--                // 2.返回本页面--%>
<%--                to_page(currentPage);--%>
<%--            }--%>
<%--        })--%>
<%--    });--%>

<%--    // 删除按钮--%>
<%--    $(document).on('click', ".delete_btn", function () {--%>
<%--        // 1. 弹出是否删除对话框--%>
<%--        let empName = $(this).parents("tr").find("td.form-emp-name").text();--%>
<%--        let empId = $(this).attr("del-id");--%>
<%--        if (confirm("确认删除【" + empName + "】吗？")) {--%>
<%--            // 确认，发送ajax--%>
<%--            $.ajax({--%>
<%--                url: "emp/" + empId,--%>
<%--                type: "DELETE",--%>
<%--                success: function (result) {--%>
<%--                    alert(result.msg);--%>
<%--                    to_page(currentPage);--%>
<%--                }--%>
<%--            })--%>
<%--        }--%>
<%--    });--%>

<%--    // 全选/全不选--%>
<%--    $("#check_all").click(function () {--%>
<%--        // attr获取checked是undefined--%>
<%--        // dom原生的属性用prop--%>
<%--        $(".check_item").prop("checked", $(this).prop("checked"));--%>
<%--    });--%>

<%--    $(document).on('click', '.check_item', function () {--%>
<%--        let flag = $(".check_item:checked").length === $(".check_item").length;--%>
<%--        $("#check_all").prop("checked", flag);--%>
<%--    });--%>

<%--    // 点击全部删除--%>
<%--    $("#emp_del_all_btn").click(function () {--%>
<%--        let empNames = "";--%>
<%--        let empIds = "";--%>
<%--        $.each($(".check_item:checked"), function (index, item) {--%>
<%--            let empName = $(this).parents("tr").find("td.form-emp-name").text();--%>
<%--            let empId = $(this).parents("tr").find("td.form-emp-id").text();--%>
<%--            empNames += empName + ",";--%>
<%--            empIds += empId + "-";--%>
<%--        });--%>
<%--        // 去除多余的逗号--%>
<%--        empNames = empNames.substring(0, empNames.length - 1);--%>
<%--        if (confirm("确认删除【" + empNames + "】吗")) {--%>
<%--            $.ajax({--%>
<%--                url: "emp/" + empIds,--%>
<%--                type: "DELETE",--%>
<%--                success: function (result) {--%>
<%--                    alert(result.msg);--%>
<%--                    // 回到当前页--%>
<%--                    to_page(currentPage);--%>
<%--                }--%>
<%--            })--%>
<%--        }--%>
<%--    })--%>
<%--</script>--%>
</body>
</html>
