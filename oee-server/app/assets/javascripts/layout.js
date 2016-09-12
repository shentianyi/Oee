var layout = {};

layout.init = function(){
	var pathname = window.location.pathname.split("/")[1];
	var all_nav = $('.main-nav').find('.nav-bar');

	$('.nav-bar').removeClass("nav-active");

	switch(pathname){
		case "":
			all_nav[0].className += ' nav-active';
			break;
		case "users":
			all_nav[1].className += ' nav-active';
			break;
		case "crafts":
			all_nav[2].className += ' nav-active';
			break;
		case "departments":
			all_nav[3].className += ' nav-active';
			break;
		case "downtime_codes":
			all_nav[4].className += ' nav-active';
			break;
		case "downtime_types":
			all_nav[4].className += ' nav-active';
			break;
		case "downtime_records":
			all_nav[4].className += ' nav-active';
			break;
        default:
            all_nav[0].className += ' nav-active';
            break;
	}
}