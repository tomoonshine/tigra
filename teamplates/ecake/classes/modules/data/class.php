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
		функция добавляет новый домен, настраивает ему шаблон, и добавляет главную 
		страницу и каталог товаров
	*/
	public function addNewShop($name){

		$collection = domainsCollection::getInstance(); 
		
		// Проверка на существование домена в системе с таким же именем
		$domains = $collection->getList();
		foreach ($domains as $domain) {
			$host = $domain->getHost();
			if($name.".tigra21.ru" == $host)
			{
				echo "<br/>домен существует ";
				return;
			}
		}
		
		// добавление домена
		// язык в системе по умолчанию, нужен при добавлении нового домена
		$defLangId = $collection->getDefaultDomain()->getDefaultLangId();
		// а ну-ка голубчик добавька новый домен
		$newDomainId = $collection->addDomain($name.".tigra21.ru", $defLangId);
		
		
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
		// выставить страница по умолчанию и активная
		$hierarchy = umiHierarchy::getInstance(); 
		$page = $hierarchy->getElement($newPageId); 
		$page->setIsActive(true);
		$page->setIsDefault(true);
		// добавить Каталог тип 82
		$newPageId = $hierarchy->addElement(0,82,"Товары","goods",82,$newDomainId,$defLangId,$newTmplId);
		$page = $hierarchy->getElement($newPageId); 
		$page->setIsActive(true);
	}
	
	public function test() {
		echo "<br/>begin ";
			$hierarchy = umiHierarchy::getInstance(); 
			// $hierarchy->addElement(0,,"Главная",,);
			$page = $hierarchy->getElement(98); 
			
			echo "<br/>id typeId ".$page->getTypeId();
			echo "<br/>id HierarchyType ".$page->getHierarchyType();
			echo "<br/>id ObjectType".$page->getObjectTypeId();
			
			// $collection = umiHierarchyTypesCollection::getInstance();
			// foreach ($collection as $type) {
				// echo "<br/>домен: " . $type; 
			// }
			
		echo "<br/>end ";
	}
};
?>