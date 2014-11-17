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

			// echo "<br/>ID: " . $objID;
			// echo "<br/>Имя: " . $obj->getName();		
		// echo "<br/>массив потомков<br/>";
		// var_dump($objChld);
		
		// echo "<br/>end test";
		
		return;
	}
	
	/* 
		Вывод товаров указанной категории со всех магазинов
		не более $amount в случайной выборке
	*/
	public function getProducts($categoryID=NULL, $amount=0) {
		
		echo "<br/>begin getProducts";
		
		if (!$categoryID) return;
		if ($amount == 0) return;
		
		// массив категорий по каторым нужно сделать отбор
		$categories = array($categoryID);
		
		// получим список дочерних объектов
		$typesCollection = umiObjectTypesCollection::getInstance();
		$objChld = $typesCollection->getSubTypesList($categoryID);
		
		foreach($objChld as $objID){
			getChildren($objID)
			$obj = $typesCollection->getType($objID);

		}
		
		echo "<br/>end getProducts";
	}
	
	public function getChildren($objID) {
		$typesCollection = umiObjectTypesCollection::getInstance();
		$objChld = $typesCollection->getSubTypesList($objID);
		foreach($objChld as $objID){
			getChildren($objID);
			echo "<br/> " . $objID;
		}
	}
	
	/*
		функция добавляет новый домен, настраивает ему шаблон, и добавляет
		главную страницу 
		каталог товаров
	*/
	public function addNewShop($name=NULL){
	
		$collection = domainsCollection::getInstance(); 
		
		if (!$name)	$name = getRequest('shopName');
		
		// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);
		
		// Проверка на существование домена в системе с таким же именем
		$domains = $collection->getList();
		foreach ($domains as $domain) {
			$host = $domain->getHost();
			if($name.".tigra21.ru" == $host)
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
		// а ну-ка приятель добавька новый домен
		$newDomainId = $collection->addDomain($name.".tigra21.ru", $defLangId);
		if($newDomainId === false) {
			$this->errorAddErrors('Неудалось создать магазин ошибка с доменом. Попробуйте позднее или обратитесь к администратору сайта.');
			$this->errorThrow('public');
			// echo "Не удалось создать новую страницу";
			// return;
		}

		// Записывает домен к пользователю
		$user->setValue('shopid', $newDomainId);
		$user->setValue('magazin', $name);

		// настройка шаблона
		$collection = templatescollection::getInstance(); 
		// добавляем шаблон к новому домену
		$newTmplId = $collection->addTemplate("default.xsl","Основной",$newDomainId,$defLangId,true);
		// настраиваем имя шаблона в templates
		$collection->getTemplate($newTmplId )->setName("ecake");
		
		// добавление главной страницы и каталога
		$hierarchy = umiHierarchy::getInstance(); 
		
		// добавить Главную страницу тип страницы 55
		$newPageId = $hierarchy->addElement(0,55,"Главная","main",55,$newDomainId,$defLangId,$newTmplId);
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
	
	

	
	
	public function setActive_mod() {

	}
	
	public function test() {
		
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