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
            break;
        case "crafts":
            $('.nav-crafts').addClass('nav-active');
            break;
        case "departments":
            $('.nav-departments').addClass('nav-active');
            break;
        case "downtime_codes":
            $('.nav-downtime').addClass('nav-active');
            $('.nav-downtime_codes').addClass('nav-active');
            break;
        case "downtime_types":
            $('.nav-downtime').addClass('nav-active');
            $('.nav-downtime_types').addClass('nav-active');
            break;
        case "downtime_records":
            $('.nav-downtime').addClass('nav-active');
            if (pathname[2] == "display") {
                $('.nav-display_downtime_records').addClass('nav-active');
            } else {
                $('.nav-downtime_records').addClass('nav-active');
            }
            break;
        case "work_times":
            $('.nav-machine').addClass('nav-active');
            $('.nav-work_times').addClass('nav-active');
            break;
        case "machine_types":
            $('.nav-machine').addClass('nav-active');
            $('.nav-machine_types').addClass('nav-active');
            break;
        case "machines":
            $('.nav-machine').addClass('nav-active');
            $('.nav-machines').addClass('nav-active');
            break;
        case "work_shifts":
            $('.nav-settings').addClass('nav-active');
            $('.nav-work_shifts').addClass('nav-active');
            break;
        case "holidays":
            $('.nav-settings').addClass('nav-active');
            $('.nav-holidays').addClass('nav-active');
            break;
        default:
            $('.nav-home').addClass('nav-active');
            break;
    }
};