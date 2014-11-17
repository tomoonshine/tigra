/**
 * @author Фарит Баширов
 */

price = {}

price.init = function(){
   var inputs = jQuery('input[name^="options\["]'),
       input = jQuery('input[name^="options\["]:checked').eq(0);
    
    jQuery.each(input, function(){
        var _this = jQuery(this),
            optionPrice = parseFloat(_this.data('float'), 10);
        price.get(optionPrice);
    });
    
    inputs.bind('change', function(){
        var _this = jQuery(this),
            optionPrice = parseFloat(_this.data('float'), 10);
        _this.attr('checked','checked');
        price.get(optionPrice);
    });
};

price.get = function(optionPrice){
    if (isNaN(optionPrice)) return;
    var priceObject = jQuery('.tab-pane.active #price'),
        currency = this.currency(priceObject),
        priceSumarry = this.sumarry(priceObject, optionPrice),
        prefix = (currency.prefix) ? currency.prefix + ' ' : '',
        suffix = (currency.suffix) ? ' ' + currency.suffix : '',
        formatMoney = false;
        
    if(!priceSumarry) return;
    if (typeof accounting.formatMoney == 'function') {
        formatMoney = true;
    }
    
    if (priceSumarry.original) {
        var original = (formatMoney) ? accounting.formatMoney(parseFloat(priceSumarry.original, 10), " ", 0, " ") : priceSumarry.original;
        priceObject.find('.old>span').text(original);
    }
    
    var actual = (formatMoney) ? accounting.formatMoney(parseFloat(priceSumarry.actual, 10), " ", 0, " ") : priceSumarry.actual;
    priceObject.find('.new>span').text(actual);
};

price.currency = function(object){
    if (!object) return false;
    var suffix = object.data('suffix'),
        prefix = object.data('prefix'),
        result = new Array();
    if (prefix) result['prefix'] = prefix; 
    else if (suffix) result['suffix'] = suffix; else result = false;
    return result;
};

price.sumarry = function(object, optionPrice){
    if (!object) return;
    var actual = parseFloat(object.data('actual'), 10),
        original = parseFloat(object.data('original'), 10),
        result = new Array();
   if (!isNaN(original)) {
       result['original'] = original + optionPrice;
       result['actual'] = this.sumarry.actual(original, actual, optionPrice);
   } else if (!isNaN(actual)) {
       result['actual'] = actual + optionPrice;
   } else result = false;
   
   return result;
};

price.sumarry.actual = function(original, actual, optionPrice){
    if (isNaN(actual)) return;
    var discountPrice = original - actual,
        discountProc = (discountPrice * 100) / original,
        original = original + optionPrice;
        newActual = original - ((original * discountProc) / 100);
    return newActual;  
};


(function($){
    
    $(function(){
        price.init();
    });
    
})(jQuery);
