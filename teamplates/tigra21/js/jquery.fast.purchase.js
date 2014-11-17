var cart = {},
    testValidateObject = {'address-block': '', 'address-choose': 'Выберите адрес доставки', 'delivery-choose': 'Выберите способ доставки', 'payment-choose': 'Выберите способ оплаты'};

cart.init = function(){       
        
    cart.city();
    cart.delivery();
    cart.payment.init();
	
	jQuery('.order-comments .title-wrap').unbind().bind('click', function(){
		var _this = jQuery(this);
			_this.next().slideToggle();
		return false;
	});
    
    jQuery('#cart_form').submit(function(){
        var testValidate = false,
            form = this,
            _form = $(form),
            _inputRequired = _form.find('.other-field-address .required :input'),
            result = false,
            j = 0,
            check = false;
            
            jQuery('.error-message').remove();
             if(_form.hasClass('issued')) return false;
            check = site.forms.data.check(form);
        if (!check) return check;
        
            check = false;
        for (var key in testValidateObject){
            if (key=='address-block'){
                j++;
                continue;
            }
            var value = testValidateObject[key];
            if(typeof value == 'string'){
                jQuery('.custom-wrap', '#'+key).append('<div class="error-message">'+ value +'</div>');
            
            } else {
                if(value === true){
                    j++;
                } else {
                    j--;
                }
            };
        };
		
        if(testValidateObject['address-block']=='new'){
            testValidateObject['address-choose']='';
            check = false;
			var defReadyJ = j;
            jQuery.each(_inputRequired, function(index){
                var _input = _inputRequired.eq(index);
                check = site.forms.errors.check(_input[0]);
            });
			if(check) {j++;}
        }
       
        if(j>= 4) check = true; else check = false;
		
        if(check) {
            _form.addClass('issued');
            _form.find(':submit').hide();
            _form.find('.loading-order').show();
        }
		
		if (window.paymentId && check) {
			var checkPaymentReceipt = function(id){
				if (jQuery('input[name="payment-id"]:checked', _form).hasClass('receipt')) {
					var url = '/emarket/saveinfo/';
					var win = window.open("", "_blank", "width=710,height=620,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no");
					win.document.write("<html><head><" + "script" + ">location.href = '" + url + "?payment-id=" + _form.serialize() + "'</" + "script" + "></head><body></body></html>");
					win.focus();
					return false;
				} else return true;
			}
			return checkPaymentReceipt(window.paymentId);
		}
		
        return check;
    });
};

cart.submit = false;

cart.delivery = {};
cart.delivery = function(){
    var deliveryAddress = cart.delivery.deliveryAddress.getInput(),
        deliveryId = cart.delivery.deliveryId.getInput(),
        otherFieldAddress = $('.other-field-address'),
        new_address = jQuery('#new-address'),
        notNew = cart.delivery.deliveryAddress.getInput(true);
        $('#payment-choose, #delivery-choose').hide();
   
    jQuery.each(deliveryAddress, function(index){
        var _this = deliveryAddress.eq(index);
            cart.delivery.addressBlock(_this);
            if (_this.val() == 'new') {
            cart.city();
            if(deliveryAddress.length == 1) testValidateObject['address-choose'] = true;
            return false;} 
            cart.viewField.delivery(deliveryId, cart.arrCompare(_this.data('city'),  cart.delivery.deliveryId.getArrayCity()), 'delivery-choose');
    });
    
    deliveryAddress.change(function(){
        var _this = jQuery(this);
        _this.attr('checked','checked').trigger('refresh');
        //cart.delivery.addressBlock(_this);
        otherFieldAddress.hide();
        if (_this.val() == 'new') {
            otherFieldAddress.show();
            testValidateObject['address-block'] = 'new';
            testValidateObject['address-choose'] = (deliveryAddress.length == 1) ? true : '';
        } else {
            testValidateObject['address-block'] = true;
            testValidateObject['address-choose'] = true;
        }
        jQuery('#address-choose .error-message').remove();
    });
    
    deliveryId.change(function(){
        var _this = jQuery(this),
            payment = _this.data('payment'),
            requestAddress = _this.data('request-address'),
			orderComments = $('.row-fluid.order-comments');
            
        _this.attr('checked','checked').trigger('refresh');
        
        if (notNew.hasClass('not-view')) notNew.attr('checked', 'checked').trigger('refresh');
            else notNew = cart.delivery.deliveryAddress.getInput(true);
        
        if (requestAddress) {           
            if (notNew.val() == 'new') otherFieldAddress.show(); else otherFieldAddress.hide();
            testValidateObject['address-choose'] = (deliveryAddress.length == 1) ? true : 'Выберите адрес доставки';
            new_address.show();
        } else {
            if (notNew.val() == 'new') notNew.removeAttr('checked').trigger('refresh');
            otherFieldAddress.hide();
            new_address.hide();
            testValidateObject['address-choose'] = true;
        }
        
        testValidateObject['delivery-choose'] = true;
        jQuery('#delivery-choose .error-message').remove();
        cart.viewField.payment(payment, 'payment-choose');
		orderComments.show();
    });
    
};
cart.delivery.addressBlock = function(input){
    var new_address = jQuery('#new-address');
    if (input[0].checked && input.val() == 'new') {
        testValidateObject['address-block'] = 'new';
        new_address.show();
    } else {
        testValidateObject['address-block'] = '';
        new_address.hide();
    }
};

cart.viewField = new function(){
    var self = this;
        this.delivery = function(inputs, index, block){
            var controlGroupBlock = jQuery('#' + block),
                controlGroup = jQuery('.control-group', controlGroupBlock);
    
                controlGroup.hide();
                controlGroup.find('input').removeAttr('checked').trigger('refresh');
                
            for (var key in index){
                var id = inputs.eq(index[key]).val();
                    jQuery('.control-group-'+id, controlGroupBlock).show();
            }
        };
        this.payment = function(payment, block){
            var paymentBlock= jQuery('#'+block).show(),
                controlGroup = paymentBlock.find('.control-group');
            if (!payment.length) {
                controlGroup.show();
                return false;
            }
            controlGroup.hide();
            controlGroup.find('input').removeAttr('checked').trigger('refresh');
            
            for (var key in payment){
                    jQuery('#'+block + ' .control-group-'+payment[key]).show();
            }
        };
};

cart.arrCompare = function(need, arrHeand) {
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

cart.delivery.deliveryAddress = new function(){
    var self = this;
        this.getInput = function(checked){
            var chek = (checked == true) ? ":checked" : ""; 
            return jQuery('input[name="delivery-address"]' + chek);
        };
};

cart.delivery.deliveryId = new function(){
    var self = this;
        this.getInput = function(){ return jQuery('input[name="delivery-id"]'); };
        this.getArrayCity = function(){
            var addressInput = self.getInput(),
                i = 0,
                result = new Array();
                
                $.each(addressInput, function(index){
                    var _this = addressInput.eq(index);
                    result[i] = _this.data('city'); i++;
                });
            return result;
        }
};

cart.payment = new function(){
    var self = this;
        this.getInput = function(){ return jQuery('input[name="payment-id"]'); };
        this.init = function(){
            var paymentInput = self.getInput();
            paymentInput.change(function(){
                var _this = jQuery(this);
                _this.attr('checked','checked').trigger('refresh');
                cart.submit = true;
                testValidateObject['payment-choose'] = true;
                jQuery('#payment-choose .error-message').remove();
            });
        }
};
cart.city = function(){
    var city = jQuery('#city'),
        city_id = city.val(),
        devChooseBlock = $('#delivery-choose'),
		orderComments = $('.row-fluid.order-comments');
        deliveryId = this.delivery.deliveryId.getArrayCity();
        cart.viewField.delivery(cart.delivery.deliveryId.getInput(), cart.arrCompare(city_id, deliveryId), 'delivery-choose');
                
        if (city_id == "") { devChooseBlock.hide(); $('.other-field-address').hide(); } else devChooseBlock.show();
        
    city.change(function(){
        var _this = jQuery(this);
        $('.other-field-address').hide();
        $('#payment-choose .control-group').hide();
        $('#new-address').hide();
        if (_this.val() == "") {devChooseBlock.hide();orderComments.hide();} else {devChooseBlock.show();orderComments.show();}
        cart.viewField.delivery(cart.delivery.deliveryId.getInput(), cart.arrCompare(_this.val(), deliveryId), 'delivery-choose');
    });
};

(function($){
    $(function(){
        cart.init();
    });
 })(jQuery);