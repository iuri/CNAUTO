jQuery.noConflict();
jQuery(document).ready(function(){

	jQuery(".showNews").click(function () {
			
			var item = jQuery(this).attr('id');
			jQuery(".active").removeClass("active");
			jQuery(this).addClass("active");

			
			var active = jQuery(".gallery_max_priority");
			var teste = jQuery(".gallery_max_priority").attr('id'); 
			jQuery(active).addClass("hide");
			jQuery(active).removeClass("gallery_max_priority");
			
			var item_to_show = '#max_priority' + item;
			jQuery(item_to_show).addClass("gallery_max_priority");
			jQuery(item_to_show).removeClass("hide");
			jQuery(item_to_show).find('div').fadeIn(1000);;

	});



});

function go_to_url(application) {

   window.location = application.value;

}



 function showNews(){
//esconde todas
	var item = jQuery(this).attr('id');

	jQuery(".active").removeClass("active");
    document.getElementById(item).className = "active";


    var active = jQuery(".gallery_max_priority");
    var teste = jQuery(".gallery_max_priority").attr('id');
    jQuery(active).addClass("hide");
    jQuery(active).removeClass("gallery_max_priority");

    var item_to_show = '#max_priority' + item;
    jQuery(item_to_show).addClass("gallery_max_priority");
    jQuery(item_to_show).removeClass("hide");
    jQuery(item_to_show).find('div').fadeIn(1000);
}

function showNews2(item){
//esconde todas
//	var item = jQuery(this).attr('id');

	jQuery(".active").removeClass("active");
    document.getElementById(item).className = "active showNews";


    var active = jQuery(".gallery_max_priority");
    var teste = jQuery(".gallery_max_priority").attr('id');
    jQuery(active).addClass("hide");
    jQuery(active).removeClass("gallery_max_priority");

    var item_to_show = '#max_priority' + item;
    jQuery(item_to_show).addClass("gallery_max_priority");
    jQuery(item_to_show).removeClass("hide");
    jQuery(item_to_show).find('div').fadeIn(1000);
}



















function moveNews(){
	 var current = 0;
	 var news = document.getElementsByName("max_priority");

	 var i = 0;
	 for(i=0; i < news.length; i ++){
		 if(news[i].className == "gallery_max_priority"){
			 current = i;
		 }

	 }
		 if((current + 1) < news.length){
			 current +=2;
		 } else{
			 current = 1;
		 }

	 var newNews =  current;
	 showNews2(current);
}

function run() {
	 ContrRelogio = setTimeout ("run()", 7000);
	 moveNews();
}
