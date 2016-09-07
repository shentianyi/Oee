var layout = {};

layout.init = function(){
	$('.main').css({height: $(window).height()-20 +'px'});

	// Nav click
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
		// case "maintenances":
		// 	all_nav[2].className += ' nav-active';
		// 	break;
		// case "inventories":
		// 	all_nav[3].className += ' nav-active';
		// 	break;
		// case "scraps":
		// 	all_nav[4].className += ' nav-active';
		// 	break;
        default:
            all_nav[0].className += ' nav-active';
            break;
	}
}