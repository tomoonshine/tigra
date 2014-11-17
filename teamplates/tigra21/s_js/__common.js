var site = {};

site.utils = {};
site.utils.getObjectType = function(obj) {
	var toString = Object.prototype.toString,
		obj_type = false;
	switch (toString.call(obj)) {
		case "[object Array]": obj_type = 'array'; break;
		case "[object Object]": obj_type = 'object'; break;
		case "[object String]": obj_type = 'string'; break;
		case "[object Number]": obj_type = 'number'; break;
		case "[object Boolean]": obj_type = 'boolean'; break;
		case "[object Function]": obj_type = 'function'; break;
	}
	return obj_type;
};

site.utils.js = {};
site.utils.js.init = function(src) {
	switch (site.utils.getObjectType(src)) {
		case "array": for (i in src) this.init(src[i]); break;
		case "string": this.include(src); break;
	}
	return true;
};

site.utils.js.include = function(src) {
	jQuery("<script/>", {
		"charset" : 'utf-8',
		"type"    : 'text/javascript',
		"src"     : src
	}).appendTo("head");
};

site.utils.js.init([
	'/js/client/basket.js',
	'/templates/tigra21/s_js/basket.js',
	'/templates/tigra21/s_js/forms.js',
	'/templates/tigra21/s_js/message.js',
	'/templates/tigra21/s_js/captcha.js'
]);

jQuery(document).ready(function(){
	
	jQuery('#on_edit_in_place').click(function() {
		uAdmin.eip.swapEditor();
		return false;
	});
	
	jQuery('.catalog .change div').click(function() {
		if (!jQuery(this).hasClass('act')) {
			jQuery('div', this.parentNode).removeClass('act');
			jQuery(this).addClass('act');
			if (jQuery(this).hasClass('list')) {
				jQuery('.catalog').addClass('list_view');
				jQuery.cookie('catalog', 'list_view', {path: '/'});
			}
			else {
				jQuery('.catalog').removeClass('list_view');
				jQuery.cookie('catalog', null, {path: '/'});
			}
		}
	});

	jQuery('.votes div a').click(function(){
		var block = jQuery(this).parents('.votes');
		if(block.hasClass('vote')) {
			var element_id = block.get(0).className.split(' ').pop().split('_').pop();
			var params = this.parentNode.className.split(' ');
			jQuery.ajax({
				url: "/udata://vote/setElementRating//" + element_id + "/" + params[0].split('_').pop() + ".json",
				type: "GET",
				dataType : 'json',
				success: function(result){
					jQuery('div', block).each(function() {
						jQuery(this).removeClass(params[1]).addClass('current_' + result.ceil_rate);
					});
					block.removeClass('vote').attr('title', 'Вы уже голосовали');
					jQuery('span', block).text('Рейтинг: ');
				}
			});
		}
		return false;
	});
	
	jQuery('tr[class^="cart_item_"]:odd').addClass('even');
	jQuery('tr[class^="cart_item_"]:odd + .related-goods').addClass('even');
});