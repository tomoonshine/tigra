<?php
class data_custom extends def_module {
	/*
		возвращает дату в необходимом формате, имеет возможность расширяться для вывода русских дат
		Пример вывода <xsl:value-of select="document(concat('udata://data/dateru/',.//property[@name = 'publish_time']/value/@unix-timestamp))/udata"/>
		В данный момент использование параметра @format, не работает
	*/
	public function dateru($time=NULL,$format=NULL) {
		$allowDateFormat = array('d','n','Y','months_ru');
		$months_ru = array(1 => 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря');
		
		if(!$time) $time=time();
		if(!$format) $format="%d% %months_ru% %Y%";
		
		$sTemplate  = str_replace(array("&#037;", "&#37;"), "%", $format);
		preg_match_all("/%[A-z0-9_]+%/", $sTemplate, $aMarks);
		//var_dump($aMarks);
		foreach($aMarks[0] as $sMark){
			$param=str_replace("%", "", $sMark);
			if(in_array($param,$allowDateFormat)){
				if($param=='months_ru'){
					$month = date('n', $time);
					$sTemplate = str_replace($sMark,  $months_ru[$month], $sTemplate);
				}/* elseif($param=='Y'){
					$year = date('Y', $time);
					if($year == date('Y')) $year_val = '';
					else $year_val = $year.' года.';
					$sTemplate = str_replace($sMark,  $year_val, $sTemplate);
				} */else {
					$sTemplate = str_replace($sMark,  date($param, $time), $sTemplate);
				}
			}
		}
		return $sTemplate;
	}
	
	
	/*
		возвращает список дочерних типов, детей $parent
		
	*/
	public function getSubCategory($parent=NULL) {
	
		if(!$parent) return;
		
		// echo "<br/>begin test";
		
		$typesCollection = umiObjectTypesCollection::getInstance();
		$objChld = $typesCollection->getSubTypesList($parent);
		
		$block_arr = Array();
		$lines = Array();
		$length = 0;
		foreach($objChld as $objID){
			$obj = $typesCollection->getType($objID);

			$line_arr = array();
			$line_arr['attribute:id'] = $objID;
			$line_arr['attribute:name'] = $obj->getName();
			
			$lines[] = $line_arr;
			$length++;
		}
		
		$block_arr['subnodes:items'] = $lines;
		$block_arr['total'] = $length;
		
		return $this->parseTemplate('', $block_arr, null);

		// echo "<br/>end test";
		
		return;
	}
	
	/* 
		Вывод товаров указанной категории со всех магазинов
		не более $amount в случайной выборке
	*/
	public function getProducts($categoryID=NULL, $amount=0) {
		
		//echo "<br/>begin getProducts";
		
		if (!$categoryID) return;
		if ($amount == 0) return;
		
		// массив категорий по каторым нужно сделать отбор
		$categories = array($categoryID);
		// получаем все подкатегории
		$categories = array_merge($categories, $this->getChildren($categoryID));
		
		// Нуно сделать выборку элементов
		$goods = new selector('objects');
		// задаються типы объектов для поиска
		foreach($categories as $cat) $goods->types('object-type')->id($cat);
		// не нужны объекты без имён
		$goods->where('name')->isnotnull(false); 
		// количество элементов для отбора
		$goods->limit(0,$amount);
		// сортировочка в случайном порядке
		$goods->order('rand');
		
		// будем работать с хиерархией
		$hierarchy = umiHierarchy::getInstance();
		// на всякий случай вдруг понядобиться домен
		$domainsCollection = domainsCollection::getInstance();
		// Переменный для формирования выходной структуры xml
		$block_arr = Array();
		$lines = Array();
		$length = 0;
		foreach($goods as $obj) {
			// полйчить все страницы объектом данных для которых являеться $obj
			$pageId = $hierarchy->getObjectInstances($obj->id, true);
			$page = $hierarchy->getElement($pageId[0]);
			$line_arr = array();
			$host = $domainsCollection->getDomain($page->getDomainId())->getHost();
			$mainPageId = $hierarchy->getIdByPath($host.'/main/');
			$mainPage = $hierarchy->getElement($mainPageId);
			
			$line_arr['attribute:pageId'] = $page->id;
			$line_arr['attribute:object-id'] = $obj->id;
			$line_arr['attribute:name'] = $obj->name;
			$line_arr['attribute:h1'] =  $page->h1;
			$line_arr['attribute:price'] = $page->price;
			$line_arr['attribute:domain'] = $host;
			$line_arr['attribute:shopName'] = $mainPage->nazvanie_magazina;
			$line_arr['attribute:link'] = $page->link;	
			// если имеються картинки то добавляем первую из всех
			$jsonFILE = $page->tigra21_image_gallery;
			$jsonFILE = json_decode($jsonFILE, true);
			if(!empty($jsonFILE)) {
				$line_arr['attribute:image']= $jsonFILE['0']['src'];
			}
		
			$lines[] = $line_arr;
			$length++;
		}

		if ($length != 0) $block_arr['subnodes:items'] = $lines;
		$block_arr['total'] = $length;
		
		return $this->parseTemplate('', $block_arr, null);
		
		//echo "<br/>end getProducts";
	}

	/*
		Функция рекурсивного перебора потомков $objID в umiObjectTypesCollection
	*/
	public function getChildren($objID) {
		
		// получим список дочерних объектов
		$typesCollection = umiObjectTypesCollection::getInstance();
		$objChldren = $typesCollection->getSubTypesList($objID);
		
		// поиск потомков $objID все потомки со своими потомкамиесли они существуют записываються 
		// в массив $array и возвращаються функцией
		$array = array();
		foreach($objChldren as $objChild){
			$array[] = $objChild;
			$array = array_merge($array,$this->getChildren($objChild));
		}
		return $array;
	}
	/*
		
		Вывод товаров в количестве &amount рандом указанной категории и входящих в нее категорий
		в формате html требуется htmlDecode для обработки после получения ajax запросом
	
	*/
	public function getSubCategoryCatalog($categoryID=NULL, $amount=0) {
		
		// если нихрена не задано то ну его нафиг
		if (!$categoryID) return;
		if ($amount == 0) return;

		// массив категорий по каторым нужно сделать отбор
		$categories = array($categoryID);
		// получаем все подкатегории
		$categories = array_merge($categories, $this->getChildren($categoryID));
		
		// Нуно сделать выборку элементов
		$goods = new selector('objects');
		// задаються типы объектов для поиска
		foreach($categories as $cat) $goods->types('object-type')->id($cat);
		// не нужны объекты без имён
		$goods->where('name')->isnotnull(false); 
		// количество элементов для отбора
		$goods->limit(0,$amount);
		// сортировочка в случайном порядке
		$goods->order('rand');
		
		// будем работать с хиерархией
		$hierarchy = umiHierarchy::getInstance();
		// на всякий случай вдруг понядобиться домен
		$domainsCollection = domainsCollection::getInstance();
		// Переменный для формирования выходной структуры xml
		$block_arr = Array();
		$htmlcode = ' ';
		$length = 0;
		foreach($goods as $obj) {
			// полйчить все страницы объектом данных для которых являеться $obj
			$pageId = $hierarchy->getObjectInstances($obj->id, true);
			$page = $hierarchy->getElement($pageId[0]);
			
			// если имеються картинки то добавляем первую из всех
			$src = ' ';
			$jsonFILE = $page->tigra21_image_gallery;
			$jsonFILE = json_decode($jsonFILE, true);
			if(!empty($jsonFILE)) {
				$src= $jsonFILE['0']['src'];
			}
			$host = $domainsCollection->getDomain($page->getDomainId())->getHost();
			$mainPageId = $hierarchy->getIdByPath($host.'/main/');
			$mainPage = $hierarchy->getElement($mainPageId);
			
			// структура html
			$htmlcode =	$htmlcode . '<li umi:element-id="' . $page->id . '" umi:region="row" class="standard">'
							. '<div class="image">'
								. '<a title="' . $obj->name .'" umi:element-id="' . $page->id . '" class="image-link" href="' .  $page->link . '">'
									. '<div style="width:170px; height: 170px" class="image_crop_block">'
										. '<img width="170" title="' . $obj->name . '" alt="' . $obj->name . '" class="primary" src="' . $src .'"></img>'
									. '</div>'
								. '</a>'
								. '</div>'
								. '<div class="title">'
									. '<a title="' .$mainPage->nazvanie_magazina . '" href="http://'. $host . '">'
										. '<h3>'.$mainPage->nazvanie_magazina.'</h3>'
									. '</a>'
									. '<a title="товар 2" href="'. $page->link .'">'
										. '<h3 umi:field-name="name" umi:element-id="'. $page->id.'" class="u-eip-edit-box" title="Нажмите Ctrl+левая кнопка мыши, чтобы перейти по ссылке.">товар 2</h3>'
										. '<div class="prices">'
											. '<span class="price">'.$page->price.'</span> руб'
										. '</div>'
										. '</a>'
									. '<div class="btn_line add_from_list btn_line_">'
										. '<i class="fa fa-spinner fa-spin"></i>'
									. '</div>'
									. '<div style="margin:20px"></div>'
								.' </div>'
						. '</li>';
			
			$length++;
		}

		// if ($length != 0) $block_arr['subnodes:items'] = $lines;
		$block_arr['total'] = $length;
		$block_arr['htmlcode'] = $htmlcode . '<div class="clear"></div>';
		return $this->parseTemplate('', $block_arr, null);
	}
	
	
	
	/*
		функция добавляет новый домен, настраивает ему шаблон, и добавляет
		главную страницу 
		каталог товаров
	*/
	public function addNewShop($domenName=NULL, $name){
	
		if (!$domenName) $domenName = getRequest('shopName');
		
		// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);
		
		// Проверка на существование домена в системе с таким же именем
		$collection = domainsCollection::getInstance(); 
		$domains = $collection->getList();
		foreach ($domains as $domain) {
			$host = $domain->getHost();
			if($domenName.".tigra21.ru" == $host)
			{
				// echo "<br/>домен существует ";
				$this->errorAddErrors('Магазин с таким названием уже есть');
				$this->errorThrow('public');
			}
		}
		
		// получить текущего пользователя 
		$permissions = permissionsCollection::getInstance();
		$userId = $permissions->getUserId();
		$objectsCollection = umiObjectsCollection::getInstance();
		$user = $objectsCollection->getObject($userId);
		
		// проверить текущего пользователя на наличее магазина
		if ($user->getValue('shopid')) {
			$this->errorAddErrors('На данного пользователя уже зарегистрирован один магазин');
			$this->errorThrow('public');
			// echo "<br/>Магазин у пользователя есть ";
			// return;
		}
		
		// добавление домена
		// язык в системе по умолчанию, нужен при добавлении нового домена
		$defLangId = $collection->getDefaultDomain()->getDefaultLangId();
		// а ну-ка добавь новый домен
		$newDomainId = $collection->addDomain($domenName.".tigra21.ru", $defLangId);
		if($newDomainId === false) {
			$this->errorAddErrors('Неудалось создать магазин ошибка с доменом. Попробуйте позднее или обратитесь к администратору сайта.');
			$this->errorThrow('public');
			// echo "Не удалось создать новую страницу";
			// return;
		}

		// Записывает домен к пользователю
		$user->setValue('shopid', $newDomainId);
		$user->setValue('magazin', $domenName);

		// настройка шаблона
		$collection = templatescollection::getInstance(); 
		// добавляем шаблон к новому домену
		$newTmplId = $collection->addTemplate("default.xsl","Основной",$newDomainId,$defLangId,true);
		// настраиваем имя шаблона в templates
		$collection->getTemplate($newTmplId )->setName("tigra21");
		
		// добавление главной страницы и каталога
		$hierarchy = umiHierarchy::getInstance(); 
		
		// добавить Главную страницу тип страницы 1058 Главная страница магазина
		$newPageId = $hierarchy->addElement(0,1058,"Главная","main",1058,$newDomainId,$defLangId,$newTmplId);
		if($newPageId === false) {
			$this->errorAddErrors('Не удалось создать главную страницу. Обратитесь к администратору сайта.');
			$this->errorThrow('public');
			// echo "Не удалось создать новую страницу";
			// return;
		}
		 
		//Установим права на страницу в состояние "по умолчанию"
		$permissions->setDefaultPermissions($newPageId);
		
		// // Вывставить права на страницу просмотр всем
		// $permissions->setElementPermissions(13,$newPageId,1);
		
		// выставить страница по умолчанию и активная
		$page = $hierarchy->getElement($newPageId); 
		$page->setIsActive(true);
		$page->setIsDefault(true);
		// запишем название магазина
		$page->nazvanie_magazina = $name;
		// запишымшымшым идентификатор пользователя
		$page->polzovatel = $userId;
		
		
		// добавить Каталог тип 82
		$newPageId = $hierarchy->addElement(0,82,"Товары","goods",82,$newDomainId,$defLangId,$newTmplId);
		if($newPageId === false) {
			$this->errorAddErrors('Не удалось создать каталог товаров. Обратитесь к администратору сайта.');
			$this->errorThrow('public');
			// echo "Не удалось создать новую страницу";
			// return;
		}
		 //Установим права на страницу в состояние "по умолчанию"
		$permissions->setDefaultPermissions($newPageId);
		// $permissions->setElementPermissions(13,$newPageId,1);
		$page = $hierarchy->getElement($newPageId); 
		$page->setIsActive(true);
		
		// Перевод пользователя в личный кабинет
		$this->redirect($this->pre_lang . "/users/settings/");
	}
	
	
	public function test() {
		echo "<br/>begin test";
		
		// Проверка на существование домена в системе с таким же именем
		$collection = domainsCollection::getInstance(); 
		$domains = $collection->getList();
		$domainID = $collection->getDomainId('test.tigra21.ru');
		//echo "<br/>domain " . $domainID;
		$domain =  $collection->getDomain($domainID);
		
		
		
		$typesCollection = umiObjectTypesCollection::getInstance();
		$objType = $typesCollection->getType(210);
		
		
		// $goods = new selector('objects');
		// $goods->types('object-type')->id(210);
		// $goods->types('object-type')->id(211);
		
		// $goods = new selector('pages');
		// $goods->types('hierarchy-type')->name('catalog', 'object');
		// $goods->where('object-id')->equals('211');
		//$goods->types('elementTypeId')->id(210);
		//$goods->types('object-type')->id(211);
		//$goods->order('rand');
		
		
		// foreach($goods as $obj) {
			// echo "<br/> ID: " . $obj->id;
			// echo " | name: " .  $obj->name;
			// echo " | link: " .  $obj->link;
		// }
		
		// echo "<br/>Total goods:{$goods->length}";
		$hierarchy = umiHierarchy::getInstance();
		$objects = $hierarchy->getObjectInstances('10362', true);
		echo "<br/> page id: ";
		echo $objects[0];
		
		// $pages = new selector('pages');
		// $pages->types('object-type')->id(210);
		// $pages->types('hierarchy-type')->name('catalog', 'object');
		// //$pages->where('price')->eqless(500);
		// foreach($pages as $page) {
			// echo "<br/><a href=\"{$page->link}\">{$page->name}</a>";
			// echo " | " . $page->getObjectTypeId();
		// }
		// echo "Pages found: {$pages->length}";
		
		echo "<br/>end test";
	}
	
	public function errortest() {
		
		// echo "<br/>begin 1";

		
		// Переход на страницу в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);
		
		// Активация ошибки в работе выводяться оба сообщения
		$this->errorAddErrors('проверка ошибок errorAddErrors message1');
		$this->errorAddErrors('проверка ошибок errorAddErrors message2');
		// Проверка на ошибки в работе если ошибка то переход на заданную страницу
		$this->errorThrow('public');
		
		// // Добавление сообщении об ошибке
		// $this->errorNewMessage("Проверка errorNewMessage1");
		// $this->errorNewMessage("Проверка errorNewMessage2"); не выводиться
		// // Вывод ошибки обнаруженных в программе
		// $this->errorPanic();
		
		$this->redirect($this->pre_lang . "/users/settings/");
		
		// echo "<br/>end ";
	}
	
	public function test2() {
		echo "<br/>begin ";
		$hierarchy = umiHierarchy::getInstance(); 
		$page = $hierarchy->getElement(617); 
		$page->setIsActive(true);
		echo "<br/>end ";
	}
};
?>