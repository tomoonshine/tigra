/**
 * @author Фарит Баширов
 */

(function($){
    
    $(function(){
        
        if (typeof uAdmin == 'function'){
            var imageEIP = $('*.u-eip-edit-box[umi\\:gallery-split="true"]');
                imageEIP.removeClass('u-eip-edit-box u-eip-empty-field');
                imageEIP.unbind('click');
                imageEIP.unbind('mouseover');
                imageEIP.unbind('mouseout');
                imageEIP.unbind('mousedown');
                imageEIP.unbind('mouseup');
                imageEIP.die('click');
                imageEIP.die('mouseover');
                imageEIP.die('mouseout');
                imageEIP.die('mousedown');
                imageEIP.die('mouseup');
                
            imageEIP.addClass('u-eip-edit-box-gallery').on('click', function(){
                 var _this = $(this),
                    id = _this.attr('umi:element-id');
                jQuery.ajax({
                    url: '/upage//' + id + '?transform=library/edit-gallery-photo.xsl',
                    dataType: 'html',
                    success: function (data) {
                            
                        jQuery('body').append(data);
                        uploadImage.init();
                        jQuery('div#edit_photo_' + id).on('hidden', function(){
                            jQuery(this).remove();
                        });
                         jQuery('div#edit_photo_' + id).modal('show');
                         
                    }
                });
                return false;
            });
            
        }
        
    });
    
})(jQuery);
