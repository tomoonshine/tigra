var map,myClusterer;

ymaps.ready(function(){
            var mapCanvas = jQuery('#maps');
            mapCanvas.html('');
             
          ymaps.geocode(mapCanvas.data('yandex-value'), { results: 1 }).then(function(res){
            // Выбираем первый результат геокодирования.
            var firstGeoObject = res.geoObjects.get(0);
                mapCanvas.html('');
                creat_map('maps', firstGeoObject.geometry.getCoordinates());
                drawMap(firstGeoObject.geometry.getCoordinates());
            });     

    });

function addCityInMaps(array_address){
    for (var key in array_address)
    ymaps.geocode(array_address[key], { results: 1 }).then(function (res) {
        // Выбираем первый результат геокодирования.
        var firstGeoObject = res.geoObjects.get(0);
            drawMap(firstGeoObject.geometry.getCoordinates());
    }, function (err) {
        // Если геокодирование не удалось, сообщаем об ошибке.
        alert(err.message);
    });
};

function drawMap(coord) {  
    myClusterer = new ymaps.Clusterer();     
    var placemark = new ymaps.Placemark(
       coord, {
            preset: 'twirl#blueStretchyIcon'
       }
    );
    myClusterer.options.set({preset: 'twirl#blueClusterIcons'});
    myClusterer.add(placemark);
    map.geoObjects.remove(myClusterer);
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
}

function creat_map(id_map, coord){
    var id_map = 'maps',
        coord = (coord) ? coord : [56.326944, 44.0075];
    map = new ymaps.Map(id_map, {
                center: coord,
                zoom: 13,
                type: 'yandex#map',
                behaviors: ['default']
            }, {maxZoom:16});
            
             //Добавляем элементы управления
            map.controls               
                .add('zoomControl')               
                .add('typeSelector')               
                .add('mapTools');
}