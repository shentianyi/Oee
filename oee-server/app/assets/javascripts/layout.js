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
            PageAction('#users', '新增用户', '编辑用户', '上传用户', '用户详情', '创建', '更新', '上传');
            break;

        case "crafts":
            $('.nav-basic').addClass('nav-active');
            $('.nav-crafts').addClass('nav-active');
            PageAction('#crafts', '新增工艺', '编辑工艺', '上传工艺信息', '工艺详情', '创建', '更新', '上传');
            break;

        case "departments":
            $('.nav-basic').addClass('nav-active');
            $('.nav-departments').addClass('nav-active');
            PageAction('#departemnts', '新增部门', '编辑部门', '上传部门信息', '部门详情', '创建', '更新', '上传');
            break;

        case "downtime_types":
            $('.nav-basic').addClass('nav-active');
            $('.nav-downtime_types').addClass('nav-active');
            PageAction('#downtime_types', '新增停机类型', '编辑停机类型', '上传停机类型信息', '停机类型详情', '创建', '更新', '上传');
            break;

        case "downtime_codes":
            $('.nav-basic').addClass('nav-active');
            $('.nav-downtime_codes').addClass('nav-active');
            PageAction('#downtime_codes', '新增停机代码', '编辑停机代码', '上传停机代码信息', '停机代码详情', '创建', '更新', '上传');
            break;

        case "work_times":
            $('.nav-basic').addClass('nav-active');
            $('.nav-work_times').addClass('nav-active');
            PageAction('#work_times', '新增标准工时', '编辑标准工时', '上传标准工时信息', '标准工时详情', '创建', '更新', '上传');
            break;

        case "machine_types":
            $('.nav-basic').addClass('nav-active');
            $('.nav-machine_types').addClass('nav-active');
            PageAction('#machine_types', '新增机器类型', '编辑机器类型', '上传机器类型信息', '机器类型详情', '创建', '更新', '上传');
            break;

        case "machines":
            $('.nav-basic').addClass('nav-active');
            $('.nav-machines').addClass('nav-active');
            PageAction('#machines', '新增机器', '编辑机器', '上传机器信息', '机器详情', '创建', '更新', '上传');
            break;

        case "work_shifts":
            $('.nav-basic').addClass('nav-active');
            $('.nav-work_shifts').addClass('nav-active');
            PageAction('#work_shifts', '新增班次设置', '编辑班次设置', '上传班次设置信息', '班次设置详情', '创建', '更新', '上传');
            break;

        case "holidays":
            $('.nav-basic').addClass('nav-active');
            $('.nav-holidays').addClass('nav-active');
            PageAction('#holidays', '新增节假日', '编辑节假日', '上传节假日信息', '节假日详情', '创建', '更新', '上传');
            break;

        //OEE 管理
        case "downtime_records":
            $('.nav-oee').addClass('nav-active');
            $('.nav-downtime').addClass('nav-active');
            if (pathname[2] == "display") {
                $('.nav-display_downtime_records').addClass('nav-active');
            } else {
                $('.nav-downtime_records').addClass('nav-active');
                PageAction('#downtime_records', '新增停机记录', '编辑停机记录', '上传停机记录信息', '停机记录详情', '创建', '更新', '上传');
            }
            break;

        case "fix_asset_tracks":
            $('.nav-fix-asset-tracks').addClass('nav-active');
            PageAction('#fix_asset_tracks', '新增固定资产追踪', '编辑固定资产追踪', '上传固定资产追踪信息', '固定资产跟踪详情', '创建', '更新', '上传');
            break;

        case "equipment_tracks":
            $('.nav-equipments').addClass('nav-active');
            $('.nav-equipment-tracks').addClass('nav-active');
            PageAction('#equipment_tracks', '新增设备跟踪记录', '编辑设备跟踪记录', '上传设备跟踪记录信息', '设备放行跟踪详情', '创建', '更新', '上传');
            break;

        case "equipment_releases":
            $('.nav-equipments').addClass('nav-active');
            $('.nav-equipment_releases').addClass('nav-active');
            PageAction('#equipment_releases', '新增设备放行记录', '编辑设备放行记录', '上传设备放行记录信息', '设备放行记录详情', '创建', '更新', '上传');
            break;

        case "equipment_depreciations":
            $('.nav-equipments').addClass('nav-active');
            $('.nav-equipment_depreciations').addClass('nav-active');
            PageAction('#equipment_depreciation', '新增设备折旧记录', '编辑设备折旧记录', '上传设备折旧记录信息', '设备折旧记录详情', '创建', '更新', '上传');
            break;

        case "equipment_statuses":
            $('.nav-equipments').addClass('nav-active');
            $('.nav-equipment_statuses').addClass('nav-active');
            PageAction('#equipment_status', '新增设备状态记录', '编辑设备状态记录', '上传设备状态记录信息', '设备设备状态详情', '创建', '更新', '上传');
            break;

        case "asset_balance_lists":
            $('.nav-asset_balance_lists').addClass('nav-active');
            $('.nav-inventory_lists').addClass('nav-active');
            PageAction('#asset_balance_lists', '新增月资产平衡', '编辑月资产平衡', '上传月资产平衡信息', '月资产平衡详情', '创建', '更新', '上传');
            break;

        case "bu_mangers":
            $('.nav-asset_balance_lists').addClass('nav-active');
            $('.nav-bu_mangers').addClass('nav-active');
            PageAction('#bu_mangers', '新增BU管理', '编辑BU管理', '上传BU管理信息', 'BU管理详情', '创建', '更新', '上传');
            break;

        case "inventory_lists":
            $('.nav-inventory').addClass('nav-active');
            $('.nav-inventory_lists').addClass('nav-active');
            PageAction('#inventory_lists', '新增资产盘点', '编辑资产盘点', '上传资产盘点信息', '资产盘点详情', '创建', '更新', '上传');
            break;

        case "areas":
            $('.nav-inventory').addClass('nav-active');
            $('.nav-areas').addClass('nav-active');
            PageAction('#areas', '新增盘点区域', '编辑盘点区域', '上传盘点区域信息', '盘点区域详情', '创建', '更新', '上传');
            break;

        case "user_area_items":
            $('.nav-inventory').addClass('nav-active');
            $('.nav-user_area_items').addClass('nav-active');
            PageAction('#user_area_items', '新增盘点任务', '编辑盘点任务', '上传盘点任务信息', '盘点任务详情', '创建', '更新', '上传');
            break;

        case "user_inventory_tasks":
            $('.nav-inventory').addClass('nav-active');
            $('.nav-user_inventory_tasks').addClass('nav-active');
            PageAction('#user_inventory_tasks', '新增盘点任务', '编辑盘点任务', '上传盘点任务信息', '盘点任务详情', '创建', '更新', '上传');
            break;

        case "capexes":
            $('.nav-capex').addClass('nav-active');
            $('.nav-capexe').addClass('nav-active');
            PageAction('#capexs', '新增CAPEX', '编辑CAPEX', '上传CAPEX信息', 'CAPEX 详情', '创建', '更新', '上传');
            break;

        case "budgets":
            $('.nav-capex').addClass('nav-active');
            $('.nav-budgets').addClass('nav-active');
            PageAction('#budgets', '新增BUDGET', '编辑BUDGET', '上传BUDGET信息', 'BUDGET 详情', '创建', '更新', '上传');
            break;

        case "budget_items":
            $('.nav-capex').addClass('nav-active');
            $('.nav-budget_items').addClass('nav-active');
            PageAction('#budget_items', '新增BUDGET ITEM', '编辑BUDGET ITEM', '上传BUDGET ITEM信息', 'BUDGET ITEM详情', '创建', '更新', '上传');
            break;

        case "pam_lists":
            $('.nav-capex').addClass('nav-active');
            $('.nav-pam_lists').addClass('nav-active');
            PageAction('#pam_lists', '新增PAM', '编辑PAM', '上传PAM信息', 'PAM 详情', '创建', '更新', '上传');
            break;

        case "pam_items":
            $('.nav-capex').addClass('nav-active');
            $('.nav-pam_items').addClass('nav-active');
            PageAction('#pam_items', '新增PAM ITEM', '编辑PAM ITEM', '上传PAM ITEM信息', 'PAM ITEM 详情', '创建', '更新', '上传');
            break;

        default:
            // $('.nav-home').addClass('nav-active');
            //可以跳转 404
            break;
    }

    function PageAction(id, newAction, editAction, importAction, showAction, newBtn, editBtn, importBtn) {
        if ($(id).length == 0) return;

        // vue.js
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
        } else {
            vueName.action = showAction;
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