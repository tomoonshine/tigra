// указатель на последнюю выбраную категорию
var lastActive_link;
// класс последней выбраной категории
var lastActive_link_i_className;

// декадировщик спецсимволов
var htmlDecode = function (value) { 
	return $('<div/>').html(value).text(); 
} 

// получаем элементы указанной категории
function getCatalog(category,amount) {
	
	// поменять значок на ожидандие
	var elm_i = lastActive_link.getElementsByTagName('i')[0];
	if (elm_i) {
		lastActive_link_i_className = elm_i.className;
		elm_i.className = "fa waitCatalog";
	}
	
	// AJAX запрос
	jQuery.ajax({
		url     : 'udata/data/getSubCategoryCatalog/'+category+'/'+amount,
		type    : 'GET',
		async	: false,
		dataType: 'xml',
		success  : outCatalog
	});
}

// обработчик AJAX ответа
function outCatalog(data) {
	// декадируем в нормальную строку без замены спецсимволов
	var htmlcode = data.getElementsByTagName('htmlcode')[0].innerHTML;
	document.getElementById('catalog').innerHTML = htmlDecode(htmlcode);
	// выставить значок напротив категории
	var elm_i = lastActive_link.getElementsByTagName('i')[0];
	if (elm_i) {
		elm_i.className = lastActive_link_i_className;
	}
}

// замена цвета выбранной категории на активной а старой на обычный
function changeActive(elm) {
	// если есть активная категория то изменить класс
	if(lastActive_link) lastActive_link.className = 'title';
	// для выбраной задать класс
	elm.className = 'active_link';
	lastActive_link = elm;
}



// Функции для работы на страницах находящихся не на главных доменнах

// получаем элементы иэрархии каталога для указанного домена
function getCategoryList(domain) {
	alert(domain);
	// поменять значок на ожидандие
	//var elm_i = lastActive_link.getElementsByTagName('i')[0];
	//lastActive_link_i_className = elm_i.className;
	//elm_i.className = "fa waitCatalog";
	
	// AJAX запрос
	jQuery.ajax({
		url     : 'udata/data/GetMagazCatalog/'+domain,
		type    : 'GET',
		async	: false,
		dataType: 'xml',
		success  : outCategory
	});
}

// обработчик AJAX ответа getCategoryList
function outCategory(data) {
	// декадируем в нормальную строку без замены спецсимволов
	var htmlcode = data.getElementsByTagName('htmlcode')[0].innerHTML;
	document.getElementById('categoryList').innerHTML = htmlDecode(htmlcode);
	// выставить значок напротив категории
	//lastActive_link.getElementsByTagName('i')[0].className = lastActive_link_i_className;
}

// получаем элементы указанной категории
function getMagazCatalog(category,amount,domain) {
	// поменять значок на ожидандие
	var elm_i = lastActive_link.getElementsByTagName('i')[0];
	if (elm_i) {
		lastActive_link_i_className = elm_i.className;
		elm_i.className = "fa waitCatalog";
	}
	
	// AJAX запрос
	jQuery.ajax({
		url     : 'udata/data/getSubCategoryCatalogMagaz/'+category+'/'+amount+'/'+domain,
		type    : 'GET',
		async	: false,
		dataType: 'xml',
		success  : outMagazCatalog
	});
}

// обработчик AJAX ответа
function outMagazCatalog(data) {
	// декадируем в нормальную строку без замены спецсимволов
	var htmlcode = data.getElementsByTagName('htmlcode')[0].innerHTML;
	document.getElementById('catalog').innerHTML = htmlDecode(htmlcode);
	// выставить значок напротив категории
	var elm_i = lastActive_link.getElementsByTagName('i')[0];
	if (elm_i) {
		elm_i.className = lastActive_link_i_className;
	}
	// lastActive_link.getElementsByTagName('i')[0].className = lastActive_link_i_className;
}