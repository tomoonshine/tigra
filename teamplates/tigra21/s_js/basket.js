site.basket = {};

site.basket.amount = function(){
	jQuery('.goodsCount_amount').each(function(){
		var _this = jQuery(this),
			_this_input = _this.find('input'),
			_this_btn = _this.find('a');
			
			_this_btn.unbind().bind('click', function(){
				var btn = jQuery(this),
					val_amount = parseInt(_this_input.val(), 10);
					if (btn.hasClass('down')) {
						if (val_amount > 1) val_amount = val_amount-1; else val_amount = 1;
					} else val_amount = val_amount + 1;
					_this_input.val(val_amount).trigger( "change" );
				return false;
			});
			
			_this_input.keypress(function(e) {
				if(e.which!=8 && e.which!=0 && (e.which<48 || e.which>57)) return false;
				if(isNaN(parseInt(_this_input.val())))_this_input.val(1);
				return true;
			}).focusout(function(){
				if(isNaN(parseInt(_this_input.val())))_this_input.val(1);
			});
			/*.change(function(){
				if (_this_input.hasClass('amount-object')) {
					var price_object = $('#price-object .cost'),
						price_actual = parseFloat(price_object.data('actual'), 10),
						count = $(this).val();
						new_price = sum_additional(price_object.data('array-additional'));
					price_object.find('span').text(accounting.formatMoney(new_price + price_actual * count, " ", 0, " "));
				}
			});*/
			
	});
};

site.basket.replace = function(id) {
	return function(e) { console.log(e);
		var text, discount, goods_discount_price, goods_discount, item_total_price, item_discount, cart_item, basket, i, item, related_goods,only_price,
			cart_summary = jQuery('.cart_summary'),
			cart_summary_all = jQuery('.cart_summary_all'),
			delivery_price = (jQuery('input[name="delivery-id"]:checked').data('price')) ? jQuery('input[name="delivery-id"]:checked').data('price') : 0,
			cart_discount = jQuery('.cart_discount'),
			goods_discount_price = jQuery('.cart_goods_discount'),
			add_basket_button_text = 'В корзине',
			rem_item = true,
			detect_options = {},
			btnOrder = jQuery('#sticky-cart .stickyBasket__slide > .btn');

		if (e.summary.amount > 0) {
			text = (e.summary.price.original) ? e.summary.price.original : e.summary.price.actual;
			text = accounting.formatMoney(parseFloat(text, 10), " ", 0, " ");
			
			text_all = e.summary.price.actual;
			goods_discount = ((typeof e.summary.price.original == 'undefined') ? e.summary.price.actual : e.summary.price.original);
			goods_discount = accounting.formatMoney(parseFloat(goods_discount, 10), " ", 0, " ");
			
			discount = ((typeof e.summary.price.discount != 'undefined') ? e.summary.price.discount : '0');
			discount = accounting.formatMoney(parseFloat(discount, 10), " ", 0, " ");
			
			for (i in e.items.item) {
				item = e.items.item[i];
				if (item.id == id) {
					rem_item = false;
					item_total_price = item["total-price"].actual;
					item_total_price = accounting.formatMoney(parseFloat(item_total_price, 10), " ", 0, " ");
					
					item_discount = ((typeof item.discount != 'undefined') ? item.discount.amount : '0');
					item_discount = accounting.formatMoney(parseFloat(item_discount, 10), " ", 0, " ");
				}
				if (item.page.id == id) {
					if (detect_options.amount) {
						detect_options.amount = detect_options.amount + item.amount;
					}
					else detect_options = {'id':id, 'amount':item.amount};
				}
			}
			if (detect_options.amount) {
				var add_basket_button = jQuery('#add_basket_' + detect_options.id);
				if (add_basket_button[0].tagName.toUpperCase() == 'A' && !site.basket.is_cart) {
					add_basket_button.text(add_basket_button_text);
				}
				if (add_basket_button[0].tagName.toUpperCase() == 'FORM') {
					add_basket_button = jQuery('input:submit', add_basket_button);
					if(add_basket_button.length) {
						add_basket_button.val(add_basket_button_text);
					} else {
						add_basket_button = jQuery('button:submit', '#add_basket_' + detect_options.id);
						add_basket_button.text(add_basket_button_text);
					}
				}
				else add_basket_button.val(add_basket_button_text);
			}
			if (rem_item) {
				if (cart_item = jQuery('.cart_item_' + id)) {
					if(related_goods = jQuery('.cart_item_' + id + ' + tr.related-goods')) {
						related_goods.remove();
					}
					cart_item.remove();
					cart_summary.text(text);
					cart_summary_all.text(accounting.formatMoney(parseFloat(text_all + delivery_price, 10), " ", 0, " "));
					cart_summary_all.data('price', text_all);
					cart_discount.text(discount);
					goods_discount_price.text(goods_discount);
					jQuery('.basket tr').removeClass('even');
					jQuery('tr[class^="cart_item_"]:odd').addClass('even');
					jQuery('tr[class^="cart_item_"]:odd + .related-goods').addClass('even');
				}
			}
			else {
				jQuery('.cart_item_price_' + id).text(item_total_price);
				jQuery('.cart_item_discount_' + id).text(item_discount);
				cart_summary.text(text);
				cart_summary_all.text(accounting.formatMoney(parseFloat(text_all + delivery_price, 10), " ", 0, " "));
				cart_summary_all.data('price', text_all);
				cart_discount.text(discount);
				goods_discount_price.text(goods_discount);
			}
			only_price = (e.summary.price.prefix||'') + ' ' + text + ' ' + (e.summary.price.suffix||'.');
			text = '<strong class="stickyBasket__textAmount" data-amount="'+e.summary.amount +'" >'+e.summary.amount + '</strong> товаров на ' + only_price;
			jQuery('#sticky-cart .small_amount').addClass('notEmpty').text(e.summary.amount);
			jQuery('#sticky-cart .only-price').text(only_price);
			btnOrder.addClass('btn-primary');
			
			if(!site.basket.is_cart) {
			    $("#addTocart").modal('show');
			    $(".btn_line_"+id).removeClass('active');
			}
		}
		else {
			jQuery('#sticky-cart .small_amount').removeClass('notEmpty').text(0);
			text = 'товаров нет';
			if (basket = jQuery('.basket')) {
				var _htmlEmpty = '<div class="span12"><div class="content"><h1>Корзина</h1><p>Ваша корзина пуста.</p><p style="font-size:197px; text-align:center; color:#dddddd;"><i class="fa fa-shopping-cart"></i></p></div></div>';
				
				basket.html(_htmlEmpty);
				//basket.html('<h4 class="empty-content">В корзине нет ни одного товара.</h4><p>Вернитесь в <a href="/">каталог</a> и добавьте товары в корзину.</p>');
			}
			btnOrder.removeClass('btn-primary');
		}
		jQuery('.basket_info_summary').html(text);
		site.basket.modify.complete = true;
	};
};

site.basket.add = function(id, form, popup) {
	var e_name, options = {};
	$(".btn_line_"+id).addClass('active');
	if (form) {
		var elements = jQuery(':radio:checked', form);
		for (var i = 0; i < elements.length; i++) {
			e_name = elements[i].name.replace(/^options\[/, '').replace(/\]$/, '');
			options[e_name] = elements[i].value;
		}
		var select = jQuery('select', form);
		for (var i = 0; i < select.length; i++) {
			e_name = select[i].name.replace(/^options\[/, '').replace(/\]$/, '');
			options[e_name] = select[i].value;
		}
	}
	options['amount'] = jQuery('input[name="amount"]').val();
	basket.putElement(id, options, this.replace(id));
	if (popup) jQuery('#add_options_' + id).modal('hide');
};

site.basket.list = function(link) {
	var id = (link.id.indexOf('add_basket') != -1) ? link.id.replace(/^add_basket_/, '') : link;
	if (!id) return false;
	if (jQuery(link).hasClass('options_true')) {
		if (jQuery('#add_options_' + id).length == 0) {
			jQuery.ajax({
				url: '/upage//' + id + '?transform=modules/catalog/popup-add-options.xsl',
				dataType: 'html',
				success: function (data) {
				        
				    jQuery('body').append(data);
				   
    			    jQuery('div#add_options_' + id).on('hidden', function(){
    			        jQuery(this).remove();
						$(".btn_line_"+id).removeClass('active');
    			         //$("#addTocart").modal('show');
    			    });
			         jQuery('div#add_options_' + id).modal('show');
				     
					jQuery('form.options').submit(function() {
						if(!site.basket.is_cart) {
							site.basket.add(id, this, true);
							return false;
						}
					});
				}
			});
		}
	}
	else this.add(id);
};

site.basket.modify = function(id, amount_new, amount_old) {
	if (amount_new.replace(/[\d]+/) == 'undefined' && amount_new != amount_old) {
		basket.modifyItem(id, {amount:amount_new}, this.replace(id));
	}
	else this.modify.complete = true;
};

site.basket.modify.complete = true;

site.basket.remove = function(id) {
	if (id == 'all') basket.removeAll(this.replace(id));
	else basket.removeItem(id, this.replace(id));
};

site.basket.get = function() {
	basket.get(this.replace(-1));
};

site.basket.init = function() {
	this.is_cart = (!!jQuery('.basket table').length);
	jQuery('.basket_list').unbind('click').live('click',function(){
		if (!site.basket.is_cart || !jQuery(this).hasClass('options_false')) {
			site.basket.list(this);
			return false;
		}
		
		return false;
	});
	jQuery('form.options').submit(function(){
		var id = (this.id.indexOf('add_basket') != -1) ? this.id.replace(/^add_basket_/, '') : this;
		site.basket.add(id, this);
		return false;
	});
	jQuery('.cart a.del').click(function(){
		site.basket.remove(this.id.match(/\d+/).pop());
		return false;
	});
	jQuery('.cart a.basket_remove_all').click(function(){
		site.basket.remove('all');
		return false;
	});
	jQuery('.cart input.amount').bind('keyup', function() {
		if(0 > parseInt(this.value))
			this.value = Math.abs(this.value);
		if (site.basket.modify.complete) {
			site.basket.modify.complete = false;
			var amountThis = this;
			setTimeout(function() {
				var id = parseInt(jQuery(amountThis).attr('id').split('_').pop()),
				e = jQuery(amountThis).next('input'),
				old = e.val();
				e.val(amountThis.value);
				site.basket.modify(id, amountThis.value, old);
			}, 500)
		}
	});
	jQuery('.cart .up').click(function(){
		if (site.basket.modify.complete) {
			site.basket.modify.complete = false;
			var id = parseInt(this.getAttribute('id').split('_').pop()),
			e = this.previousSibling,
			old = e.value;
			e.value = (parseInt(old) + 1);
			e.previousSibling.value = e.value;
			site.basket.modify(id, e.value, old);
		}
		return false;
	});
	jQuery('.cart .down').click(function(){
		if (site.basket.modify.complete) {
			site.basket.modify.complete = false;
			var id = parseInt(this.getAttribute('id').split('_').pop()),
			e = this.nextSibling.nextSibling,
			old = e.value;
			e.value = (parseInt(old) - 1);
			e.previousSibling.value = e.value;
			site.basket.modify(id, e.value, old);
		}
		return false;
	});
	site.basket.amount();
};

jQuery(document).ready(function(){site.basket.init()});