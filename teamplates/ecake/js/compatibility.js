/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$('ul.objects a.options_true').click(function(){
    $('#popupOptions').modal('show');                                         
    return false;
})
$('ul.objects a.options_false').click(function(){
    $('#popupGoodsAdd').modal('show');                                         
    return false;
})
jQuery('div.change div').click(function() {
            
		if (!jQuery(this).hasClass('act')) {
			jQuery('div', this.parentNode).removeClass('act');
			jQuery(this).addClass('act');
			if (jQuery(this).hasClass('list')) {
				jQuery('.product-list').addClass('list_view').isotope('reLayout');
				jQuery.cookie('catalog', 'list_view', {path: '/'});
			}
			else {
				jQuery('.product-list').removeClass('list_view').isotope('reLayout');
				jQuery.cookie('catalog', null, {path: '/'});
			}
		}
	});