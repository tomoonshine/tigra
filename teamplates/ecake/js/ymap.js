var map,myClusterer,icoord,
	loader = jQuery('.loader'),
	loader_text = jQuery('.overlay_form, .text_loader'),
	projects_list_content = jQuery('.active-stores');
	loader_text.show();

ymaps.ready(function () {
		
			jQuery('#mapsID').html('');
			map = new ymaps.Map('mapsID', {
				center: [56.326944, 44.0075],
				zoom: 9,
				type: 'yandex#map',
				behaviors: ['default']
			}, {maxZoom:16});
			
			 //Добавляем элементы управления
			map.controls               
				.add('zoomControl')               
				.add('typeSelector')               
				.add('mapTools');
													
			myClusterer = new ymaps.Clusterer();         
				$('form.filter select').change(function(){
					
					do_search($(this).attr('id'), true);    
					return false;
				}); 
				
			$('.moveToMap', projects_list_content).live('click', function(){
				var _this = $(this),
					coord = new Array();
				if (_this.data('lon') && _this.data('lat') && !_this.hasClass('stopMove')) { coord = [_this.data('lat'), _this.data('lon')]  } else return false;
					
				map.panTo(coord, {
					flying	: false,
					callback: function(){map.setZoom(16);}
				});
				
				
				return false;
			});
			 /* $("#selecttown").change(function () {              
						town = $("#selecttown :selected").val();    
						do_search(town);         
			 }); */
			 do_search();         

	})

function do_search(select, not_foreach){
	var params = $('form.filter').serialize(),
		loader_text_timeout = setTimeout(function(){ loader_text.show(); }, 500);
		params = (not_foreach) ? params + '&not_foreach='+not_foreach :  params + '&not_foreach='+false;
	loader.show();
	
	projects_list_content.hide();
     $.getJSON("/udata/maps/allPoints/", params, function(data){
         clearTimeout(loader_text_timeout);
		  //console.log(data);
          drawMap(data,select);
     });
}

function drawMap(data,select) {    
	var json =data.list;	
	var select_vals =data.select;
	var not_change_select = false;
	
	for (var i in select_vals) {
		var select_name = select_vals[i].name,
			select_options = select_vals[i].options,
			options_str ='';
		
		
		if(select==select_name) not_change_select = true;
		
		if(not_change_select){
			for (var j in select_options) {
				var option_id = select_options[j].id,
					option_name = select_options[j].name;
				//console.log(option_id);
				//console.log(option_name);
				options_str = options_str+'<option value="'+option_id+'">'+option_name+'</option>';
			}
			
			
			var select_obj = jQuery('#'+select_name).not('#'+select),
				selected_id = jQuery(':selected', select_obj).val();
			
			jQuery('option', select_obj).not(':first-child').remove();
			
			select_obj.append(options_str).find('option[value="'+selected_id+'"]').attr('selected','selected');
		}
    }
	
     myClusterer.removeAll();

	 var more_info_list='',flag=false, count = 1;
	 
	 for (var i in json){
		var baloonContent = '',
			real_shop = json[i].real_shop,
			info = json[i].info,
			class_click = (real_shop == 0) ? 'stopMove' : '';
			/*baloonContent = '<tr class="project_item"><td class="not_visible_ymap"><div class="project_item_icon">'+((json[i].icon_content != false && json[i].icon_content != 0) ? '<b class="icon-fake-yandex">' + json[i].icon_content + '</b>' : '') +'</div></td><td>'+((json[i].name != false && json[i].name != null) ? '<div class="set descr_line"><a href="#" class="moveToMap '+class_click+'" data-lat="'+json[i].lat+'" data-lon="'+json[i].lon+'">' + json[i].name + '</a></div>' : '') + ((info.metro != false && info.metro != null) ? '<div class="metro descr_line">м. ' + info.metro + '</div>' : '') + ((info.address != false && info.address != null) ? '<div class="adres descr_line">' + info.address + '</div>' : '') + ((info.operating_mode != false && info.operating_mode != null) ? '<div class="operating_mode descr_line">' + info.operating_mode + '</div>' : '') + ((info.content != false && info.content != null) ? '<div class="content_val descr_line">' + info.content + '</div>' : '') + '</div>' + ((info.phone != false && info.phone != null) ? '<div class="descr_line">' + info.phone + '</div>' : '') +' '+ ((info.email != false && info.email != null) ? '<div class="descr_line">' + info.email + '</a></div>' : '') + '</td></tr>';*/
			
			baloonContent = '<li>'+((json[i].name != false && json[i].name != null) ? '<h3 class="moveToMap" data-lat="'+json[i].lat+'" data-lon="'+json[i].lon+'">' + json[i].name + '</h3>' : '')+'<small class="distance" style="display: none">0.4 miles away</small><p><img src="//chart.apis.google.com/chart?chst=d_map_pin_letter&amp;chld='+count+'|00BDFF|000000" alt="count" />' + ((info.address != false && info.address != null) ? info.address : '') + '</p></li>';
		
		if(real_shop == 1){
			var pointStyleVal = 'twirl#blueStretchyIcon';
			var j = i+1;
			
			myClusterer.options.set({preset: 'twirl#blueClusterIcons'});

			var placemark = new ymaps.Placemark(
			   [json[i].lat,json[i].lon], {
					iconContent: json[i].icon_content
					//balloonContentBody: '<ol class="active-stores">'+baloonContent+'</ol>'  
			   }, {
					preset: pointStyleVal
			   }
			);
			myClusterer.add(placemark);
			flag=true;
		}
		more_info_list = more_info_list+baloonContent;
		count++;
	}
	 
	 if(flag){
		 map.geoObjects.add(myClusterer);

		 map.setBounds(myClusterer.getBounds(), {
			  zoomMargin:40,
			  //checkZoomRange: true,
			  callback: function(err) {
				   if (err) {
						// Не удалось показать заданный регион
						// ...
				   }      
			  }
		 });

		if(map.getZoom() > 9 ){
			map.setZoom(9, {duration: 1000});
		}
	}
	loader.hide();
	loader_text.hide();
	projects_list_content.html(more_info_list).show();
	
}
