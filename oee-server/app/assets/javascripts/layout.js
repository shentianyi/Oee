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
            PageAction('#users', '新增用户', '编辑用户', '上传用户', '创建', '更新', '上传');
            break;

        case "crafts":
            $('.nav-basic').addClass('nav-active');
            $('.nav-crafts').addClass('nav-active');
            PageAction('#crafts', '新增工艺', '编辑工艺', '上传工艺信息', '创建', '更新', '上传');
            break;

        case "departments":
            $('.nav-basic').addClass('nav-active');
            $('.nav-departments').addClass('nav-active');
            PageAction('#departemnts', '新增部门', '编辑部门', '上传部门信息', '创建', '更新', '上传');
            break;

        case "downtime_types":
            $('.nav-basic').addClass('nav-active');
            $('.nav-downtime_types').addClass('nav-active');
            PageAction('#downtime_types', '新增停机类型', '编辑停机类型', '上传停机类型信息', '创建', '更新', '上传');
            break;

        case "downtime_codes":
            $('.nav-basic').addClass('nav-active');
            $('.nav-downtime_codes').addClass('nav-active');
            PageAction('#downtime_codes', '新增停机代码', '编辑停机代码', '上传停机代码信息', '创建', '更新', '上传');
            break;

        case "work_times":
            $('.nav-basic').addClass('nav-active');
            $('.nav-work_times').addClass('nav-active');
            PageAction('#work_times', '新增标准工时', '编辑标准工时', '上传标准工时信息', '创建', '更新', '上传');
            break;

        case "machine_types":
            $('.nav-basic').addClass('nav-active');
            $('.nav-machine_types').addClass('nav-active');
            PageAction('#machine_types', '新增机器类型', '编辑机器类型', '上传机器类型信息', '创建', '更新', '上传');
            break;

        case "machines":
            $('.nav-basic').addClass('nav-active');
            $('.nav-machines').addClass('nav-active');
            PageAction('#machines', '新增机器', '编辑机器', '上传机器信息', '创建', '更新', '上传');
            break;

        case "work_shifts":
            $('.nav-basic').addClass('nav-active');
            $('.nav-work_shifts').addClass('nav-active');
            PageAction('#work_shifts', '新增班次设置', '编辑班次设置', '上传班次设置信息', '创建', '更新', '上传');
            break;

        case "holidays":
            $('.nav-basic').addClass('nav-active');
            $('.nav-holidays').addClass('nav-active');
            PageAction('#holidays', '新增节假日', '编辑节假日', '上传节假日信息', '创建', '更新', '上传');
            break;

        //OEE 管理
        case "downtime_records":
            $('.nav-oee').addClass('nav-active');
            $('.nav-downtime').addClass('nav-active');
            if (pathname[2] == "display") {
                $('.nav-display_downtime_records').addClass('nav-active');
            } else {
                $('.nav-downtime_records').addClass('nav-active');
                PageAction('#downtime_records', '新增停机记录', '编辑停机记录', '上传停机记录信息', '创建', '更新', '上传');
            }
            break;

        default:
            $('.nav-home').addClass('nav-active');
            break;
    }

    function PageAction(id, newAction, editAction, importAction, newBtn, editBtn, importBtn) {
        if ($(id).length == 0) return;

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
        } else if (pathname[pathname.length - 1] == "import") {
            vueName.action = importAction;
            vueName.actionBtn = importBtn;
        }
    }

    //所有的界面都需要
    //TODO: 如何判断是 警告， 提示， 正常返回 ?
    layout.notice('popMsg-success', $('#notice').html());
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

//格式化日期
Date.prototype.marcoFormat = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1,                 //月份
        "d+": this.getDate(),                    //日
        "h+": this.getHours(),                   //小时
        "m+": this.getMinutes(),                 //分
        "s+": this.getSeconds(),                 //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds()             //毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};

//从今天算的 之前的 day天
layout.futureDate = function (day) {
    var now = new Date();
    var FutureDate = new Date(now.getTime() - day * 24 * 60 * 60 * 1000).marcoFormat("yyyy-MM-dd");
    return FutureDate;
};

layout.date_picker = function (cls) {
    $(cls).datetimepicker({
        lang: 'ch',
        format: 'Y-m-d',
        timepicker: false
    });
};