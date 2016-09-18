var layout = {};

layout.init = function () {
    var pathname = window.location.pathname.split("/");
    $('.first-nav li').removeClass("nav-active");

    switch (pathname[1]) {
        case "":
            $('.nav-home').addClass('nav-active');
            break;
        case "users":
            $('.nav-users').addClass('nav-active');
            PageAction('#users', '新增用户', '编辑用户', '创建', '更新');
            break;
        case "crafts":
            $('.nav-basic').addClass('nav-active');
            $('.nav-crafts').addClass('nav-active');
            break;
        case "departments":
            $('.nav-basic').addClass('nav-active');
            $('.nav-departments').addClass('nav-active');
            break;
        case "downtime_codes":
            $('.nav-basic').addClass('nav-active');
            $('.nav-downtime_codes').addClass('nav-active');
            break;
        case "downtime_types":
            $('.nav-basic').addClass('nav-active');
            $('.nav-downtime_types').addClass('nav-active');
            break;
        case "downtime_records":
            $('.nav-oee').addClass('nav-active');
            $('.nav-downtime').addClass('nav-active');
            if (pathname[2] == "display") {
                $('.nav-display_downtime_records').addClass('nav-active');
            } else {
                $('.nav-downtime_records').addClass('nav-active');
            }
            break;
        case "work_times":
            $('.nav-basic').addClass('nav-active');
            $('.nav-work_times').addClass('nav-active');
            break;
        case "machine_types":
            $('.nav-basic').addClass('nav-active');
            $('.nav-machine_types').addClass('nav-active');
            break;
        case "machines":
            $('.nav-basic').addClass('nav-active');
            $('.nav-machines').addClass('nav-active');
            break;
        case "work_shifts":
            $('.nav-basic').addClass('nav-active');
            $('.nav-work_shifts').addClass('nav-active');
            break;
        case "holidays":
            $('.nav-basic').addClass('nav-active');
            $('.nav-holidays').addClass('nav-active');
            break;
        default:
            $('.nav-home').addClass('nav-active');
            break;
    }

    function PageAction(id, newAction, editAction, newBtn, editBtn) {
        var vueName = new Vue({
            el: id,
            data: {
                action: newAction,
                actionBtn: newBtn
            }
        });

        if (pathname[pathname.length - 1] == "edit") {
            vueName.action = editAction;
            vueName.actionBtn = editBtn;
        }

        // else if (pathname[pathname.length - 1] == "delete") {
        //     vueName.action = deleteAction;
        //     vueName.actionBtn = deleteBtn;
        // }
    }
};

layout.notice = function (cls, Notice) {
    if (Notice) {
        layout.popMsg(cls, Notice);
    }
};

layout.popMsg = function (cls, content) {
    var Html = "<div class='" + cls + "'><div class='popMsg-body'> " + content + "</div></div>";

    $(Html).appendTo($('body'));

    window.setTimeout(function () {
        $("." + cls).slideUp();
    }, 3000);
};