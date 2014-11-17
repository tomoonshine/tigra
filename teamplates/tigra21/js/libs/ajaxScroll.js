var ajaxScroll = {};

	ajaxScroll.init = function(){
		k=1, summPage=0, arrHref= new Array();
		status = true;
		ajaxScroll.numpages_init();
		ajaxScroll.moreBtn_init();
		ajaxScroll.scroll_init();
		this.load = false;
	};
		
	ajaxScroll.numpages_init = function(){
		jQuery('.numpages').each(function(){
			var _this = jQuery(this);
			ajaxScroll.module = _this.data('module');
			ajaxScroll.method = _this.data('method');
			ajaxScroll.langprefix = _this.data('lang-prefix');
			ajaxScroll.idPage = _this.data('id');
			_this.after('<div class="loading-block" style="text-align: center;"><i class="fa fa-spinner fa-spin fa-2x"></i> Загрузка...</div><div align="center" class="more-btn"><a href="#" id="more-btn"></a></div>');
				summPage = parseInt(_this.data('per-page'), 10);
			jQuery('.pages a', _this).each(function(index){
				arrHref[index] = jQuery(this).attr('href');
			});
			_this.remove();
		});
	};
	
	ajaxScroll.moreBtn_init = function(){
		jQuery('#more-btn').bind('click', function(){
			var parent = jQuery(this).parent();
			if (summPage>=k && !ajaxScroll.load) {
				ajax_get_objects(k); k++;
			} else parent.remove();
			return false;
		});
	};
	
	function ajax_get_objects(page){
		ajaxScroll.load = true;
		jQuery('.loading-block').show();
		jQuery.ajax({
			//url: window.location.href + '&p='+page,
			url: '/udata//'+ajaxScroll.module+'/'+ajaxScroll.method+'/default/'+ajaxScroll.idPage+'/?p='+page+'&lang-prefix='+ajaxScroll.langprefix+'&transform=modules/catalog/ajax-getObjectList.xsl',
			cache: false,
			type: "GET",
			dataType: "html",
			success: function( data ){
				jQuery('.loading-block').hide();
				var content, _data, numpage, dataParse;
				    dataParse = $.parseHTML( data );
				    _data = $('<div>').append(dataParse);
					
					content = _data.find('#catalog-ajax'),
					separator = jQuery('<li class="standard separator-li"><span class="separator-text">Страница '+ (page + 1) +' из '+summPage+'</span></li>'),
					catalog = jQuery('#catalog');
					separator.prependTo(content);
					imagesLoaded(content.find('img'), function(){
						catalog.append(content).isotope('appended', content );
					});
					setTimeout('ajaxScroll.load = false', 1000);
					
					if (summPage<=page+1) {jQuery('.more-btn').remove();jQuery('.loading-block').hide();}
					_data.remove();
			},
			error: function() {
				ajaxScroll.load = false;
				jQuery('#catalog').html('<p align="center">Ошибка загрузки</p>');
			}
		});
	};
	ajaxScroll.scroll_init = function(){
		jQuery(window).bind('scroll', function(){
			if(ajaxScroll.load) return false;
			if (jQuery('#more-btn').position()!=null) {
				if ((parseInt(jQuery(window).height()) + parseInt(jQuery(window).scrollTop())) > (jQuery('#more-btn').position().top) && summPage>=k) {
					ajax_get_objects(k); k++;
				}
			}
		});
	};
	ajaxScroll.initTest = true;
	
(function($){
	jQuery(function(){
	    var all = jQuery('#all');
	    $.each(all, function(){
			var input = jQuery(this);
			if (input[0].checked == true){
			   ajaxScroll.init();
			   ajaxScroll.initTest = true;
			}
	       
			input.bind('change', function(){
                var _this = jQuery(this),
					_parent = _this.parent();
					console.log(_parent);
                if (_this[0].checked === false){
                    $.cookie('allView', 'false', {path: '/'});
                    _this.removeAttr('checked');
					_parent.removeClass('item-view');
                    ajaxScroll.initTest = false;
                    window.location.href = window.location.pathname;
                } else {
                    $.cookie('allView', 'true', {path: '/'});
                    _this.attr('checked','checked');
					_parent.addClass('item-view');
                    ajaxScroll.init();
                    ajaxScroll.initTest = true;
                }
            });
	        
	    });
		
	});
})(jQuery);