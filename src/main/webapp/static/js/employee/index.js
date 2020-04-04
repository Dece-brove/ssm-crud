let totalRecord;
let currentPage;

$(function () {
    to_page(1);

// �������������ģ̬��
    $("#emp_add_modal_btn").click(function () {
        // ���������(���ݡ���ʽ)
        reset_form("#empAddModal form");
        // ����ajax�����������Ϣ����ʾ�������б�
        getDepts("#dept_add_select");
        // ����
        $("#empAddModal").modal({
            backdrop: "static"
        })
    })


// ������֤�Ƿ��ظ�
    $("#empName_add_input").change(function () {
        // ����ajaxУ���û����Ƿ����
        let empName = $(this).val();
        $.ajax({
            url: "checkUser",
            data: {"empName": empName},
            type: "POST",
            success: function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input", "success", "�û�������");
                    $("#emp_save_btn").attr("ajax-validate", "success");
                } else {
                    show_validate_msg("#empName_add_input", "error", result.extend.validate_msg);
                    $("#emp_save_btn").attr("ajax-validate", "error");
                }
            }
        })
    })

// �������
    $("#emp_save_btn").click(function () {
        // 1. ��ģ̬���еı������ύ��������
        // 1.5. ��֤����
        // if (!validate_add_form()) {
        //     return;
        // }
        // 1.6 �ж��Ƿ�У��ͨ��
        if ($(this).attr("ajax-validate") === "error") {
            return;
        }
        // 2.����ajax����Ա��
        $.ajax({
            url: "emp",
            type: "POST",
            data: $("#empAddModal form").serialize(),
            success: function (result) {
                // alert(result.msg);
                // �ж�
                if (result.code == 100) {
                    // 1. �ر�ģ���
                    $("#empAddModal").modal("hide");
                    // 2. �������һҳ
                    // ����ajax����ʾ���һҳ
                    // ���������һ���㹻���ҳ�룬���Զ�ת�������һҳ��
                    to_page(totalRecord);
                } else {
                    // ��ʾʧ����Ϣ
                    // console.log(result);
                    if (undefined != result.extend.errorFields.email) {
                        // ��ʾ���������Ϣ
                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                    }
                    if (undefined != result.extend.errorFields.empName) {
                        // ��ʾԱ��������Ϣ
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                }

            }
        });
    })

// ���°�ť
    $(document).on('click', ".edit_btn", function () {
        // 0. ��ѯ����
        getDepts("#dept_update_select");
        // 1. ��ѯԱ����Ϣ
        getEmp($(this).attr("edit-id"));
        // 2.��ʾ����Ա��id���ݸ�ģ̬����°�ť
        $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
        $("#empUpdateModal").modal({
            backdrop: "static"
        });
    });


// �������Ա����Ϣ
    $("#emp_update_btn").click(function () {
        // ��֤������Ϣ�Ƿ�Ϸ�
        let email = $("#email_update_input").val();
        let regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
        if (!regEmail.test(email)) {
            // alert("���������淶��");
            show_validate_msg("#email_add_input", "error", "�����ʽ���淶��");
            return false;
        } else {
            show_validate_msg("#email_add_input", "success", "");
        }
        // ����ajax�������������
        $.ajax({
            url: "emp/" + $(this).attr("edit-id"),
            type: "PUT",
            data: $("#empUpdateModal form").serialize() + "&_method=PUT",
            success: function (result) {
                alert(result.msg);
                // 1.�رնԻ���
                $("#empUpdateModal").modal("hide");
                // 2.���ر�ҳ��
                to_page(currentPage);
            }
        })
    });

// ɾ����ť
    $(document).on('click', ".delete_btn", function () {
        // 1. �����Ƿ�ɾ���Ի���
        let empName = $(this).parents("tr").find("td.form-emp-name").text();
        let empId = $(this).attr("del-id");
        if (confirm("ȷ��ɾ����" + empName + "����")) {
            // ȷ�ϣ�����ajax
            $.ajax({
                url: "emp/" + empId,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            })
        }
    });

// ȫѡ/ȫ��ѡ
    $("#check_all").click(function () {
        // attr��ȡchecked��undefined
        // domԭ����������prop
        $(".check_item").prop("checked", $(this).prop("checked"));
    });

    $(document).on('click', '.check_item', function () {
        let flag = $(".check_item:checked").length === $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

// ���ȫ��ɾ��
    $("#emp_del_all_btn").click(function () {
        let empNames = "";
        let empIds = "";
        $.each($(".check_item:checked"), function (index, item) {
            let empName = $(this).parents("tr").find("td.form-emp-name").text();
            let empId = $(this).parents("tr").find("td.form-emp-id").text();
            empNames += empName + ",";
            empIds += empId + "-";
        });
        // ȥ������Ķ���
        empNames = empNames.substring(0, empNames.length - 1);
        if (confirm("ȷ��ɾ����" + empNames + "����")) {
            $.ajax({
                url: "emp/" + empIds,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    // �ص���ǰҳ
                    to_page(currentPage);
                }
            })
        }
    })

});

function to_page(pn) {
    $.ajax({
        url: "emps",
        data: {
            "pn": pn
        },
        type: "get",
        success: function (result) {
            // console.info(result);
            // 0. ��ȫѡ���ÿ�
            $("#check_all").prop('checked', false);
            // 1. ��������ʾԱ������
            build_emps_table(result);
            // 2. ��������ʾ��ҳ��Ϣ
            build_page_info(result);
            // 3. ��������ʾ��ҳ��
            build_page_nav(result);
        }
    })
}

function build_emps_table(result) {
    let emps = result.extend.pageInfo.list;
    $("#emps tbody").empty();
    $.each(emps, function (index, item) {
        let checkBoxTd = $("<td></td>").append($("<input type='checkbox'>").addClass("check_item"));
        let empIdTd = $("<td></td>").append(item.empId).addClass("form-emp-id");
        let empNameTd = $("<td></td>").append(item.empName).addClass("form-emp-name");
        let genderTd = $("<td></td>").append(item.gender === 'M' ? "��" : "Ů");
        let emailTd = $("<td></td>").append(item.email);
        let deptNameTd = $("<td></td>").append(item.department.deptName);
        let editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").attr("edit-id", item.empId)
            .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
            .append("�༭");
        let delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").attr("del-id", item.empId)
            .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
            .append("ɾ��");
        let btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
        let tr = $("<tr></tr>")
            .append(checkBoxTd)
            .append(empIdTd)
            .append(empNameTd)
            .append(genderTd)
            .append(emailTd)
            .append(deptNameTd)
            .append(btnTd)
            .appendTo("#emps tbody");
    })
}

function build_page_info(result) {
    let pageInfo = result.extend.pageInfo;
    $("#page_info_area").empty().append("��ǰҳ��" + pageInfo.pageNum + "�� ��ҳ����" + pageInfo.pages + "�� ����Ŀ����" + pageInfo.total)
    totalRecord = pageInfo.pages;
    currentPage = pageInfo.pageNum;
}

function build_page_nav(result) {
    var pageInfo = result.extend.pageInfo;
    let ul = $("<ul></ul>").addClass("pagination");
    let firstPageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("��ҳ"));
    let prePageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("&laquo;"));
    let nextPageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("&raquo;"));
    let lastPageLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append("βҳ"));
    if (pageInfo.hasPreviousPage == false) {
        firstPageLi.addClass("disabled");
        prePageLi.addClass("disabled");
    } else {
        firstPageLi.click(function () {
            to_page(1);
        });
        prePageLi.click(function () {
            to_page(pageInfo.prePage);
        })
    }
    if (pageInfo.hasNextPage == false) {
        nextPageLi.addClass("disabled");
        lastPageLi.addClass("disabled");
    } else {
        nextPageLi.click(function () {
            to_page(pageInfo.nextPage);
        })
        lastPageLi.click(function () {
            to_page(pageInfo.pages);
        })

    }

    ul.append(firstPageLi).append(prePageLi);
    $.each(pageInfo.navigatepageNums, function (index, item) {
        let numLi = $("<li></li>").append($("<a></a>").attr("href", "javascript:void(0);").append(item));
        if (pageInfo.pageNum == item) {
            numLi.addClass("active");
        }
        numLi.click(function () {
            to_page(item);
        });
        ul.append(numLi);
    });
    ul.append(nextPageLi).append(lastPageLi);
    let navEle = $("<nav></nav>").append(ul);
    $("#page_nav_area").empty().append(navEle);
}

// ��ձ���ʽ������
function reset_form(ele) {
    $(ele)[0].reset();
    // ��ձ���ʽ
    $(ele).find("*").removeClass("has-error has-success");
    $(ele).find(".help-block").text("");
}

/**
 * ��ò�����Ϣ
 * @param ele  ������ʾ��ele��
 */
function getDepts(ele) {
    $.ajax({
        url: "depts",
        type: "GET",
        success: function (result) {
            // console.info(result);
            let depts = result.extend.depts;
            $(ele).empty();
            $.each(depts, function (index, item) {
                let optionItem = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                $(ele).append(optionItem);
            })
        }
    });
}

// ���Ա������֤����������Ƿ�Ϸ�
function validate_add_form() {
    let empName = $("#empName_add_input").val();
    let regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
    if (!regName.test(empName)) {
        // alert("�û������淶��");
        show_validate_msg("#empName_add_input", "error", "�û������淶��");
        return false;
    } else {
        show_validate_msg("#empName_add_input", "success", "");
    }
    let email = $("#email_add_input").val();
    let regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
    if (!regEmail.test(email)) {
        // alert("���������淶��");
        show_validate_msg("#email_add_input", "error", "���������淶��");
        return false;
    } else {
        show_validate_msg("#email_add_input", "success", "");
    }
    return true;
}

// ��ʾУ��������ʾ��Ϣ
function show_validate_msg(ele, status, msg) {
    $(ele).parent().removeClass("has-success has-error");
    $(ele).next("span").text("");
    if ("success" == status) {
        $(ele).parent().addClass("has-success");
        $(ele).next("span").text(msg);
    } else if ("error" == status) {
        $(ele).parent().addClass("has-error");
        $(ele).next("span").text(msg);
    }
}

// ͨ��idѰ��Ա��
function getEmp(id) {
    $.ajax({
        url: "emp/" + id,
        type: "GET",
        success: function (result) {
            // console.info(result);
            let empData = result.extend.emp;
            $("#empName_update_static").text(empData.empName);
            $("#email_update_input").val(empData.email);
            $("#empUpdateModal input[name='gender']").val([empData.gender]);
            $("#empUpdateModal select").val([empData.dId]);
        }
    })
}
