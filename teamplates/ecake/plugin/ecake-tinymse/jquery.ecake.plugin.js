var sliderEasy = {

	init: function(selector){
		var _slider = jQuery(selector);
		
		jQuery.each(_slider, function(index){
			var _this = _slider.eq(index),
				lengthItem = _this.find('.item').length,
				parent = _this.parent('.wrapper-easy-slider'),
				control;
				
			if(!lengthItem) { _this.remove(); return false;}
			var firstItem = _this.find('.item').eq(0);
			if(!parent.length) {
				_this.wrap('<div class="wrapper-easy-slider"></div>');
				parent = _this.parent('.wrapper-easy-slider');
			}
			
			if(!parent.find('.easy-slider-control').length) {
				parent.append('<div class="easy-slider-control"></div>');
				control = parent.find('.easy-slider-control');
				for(a = 1; a<=lengthItem; a++){
					var _a = $("<a>");
					_a.appendTo(control);
				}
				
				jQuery('a', control).unbind().bind('click', function(){
					var _this = jQuery(this);
					if(_this.hasClass('active')) return false;
					_this.siblings().removeClass('active').end().addClass('active');
					sliderEasy.flip(_this.index(), _this, _slider, false);
					return false;
				});
			}
			if(!_this.find('.next, .prev').length) {
				_this.append('<a class="prev"></a><a class="next"></a>');
			}
			
			_this.css('overflow','hidden');
			firstItem.addClass('active').fadeIn(function(){
				_this.stop().css('overflow','visibile').animate({
					height: jQuery(this).outerHeight()
				}, 250, function(){
					control.find('a').eq(0).addClass('active');
				});
			});
			sliderEasy.navReposition(firstItem, _this);
		});
		
		jQuery('.prev, .next', _slider).unbind().bind('click', function(){
			sliderEasy.flippedSlide(jQuery(this));
			return false;
		});
		
		
		jQuery(window).resize(function(){
			jQuery.each(_slider, function(index){
				var _this = _slider.eq(index);
				var activeSlide = _this.find('.item.active');
				
				sliderEasy.navReposition(activeSlide, _this);
				_this.height(activeSlide.outerHeight());
			});
		});
		
	},
	flippedSlide: function(object){
		var _slider = object.parents('.slider'),
			next = object.hasClass('next'),
			control = _slider.next('.easy-slider-control'),
			items = _slider.find('.item'),
			current = _slider.find('.item.active'),
			indexItem, item, count;
			
		indexItem = (next) ? current.next('.item').index() : current.prev('.item').index();
		
		if(next && indexItem == -1) {
			indexItem = 0;
		}
		sliderEasy.flip(indexItem, object, _slider, items, current, control);
	},
	flip: function(indexItem, object, _slider, items, current, control){
		var _slider = (_slider.length) ? _slider : object.parents('.wrapper-easy-slider').find('.slider'),
			item = (items) ? items.eq(indexItem) : _slider.find('.item').eq(indexItem),
			current = (current) ? current : item.siblings('.item.active');
		
		current.removeClass('active').fadeOut(100, function(){
			_slider.animate({
				height: item.outerHeight()
			}, 250, function(){
				item.addClass('active').stop().fadeIn();
				if(control) {
					control.find('a').eq(indexItem).siblings().removeClass('active').end().addClass('active');
				}
				sliderEasy.navReposition(item, _slider);
			});
		});
	},
	navReposition: function(item, slider){
		var minigalNav = slider.find('.minigal-nav');
		/* if (window.pageStyle.mobile){
			var _top = item.find('.image-slider').outerHeight();
			minigalNav.css('top', _top);
		} else { */
			 minigalNav.removeAttr('style');
		//}
	}
	
};


jQuery(document).ready(function(){
	var _accordion = $(".accordion");
	_accordion.accordion({
		header: "> .item > div.title",
		autoHeight: false
	});
	
	sliderEasy.init('.slider');
});