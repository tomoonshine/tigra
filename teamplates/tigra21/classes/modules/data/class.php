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
		Для типов данных
		
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
		Вывод для доменна списка категорий товаров.
		Строется на основе всех товаров лежащих в каталоге goods
		уровней должно быть не более 10
		в формате html требуется htmlDecode для обработки после получения ajax запросом
	*/
	public function GetMagazCatalog($domain = NULL) {
		// если домен не задан то выход
		if(!$domain) return;
		
		// получаем все товары из каталога goods
		$pages = new selector('pages');
		$pages->where('hierarchy')->page($domain.'/goods/')->childs(1);
		
		// id корня каталога 240 Категории товаров
		// начальный элемент иерархии предок всех задан в сиситеме, шаблоны данных, объекты каталога
		$rootId = 240;
		// корневой элемент структуры каталогов
		// используется ассоциативный массив
		/*
			$root = {
						"name" = "название категории",
						'id' = "идентификатор",
						'chld' = "указатель на массив таких структур, по иерархии они на 1 уровень ниже"
					}
			$root['chld'] = &$array {
										{
											"name" = "название категории",
											'id' = "идентификатор",
											'chld' = "указатель на массив таких структур, по иерархии они на 1 уровень ниже"
										},
										{
											"name" = "название категории",
											'id' = "идентификатор",
											'chld' = "указатель на массив таких структур, по иерархии они на 1 уровень ниже"
										}
										
										и т.д
									}
		*/
		$root = array("name"=>"Категории товаров", "id"=>$rootId , "chld");
			
		foreach($pages as $page) {
			$this->getPageCatalog(&$root, $page->getObjectTypeId());
		}
		// вывод иерархии в формате html 
		/*
			сокращённо примерно так
			<ul>
				<li> name </li>
				<li> name </li>
			</ul>
		*/
		$str = "";
		if($root['chld']) {
			//echo "<ul class='category-list secondary'>";
			$str = $str . "<ul class='category-list secondary'>";
				foreach($root['chld'] as $child) {
//					echo '<a onclick=" " class="title" title="'. $child["name"]. '" >'.$child["name"].'<i class="fa fa-chevron-down"></i></a>';
					$str = $str . '<li>';
					// $str = $str . '<a onclick="changeActive(this);';
					// $str = $str . 'getMagazCatalog('. $child['id'] . ',10,"' . 'domain' . '");"';
					// $str = $str . 'class="title" >'
					$str = $str . '<a onclick="changeActive(this);getMagazCatalog('.$child["id"].',10,'."'". $domain."'". ')" class="title" title="' . $child["name"] . '" >';
					$str = $str. $child["name"];
					if($child['chld']) $str = $str .'<i class="fa fa-chevron-down"></i>';
					$str = $str.'</a>';
					$this->getListType($child, &$str, $domain);
					$str = $str . '</li>';
				}
			//echo "</ul>";
			$str = $str . "</ul>";
		}
		$block_arr = Array();
		$block_arr['htmlcode'] = $str;
		return $this->parseTemplate('', $block_arr, null);
	}
	/*
		построение списка каталого в формате html tigra21.ru
	*/
	function getListType($parent, &$str, $domain) {
			
			if($parent['chld']) {
				//echo '<ul class="sub-menu">';
				$str = $str . '<ul class="sub-menu">';
				foreach($parent['chld'] as $child) {
					//echo '<a onclick=" " class="title" title="'. $child["name"]. '" >'.$child["name"].'<i class="fa fa-chevron-down"></i></a>';
					$str = $str . '<li>';
					$str = $str . '<a onclick="changeActive(this);getMagazCatalog('.$child["id"].',10,'."'". $domain."'". ')" class="title" >';
					$str = $str .$child["name"];
					if($child['chld']) $str = $str .'<i class="fa fa-chevron-down"></i>';
					$str = $str.'</a>';
					$this->getListType($child,&$str,$domain);
					$str = $str . '</li>';
				}
				//echo '</ul>';
				$str = $str . '</ul>';
			}
	}
	
	
	
	/*
		Построение иерархии категорий для заданного типа объекта $curTypeId
		$root используеться в качестве корня иерархии как начальный элемент
	*/
	public function getPageCatalog(&$root, $curTypeId) {
			
			$typesCollection = umiObjectTypesCollection::getInstance();
			//$typeObj = $typesCollection->getType($typeId);
			// массив предков элемента в иерархии шаблона данных
			/*
				строиться массив предков
				$parents = {
								{
									"name" = "название категории",
									'id' = "идентификатор",
								},
								{
									"name" = "название категории",
									'id' = "идентификатор",
								}
								
								и т.д
							}
			*/
			$parents = array();
			// перебор и запись предков внуков должно быть не более 10
			$i = 0;
	   		while ($curTypeId != $root['id'] ) {
				$typeObj = $typesCollection->getType($curTypeId);
				$parents[$i]['id'] = $curTypeId;
				$parents[$i]['name'] = $typeObj->getName();
				//echo "<br/>". $typeObj->getName() . "</br>";
				$curTypeId = $typeObj->getParentId();
				$i++;
				if ($i == 10) { echo "</br> break overflow "; return; }
				
			}
			$i--;
			$elm = &$root;
			$flag = 0;
			// записываем структуру иерархии начиная с детей $root далее детей детей $root
			// если элемент присутствует в нашей иерархии то он не включаеться
			for($i; $i >= 0 ; $i--) {
				$chlds = &$elm['chld'];
				$l = count($chlds); // длинна массива потомков
				$flag = 0;
				$j = 0;
				// ищем в потомках ветвь нашего элемента
				for($j; $j < $l; $j++) {
					if ($chlds[$j]['id'] == $parents[$i]['id']) {
						// если есть вхождение ветви то переключаемся на неё
						$elm = &$chlds[$j];
						// перейдём к следующей итерации
						$flag = 1;
						break;
					}
				}
				if ($flag) continue;
				// если нет то добавляем новою ветвь
				$chlds[$j] = array('name'=>$parents[$i]['name'], 'id'=>$parents[$i]['id'], "chld");
				// переключаемся на неё
				$elm = &$chlds[$j];
			}
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
		$pages = new selector('pages');
		$pages->types('hierarchy-type')->name('catalog', 'object');
		
		// собираем со всех поддоменов
		$collection = domainsCollection::getInstance(); 
		$domains = $collection->getList();
		foreach ($domains as $domain) {
			$host = $domain->getHost();
			$pages->where('hierarchy')->page($host.'/goods/')->childs(1);
		}
	
		// лимит на количество
		$pages->limit(0,$amount);
		
		// сортировочка в случайном порядке
		$pages->order('rand');
		
		// будем работать с хиерархией
		$hierarchy = umiHierarchy::getInstance();
		// на всякий случай вдруг понядобиться домен
		$domainsCollection = domainsCollection::getInstance();
		// Переменный для формирования выходной структуры xml
		$block_arr = Array();
		$lines = Array();
		$length = 0;
		foreach($pages as $page) {
			// полйчить все страницы объектом данных для которых являеться $obj
			$line_arr = array();
			$host = $domainsCollection->getDomain($page->getDomainId())->getHost();
			$mainPageId = $hierarchy->getIdByPath($host.'/main/');
			$mainPage = $hierarchy->getElement($mainPageId);
			
			$line_arr['attribute:pageId'] = $page->id;
			$line_arr['attribute:object-id'] = $page->getObject();
			$line_arr['attribute:name'] = $page->name;
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
		Доработанна. getProducts отстой. 
		Если категория задана конечная то есть потомков у неё нет то выводиться 100 товаров
	
	*/
	public function getSubCategoryCatalog($categoryID=NULL, $amount=0) {
		
		// если нихрена не задано то ну его нафиг
		if (!$categoryID) return;
		if ($amount == 0) return;

		$typesCollection = umiObjectTypesCollection::getInstance();
		$objChldren = $typesCollection->getSubTypesList($categoryID);
		$sheet = false;
		// узнаем не на лист ли перадали
		if (count($objChldren) == 0) $sheet = true;
		
		// массив категорий по каторым нужно сделать отбор
		//$categories = array($categoryID);
		// получаем все подкатегории
		//$categories = array_merge($categories, $this->getChildren($categoryID));
		
		
		// Нуно сделать выборку элементов
		$pages = new selector('pages');
		$pages->types('hierarchy-type')->name('catalog', 'object');
		// задаються типы объектов для поиска
		$pages->types('object-type')->id($categoryID);
		// собираем со всех поддоменов
		$pages->where('domain')->isnull(false); 
	
		// лимит на количество
		//$pages->limit(0,$amount);
		
		// сортировочка в случайном порядке
		$pages->order('rand');
		
		
		// понадобиться для картинок	
		if (!$oContentMdl = cmsController::getInstance()->getModule("content")) { 
			$this->errorAddErrors('Не удалось подключить модуль content');
			$this->errorThrow('public');
		}

		// будем работать с хиерархией
		$hierarchy = umiHierarchy::getInstance();
		// на всякий случай вдруг понядобиться домен
		$domainsCollection = domainsCollection::getInstance();
		// Переменный для формирования выходной структуры xml
		$block_arr = Array();
		$htmlcode = ' ';
		$length = 0;
		// если лист то поболе вывести нужно
		if ($sheet) $amount = 100;
		foreach($pages as $page) {
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
			$imgArray = $oContentMdl->makeThumbnailCare('.'.$src,270,340,'void',0,1,0);
			
			// структура html
			$htmlcode =	$htmlcode . '<li class="standard">'
				. '<div class="image">'
					. '<a title="' . $page->name .'" umi:element-id="' . $page->id . '" class="image-link" href="' .  $page->link . '">'
						. '<div class="image_crop_block">'
							.'<img src="'.$imgArray['src'].'" width="270" height="340" class="primary" data-zoom-image=" " alt="' . $page->name . '" title="' . $page->name . '">'
						. '</div>'
					. '</a>'
					. '<div class="electee-wrap">
						<a href="/users/electee_item/'
						.$page->id
						.'" class="fa fa-star-o add_electee_item" data-delete-url="/users/electee_delete/'
						.$page->id
						.'" data-add-url="/users/electee_item/'
						.$page->id
						.'" data-untext="Отменить" data-text="В избранное" data-id-sticky="#sticky-electee" data-placement="right" title="В избранное" data-original-title="В избранное"></a>
					</div>'
					. '</div>'
					. '<div class="title">'
						. '<a title="" href="'. $page->link .'">'
							. '<h3 umi:field-name="name" umi:element-id="'. $page->id.'" class="u-eip-edit-box" title="Нажмите Ctrl+левая кнопка мыши, чтобы перейти по ссылке.">'
							. $page->name .'</h3>'
							. '<div class="prices">'
								. '<span class="price">'.$page->price.'</span> руб'
							. '</div>'
						. '</a>'
						.'<div class="item_properties">
							<p>Характеристики:</p>
							<ul class="list-border">
							<li>?Бренд: Bruno Amaranti</li>
							<li>?Материал: Кожа</li>
							<li>?Цвет: Черный</li>
							</ul>
						</div>'
						.'<div class="btn_line add_from_list btn_line_'.$page->id.'">
							<div class="prices"> <span class="price">'.$page->price.'</span> руб</div>
							<div class="shopAdress_MainPage">'
							.$mainPage->adress
							.'</div>
							<div>
							<a href="http://'. $host . '" title="'.$mainPage->nazvanie_magazina.'" class="btn btn-small btn-primary button options basket_list ">'
							.$mainPage->nazvanie_magazina
							.'</a>
							</div>
							<i class="fa fa-spinner fa-spin"></i>
						</div>'
						
						
						. '<div class="btn_line add_from_list btn_line_">'
							. '<i class="fa fa-spinner fa-spin"></i>'
						. '</div>'
						. '<div style="margin:20px"></div>'
					.' </div>'
			. '</li>';
	
			$length++;
			if ($length == $amount) break;
		}
		
		$block_arr['sheet'] = $sheet;
		$block_arr['total'] = $pages->length();
		$block_arr['selected'] = $length;
		$block_arr['htmlcode'] = $htmlcode . '<div class="clear"></div>';
		return $this->parseTemplate('', $block_arr, null);
	}
	
	
	
	/*
		Используеться для магазинов на поддоменах tigra21.ru (усовершенствованная
		getSubCategoryCatalog)
		Вывод товаров в количестве &amount рандом указанной категории и входящих в нее категорий
		в формате html требуется htmlDecode для обработки после получения ajax запросом
	
	*/
	public function getSubCategoryCatalogMagaz($categoryID=NULL, $amount=0, $domain = NULL) {
		
		// если нихрена не задано то ну его нафиг
		if (!$categoryID) return;
		if ($amount == 0) return;
		if (!$domain) return;
		
		$typesCollection = umiObjectTypesCollection::getInstance();
		$objChldren = $typesCollection->getSubTypesList($categoryID);
		$sheet = false;
		// узнаем не на лист ли перадали
		if (count($objChldren) == 0) $sheet = true;
		
		// массив категорий по каторым нужно сделать отбор
		//$categories = array($categoryID);
		// получаем все подкатегории
		//$categories = array_merge($categories, $this->getChildren($categoryID));
		
		// Нуно сделать выборку элементов
		$pages = new selector('pages');
		//$pages->types('object-type')->id($categoryID);
		//foreach($categories as $cat) $pages->types('object-type')->id($cat);
		$pages->types('object-type')->id($categoryID);
		$pages->types('hierarchy-type')->name('catalog', 'object');
		$pages->where('hierarchy')->page($domain.'/goods/')->childs(1);
	
		// $goods = new selector('objects');
		// задаються типы объектов для поиска
	//	foreach($categories as $cat) $goods->types('object-type')->id($cat);
		//
		// не нужны объекты без имён
		//$pages->where('name')->isnotnull(false); 
		// количество элементов для отбора
		//$pages->limit(0,$amount);
		// сортировочка в случайном порядке
		$pages->order('rand');
		
		
		// понадобиться для картинок	
		if (!$oContentMdl = cmsController::getInstance()->getModule("content")) { 
			$this->errorAddErrors('Не удалось подключить модуль content');
			$this->errorThrow('public');
		}
		
		// будем работать с хиерархией
		$hierarchy = umiHierarchy::getInstance();
		// на всякий случай вдруг понядобиться домен
		$domainsCollection = domainsCollection::getInstance();
		// Переменный для формирования выходной структуры xml
		$block_arr = Array();
		$htmlcode = ' ';
		$length = 0;
		// если лист то поболе вывести нужно
		if ($sheet) $amount = 100;
		foreach($pages as $page) {
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
			$imgArray = $oContentMdl->makeThumbnailCare('.'.$src,270,340,'void',0,1,0);
			
			// структура html
			$htmlcode =	$htmlcode . '<li class="standard">'
				. '<div class="image">'
					. '<a title="' . $page->name .'" umi:element-id="' . $page->id . '" class="image-link" href="' .  $page->link . '">'
						. '<div class="image_crop_block">'
							.'<img src="'.$imgArray['src'].'" width="270" height="340" class="primary" data-zoom-image=" " alt="' . $page->name . '" title="' . $page->name . '">'
						. '</div>'
					. '</a>'
					. '<div class="electee-wrap">
						<a href="/users/electee_item/'
						.$page->id
						.'" class="fa fa-star-o add_electee_item" data-delete-url="/users/electee_delete/'
						.$page->id
						.'" data-add-url="/users/electee_item/'
						.$page->id
						.'" data-untext="Отменить" data-text="В избранное" data-id-sticky="#sticky-electee" data-placement="right" title="В избранное" data-original-title="В избранное"></a>
					</div>'
					. '</div>'
					. '<div class="title">'
						. '<a title="" href="'. $page->link .'">'
							. '<h3 umi:field-name="name" umi:element-id="'. $page->id.'" class="u-eip-edit-box" title="Нажмите Ctrl+левая кнопка мыши, чтобы перейти по ссылке.">'
							. $page->name .'</h3>'
							. '<div class="prices">'
								. '<span class="price">'.$page->price.'</span> руб'
							. '</div>'
						. '</a>'
						.'<div class="item_properties">
							<p>Характеристики:</p>
							<ul class="list-border">
							<li>?Бренд: Bruno Amaranti</li>
							<li>?Материал: Кожа</li>
							<li>?Цвет: Черный</li>
							</ul>
						</div>'
						.'<div class="btn_line add_from_list btn_line_'.$page->id.'">
							<div class="prices"> <span class="price">'.$page->price.'</span> руб</div>
							<div class="shopAdress_MainPage">'
							.$mainPage->adress
							.'</div>
							<div>
							<a href="http://'. $host . '" title="'.$mainPage->nazvanie_magazina.'" class="btn btn-small btn-primary button options basket_list ">'
							.$mainPage->nazvanie_magazina
							.'</a>
							</div>
							<i class="fa fa-spinner fa-spin"></i>
						</div>'
						
						
						. '<div class="btn_line add_from_list btn_line_">'
							. '<i class="fa fa-spinner fa-spin"></i>'
						. '</div>'
						. '<div style="margin:20px"></div>'
					.' </div>'
			. '</li>';
	
			$length++;
			if ($length == $amount) break;
		}
		
		$block_arr['sheet'] = $sheet;
		$block_arr['total'] = $pages->length();
		$block_arr['selected'] = $length;
		$block_arr['htmlcode'] = $htmlcode . '<div class="clear"></div>';
		return $this->parseTemplate('', $block_arr, null);
		
		
		
		
		// // Переменный для формирования выходной структуры xml
		// $block_arr = Array();
		// $htmlcode = ' ';
		// $length = 0;
		// foreach($pages as $page) {
			// // полйчить все страницы объектом данных для которых являеться $obj
			// //$pageId = $hierarchy->getObjectInstances($obj->id, true);
			// //$page = $hierarchy->getElement($pageId[0]);
			
			// // если имеються картинки то добавляем первую из всех
			// $src = ' ';
			// $jsonFILE = $page->tigra21_image_gallery;
			// $jsonFILE = json_decode($jsonFILE, true);
			// if(!empty($jsonFILE)) {
				// $src= $jsonFILE['0']['src'];
			// }
			// //$host = $domainsCollection->getDomain($page->getDomainId())->getHost();
			// $mainPageId = $hierarchy->getIdByPath($domain.'/main/');
			// $mainPage = $hierarchy->getElement($mainPageId);
			
			// // структура html
			// $htmlcode =	$htmlcode . '<li umi:element-id="' . $page->id . '" umi:region="row" class="standard">'
							// . '<div class="image">'
								// . '<a title="' . $page->name .'" umi:element-id="' . $page->id . '" class="image-link" href="' .  $page->link . '">'
									// . '<div style="width:170px; height: 170px" class="image_crop_block">'
										// . '<img width="170" title="' . $page->name . '" alt="' . $page->name . '" class="primary" src="' . $src .'"></img>'
									// . '</div>'
								// . '</a>'
								// . '</div>'
								// . '<div class="title">'
									// . '<a title="' .$mainPage->nazvanie_magazina . '" href="http://'. $domain . '">'
										// . '<h3>'.$mainPage->nazvanie_magazina.'</h3>'
									// . '</a>'
									// . '<a title="товар 2" href="'. $page->link .'">'
										// . '<h3 umi:field-name="name" umi:element-id="'. $page->id.'" class="u-eip-edit-box" title="Нажмите Ctrl+левая кнопка мыши, чтобы перейти по ссылке.">товар 2</h3>'
										// . '<div class="prices">'
											// . '<span class="price">'.$page->price.'</span> руб'
										// . '</div>'
										// . '</a>'
									// . '<div class="btn_line add_from_list btn_line_">'
										// . '<i class="fa fa-spinner fa-spin"></i>'
									// . '</div>'
									// . '<div style="margin:20px"></div>'
								// .' </div>'
						// . '</li>';
			
			// $length++;
		// }

		// // if ($length != 0) $block_arr['subnodes:items'] = $lines;
		// $block_arr['total'] = $length;
		// $block_arr['htmlcode'] = $htmlcode . '<div class="clear"></div>';
		// return $this->parseTemplate('', $block_arr, null);
	}
	
	
	
	
	/*
		функция добавляет новый домен, настраивает ему шаблон, и добавляет
		главную страницу 
		каталог товаров
	*/
	public function addNewShop($domenName=NULL, $shopName){
	
		if (!$domenName) $domenName = getRequest('shopDomain');
		if (!$shopName) $shopName = getRequest('shopName');
			
		// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);
	
			
		// Проверка на пустые строки
		if ((!$domenName) | (!$shopName)) {
			$this->errorAddErrors('Не заполнены поля');
			$this->errorThrow('public');
		}
		

		
		
		// Проверка на корректность имени домена может содержать латинские буквы и цифры
		if (preg_match("/[\W]/", $domenName, $matches)) {
			$this->errorAddErrors('Название домена может содержать только латинские буквы и цифры');
			$this->errorThrow('public');
		}
		
				
		// Проверка на существование домена в системе с таким же именем
		$collection = domainsCollection::getInstance(); 
		$domains = $collection->getList();
		foreach ($domains as $domain) {
			$host = $domain->getHost();
			if($domenName.".tigra21.ru" == $host)
			{
				// echo "<br/>домен существует ";
				$this->errorAddErrors('Магазин с доменом '.$domenName.' уже есть');
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
		// Создадим каталог для хранения всякой всячины
		mkdir("images/stores/".$user->shopid);
		
		// Записывает домен к пользователю
		$user->setValue('shopid', $newDomainId);
		$user->setValue('magazin', $shopName);
		$user->setValue('imya_hosta', $collection->getDomain($newDomainId)->getHost());

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
		$page->nazvanie_magazina = $shopName;
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
		
		// Добавим все дружно каталог для новостей - ленту новостей
		$newPageId = $hierarchy->addElement(0,31,"Акции и новости магазина","promotionsandnews",31,$newDomainId,$defLangId,$newTmplId);
		if($newPageId === false) {
			$this->errorAddErrors('Не удалось создать ленту новостей. Обратитесь к администратору сайта (: бывает такое на нашей планете.');
			$this->errorThrow('public');
		}
		//Установим права на страницу в состояние "по умолчанию"
		$permissions->setDefaultPermissions($newPageId);
		// $permissions->setElementPermissions(13,$newPageId,1);
		$page = $hierarchy->getElement($newPageId); 
		$page->setIsActive(true);
		//создадим каталог для хранения изображений
		mkdir("images/stores/".$user->shopid."/promo");
		
		
		
		// Добавим слаааайййййдерррррррррррррррррррр  
		$newPageId = $hierarchy->addElement(0,55,"Слайдер","slider",55,$newDomainId,$defLangId,$newTmplId);
		if($newPageId === false) {
			$this->errorAddErrors('Не удалось создать слайдер. Обратитесь к администратору сайта (: Нет ничего совершенного');
			$this->errorThrow('public');
		}
		//Установим права на страницу в состояние "по умолчанию"
		$permissions->setDefaultPermissions($newPageId);
		// $permissions->setElementPermissions(13,$newPageId,1);
		$page = $hierarchy->getElement($newPageId); 
		$page->setIsActive(true);
		//создадим каталог для хранения изображений
		mkdir("images/stores/".$user->shopid."/slider");
		
		
		
		// Перевод пользователя в личный кабинет
		$this->redirect($this->pre_lang . "/stranicy_dlya_lichnogo_kabineta/nastrojki_magazina/");
	}
	
	/*
		Выводит название магазина и домен для указанной страницы
	*/
	public function getShopName($pageId) {
		
		
		$hierarchy = umiHierarchy::getInstance();
		// получаем umiHierarchyElement, либо false, если страница не существует
		$page = $hierarchy->getElement($pageId); 	
		
		if (!$page instanceof umiHierarchyElement) {
			// выбрасываем исключение
			throw new publicException(getLabel('error-page-does-not-exist')); 
		}
		
		
		// получаем экземпляр коллекции
		$collection = domainsCollection::getInstance(); 
		$domain = $collection->getDomain($page->getDomainId());
		$host = $domain->getHost();
		$mainPageId = $hierarchy->getIdByPath($host.'/main/');
		$mainPage = $hierarchy->getElement($mainPageId);
		$block_arr = Array();
		$block_arr['name'] = $mainPage->nazvanie_magazina;
		$block_arr['domain'] = $host;
		return $this->parseTemplate('', $block_arr, null);
	}
	
	public function changeShopName($shopName) {

		
		// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);
		
		if (!$shopName) $shopName = getRequest('shop_name');
		// Проверка на пустые строки
		if (!$shopName) {
			$this->errorAddErrors('Не заполнены поля');
			$this->errorThrow('public');
		}
		
				
		$permissions = permissionsCollection::getInstance();
		$userId = $permissions->getUserId();
		if ($userId == '13') { echo "error"; return; }
		$objectsCollection = umiObjectsCollection::getInstance();
		$user = $objectsCollection->getObject($userId);
		// получаем экземпляр коллекции
		$collection = domainsCollection::getInstance(); 
		$domain = $collection->getDomain($user->getValue('shopid'));
		$host = $domain->getHost();
		$hierarchy = umiHierarchy::getInstance();
		$mainPageId = $hierarchy->getIdByPath($host.'/main/');
		$mainPage = $hierarchy->getElement($mainPageId);
		
		$user->setValue('magazin', $shopName);
		$mainPage->nazvanie_magazina = $shopName;
		
		
		// Перевод пользователя в личный кабинет
		$this->redirect($this->pre_lang . "/stranicy_dlya_lichnogo_kabineta/nastrojki_magazina/");
		
		
	}
	
	/*
		Получить все товары в магазине, определяется по домену, в количестве amount.
	*/
	public function getShopProducts($domainId=NULL, $amount=25){
		
		// если нихрена не задано то ну его нафиг
		if (!$domainId) return;
		
		$domainsCollection = domainsCollection::getInstance();
		$domain = $domainsCollection->getDomain($domainId);
		$host = $domain->getHost();
		// Нуно сделать выборку элементов
		$pages = new selector('pages');
		$pages->types('hierarchy-type')->name('catalog', 'object');
		// задаються типы объектов для поиска
		$pages->types('object-type')->id(240);
		
		// выбираем с поддомена в каталоге goods
		$pages->where('hierarchy')->page($host.'/goods/')->childs(1);
	
		// лимит на количество
		//$pages->limit(0,$amount);
		
		// сортировочка в случайном порядке
		//$pages->order('rand');
		
		$block_arr = Array();
		$lines = Array();
		$length = 0;
		foreach($pages as $page) {
			// полйчить все страницы объектом данных для которых являеться $obj
			$line_arr = array();
		
			$line_arr['attribute:pageId'] = $page->id;
			$line_arr['attribute:object-id'] = $page->getObject();
			$line_arr['attribute:name'] = $page->name;
			$line_arr['attribute:h1'] =  $page->h1;
			$line_arr['attribute:price'] = $page->price;
			$line_arr['attribute:link'] = $page->link;	
			// если имеються картинки то добавляем первую из всех
			$jsonFILE = $page->tigra21_image_gallery;
			$jsonFILE = json_decode($jsonFILE, true);
			if(!empty($jsonFILE)) {
				$images = array();
				foreach ($jsonFILE as $img) {
					$image = array();
					$image['attribute:src']= $jsonFILE['0']['src'];
					$images[] = $image;
				}
				$line_arr['images']['subnodes:items'] = $images;
			}
		
			$lines[] = $line_arr;
			$length++;
		}

		if ($length != 0) $block_arr['subnodes:items'] = $lines;
		$block_arr['total'] = $length;
		
		return $this->parseTemplate('', $block_arr, null);
		
	}
	

	/*
		добавляет новый товар в каталог магазина goods
		через POST запрос
		input product_name Обязательный параметр
		input categoryId Обязательный параметр
		input price
		textarea description
		$_FILES["image"] один или несколько файлов массив
	*/
	public function addNewProduct() {
	
		// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);	
				
		$poductName = getRequest('product_name');
		$categoryId = getRequest('categoryId');
		$price = getRequest('price');
		$description = getRequest('description');
		
		$errors = true;
		// Проверка на пустые строки
		if ((!$poductName) | (!$categoryId)) {
			$this->errorAddErrors('Не заполнены поля');
			$this->errorThrow('public');
		}
		
		foreach ($_FILES["image"]["error"] as $key => $error) {
			// Проверяем загружен ли файл
			if($error == UPLOAD_ERR_OK)
			{
				$imgName = $_FILES["image"]["name"][$key];
				if($_FILES["imageN"]["size"][$key] > 1024*3*1024)
				{
					$this->errorAddErrors('Размер файла '.$imgName.' превышает три мегабайта');
					$errors = true;
				}
				else
					if ($this->checkImageFile($imgName)) {
						$errors = false;
					}

				
			}
		}
		if($errors) {
			$this->errorAddErrors('Ни одной фотографии загрузить не удалось. Проверте имя файла(только буквы латинского алфавита и цифры) размер(не более 3 мегабайт) и формат(jpg,jpeg,png,gif). ');
			$this->errorThrow('public');
		}
		
		// получить текущего пользователя 
		$permissions = permissionsCollection::getInstance();
		$userId = $permissions->getUserId();
		$objectsCollection = umiObjectsCollection::getInstance();
		$user = $objectsCollection->getObject($userId);
		
		//$domainsCollection = domainsCollection::getInstance(); 

		$hierarchy = umiHierarchy::getInstance();
		$goodsId = $hierarchy->getIdByPath($user->imya_hosta.'/goods');
		
		$newPageId = $hierarchy->addElement($goodsId,$categoryId,$poductName,NULL,$categoryId);

		if($newPageId === false) {
			$this->errorAddErrors('Не удалось добавть товар. Обратитесь к администратору сайта.');
			$this->errorThrow('public');
		}
		 //Установим права на страницу в состояние "по умолчанию"
		$permissions->setDefaultPermissions($newPageId);
		$page = $hierarchy->getElement($newPageId); 
		$page->setIsActive(true);
		$page->price = $price;
		$page->description= $description;
		
		// загружаем файлы
		mkdir("images/catalog/object/".$newPageId);
		
		$image_gallery = array();
		foreach ($_FILES["image"]["error"] as $key => $error) {
			$imageInGallery = array();
			// Проверяем загружен ли файл
			if($error == UPLOAD_ERR_OK)
			{
				$imgName = $_FILES["image"]["name"][$key];
				
				$upfiletype = substr( $imgName,  strrpos( $imgName, "." ) + 1 );
				if($_FILES["imageN"]["size"][$key] > 1024*3*1024)
				{
					$this->errorAddErrors('Размер файла '.$imgName.' превышает три мегабайта');
					$errors = true;
				}
				else				
					if ($this->checkImageFile($imgName))
					{
						move_uploaded_file($_FILES["image"]["tmp_name"][$key], 'images/catalog/object/'.$newPageId.'/'.$imgName);
						$imageInGallery['name'] = $imgName;
						$imageInGallery['altName'] = $poductName;
						$imageInGallery['src'] = '/images/catalog/object/'.$newPageId.'/'.$imgName;
						$imageInGallery['type'] = $upfiletype;
						
					} else {
						$this->errorAddErrors('Не удалось загрузить картику.'.$imgName.' Имя или тип файла не поддерживается. Имя должно состоять только из латинских букв и цифр. Используйте форматы jpg,gif,png,jpeg.');
						$errors = true;
					
					}
			} else {
				$this->errorAddErrors('Не удалось загрузить картику. Обратитесь к администратору сайта.');	
				$errors = true;
			}
			$image_gallery[] = $imageInGallery;
		}
		$page->tigra21_image_gallery = json_encode($image_gallery);
		
		if($errors) $this->errorThrow('public');
		
		$this->redirect($this->pre_lang . "/stranicy_dlya_lichnogo_kabineta/tovary/");
	}
	
	
	public function setInform() {
		// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);	
		
		$legal_address = getRequest('legal_address');
		$content = getRequest('content');
		
		$errors = false;
		
		$permissions = permissionsCollection::getInstance();
		$userId = $permissions->getUserId();
		$objectsCollection = umiObjectsCollection::getInstance();
		$user = $objectsCollection->getObject($userId);
		
		$hierarchy = umiHierarchy::getInstance();
		$mainId = $hierarchy->getIdByPath($user->imya_hosta.'/main');
		$page = $hierarchy->getElement($mainId); 
		$page->legal_address = $legal_address;
		$page->content= $content;
		
		$this->redirect($this->pre_lang . "/stranicy_dlya_lichnogo_kabineta/informaciya_dlya_posetitelej/");
	}
	
	public function addPromo() {
			// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);	
				
		$promo_name = getRequest('promo_name');
		$description = getRequest('description');
		
		$errors = false;
		// Проверка на пустые строки
		if ((!$promo_name) | (!$description)) {
			$this->errorAddErrors('Не заполнены поля');
			$this->errorThrow('public');
		}
			
		// получить текущего пользователя 
		$permissions = permissionsCollection::getInstance();
		$userId = $permissions->getUserId();
		$objectsCollection = umiObjectsCollection::getInstance();
		$user = $objectsCollection->getObject($userId);
	
		 //Получим иерархический типа страницы - "Новость"
		$hierarchyTypes = umiHierarchyTypesCollection::getInstance();
		$hierarchyType = $hierarchyTypes->getTypeByName("news", "item");
		$hierarchyTypeId = $hierarchyType->getId();
		 
		$hierarchy = umiHierarchy::getInstance();
		 
		//Получим id родительской страницы
		$parentElementId = $hierarchy->getIdByPath($user->imya_hosta.'/promotionsandnews/');
		 
		//add new element
		$newElementId = $hierarchy->addElement($parentElementId, $hierarchyTypeId, $promo_name);
		if($newElementId === false) {
			echo "Не удалось создать новую страницу";
		}
		 
		//Установим права на страницу в состояние "по умолчанию"
		$permissions = permissionsCollection::getInstance();
		$permissions->setDefaultPermissions($newElementId);
		 
		//Получим экземпляр страницы
		$newElement = $hierarchy->getElement($newElementId);
		
		if($newElement instanceof umiHierarchyElement) {
			//Заполним новую страницу свойствами
			$newElement->setValue("h1", $newElementName);
			$newElement->setValue("content", $description);
			$newElement->setValue("publish_time", time()); //Время публикации - сейчас
		  
			
			// загружаем файлы
			$uploaddir = 'images/stores/'.$user->shopid.'/promo/';
			$imgName = $_FILES["imageN"]["name"];
				
			//mkdir("images/stores/".$user->shopid."/promo");
			if($_FILES["imageN"]["size"] > 1024*3*1024)
			{
				$this->errorAddErrors('Размер файла превышает три мегабайта');
				$errors = true;
			}
			// Проверяем загружен ли файл
			if(is_uploaded_file($_FILES["imageN"]["tmp_name"]))
			{
				// Если файл загружен успешно, перемещаем его
				// из временной директории в конечную
				if ($this->checkImageFile($imgName)) {
					move_uploaded_file($_FILES["imageN"]["tmp_name"], $uploaddir.$imgName);
				}
				else {
					$this->errorAddErrors('Не удалось загрузить картику.'.$imgName.' Имя или тип файла не поддерживается. Имя должно состоять только из латинских букв и цифр. Используйте форматы jpg,gif,png,jpeg.');
					$errors = true;
				}
				
			} else {
				$this->errorAddErrors('Ошибка загрузки файла. Обратитесь к администратору сайта.');
				$errors = true;
			}
			
			if(!$errors) {
				$image = new umiImageFile('./'.$uploaddir.$imgName);
				$newElement->setValue("anons_pic", $image);
			}
			
			//Укажем, что страница является активной
			$newElement->setIsActive(true);

			//Подтвердим внесенные изменения
			$newElement->commit();
		  
		} else {
		
			$this->errorAddErrors('Не удалось добавить. Обратитесь к администратору сайта.');
			$this->errorThrow('public');
		}
		
		if($errors) $this->errorThrow('public');
		
		
		$this->redirect($this->pre_lang . "/stranicy_dlya_lichnogo_kabineta/akcii_i_novosti/");
	}
	
	
	public function getPromoAndNews($domainId=NULL) {
		
		// если нихрена не задано то ну его нафиг
		if (!$domainId) return;
		
		$domainsCollection = domainsCollection::getInstance();
		$domain = $domainsCollection->getDomain($domainId);
		$host = $domain->getHost();
		// Нуно сделать выборку элементов
		$pages = new selector('pages');
		$pages->types('hierarchy-type')->name('news', 'item');
	
		// выбираем с поддомена в каталоге goods
		$pages->where('hierarchy')->page($host.'/promotionsandnews/')->childs(1);
	
		// лимит на количество
		//$pages->limit(0,$amount);
		
		// сортировочка в случайном порядке
		//$pages->order('rand');
		
		$block_arr = Array();
		$lines = Array();
		$length = 0;
		foreach($pages as $page) {
			// полйчить все страницы объектом данных для которых являеться $obj
			$line_arr = array();
		
			$line_arr['attribute:pageId'] = $page->id;
			$line_arr['attribute:name'] = $page->name;
			$line_arr['attribute:link'] = $page->link;	
			$line_arr['attribute:image'] = $page->anons_pic;
			$line_arr['attribute:content']  = $page->content;
			
			$lines[] = $line_arr;
			$length++;
		}

		if ($length != 0) $block_arr['subnodes:items'] = $lines;
		$block_arr['total'] = $length;
		
		return $this->parseTemplate('', $block_arr, null);
	}
	
	
	
	public function checkImageFile($name) {
		if (!preg_match('/^[a-zA-Z0-9]{1,25}.jpg|gif|png|jpeg|GIF|JPG|PNG|JPEG$/', $name))
			return false;
		else
			return true;
	}
	
	public function addSlide() {
			// Страница для вывода в случае ошибки
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);	
				
		$slide_name = getRequest('slide_name');
		
		$errors = false;
		// Проверка на пустые строки
		if (!$slide_name) {
			$this->errorAddErrors('Не заполнены поля');
			$this->errorThrow('public');
		}
				
		// получить текущего пользователя 
		$permissions = permissionsCollection::getInstance();
		$userId = $permissions->getUserId();
		$objectsCollection = umiObjectsCollection::getInstance();
		$user = $objectsCollection->getObject($userId);
	
		$hierarchy = umiHierarchy::getInstance();
		$Slider = $hierarchy->getIdByPath($user->imya_hosta.'/slider');
		
		$newSlideId = $hierarchy->addElement($Slider,143,$slide_name,NULL,143);

		if($newSlideId === false) {
			$this->errorAddErrors('Не удалось добавть слайд. Обратитесь к администратору сайта.');
			$this->errorThrow('public');
		}
		 //Установим права на страницу в состояние "по умолчанию"
		$permissions->setDefaultPermissions($newSlideId);
		$page = $hierarchy->getElement($newSlideId); 
		$page->setIsActive(true);
		$page->setIsVisible(true);

		
		// загружаем файлы
		$uploaddir = 'images/stores/'.$user->shopid.'/slider/';
		$filetype = array ( 'jpg', 'gif', 'png', 'jpeg');
		$imgName = $_FILES["imageN"]["name"];
			
		//mkdir("images/stores/".$user->shopid."/Slider");
		if($_FILES["imageN"]["size"] > 1024*3*1024)
		{
			$this->errorAddErrors('Размер файла превышает 3 мегабайта');
			$errors = true;
		}
		// Проверяем загружен ли файл
		if(is_uploaded_file($_FILES["imageN"]["tmp_name"]))
		{
			// Если файл загружен успешно, перемещаем его
			// из временной директории в конечную
			if ($this->checkImageFile($imgName)) {
					move_uploaded_file($_FILES["imageN"]["tmp_name"], $uploaddir.$imgName);
				}
			else {
				$this->errorAddErrors('Не удалось загрузить картику.'.$imgName.' Имя или тип файла не поддерживается. Имя должно состоять только из латинских букв и цифр. Используйте форматы jpg,gif,png,jpeg.');
				$errors = true;
			}
		} else {
			$this->errorAddErrors('Ошибка загрузки файла. Обратитесь к администратору сайта.');
			$errors = true;
		}
		
		if(!$errors) $page->photo = './'.$uploaddir.$imgName;
		else $this->errorThrow('public');
		
		
		$this->redirect($this->pre_lang . "/stranicy_dlya_lichnogo_kabineta/slajder/");
	}
	
	public function getSlides($domainId=NULL) {
		
		// если нихрена не задано то ну его нафиг
		if (!$domainId) return;
		
		$domainsCollection = domainsCollection::getInstance();
		$domain = $domainsCollection->getDomain($domainId);
		$host = $domain->getHost();
		// Нуно сделать выборку элементов
		$pages = new selector('pages');
	
		// выбираем с поддомена в каталоге goods
		$pages->where('hierarchy')->page($host.'/slider/')->childs(1);
	
		// лимит на количество
		//$pages->limit(0,$amount);
		
		// сортировочка в случайном порядке
		//$pages->order('rand');
		
		$block_arr = Array();
		$lines = Array();
		$length = 0;
		foreach($pages as $page) {
			// полйчить все страницы объектом данных для которых являеться $obj
			$line_arr = array();
		
			$line_arr['attribute:pageId'] = $page->id;
			$line_arr['attribute:name'] = $page->name;
			$line_arr['attribute:link'] = $page->link;	
			$line_arr['attribute:image'] = $page->photo;
			
			$lines[] = $line_arr;
			$length++;
		}

		if ($length != 0) $block_arr['subnodes:items'] = $lines;
		$block_arr['total'] = $length;
		
		return $this->parseTemplate('', $block_arr, null);
	}
	
	
	
	
	
	public function test($categoryID=NULL, $amount=0, $domain) {
		echo "<br/>begin test";
		$s = "123123.jp";
		if ($this->checkImageFile($s)) echo "<br/> image";
		else echo "<br/> не имадже";
		
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