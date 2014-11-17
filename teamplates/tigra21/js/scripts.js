ajaxsubmit = new function(){
    var self = this;
    this.initFancybox = function(form){
        var _form = $(form);
        _form.submit(function(){
            $('.ajax-error', _form).remove();
			btn_line.addClass('active');
            jQuery.ajax({
                url     : _form.attr('action'),
                type    : "POST",
                dataType: "json",
                data    :   _form.serialize(),
                success :   function (data) {
                    if (data.error) {
                       $('.popupOneClick__layout', _form).prepend('<div class="ajax-error">'+data.error+'</div>');
                        return false;
                    }
                    
                    $.fancybox({
                        content: '<div class="ajax-success">'+data+'</div>',
                        tpl: {
                             wrap     : '<div class="fancybox-wrap" tabIndex="-1"><div class="fancybox-skin no-shadow"><div class="fancybox-outer "><div class="fancybox-inner no-shadow"></div></div><div class="clear"></div></div></div>',
                            closeBtn : '<a title="Закрыть окно" class="fancybox-item fancybox-close custom-fancybox-close" href="javascript:;"></a>',
                        }
                    });
                }
            }); 
            return false;
        });
    }
	this.init = function(form, url){
        var _form = $(form),
			urlSubmit = (url) ? url : _form.attr('action');
			btn_line = _form.find('.btn_line'),
			basketTest = (_form.attr('id') == 'fastorder') ? true : false,
			noSkipTest = true;
			
			
			
        _form.submit(function(){
			if (basketTest && noSkipTest) {
				var notEmptyCartFastOrder = $('#notEmptyCartFastOrder');
				var amount = parseFloat($('#sticky-cart .small_amount').text(), 10);
				
				amount = (isNaN(amount)) ? 0 : amount;
				if (amount > 0) {
					notEmptyCartFastOrder.modal('show');
					
					$('#skipTest', notEmptyCartFastOrder).unbind().on('click', function(){
						noSkipTest = false;
						notEmptyCartFastOrder.modal('hide');
						_form.submit();
						return false;
					});
					return false;
				}
			}
			if(_form.hasClass('no-submit')) return false;
            $('.alert-custom').remove();
			if(!site.forms.data.check(this)) return false;
			btn_line.addClass('active');
			_form.addClass('no-submit');
			
            jQuery.ajax({
                url     : urlSubmit,
                type    : "POST",
                dataType: "json",
                data    :   _form.serialize(),
                success :   function (data) {
					btn_line.removeClass('active');
					_form.removeClass('no-submit');
					var text  = '', class_alert = '';
					
                    if (data.error) {
						text = data.error;
						class_alert = 'error';
                    } else {
						text = data;
						class_alert = 'success';
						_form[0].reset();
					}
					_form.before('<div class="alert alert-'+class_alert+' alert-custom"><button class="close" type="button" data-dismiss="alert">×</button>'+text+'</div>');
                }
            }); 
            return false;
        });
    },
	this.subscribeForm = function(form, url){
        var _form = $(form),
			urlSubmit = (url) ? url : _form.attr('action'),
			btn_line = _form.find('.btn_line');
        _form.submit(function(){
            $('.alert-custom').remove();
			btn_line.addClass('active');
            jQuery.ajax({
                url     : '/udata/' + urlSubmit + '.json',
                type    : "POST",
                data    :   _form.serialize(),
                complete :   function (data) {
					var text  = '', class_alert = '',
						data = JSON.parse(data.responseText);
						btn_line.removeClass('active');
						
					if (data.result.items){
						var items = data.result.items,
							html = '<ul>';
						text = 'Вы подписались на рассылки.';
						class_alert = 'success';
						for (var k in items){
							html += '<li>'+items[k].disp_name+'</li>';
						}
						html += '</ul>';
						text += html;
                    }else{
						text = 'Вы отписались от рассылок.';
						class_alert = 'info';
					}
					_form.before('<div class="alert alert-'+class_alert+' alert-custom"><button class="close" type="button" data-dismiss="alert">×</button>'+text+'</div>');
                }
            }); 
            return false;
        });
    }
	
};

(function($){
	$(function(){
		var timeoutAjax, phoneValid = $('.phone_valid'),
		input_full_name = $('#input_full_name'),
		emailValid = $('.email_valid'),
		email_row = $('#email_row'),
		promocode_obj = $('.promocode'),
		cart_form = $('#cart_form'),
		other_field = $('#other_field'),
		delivery_price = $('.delivery_price'),
		payment_radio = $('input[type="radio"].payment', cart_form),
		deliveryId = $('input[name="delivery-id"]', cart_form),
		validMobileTest = validMobile();
		
		if(validMobileTest) $('#photo_object').removeClass('zoom-true');
		
		priceDelivery = function(input){
			var price = (input.data('price')) ? parseFloat(input.data('price')) : 0,
				cart_summary_all = jQuery('.cart_summary_all');
			if (input[0].checked) {
				if (isNaN(price)) {
					price = "не определено";
					cart_summary_all.text(accounting.formatMoney(parseFloat(cart_summary_all.data('price'), 10), " ", 0, " "));
				} else {cart_summary_all.text(accounting.formatMoney(parseFloat(cart_summary_all.data('price'), 10) + price, " ", 0, " "));}
				delivery_price.text(accounting.formatMoney(price, " ", 0, " "));
			}
		}
		
		$('ul.orderTimeline').each(function(){
			var _this = $(this),
			li = _this.find('li'),
			width = _this.width(),
			width_li = Math.floor(width/li.length);
			$.each(li, function(index){
				var _li = li.eq(index); 
				_li.width(width_li - parseFloat(_li.css('padding-left'), 10) - parseFloat(_li.css('padding-right'), 10));
			});
		});
		
		$("#form-search").submit(function(){
			var val = $(this).find('input').val();
			if(val) return true;
			return false;
		});
		
		var input_search_auto = $("#query");
			$('#autocomplete-results').empty().show();
		input_search_auto.autocomplete({
			//minChars:2,
			delay:10,
			matchSubset:1,
			autoFill:true,
			matchContains:1,
			cacheLength:10,
			selectFirst:true,
			maxItemsToShow:10,
			create: function(event, ui){
				
			},
			appendTo: "#autocomplete-results",
			source: function( request, response ) {
				var url_action = input_search_auto.parents('form').attr('action');
				if (!url_action || url_action=='') return;
				$.get('/udata:/'+url_action+'.json', {search_string: request.term}, function(result){
					var items_array = custom_make_array(result.items.item);
					
					response( $.map( items_array, function( item ) {
						
					  return {
						label: item.name,
						value: item.name,
						href: item.link,
						src: item.src_image
					  }
					}));
				}, "json");
			},
			select: function( event, ui ) {
				console.log(ui);
				window.location.href = ui.item.href;
			}			
		}).data( "autocomplete" )._renderItem = function( ul, item ) {
			item = item;
			return $( "<li>" ).data( "item.autocomplete", item ).append( "<a title="+item.label+"><div class='image'><img src="+item.src+" width='60' height='60' alt='' /></div><h6>" + item.label + "</h6></a>" ).appendTo( ul );
		};
	
	var goodsreview__formtext = $('.goodsreview__formtext'),
		goodsreview__write = $('a.goodsreview__write');
	goodsreview__write.click(function(){
		var _this = $(this);
			goodsreview__formtext.toggle();
		return false;
	});
	
	var orderTable__input_amount = $('.orderTable__input_amount'),
	   new_amount = 1;
	
	orderTable__input_amount.bind('keypress', function(e){
	    var _this = $(this);
	    if(e.which!=8 && e.which!=0 && (e.which<48 || e.which>57)) return false;
        if(isNaN(parseInt(_this.val()))) _this.val(1);
        return true;
	}).focusout(function(){
        var _this = $(this);
        if(isNaN(parseInt(_this.val())))_this.val(1);
    });
    
	$('.orderoneclick__link a').click(function(){
		var _this = $(this);
		$.fancybox.open($('#'+_this.data('id-window')), {
			padding: 0,
			scrolling: 'visible',
			tpl: {
				 wrap     : '<div class="fancybox-wrap" tabIndex="-1"><div class="fancybox-skin no-shadow"><div class="fancybox-outer "><div class="fancybox-inner no-shadow"></div></div><div class="clear"></div></div></div>',
				closeBtn : '<a title="Закрыть окно" class="fancybox-item fancybox-close custom-fancybox-close" href="javascript:;"></a>',
			}
		});
		return false;
	});
	
    ajaxsubmit.init('#fastorder');
    ajaxsubmit.subscribeForm('#subscribe-form');
	
	$('.goodsdetails__numbs a').bind('click', function(){
	    var _this = $(this),
	       input_amount = _this.siblings('input.orderTable__input_amount'),
	       amount = parseInt(input_amount.val(), 10);
	       if (_this.hasClass('down')) {amount = (new_amount <= 1) ? 1 : new_amount--;}
	       if (_this.hasClass('up')) {amount = new_amount++;}
	       
	       input_amount.val(new_amount);
	    return false;
	});
	
	var photo_object = $('#photo_object img'),
	    photo_object_zoom = $('#photo_object.zoom-true img'),
		gallery_a = $('.thumbs ul.thumbs-list li a'),
		
		arrayFancy = function(object){
			var array = [], i = 0;
			$.each(object, function(index){
				array[i] = object.eq(index).data('zoom-image');
				i++;
			});

			return array;
		},
		 zoomConfig = {
            zoomType: "window",
            lensFadeIn: 500,
            lensFadeOut: 500,
            cursor: "crosshair",
            zoomWindowFadeIn: 300,
            zoomWindowFadeOut: 300,
            onZoomedImageLoaded: function(currentImg){
                var width = currentImg.width();
                if(width < 370){
                    $.removeData(currentImg, 'elevateZoom');
					$('.zoomContainer').remove();
                };
            }
        },
		data_fancybox = arrayFancy(gallery_a);
		photo_object.data('index', 0);
		
		
		gallery_a.unbind().bind('click', function(){
			var _this = $(this);
			photo_object.data('index', _this.data('index'));
			photo_object.attr('src', _this.data('zoom-image'));
			photo_object.data('zoom-image', _this.data('zoom-image'));
			$('.zoomContainer').remove();
			photo_object_zoom.elevateZoom(zoomConfig);
			gallery_a.removeClass('active');
			_this.addClass('active');
			return false;
		});
		
		photo_object.click(function(){
			var _this = $(this);
			$.fancybox.open(data_fancybox,
			{
				padding: 10,
				index: _this.data('index'),
				tpl: {
					wrap     : '<div class="fancybox-wrap" tabIndex="-1"><div class="fancybox-skin custom-fancybox-skin"><div id="nav-thumb"></div><div class="fancybox-outer"><div class="fancybox-inner fancybox-inner-custom"></div></div><div class="clear"></div></div></div>',
					closeBtn : '<a title="Закрыть окно" class="fancybox-item fancybox-close custom-fancybox-close" href="javascript:;"></a>',
				}
			});
			return false;
		});
		/*
		$.each(photo_object_zoom, function(){
		    var _img = $(this);
		    if(_img.width() < 370){
		        _img.parents("#photo_object").removeClass('zoom-true');
		    } else {
                _img.parents("#photo_object").addClass('zoom-true');
                
            }
		}); */
		photo_object_zoom.elevateZoom(zoomConfig);
		
	
		function addLinks() {
			var list = $("#links"),
				navThumb = $("#nav-thumb");
			
			if (!list.length) {    
				list = $('<ul id="links">');
			
				for (var i = 0; i < this.group.length; i++) {
					var item = this.group[i], href, href_big;
					if (item.element) {
						href = $(item.element).data('fancybox');
						href_big = $(item.element).attr('href');
					}

					if (!href && item.type === 'image' && item.href) {
						href = item.href;
						href_big = item.href;
					}
					$('<li data-index="' + i + '"><a href="'+href_big+'"><img src="'+href+'" width="117" height="101" /></a></li>').appendTo( list );
				}
				
			}
			
			var li = list.find('li'),
				_this_index = this.index;
				//list.animate({'top': Math.floor((li.height() + 10) * _this_index)*(-1)}, 200);
			li.removeClass('active').eq(_this_index).addClass('active');;
			$.each(li, function(i){
				var _this_li = li.eq(i);
				if (_this_index == i) {
					console.log(_this_index+'='+i);
					console.log(_this_li);
					return false;
				} else {
					li.eq(i).remove();
					_this_li.appendTo( list )
				}
			});
			navThumb.append(list);
			$.fancybox.update();
		}

		function removeLinks() {
			$("#links").remove();    
		}

		$('ul.lkBookmarks li a.del').bind('click', function(){
			var _this = $(this),
				li = _this.parents('li');
				li.append('<div class="myloader"></div>');
				li.find('form').css('opacity', 0.1);
				$.ajax({
					url: _this.attr('href'),
					success: function(){
						li.css({'overflow': 'hidden'}).animate({
							height: 0,
							'padding-top': 0,
							'padding-bottom': 0,
							'margin-top': 0,
							'margin-bottom': 0
						}, function(){
							li.remove();
						});
					},
					error: function(){
						window.alert('Oooops... Что-то пошло не так');
					}
				});
			return false;
		});
	
	var authForm = $('#auth-form');
	authForm.each(function(){
		var _form = $(this),
			input = _form.find(':input').not(':submit'),
			submit = _form.find('input[type="submit"]'),
			status_return = false;
		
		input.focus(function(){
			var _this = $(this);
			_this.parent().siblings('.error').remove();
		});
		
		_form.submit(function(){
			var data = _form.serializeArray(),
				_error_text = '',
				empty_err = "Поле обязательно для заполнения.",
				password_val = '',
				stop = false;
			$('.error', _form).remove();
			
			for (var i in data) {
				var element_data = data[i],
					element = _form.find('input[name="'+element_data.name+'"]'),
					parents = element.parents('label'),
					val = element.val();
					
				switch (element_data.name) {
					case "from_page": continue; break;
					case "password": {
						if (val.length < 3) {
							_error_text = 'Слишком короткий пароль. Пароль должен состоять не менее, чем из 3х символов.'; stop = true; break;
						}
						password_val = val;
						break;
					}
					case "password_confirm": {
						if (password_val != val) {
							_error_text = 'Пароли должны совпадать.'; stop = true;
						}
						break;
					}
					case "login":
					case "forget_login":
					case "email": {
						status_return = isValidEmailAddress(element.val());
						if (!status_return) {_error_text = 'Некорректный E-mail'; stop = true;}
						break;
					}
				}
				if (!val && !stop) {_error_text = empty_err; stop = true;}
				if (stop){
					parents.append('<span class="error"><span class="arrow"></span><span class="arrow_inner"></span><span class="red">Ошибка:</span> '+_error_text+'</span>');
					return false;
				}
			}
			return !stop;
		});
	});
	
	var compare__tbl = $('table.compare__tbl');
	compare__tbl.find('tr td .blockCatalog__item a.closebtn').bind('click', function(){
		var _this = $(this),
			parent_td_index = parseInt(_this.parents('td').index(), 10)+1;
			$.ajax({
				url: _this.attr('href'),
				success :   function (){
					compare__tbl.find('tr td:nth-child('+parent_td_index+')').remove();
                },
				error: function(){
					window.alert('Oooops... Что-то пошло не так');
				}
			});
		return false;
	});
	
	$('#answer_consultant_link').each(function(){
		var _this = $(this),
			block = $('#'+_this.data('id-block')); block.hide();
		_this.bind('click', function(){
			block.toggle('normal');
			return false;
		});
	});
	
	var tr_compare__tbl = compare__tbl.find('tr').not('.no_select');
	
	$('.compare__tbl form label input.compare_rather').change(function(){
	    var input = $(this),
	        value = input.data('value');
	    
	    if (value == 'all') {
	        tr_compare__tbl.removeClass('same');
	        return false;
	    }
	    
        tr_compare__tbl.each(function(index){
            var _same=true,
                _tr = tr_compare__tbl.eq(index),
                _td = _tr.find('td').not(':first'),
                _value = _td.eq(0).html();
           _td.each(function(i){
                if(_value != _td.eq(i).html()) _same=false;
            });
            
            if(_same==true) {
               _tr.addClass('same');
            } else {
               _tr.removeClass('same');
            }
        });
        return false;
    });
		setTimeout(function(){
			$('ul.goodsdetails__color li label span.jq-radio').each(function(){
				var _this = $(this),
					color = _this.data('color');
					_this.find('span').css({'background' : color});
			});
		}, 100);
	var original_block = $('#priceID .goodsdetails__oldprice span'),
		original_price = parseFloat(original_block.data('price-old'), 10),
		actual_block = $('#priceID .goodsdetails__price'),
		actual_price = parseFloat(actual_block.data('price-new'), 10);
    var percent_price;
    
    $('.options_change :radio, .options_change select').change(function(){
		var actualPriceNew,originalPriceNew,_object;
		var _this = $(this),
			floatval =  0,
			_type = this.type;
			
			_object = _this
			if (_type == 'select-one') {
				_object =  _this.find(':selected');
			}
			
       
		
		floatval =  parseFloat(_object.data('floatval'), 10);
        if (isNaN(floatval)) floatval = 0;
        originalPriceNew = original_price + floatval;
        
        if (isNaN(actual_price)) original_block.text(accounting.formatNumber(originalPriceNew," ", " ") + ' ' + original_block.data('pre-suffix'));
		else {
            percent_price = 100-((actual_price * 100)/original_price);
            actualPriceNew = originalPriceNew - ((originalPriceNew*percent_price)/100);
            original_block.text(accounting.formatNumber(originalPriceNew," ", " ") + ' ' + original_block.data('pre-suffix'));
            actual_block.text(accounting.formatNumber(actualPriceNew," ", " ") + ' ' + actual_block.data('pre-suffix'));
		}
		
	});
	
	/*$('ul.objects a.options_true').click(function(){
		$('#popupOptions').modal('show');                                         
		return false;
	});
	$('ul.objects a.options_false').click(function(){
		$('#popupGoodsAdd').modal('show');                                         
		return false;
	});*/
	$('div.change div').click(function() {
		if (!jQuery(this).hasClass('act')) {
			jQuery('div', this.parentNode).removeClass('act');
			jQuery(this).addClass('act');
			
			if (jQuery(this).hasClass('list')) {
				jQuery('.product-list').addClass('list_view').isotope('layout');
				jQuery.cookie('catalogView', 'list', {path: '/'});
			} else {
				jQuery('.product-list').removeClass('list_view').isotope('layout');
				jQuery.cookie('catalogView', 'tile', {path: '/'});
			}
		}
	});
	
	var $container = $('#catalog');
	imagesLoaded($container.find('img'), function(){
		$container.isotope({
			itemSelector: 'li.standard',
			layoutMode: 'fitRows'
		});
	});
	
	var $getCategoryList = $('#catalog.getCategoryList');
	imagesLoaded($getCategoryList.find('img'), function(){
		$getCategoryList.isotope({
			itemSelector: 'li.standard',
			layoutMode: 'fitRows'
		});
	});
	
	var reposition = function(object, objectTop) {
		if(object.hasClass('fixed')){
			var offset = object.offset(),
				parent = object.parent(),
				parentHeight = parent.height(),
				rowHeight = basket.parents('.row').height();
				
	       if (parentHeight < rowHeight) parent.height(rowHeight);
	        
	      if ($(window).scrollTop() > parentHeight - object.outerHeight() - 20 + parent.offset().top) {
              object.removeClass('prilip').addClass('stop');
              object.css('top', (parentHeight - object.outerHeight() - 20) + 'px');
            } else {
              object.css('top', objectTop);
              object[0].className = (parent.offset().top < $(window).scrollTop() ? 'fixed prilip': 'fixed');
            }
		}
	}
	
	var basket = $('#summary_basket'),
        basketTop = parseFloat(basket.css('top'), 10);
		basket.width(basket.width());
		basket.parent().css('position','relative');
		reposition(basket, basketTop);
		
	$(window).bind('scroll',function() {
		if (!site.basket.is_cart) domendo.stickyBasketFunc.reposition();
		reposition(basket, basketTop);
	});
	
	var menu = $('.sidebar ul.category-list'),
		def_menu_height = menu.height();
	
	$('.sidebar .toggle-menu').click(function(){
		var _this = $(this);
			_this.toggleClass('main-up');
			menu.slideToggle(function(){
				$(this).toggleClass('hideBlock');
				_this.find('i').toggleClass('fa-caret-down');
			});
			
		return false;
	});
	
		
		$.each(deliveryId, function(index){
			var _this = deliveryId.eq(index);
				priceDelivery(_this);
				
				_this.change(function(){
					$(this).attr('checked','checked').trigger('refresh');
					priceDelivery($(this));
				});
		});
		
	$('.auth-register-popover .popover-close').unbind('click').live('click', function(){
	    $(this).parents('.popover').prev().popover('hide');
	    return false;
	});	
	
	emailValid.blur(function(){
		var _this = $(this),
			email = _this.val(),
			testEmail = isValidEmailAddress(email),
			option = {html: true, placement: 'bottom', trigger: 'manual',template: '<div class="popover auth-register-popover"><div class="arrow"></div><div class="popover-content"></div></div>'};
			
			//clearTimeout(timeoutAjax);
		if (testEmail && !_this.hasClass('auth_true')) {
	 // timeoutAjax =	setTimeout(function() {
			jQuery.ajax({
					type: "POST",
					url: '/users/testEmailValid/.json',
					data: {email: email},
					success: function(data){
						result = JSON.parse(data);
						$('.auth-register-popover').popover('hide');
						if (result) {
							option['content'] = $('#auth-cart').html();
						} else {
							option['content'] = $('#register-cart').html();
						}
						_this.popover(option);
						_this.popover('show');
						
						$('.modal-auth').unbind().bind('click', function(){
							var parent = $(this).parents('.auth-register-cart'),
								modalBody = parent.find('.modal-body'),
								password_fast_reg = parent.find('.password_fast_reg');
								$('.alert-custom').remove();
								
								if (parent.hasClass('redirect-true')) {window.location.href = window.location.href; return false;}
								
								jQuery.ajax({
									type: "POST",
									url: '/users/fastRegistrateAndLogin.json',
									data: {email_fast_reg: email, password_fast_reg: password_fast_reg.val(), test_auth: result},
									complete: function(data){
										data = JSON.parse(data.responseText);
										password_fast_reg.val('');
										
										if (data.redirect) {
											parent.addClass('redirect-true');
											modalBody.html('<div class="alert alert-'+data.classAlert+' alert-custom"><p>'+data.text+'</p></div>');
										} else {
											parent.removeClass('redirect-true');
											modalBody.prepend('<div class="alert alert-'+data.classAlert+' alert-custom"><button class="close" type="button" data-dismiss="alert">×</button><p>'+data.text+'</p></div>');
										}
									}
								});
								return false;
							});
							cart_form.removeClass('notSubmit');
							other_field.show();
					},
					error: function(jqXHR, textStatus, errorThrown){
						console.log(jqXHR);
						console.log(textStatus);
						console.log(errorThrown);
						window.alert('Ooops... Что-то пошло не так!'); 
					}
				});
		 //}, 500);
		} else {other_field.hide();cart_form.addClass('notSubmit');_this.popover('hide');}
	});
	
	$('.auth-register-cart').on('hidden', function(){
		var _this = $(this);
		if (_this.hasClass('redirect-true')) window.location.href = window.location.href;
	});
	
	$('#login form').bind('submit', function(){
		var _this = $(this);
			ajaxLogin(_this);	
			
		return false;
	});
	
	$('#settings-form').bind('submit', function(){
		var _this = $(this);
			$('.alert-custom').remove();
			jQuery.ajax({
				url     : _this.attr('action'),
				type    : "POST",
				data    :   _this.serialize(),
				complete :   function (data) {
					var text  = '', class_alert = '',
						error = $(data.responseText).find('.content .alert-error');
					if (error.length) {
						error.find('button').remove();
						text = error.html();
						class_alert = 'error';
					} else {
						text = 'Изменения сохранены успешно.';
						class_alert = 'success';
					}
					_this.before('<div class="alert alert-'+class_alert+' alert-custom"><button class="close" type="button" data-dismiss="alert">×</button>'+text+'</div>');
					//_form[0].reset();
				}
			}); 
		return false;
	});
	
	$('section.reset_password form, #callback form, .newsletter form').submit(function(){
		var _form = $(this),
			btn_line = _form.find('.btn_line');
			btn_line.addClass('active');
		if(_form.attr('id') == 'registrate') {
			site.forms.data.save(this);
		}
		if(!site.forms.data.check(_form)) {btn_line.removeClass('active');}
	});
	
	/*
	$('.phone-valid').inputmask("phone", {clearMaskOnLostFocus: false, autoUnmask : true,
	   "oncomplete": function(){ $(this).removeClass('empty-phone'); },
	   "onincomplete": function(){ $(this).addClass('empty-phone'); },
	   "oncleared": function(){ $(this).addClass('empty-phone'); }     
	}); */
	
	$('#okfastorder').modal('show');
	
	/*rating apply*/
	function starrating(maxRate) {
		$('.starrating').each(function() {
			var wrate = ($(this).outerWidth() * $(this).find('span').data('starrate')) / maxRate;
			//$(this).find('span').css('width', wrate).addClass('starlight');
		});
	}
	
	function initStars(rateBlockClass) {
	  var _newpos = 0, this$ =  $(rateBlockClass + ':not(.disabled)'), _star_width = this$.outerWidth() / 5;
	  this$.mousemove(function(e) {
		var  _posX = e.pageX - this$.offset().left;
		_newpos = (parseInt(_posX / _star_width) + 1);
		//add hover width    
		var starrating__txt;
		switch (_newpos) {
		  case 1:
			starrating__txt = '(всё равно)';
			break
		  case 2:
			starrating__txt = '(так себе)';
			break
		  case 3:
			starrating__txt = '(обычный)';
			break
		  case 4:
			starrating__txt = '(хороший)';
			break
		  case 5:
			starrating__txt = '(привел в восторг!)';
			break
		  default:
			starrating__txt = '(оцените букет)';
		}
		this$.find('span.rating_curr').css({'width': _newpos * _star_width + 'px'}).end().next('.starrating__txt').text(starrating__txt);
		console.log(_star_width);
		console.log(_newpos);
		console.log(_newpos * _star_width + 'px');
	  }).mouseleave(function() {   
		if(this$.find('.rating_curr').data('val')>0){
			console.log('qqq'+this$.find('.rating_curr').data('val') * _star_width);
			
			this$.find('.rating_curr').css({'width': (this$.find('.rating_curr').data('val') * _star_width) + 'px'});
		}else{
			console.log('ttt'+0);
			var starrating__txt = '(оцените букет)';
			this$.find('span.rating_curr').css({'width': '0'}).end().next('span.starrating__txt').text(starrating__txt);
		}
	  }).click(function() {
		var url = this$.attr('href') + _newpos + '/';
		// set current mark
		this$.find('.rating_curr').data('val',_newpos).css({'width': (_newpos * _star_width) + 'px'});//.end().next('.loader').css({display: 'block'});
		console.log(_newpos);
		
		this$.find('.rating_int').val(_newpos);

		return false;
	  });
	}
	
	//comment send
	  starrating(5);
	  initStars('.goodsreview__setrating');
	  var alertComment = $('.alert-comment').hide();
	  $('.comment_post').submit(function (e) {
			var answer = jQuery('.answer'),
				review_text = jQuery('#review_text'),
				form = jQuery(this);
			
			if(review_text.val()==''){
				$('.alert-comment.alert-error').fadeIn();
				//answer.html('Отзыв не может быть отправлен так как он пуст.');
				//answer.hide().removeClass('hide').fadeIn();
				return false;
			}
			answer.hide().removeClass('hide');
			jQuery.ajax({
			   url: form.attr('action'),
			   dataType: 'html',
			   data:  form.serialize(),
			   success: function (data) {
					//form.find(':input').not('input[type="submit"]').val('');
					review_text.val('');
					alertComment.hide();
					//answer.html('Ваш комментарий успешно добавлен. После модерации он будет показан.');
					$('.alert-comment.alert-success').fadeIn();
			   }
			});
			return false;
		});
	$('button', alertComment).unbind().bind('click', function(){
		$(this).parents('.alert').fadeOut();
		return false;
	});
	// comment paging ajax
	jQuery(".ratings-items .pagination ul li a").on("click", function() {
	  var href=jQuery(this).attr('href');
	  var index=jQuery(this).parents('.ratings-items').attr('index');
		   jQuery.ajax({
				url: '/udata://comments/insert/'+index+'/6/'+href+'&transform=modules/comments/comments-list-ajax.xsl',
				dataType: 'html',
				success: function (data) {
					 jQuery('.ratings-items').html(data);
				}
		   });
	  return false;
	});
	
	$('.category-list li a .fa').click(function(){
		var _this = $(this),
			ulBlock = _this.parent().next();
			_this.toggleClass('fa-chevron-up');
			ulBlock.slideToggle();
		return false;
	});
	
	$('a.del_electee_item').unbind('click').live('click', function(){
		var _this = $(this),
			parentObj = _this.parents('li.standard'),
			iconStar = _this.hasClass('fa fa-star'),
			sticky = $(_this.data('id-sticky')),
			stickySmallAmount = $('.small_amount', sticky);
		$.ajax({
			url: $(this).attr('href'),
			success: function(){
				amount = parseInt(stickySmallAmount.text(),10) - 1;
				stickySmallAmount.text(amount);
				if (!iconStar){
					parentObj.css('overflow','hidden').animate({'height':0,
					'opacity':0,
					'padding-top':0,
					'padding-bottom':0,
					'margin-bottom': 0
					}, 400, function(){
						//$(this).remove();
						$('.product-list.isotope').isotope( 'remove', parentObj );
					});
					
				} else {
					_this.attr('class', '').addClass('fa fa-star-o add_electee_item');
					_this.attr('href', _this.data('add-url'));
					_this.attr('title', _this.data('text'));
					if(amount < 1) sticky.removeClass('notEmpty');
				}
			},
			error: function(){
				window.alert('Oooops... что-то пошло не так!');
			}
		});
		return false;
	});
	$('.electee-wrap a.add_electee_item').unbind('click').live('click', function(){
		var _this = $(this),s
			sticky = $(_this.data('id-sticky')),
			stickySmallAmount = $('.small_amount', sticky);
		
		$.ajax({
			url: _this.attr('href'),
			success: function(){
				_this.attr('class', '').addClass('fa fa-star del_electee_item');
				_this.attr('href', _this.data('delete-url'));
				_this.attr('title', _this.data('untext'));
				stickySmallAmount.text(parseInt(stickySmallAmount.text(),10) + 1);
				sticky.addClass('notEmpty');
			},
			error: function(){
				window.alert('Oooops... что-то пошло не так!');
			}
		});
		return false;
	});
	var usePromocode = $('#usePromocode');
	usePromocode.click(function(){
		var _this = $(this);
			_this.next().slideDown().end().hide();
		return false;
	});
	
	$('#summary_basket form').submit(function(e){
		e.preventDefault();
		var _form = $(this),
			btn_line = _form.find('.btn_line'),
			input_append = _form.find('.input-append');
		
			jQuery.ajax({
				beforeSend: function(){ input_append.hide(); btn_line.addClass('active');},
				dataType: 'json',
				data: _form.serialize(),
				type: 'POST',
				url: _form.attr('action') + '.json?json=1',
				success: function (data) {
					btn_line.removeClass('active');
					_form[0].reset();
					input_append.show();
				if(typeof data.bonus != 'undefined'){
					var actual, bonus = data['bonus'],
						cart_summary_all = $('.cart_summary_all'),
						available_bonus_float = (typeof bonus.available_bonus != 'undefined' ) ? parseFloat(bonus.available_bonus, 10) : 0,
						reserved_bonus_float = (typeof bonus.reserved_bonus != 'undefined' ) ? parseFloat(bonus.reserved_bonus, 10) : 0,
					available_bonus = $('.available_bonus'),						
					reserved_bonus = $('.reserved_bonus');						
					available_bonus.text(available_bonus_float);
					reserved_bonus.text(reserved_bonus_float);
					actual = parseFloat(bonus.actual_total_price, 10);
					cart_summary_all.text(actual);
					cart_summary_all.data('price', actual);
				} else {
					site.basket.get();
					usePromocode.next().hide().end().show();
				}
					
				}
		   });
	});
	
	$('.product-content a.reviewsLink').unbind().bind('click', function (e) {
			$('a#ratingsTab').click();
		return false;
	});
	
	$('div.sticky-block-wrapper a').not('.upbtn').unbind('click').bind('click', function(){
		var _this = $(this), _object, amount;
			if(_this.hasClass('btn')) {
				_object = _this.parent().siblings('a');
			}
			amount = parseInt(_object.find('.small_amount').text(), 10);
		if(isNaN(amount) || amount == 0) return false;
	});
	
	$('input[type="checkbox"]').not('.not-styler').change(function(e){
		e.preventDefault();
		var _this = $(this),
			_id = _this.data('id-hidden');
		if(!_id) return true 
		else {
			var _hidden = $('#'+_id);
			if(_this[0].checked){
				_hidden.val(this.checked);
			} else _hidden.val('');
		}
	});
	
	$('#sticky-cart').each(function(){
		var _this = $(this),
			stickyBasket__slide = $('.stickyBasket__slide', _this);
		_this.hover(function(e){
			if (_this.hasClass('stickyElectee') || jQuery('body').hasClass('basket_small_bottom')) return false;
			$('.stickyBasket__slide', _this).stop().animate({
				opacity: 'toggle',
				width: 'toggle'
			}, 300);
		});
		
	});
	
	$('div.menu-iphone ul li a').click(function(){
		var _this = $(this),
			_subMenu = _this.siblings('.sub-menu');
		if(_subMenu.length){
			_subMenu.slideToggle();
			return false;
		} else return true;
	});
	  
});
		
})(jQuery);

function ajaxLogin(form){
	var btn_line = form.find('.btn_line').addClass('active');
	$.ajax({
		url: form.attr('action') + '.json?ajax=1',
		data: form.serialize(),
		complete: function(data){
			//result = true;
			var text = JSON.parse(data.responseText);
			if (text.error) {
				form.find('.modal-body').prepend('<div class="alert alert-error"><button class="close" type="button" data-dismiss="alert">×</button><p>'+text.error+'</p></div>');
				btn_line.removeClass('active');
			}
			else {
				form.find('.alert').remove();
				window.location.href = window.location.href;
			}
			
		}
	});
};

function custom_make_array(obj){
	var array_result = new Array();
	for (var key in obj){
		array_result[key] = new function(){ return obj[key]}
	}
	return (array_result.length) ? array_result : false;
}

function parseObject(value, object) {
	var arr = new Array(),
		i = 1;
	for(var key in object) {
		for (var k in object[key]) {
			if (object[key][k] == value) arr[i++] = key;
		}
	}
	return arr;
}

function arrCompare(need, arrHeand) {
	var return_val = new Array(), i = 0;
	for(var key in arrHeand) {
		for (var k in arrHeand[key]) {
			var heandVal = parseInt(arrHeand[key][k], 10);
			if (heandVal == need) {
			return_val[i++] = key;
			}
		}
	}
	if (return_val.length == 0) return_val = false;
	return return_val;
}

function isValidEmailAddress(emailAddress) {
	var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
	return pattern.test(emailAddress);
}

/*
*	@author - http://detectmobilebrowser.com/mobile
*/
function validMobile(){
	var a = navigator.userAgent||navigator.vendor||window.opera;
	if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) return true;
	
	return false;
}

/*!
 * accounting.js v0.3.2, copyright 2011 Joss Crowcroft, MIT license, http://josscrowcroft.github.com/accounting.js
 */
(function(p,z){function q(a){return!!(""===a||a&&a.charCodeAt&&a.substr)}function m(a){return u?u(a):"[object Array]"===v.call(a)}function r(a){return"[object Object]"===v.call(a)}function s(a,b){var d,a=a||{},b=b||{};for(d in b)b.hasOwnProperty(d)&&null==a[d]&&(a[d]=b[d]);return a}function j(a,b,d){var c=[],e,h;if(!a)return c;if(w&&a.map===w)return a.map(b,d);for(e=0,h=a.length;e<h;e++)c[e]=b.call(d,a[e],e,a);return c}function n(a,b){a=Math.round(Math.abs(a));return isNaN(a)?b:a}function x(a){var b=c.settings.currency.format;"function"===typeof a&&(a=a());return q(a)&&a.match("%v")?{pos:a,neg:a.replace("-","").replace("%v","-%v"),zero:a}:!a||!a.pos||!a.pos.match("%v")?!q(b)?b:c.settings.currency.format={pos:b,neg:b.replace("%v","-%v"),zero:b}:a}var c={version:"0.3.2",settings:{currency:{symbol:"$",format:"%s%v",decimal:".",thousand:",",precision:2,grouping:3},number:{precision:0,grouping:3,thousand:",",decimal:"."}}},w=Array.prototype.map,u=Array.isArray,v=Object.prototype.toString,o=c.unformat=c.parse=function(a,b){if(m(a))return j(a,function(a){return o(a,b)});a=a||0;if("number"===typeof a)return a;var b=b||".",c=RegExp("[^0-9-"+b+"]",["g"]),c=parseFloat((""+a).replace(/\((.*)\)/,"-$1").replace(c,"").replace(b,"."));return!isNaN(c)?c:0},y=c.toFixed=function(a,b){var b=n(b,c.settings.number.precision),d=Math.pow(10,b);return(Math.round(c.unformat(a)*d)/d).toFixed(b)},t=c.formatNumber=function(a,b,d,i){if(m(a))return j(a,function(a){return t(a,b,d,i)});var a=o(a),e=s(r(b)?b:{precision:b,thousand:d,decimal:i},c.settings.number),h=n(e.precision),f=0>a?"-":"",g=parseInt(y(Math.abs(a||0),h),10)+"",l=3<g.length?g.length%3:0;return f+(l?g.substr(0,l)+e.thousand:"")+g.substr(l).replace(/(\d{3})(?=\d)/g,"$1"+e.thousand)+(h?e.decimal+y(Math.abs(a),h).split(".")[1]:"")},A=c.formatMoney=function(a,b,d,i,e,h){if(m(a))return j(a,function(a){return A(a,b,d,i,e,h)});var a=o(a),f=s(r(b)?b:{symbol:b,precision:d,thousand:i,decimal:e,format:h},c.settings.currency),g=x(f.format);return(0<a?g.pos:0>a?g.neg:g.zero).replace("%s",f.symbol).replace("%v",t(Math.abs(a),n(f.precision),f.thousand,f.decimal))};c.formatColumn=function(a,b,d,i,e,h){if(!a)return[];var f=s(r(b)?b:{symbol:b,precision:d,thousand:i,decimal:e,format:h},c.settings.currency),g=x(f.format),l=g.pos.indexOf("%s")<g.pos.indexOf("%v")?!0:!1,k=0,a=j(a,function(a){if(m(a))return c.formatColumn(a,f);a=o(a);a=(0<a?g.pos:0>a?g.neg:g.zero).replace("%s",f.symbol).replace("%v",t(Math.abs(a),n(f.precision),f.thousand,f.decimal));if(a.length>k)k=a.length;return a});return j(a,function(a){return q(a)&&a.length<k?l?a.replace(f.symbol,f.symbol+Array(k-a.length+1).join(" ")):Array(k-a.length+1).join(" ")+a:a})};if("undefined"!==typeof exports){if("undefined"!==typeof module&&module.exports)exports=module.exports=c;exports.accounting=c}else"function"===typeof define&&define.amd?define([],function(){return c}):(c.noConflict=function(a){return function(){p.accounting=a;c.noConflict=z;return c}}(p.accounting),p.accounting=c)})(this);