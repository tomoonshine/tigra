var deparam = function(){
	var result = {};
	var _query = decodeURIComponent(window.location.search.substr(1));
	if(!_query) return result;
	var _arrTemp = _query.split("&");
	
	for(var key in _arrTemp){
		var _item = _arrTemp[key].split("=");
		result[_item[0]] = _item[1];
	};
	return result;
}
priceReset = true;
params = deparam();

jQuery(function($){
	var btnAll = $('#all_view_items'),
		form_init = $("form.catalog_filter");
	btnAll.click(function(){
		$(this).fadeOut();
		ajaxScroll.init();
		return false;
	});
	
	is_default = (form_init.data('is-default')) ? true : false;
	
	var path = '', content_block = $('#catalog');
	$.address.state(window.location.pathname);
	
	var ajax_get_objects_search = function(value,dataValue){
		var url = (url) ? url : window.location.pathname;
		if (is_default) url = '/shop/';
		catalog = $('#catalog');
		$.ajax({
			url: '/udata//catalog/getObjectsListAmount//'+ catID +'/?lang-prefix='+ form_init.data('lang-prefix') +'&search-filter=1&transform=modules/catalog/ajax-getObjectList.xsl',
			data: dataValue,
			cache: false,
			dataType: "html",
			beforeSend: function(){ catalog.empty().append('<li class="li-spinner"><span class="fa fa-spinner fa-spin"></span></li>'); },
			success: function( data ){
				$.address.value(value+'?'+decode_param(dataValue));
				var content, _data, numpage, dataParse;
				    dataParse = $.parseHTML( data );
				    _data = $('<div>').append(dataParse);
					content = _data.find("#catalog-ajax"),
					numpage = _data.find("#numpages");
					
					$('.numpages,.more-btn,.loading-block').remove();
					imagesLoaded(content.find('img'), function(){
						catalog.empty().prepend(content.html()).isotope('reloadItems').isotope({ sortBy: 'original-order' });
					});
					catalog.after(numpage);
				if(ajaxScroll.initTest == true) ajaxScroll.init();
				status_price = false;
				isClearBtn();
				_data.remove();
			},
			error: function(data){
				window.alert('Oooops... Что-то пошло не так');
			}
		});
		return false;
	},
	
	ajax_get_field_search = function(value){
		$.ajax({
			url: '/udata//catalog/search_new/'+ catID +'/1000///'+form_init.data('type-id')+'/.json',
			data: value,
			cache: false,
			dataType: "json",
			success: function( result ){
				for ( var key in result.group ){
					var group = result.group[key];
					for ( var key in group.field ){
						var field = group.field[key],
							dataType = field['data-type'];
						if ((dataType == "symlink" || dataType == "relation") && !$.isEmptyObject(field.values)) {
							for ( var key in field.values.item ){
								var item = field.values.item[key],
									block = $('div.filters-features-block').not('.active'),
									inputClass = '.'+dataType+'_'+item['id'],
									input = $(inputClass, block),
									text = input.parent().siblings();
								if (item['visible'] == 'hidden') {
									text.addClass('disabled');
								} else {
									text.removeClass('disabled');
								}
								input.prop('disabled', (item['visible'] == 'hidden')).trigger('refresh');
							}
						}
						if (dataType == "price" || dataType == "float" || dataType == "int"){
								priceReset = false;
								value_from = (field['value_from']) ? field['value_from'] : field['min'];
								value_to = (field['value_to']) ? field['value_to'] : field['max'];
								var name = field['name'];
								var slider_label = $('.slider-label-'+name);
								var valFrom = (typeof accounting.formatMoney == 'function') ? accounting.formatMoney(value_from, " ", 0, " ") : ui.values[ 0 ];
								var valTo = (typeof accounting.formatMoney == 'function') ? accounting.formatMoney(value_to, " ", 0, " ") : ui.values[ 0 ];
								
								$('.slider_'+name).slider( "option", "values", [value_from, value_to] );
								$('.slider_from_'+name).val(value_from);
								$('.slider_to_'+name).val(value_to);
								slider_label.find('.begin').text(valFrom);
								slider_label.find('.end').text(valTo);
							priceReset = true;
						}
					}
				}
			}
		});
	},
	
	filter_apply = function(name,value){
		if (value) {
				params[name] = value;
			} else {delete params[name]}
			ajax_get_objects_search(path, params);
			ajax_get_field_search(params);
		return false;	
	},
	
	delete_param = function(name){
		delete params[name];
		ajax_get_objects_search(path, params);
		ajax_get_field_search(params);
		return false;	
	},
	slider_search = $('.slider_search');
	
	resetFormAll = function(fromReset){
		params = {};
		fromReset[0].reset();
		$('.clearBtn_form').fadeOut();
		$('.clearBtn').fadeOut();
		$('.filters-features-block').removeClass('active');
		slider_search.each(function(){
			priceReset_init($(this).data('name'));
		});
		ajax_get_objects_search(path);
	},
	
	isClearBtn = function(){
		if(window.location.search == '' || window.location.search == undefined) {
			$('.clearBtn_form').fadeOut();
		}
	},
	
	decode_param = function(param){
		return decodeURIComponent($.param(param));
	},
	
	select_block = function(select){
		$(select).unbind().bind('change', function(){
			var _this = $(this), 
				name = _this.attr('name'),
				resetOption = $("option:gt(1)", _this),
				selected = $("option:selected", _this),
				val = selected.val();
			if (selected.data('order')) {
				params[name] = {};				
				params[name][selected.data('order')] = val;
				ajax_get_objects_search(path, params);
			}
			else {
				delete params[name];
			ajax_get_objects_search(path, params); }
			console.log(val);
			return false;
		});
		return false;
	};
	
	
	form_init.each(function(){
		var form = $(this), select = form.find('select'),
			input_price = form.find('input[type_field="price"]'),
			clearForm = form.find('.clearBtn_form');
		checkbox = form.find('input[type="checkbox"]');
		catID = form.data('cat');
		
		
		select.change(function(){
			var thisSelectName = $(this).attr('name');
			$('option:selected', $(this)).each(function(){
				filter_apply(thisSelectName, $(this).val());
			});
			clearForm.fadeIn();isClearBtn();
		});
		
		checkbox.change(function(){
			var parent = $(this).parents('.filters-features-block'),
				closeBtn = $('.clearBtn', parent),
				checkboxChecked = $('input:checkbox:checked', parent);
				closeBtn.unbind().on('click', function(){
					checkboxChecked.removeAttr('checked','checked');
					for (i=checkboxChecked.length; i>-1; i--) { delete params[checkboxChecked.eq(i).attr('name')];}
					ajax_get_objects_search(path, params);
					ajax_get_field_search(params);
						closeBtn.fadeOut();
						checkboxChecked.trigger('refresh');
						parent.removeClass('active');
						isClearBtn();
						return false;
				});
			if ($(this).attr('checked')=='checked') {parent.addClass('active');filter_apply($(this).attr('name'), $(this).val());closeBtn.fadeIn();
				$(this).parents('li').addClass('active');
			}
				else {delete_param($(this).attr('name'));
					if (checkboxChecked.length < 1) {parent.removeClass('active');closeBtn.fadeOut();isClearBtn();$(this).parents('li').removeClass('active');}
				}
			clearForm.fadeIn();
		});
		
		$('.clearBtn_form').unbind().on('click', function(){
			resetFormAll(form);
			return false;
		});
		
		$('.clearBtn').unbind('click').bind('click', function(){
			var _this = $(this),
				_parent = _this.parents('.filters-features-block');
				dataType = _this.data('type'),
				checkboxChecked = $('input:checkbox:checked', _parent);
				
				checkboxChecked.removeAttr('checked','checked');
				for (i=checkboxChecked.length; i>-1; i--) { delete params[checkboxChecked.eq(i).attr('name')];}
				ajax_get_objects_search(path, params);
				ajax_get_field_search(params);
					_this.fadeOut();
					checkboxChecked.trigger('refresh');
					_parent.removeClass('active');
					isClearBtn();
			
			return false;
		});
		
		form.submit(function(){
			return false;
		});
	});
	
	slider_search.slider({
			range: true,
			create: function( event,ui ){
				var _this = $(this),
					slide_lable = _this.parents('.filters-features-block').find('.slider-label'),
					begin = slide_lable.find('.begin'),
					end = slide_lable.find('.end');
				value_from = (!isNaN(parseFloat(_this.data('from')))) ? parseFloat(_this.data('from')) :  parseFloat(_this.data('min'));
				value_to = (!isNaN(parseFloat(_this.data('to')))) ? parseFloat(_this.data('to')) : parseFloat(_this.data('max'));
				//console.log($(this).data('to'));
				var slider_name = _this.data('name'),
					sliderFrom = $('.slider_from_'+slider_name),
					sliderTo = $('.slider_to_'+slider_name);
				_this.slider( "option", "min", parseFloat(_this.data('min')) );
				_this.slider( "option", "max", parseFloat(_this.data('max')) );
				_this.slider( "option", "values", [value_from, value_to] );
				_this.on( "slide", function( event, ui ) {
					sliderFrom.val(ui.values[ 0 ]);
					sliderTo.val(ui.values[ 1 ]);
					var valFrom = (typeof accounting.formatMoney == 'function') ? accounting.formatMoney(ui.values[ 0 ], " ", 0, " ") : ui.values[ 0 ];
					var valTo = (typeof accounting.formatMoney == 'function') ? accounting.formatMoney(ui.values[ 1 ], " ", 0, " ") : ui.values[ 0 ];
					begin.text(valFrom);
					end.text(valTo);
				});
				_this.on( "slidechange", function( event, ui ) {
					filter_price(sliderFrom,sliderTo,slider_name);
				} );
			}
		});
	
	function filter_price(sliderFrom_func, sliderTo_func, slider_func, products){
		var slider_from = $( sliderFrom_func ).slider( "value" ),
			slider_to = $( sliderTo_func ).slider( "value" );
			closeBtn = $('.clearBtn_'+slider_func),
			parent = closeBtn.parents('.filters-features-block');

		if (priceReset) {
					params[slider_from.attr('name')] = slider_from.val();
					params[slider_to.attr('name')] = slider_to.val();
				ajax_get_objects_search(path, params);
				ajax_get_field_search(params);
				parent.addClass('active');
			closeBtn.fadeIn();
			$('.clearBtn_form').fadeIn();
		}
		closeBtn.unbind().bind('click', function(){
			priceReset_init(slider_func);
			delete params[slider_from.attr('name')];
			delete params[slider_to.attr('name')];
			ajax_get_objects_search(path, params);
			ajax_get_field_search(params);
			parent.removeClass('active');
			closeBtn.fadeOut();
			return false;
		});
	};
	
	function priceReset_init(slider_res_name){
		priceReset = false;
			var	_slider = $('.slider_'+slider_res_name),
				min = _slider.data('min'),
				max = _slider.data('max'),
				slider_label = _slider.parents('.filters-features-block').find('.slider-label'),
				_begin = slider_label.find('.begin'),
				_end = slider_label.find('.end');
				
			_slider.slider( "option", "min", parseFloat(min) );
			_slider.slider( "option", "max", parseFloat(max) );
			_slider.slider( "option", "values", [parseFloat(min), parseFloat(max)] );
			$('.slider_from_'+slider_res_name, _slider).val(min);
			$('.slider_to_'+slider_res_name, _slider).val(max);
			_begin.text(accounting.formatMoney(min, " ", 0, " "));
			_end.text(accounting.formatMoney(max, " ", 0, " "));
		priceReset = true;
	};
	
	$('.button_remove').remove();
	
	
	select_block('#sort-field');
	
});