<?php
class catalog_custom extends catalog {

	public function __construct($self) {
		$self->__loadLib("/search_new.php", (dirname(__FILE__)));
		$self->__implement("__search_new_catalog");
		
	}
	
	//TODO: Write here your own macroses
	public function getObjectsListBrands($brends_id = NULL, $path = false, $limit = false, $ignore_paging = false, $i_need_deep = 0, $field_id = false, $asc = true) {
		$template = "default";

		if (!$i_need_deep) $i_need_deep = intval(getRequest('param4'));
		if (!$i_need_deep) $i_need_deep = 0;
		$i_need_deep = intval($i_need_deep);
		if ($i_need_deep === -1) $i_need_deep = 100;

		$hierarchy = umiHierarchy::getInstance();

		list($template_block, $template_block_empty, $template_block_search_empty, $template_line) = def_module::loadTemplates("catalog/".$template, "objects_block", "objects_block_empty", "objects_block_search_empty", "objects_block_line");

		$hierarchy_type_id = umiHierarchyTypesCollection::getInstance()->getTypeByName("catalog", "object")->getId();

		$category_id = $this->analyzeRequiredPath($path);

		if($category_id === false && $path != KEYWORD_GRAB_ALL) {
			throw new publicException(getLabel('error-page-does-not-exist', null, $path));
		}

		$category_element = $hierarchy->getElement($category_id);

		$per_page = ($limit) ? $limit : $this->per_page;
		$curr_page = getRequest('p');
		if($ignore_paging) $curr_page = 0;

		$sel = new umiSelection;
		$sel->setElementTypeFilter();
		$sel->addElementType($hierarchy_type_id);

		if($path != KEYWORD_GRAB_ALL) {
			$sel->setHierarchyFilter();
			$sel->addHierarchyFilter($category_id, $i_need_deep);
		}

		$sel->setPermissionsFilter();
		$sel->addPermissions();

		$hierarchy_type = umiHierarchyTypesCollection::getInstance()->getType($hierarchy_type_id);
		$type_id = umiObjectTypesCollection::getInstance()->getBaseType($hierarchy_type->getName(), $hierarchy_type->getExt());


		if($path === KEYWORD_GRAB_ALL) {
			$curr_category_id = cmsController::getInstance()->getCurrentElementId();
		} else {
			$curr_category_id = $category_id;
		}


		if($path != KEYWORD_GRAB_ALL) {
			$type_id = $hierarchy->getDominantTypeId($curr_category_id, $i_need_deep, $hierarchy_type_id);
		}

		if(!$type_id) {
			$type_id = umiObjectTypesCollection::getInstance()->getBaseType($hierarchy_type->getName(), $hierarchy_type->getExt());
		}


		if($type_id) {
			$this->autoDetectOrders($sel, $type_id);
			$this->autoDetectFilters($sel, $type_id);

			if($this->isSelectionFiltered) {
				$template_block_empty = $template_block_search_empty;
				$this->isSelectionFiltered = false;
			}
			
			if($brends_id) {
				$objectTypes = umiObjectTypesCollection::getInstance();
				$objectTypeId = $objectTypes->getBaseType("catalog", "object");
				$objectType = $objectTypes->getType($objectTypeId);
				$fieldId=$objectType->getFieldId('proizvoditel');
				$sel->addPropertyFilterEqual($fieldId, $brends_id);
				//exit($fieldId.'-aaa-'.$brends_id);
			}
		} else {
			$sel->setOrderFilter();
			$sel->setOrderByName();
		}

		if($curr_page !== "all") {
			$curr_page = (int) $curr_page;
			$sel->setLimitFilter();
			$sel->addLimit($per_page, $curr_page);
		}

		if($field_id) {
			if (is_numeric($field_id)) {
				$sel->setOrderByProperty($field_id, $asc);
			} else {
				if ($type_id) {
					$field_id = umiObjectTypesCollection::getInstance()->getType($type_id)->getFieldId($field_id);
					if ($field_id) {
						$sel->setOrderByProperty($field_id, $asc);
					} else {
						$sel ->setOrderByOrd($asc);
					}
				} else {
					$sel ->setOrderByOrd($asc);
				}
			}
		}
		else {
			$sel ->setOrderByOrd($asc);
		}


		$result = umiSelectionsParser::runSelection($sel);
		$total = umiSelectionsParser::runSelectionCounts($sel);

		if(($sz = sizeof($result)) > 0) {
			$block_arr = Array();

			$lines = Array();
			for($i = 0; $i < $sz; $i++) {
				$element_id = $result[$i];
				$element = umiHierarchy::getInstance()->getElement($element_id);

				if(!$element) continue;

				$line_arr = Array();
				$line_arr['attribute:id'] = $element_id;
				$line_arr['attribute:alt_name'] = $element->getAltName();
				$line_arr['attribute:link'] = umiHierarchy::getInstance()->getPathById($element_id);
				$line_arr['xlink:href'] = "upage://" . $element_id;
				$line_arr['node:text'] = $element->getName();

				$lines[] = self::parseTemplate($template_line, $line_arr, $element_id);

				$this->pushEditable("catalog", "object", $element_id);
				umiHierarchy::getInstance()->unloadElement($element_id);
			}

			$block_arr['subnodes:lines'] = $lines;
			$block_arr['numpages'] = umiPagenum::generateNumPage($total, $per_page);
			$block_arr['total'] = $total;
			$block_arr['per_page'] = $per_page;
			$block_arr['category_id'] = $category_id;

			if($type_id) {
				$block_arr['type_id'] = $type_id;
			}

			return self::parseTemplate($template_block, $block_arr, $category_id);
		} else {
			$block_arr['numpages'] = umiPagenum::generateNumPage(0, 0);
			$block_arr['lines'] = "";
			$block_arr['total'] = 0;
			$block_arr['per_page'] = 0;
			$block_arr['category_id'] = $category_id;

			return self::parseTemplate($template_block_empty, $block_arr, $category_id);;
		}

	}
	
	public function Next_Prev($path=null,$template='default',$field_id=NULL,$asc=true) {
			$element_id = def_module::analyzeRequiredPath($path);

			if($element_id === false) {
				throw new publicException(getLabel('error-page-does-not-exist', null, $path));
			}
			list($template_block, $template_next, $template_prev) = def_module::loadTemplates("numpages/".$template, "Next_Prev", "next", "prev");
			$element = umiHierarchy::getInstance()->getElement($element_id);
			$parent_id = $element->getParentId();

			
			$hierarchy_type_id = umiHierarchyTypesCollection::getInstance()->getTypeByName("catalog", "object")->getId();
			$category_id = $parent_id;
			
			$i_need_deep = 0;
			
			$type_id = umiHierarchy::getInstance()->getDominantTypeId($category_id, $i_need_deep, $hierarchy_type_id);
			if(!$type_id){
				$hierarchy_type = umiHierarchyTypesCollection::getInstance()->getType($hierarchy_type_id);
				$type_id = umiObjectTypesCollection::getInstance()->getBaseType($hierarchy_type->getName(), $hierarchy_type->getExt());
			}
			
			$sel = new umiSelection;
			$sel->setElementTypeFilter();
			$sel->addElementType($hierarchy_type_id);
			if($path != KEYWORD_GRAB_ALL) {
				$sel->setHierarchyFilter();
				$sel->addHierarchyFilter($category_id, $i_need_deep);
			}
			$sel->setPermissionsFilter();
			$sel->addPermissions();
			if($field_id) {
				if (is_numeric($field_id)) {
					$sel->setOrderByProperty($field_id, $asc);
				} else {
					if ($type_id) {
						$field_id = umiObjectTypesCollection::getInstance()->getType($type_id)->getFieldId($field_id);
						if ($field_id) {
							$sel->setOrderByProperty($field_id, $asc);
						} else {
							$sel ->setOrderByOrd($asc);
						}
					} else {
						$sel ->setOrderByOrd($asc);
					}
				}
			}
			else {
				$sel ->setOrderByOrd($asc);
			}
			$sort_array = umiSelectionsParser::runSelection($sel);
			//$total = umiSelectionsParser::runSelectionCounts($sel);
			//$sort_array = umiHierarchy::getInstance()->getChilds($parent_id, false);
			//$sort_array = array_keys($sort_array);
			

			$prev_id = false;
			$prev_index = false;
			$next_id = false;
			$next_index = false;
			$curr_index = false;
			foreach($sort_array as $key=>$id) {
				if($id == $element_id) {
					$curr_index=$key+1;
					$next_index_tmp = $key+1;
					if(isset($sort_array[$next_index_tmp])){
						$next_id = $sort_array[$next_index_tmp];
						$next_index = $next_index_tmp+1;
					}
					break;
				} else {
					$prev_index = $key+1;
					$prev_id = $id;
				}
			}
			
			$block_arr = Array();
			$block_arr['id'] =  $element_id;
			$block_arr['total'] =  sizeof($sort_array);
			$block_arr['prev'] = def_module::parseTemplate($template_prev, array(
			'attribute:id'=>$prev_id,
			'attribute:index'=>$prev_index,
			'attribute:link'=>umiHierarchy::getInstance()->getPathById($prev_id)
			));
			
			$block_arr['next'] = def_module::parseTemplate($template_next, array(
			'attribute:id'=>$next_id,
			'attribute:index'=>$next_index,
			'attribute:link'=>umiHierarchy::getInstance()->getPathById($next_id)
			));
			$block_arr['curr_index'] = $curr_index;

			return def_module::parseTemplate($template_block, $block_arr, $prev_id);
		}
	
	public function order_by($fieldName, $parent_id=NULL, $typeId=NULL, $template = "default") {
		if(!$fieldName) return;
		$from = Array('%5B', '%5D');
		$to = Array('[', ']');
		$result = self::generateOrderBy($fieldName, $typeId, $template, $parent_id);
		$result = str_replace($from, $to, $result);
		return $result;
	}
 
	public static function generateOrderBy($fieldName, $type_id, $template = "default", $parent_id) {
	 
		if(!$template) $template = "default";
		list($template_block, $template_block_a1, $template_block_a2) = def_module::loadTemplates("tpls/numpages/{$template}.tpl", "order_by", "order_by_a", "order_by_b");
	 
		if(!$parent_id) $parent_id = cmsController::getInstance()->getCurrentElementId();
		$i_need_deep = 1;
		if(!$type_id) $type_id = umiHierarchy::getInstance()->getDominantTypeId($parent_id, $i_need_deep);
	 
		if(!($type = umiObjectTypesCollection::getInstance()->getType($type_id))) return "";
	 
		$block_arr = Array();
		if(($field_id = $type->getFieldId($fieldName)) || ($fieldName == "name")) {
			$params = $_GET;
	 
			unset($params['path']);
			$order_filter = getArrayKey($params, 'order_filter');
	 
			$tpl = 0;    
			if(is_array($order_filter)) {
				if (array_key_exists($fieldName, $order_filter)){
					if ($order_filter[$fieldName] == 1){
						$tpl = $template_block_a1;
						unset($params['order_filter']);
						$params['order_filter'][$fieldName] = 0;
						$order_direction = 1;
					} else {
						$tpl = $template_block_a2;
						unset($params['order_filter']);
						$params['order_filter'][$fieldName] = 1;
						$order_direction = 0;
					}
				} else {
					unset($params['order_filter']);
					$params['order_filter'][$fieldName] = 1;
					$tpl = $template_block;
					$order_direction = 'non';
				}
			} else {
			unset($params['order_filter']);
			$params['order_filter'][$fieldName] = 1;
			$tpl = $template_block;
			$order_direction = 'non';
			}
			
			$params = self::protectParams($params);
			unset($params['umi_authorization']);
			$q = (sizeof($params)) ? "&" . http_build_query($params, '', '&') : "";
			//$q = (sizeof($params)) ? "&amp;" . str_replace("&", "&amp;", http_build_query($params)) : "";
			$q = urldecode($q);
			$q = str_replace("%", "&#037;", $q);
	 
			$block_arr['link'] = "?" . $q;
			$block_arr['attribute:direction'] = $order_direction; //главное тут
	 
			if($fieldName == "name") {
				$block_arr['title'] = getLabel('field-name');
			} else {
				$block_arr['title'] = umiFieldsCollection::getInstance()->getField($field_id)->getTitle();
			} 
			$block_arr['field_name'] = $fieldName;
			return def_module::parseTemplate($tpl, $block_arr);
		}
		return "";
	}
	
	public function changeCount($total = NULL) {
		//check $count_list
		$count_items = func_get_args();
		
		if(sizeof($count_items) > 0) unset($count_items[0]);
		$count_items_int = array();
		foreach($count_items as $key=>$count){
			if(intval($count)>0) $count_items_int[]= intval($count);
		}
		$block_arr = Array();
		$block_arr['total'] = $total;
		if(sizeof($count_items_int) > 0){
			
			
			$params_val = $_GET;
			unset($params_val['path']);
			if(isset($params_val['p']))     unset($params_val['p']);
			
			if(isset($params_val['count'])){
				$old_count = $params_val['count'];
				unset($params_val['count']);
			}

			$line = Array();
			
			$params = self::protectParams($params_val);
			$q = (sizeof($params)) ? "&" . http_build_query($params, '', '&') : "";
			$q = urldecode($q);
			$q = str_replace("%", "&#037;", $q);
			
			$line_all_arr = Array();
			$line_all_arr['attribute:filter_link'] = "?" . $q;
			if(!isset($old_count)) $line_all_arr['attribute:selected'] = 'selected';
			$line_all_arr['attribute:count'] = 'all';
			$line[] = def_module::parseTemplate('', $line_all_arr);
			$pre_count=-1;
			foreach($count_items_int as $count){
				
				if(isset($params_val['count'])) unset($params_val['count']);                   
				$params_val['count']= $count;
				
				$params = self::protectParams($params_val);
				
				$q = (sizeof($params)) ? "&" . http_build_query($params, '', '&') : "";
				$q = urldecode($q);
				$q = str_replace("%", "&#037;", $q);
				
				$line_arr = Array();
				$line_arr['attribute:filter_link'] = "?" . $q;
				
				if(isset($total) && $total<=$count && $total<=$pre_count) $line_arr['attribute:unactive'] = 'unactive';
				if(isset($old_count) && $count == $old_count) $line_arr['attribute:selected'] = 'selected';
				$line_arr['attribute:count'] = $count;
				
				$line[] = def_module::parseTemplate('', $line_arr);
				
				$pre_count=$count;
			}
			$block_arr['subnodes:items'] = $line;
		}         
		return def_module::parseTemplate('', $block_arr);
	}
	
 
	protected static function protectParams($params) {
		foreach($params as $i => $v) {
			if(is_array($v)) {
				$params[$i] = self::protectParams($v);
			} else {
				$v = htmlspecialchars($v);
				$params[$i] = str_replace("%", "&#037;", $v);
			}
		}
		return $params;
	}
	
	public function cookieCount() {
		$countViewItem = (!empty($_COOKIE['countViewItem'])) ? $_COOKIE['countViewItem'] : '';
		return $countViewItem;
	}
		
	public function getLinkByObject($objId = NULL) {
		if(!$objId) return ;
			$h = umiHierarchy::getInstance();
			$arr_id = $h->getObjectInstances($objId);
			if (empty($arr_id)) return;
			$element_id = $arr_id[0];
			if($element_id) return $h->getPathById($element_id);
		return;
	}
	
	public function generateQRCode($id, $qr_code_size, $user_text = NULL){
			$collection = domainsCollection::getInstance();
			$domain = $collection->getDefaultDomain();
			$host = $domain->getHost();
			
			$element = umiHierarchy::getInstance()->getElement($id);
			$qr_code_text = 'Наименование товара: '.$element->name.'
URL: http://'.$host.umiHierarchy::getInstance()->getPathById($id);
		if (!empty($user_text) && $user_text!=NULL) $qr_code_text.='
'.$user_text;
			$qr_code_url = "http://chart.apis.google.com/chart?chs=".$qr_code_size."x".$qr_code_size."&amp;cht=qr&amp;chl=".urlencode($qr_code_text)."&choe=UTF-8";
	return array('url'=>$qr_code_url);
    }

	public function sortArrayRand($id, $limit=null){
		
		$arr_block = array();
		$limit = ($limit != null) ? $limit : 4;
		$hierarchy = umiHierarchy::getInstance();
		$element = $hierarchy->getElement($id);
		
		if (!$element) return;
		
		$recommended_items = $element->recommended_items;
		$common_quantity = regedit::getInstance()->getVal("//modules/settings_site/hide_null_quantity");
		
		if (isset($recommended_items)){
			shuffle($recommended_items);
			$pages_arr=array();
			foreach ($recommended_items as $key => $item){
				if ($common_quantity){
					$common_quantity_item = (int) $item->getValue('common_quantity');
					if($common_quantity_item < 1) continue;
				}
				if ($key+1 <= $limit) {
					$page['page'] = $item;
					$pages_arr[]=$item;
				} else break;
			}
			$arr_block['nodes:page'] = $pages_arr;
		}
		return $this->parseTemplate('', $arr_block);
	}
	
	 /* создает html кэш запроса $udata списка разделов и подразделов в файл /sys-temp/udatacache/temp_dynamic_category_list.xml по шаблону ~/xslt/modules/catalog/temp_dynamic_category_list.xsl */
		public function temp_dynamic_category_list($template_path = NULL, $cache_path = NULL, $udata=NULL){
			if(!$udata || !$cache_path || !$template_path) return;
			$folder = CURRENT_WORKING_DIR . '/sys-temp/udatacache/'; 
			$path = $folder . $cache_path;
			if(!is_dir($folder)) mkdir($folder, 0777, true);
			if(is_file($path)) $mtime = filemtime($path);
			$expire = 3600;

			if(!is_file($path) || time() > ($mtime + $expire)) {
			$xsltDom = new DomDocument;
			$xsltDom->resolveExternals = true;
			$xsltDom->substituteEntities = true;
			// $filePath - путь к xsl-шаблону трансформации.
			$filePath = CURRENT_WORKING_DIR . $template_path;

			$xsltDom->load($filePath, DOM_LOAD_OPTIONS);

			$xslt = new xsltProcessor;
			$xslt->registerPHPFunctions();
			$xslt->importStyleSheet($xsltDom);

			$dom_new = new DOMDocument("1.0", "utf-8");
			// $xml - xml-данные для трансформации.
			$xml = file_get_contents($udata);
			//var_dump($xml);
			//exit('ff');
			$dom_new->loadXML($xml);

			//производим трансформацию
			$result = $xslt->transformToXML($dom_new);
			//html-данные необходимо включить в CDATA и в какой либо корневой узел.
			$result = "<udata mode=\"cache\"><![CDATA[" . $result . "]]></udata>";
			file_put_contents($path, $result);

			// данный принцип возвращения данных отключает xslt-трансформацию системой UMI.CMS
			return array('plain:result' => $result);
			}else{
			$result = file_get_contents($path);
			return array('plain:result' => $result);
			}    
		}
	 
	public function getFieldTitleOpt($current_page_id=NULL, $fieldName=NULL){
		if(!$current_page_id || !$fieldName) return;
		
		$hierarchy = umiHierarchy::getInstance();
		$ObjectTypeId = $hierarchy->getElement($current_page_id)->getObjectTypeId();
		$type  = umiObjectTypesCollection::getInstance()->getType($ObjectTypeId);
		$fields = $type->getAllFields();
		
		foreach($fields as $field_id => $field) {
			if ($field->getName() == $fieldName) {
				$fieldTitle = $field->getTitle();
			} else continue;
		}
		
		return array('field-title' => $fieldTitle);         
     }
	
	
	public function getObjectDiscount($limit = null, $rand = false){
		$limit = ($limit) ? $limit : $this->per_page;
		$curr_page = getRequest('p');
		$obj_coll = umiObjectsCollection::getInstance();
		$disounts = new selector('objects');
		$disounts->types('object-type')->guid('emarket-discount');
		$disounts->where('is_active')->equals(1);
		
		$lines = Array();
		$block_arr = Array();
		$catalog_items = Array();
		$foreach_items = Array();
		
		foreach ($disounts as $discount){
			$prop_id = $discount->getValue('discount_rules_id');
			$prop = $obj_coll->getObject($prop_id[0]);
			if($items = $prop->getValue('catalog_items')){
				foreach($items as $item){
					if($item->getMethod() == 'category') {
						$category = new selector('pages');
						$category->types('hierarchy-type')->name('catalog', 'object');
						$category->where('hierarchy')->page($item->id)->childs(10);
						$catalog_items = array_merge($catalog_items, $category->result());
					} else {
						$catalog_items[] = $item;
					}
				}
			} else continue;
		}
		
		if($rand) $foreach_items = array_rand($catalog_items, $limit); else {
			$foreach_items = array_slice($catalog_items, $curr_page * $limit, $limit);
		}
		
		foreach($foreach_items as $value){
			$page = ($rand) ? $catalog_items[$value] : $value;
			$element_id = $page->id;
			$element = umiHierarchy::getInstance()->getElement($element_id);

			if(!$element) continue;

			$line_arr = Array();
			$line_arr['attribute:id'] = $element_id;
			$line_arr['attribute:alt_name'] = $element->getAltName();
			$line_arr['attribute:link'] = umiHierarchy::getInstance()->getPathById($element_id);
			$line_arr['xlink:href'] = "upage://" . $element_id;
			$line_arr['node:text'] = $element->getName();

			$lines[] = self::parseTemplate("objects_block_line", $line_arr, $element_id);

			$this->pushEditable("catalog", "object", $element_id);
			umiHierarchy::getInstance()->unloadElement($element_id);
		}
		
		$block_arr['subnodes:lines'] = $lines;
		$block_arr['total'] = sizeof($catalog_items);
		$block_arr['per_page'] = $this->per_page;
		return self::parseTemplate("objects_block_empty", $block_arr);
	}

	public function getViewCatalog($val=false) {
		if (!$val) return;
		$result = (!empty($_COOKIE[$val])) ? $_COOKIE[$val] : '';
		
		if (!$result) {
			$regedit = regedit::getInstance();
			$result = $regedit->getVal("//modules/settings_site/catalog_list_or_tile");
		}
		
		return $result;
	}
	
	
	public function getViewPagesCatalog($val=false) {
		if (!$val) return;
		$result = (!empty($_COOKIE[$val])) ? $_COOKIE[$val] : '';
	
		if (!$result) {
			$regedit = regedit::getInstance();
			$pagination = $regedit->getVal("//modules/settings_site/pagination");
			$result = ($pagination == 'all') ? 'true' : 'false';
			
			
		}
		
		return $result;
	}

	public function getPropertyLinked($id = null, $propertyGet = null, $propertyLinked = null){
		if (!$id || !$propertyGet || !$propertyLinked) return '';
		
		$hierarchy = umiHierarchy::getInstance();
		$objectsCollection = umiObjectsCollection::getInstance();
		$element = $hierarchy->getElement($id);
		$item = array();
		$items = array();
		
		$propertyGetValue = $element->getValue($propertyGet);
		$propertyGetObject = $objectsCollection->getObject($propertyGetValue);
		
		$item['@id'] = $propertyGetValue;
		$item['@name'] = $propertyGetObject->getName();
		$item['@html_color'] = $propertyGetObject->getValue('html_color');
		
		$items[] = $item;
		
		$propertyLinkedArray = $element->getValue($propertyLinked);
		$hierarchy->unloadElement($id);
		
		unset($item);
		
		foreach ($propertyLinkedArray as $key => $page) {
			$item = array();
			$idPage = $page->id;
			$pageElement = $hierarchy->getElement($idPage);
			$pageGetValue = $pageElement->getValue($propertyGet);
			$pageGetObject = $objectsCollection->getObject($pageGetValue);
			
			$item['@id'] = $idPage;
			$item['@name'] = $pageGetObject->getName();
			$item['@html_color'] = $pageGetObject->getValue('html_color');
			$item['@link'] = $hierarchy->getPathById($idPage);
			$items[] = $item;
			
			$hierarchy->unloadElement($idPage);
		}
		
		$block_arr['items']['nodes:item'] = $items;
		return $block_arr;
	}
	
	public function applyQuantity(){
		$hierarchy = umiHierarchy::getInstance();
		$pages = new selector('pages');
		$pages->types('hierarchy-type')->name('catalog', 'object');
		
		foreach($pages as $page){
			$id = $page->id;
			$pageElement = $hierarchy->getElement($id);
			$pageGetValue = (float) $pageElement->getValue('common_quantity');
			$pageElement->setValue('common_quantity',$pageGetValue);
			$pageElement->commit();
			$hierarchy->unloadElement($id);
		}
		
		return "all right";
	}
	
	public function getObjectsListAmount($template = "default", $path = false, $limit = false, $ignore_paging = false, $i_need_deep = 0, $field_id = false, $asc = true) {
		if(!$template) $template = "default";

		if (!$i_need_deep) $i_need_deep = intval(getRequest('param4'));
		if (!$i_need_deep) $i_need_deep = 0;
		$i_need_deep = intval($i_need_deep);
		if ($i_need_deep === -1) $i_need_deep = 100;

		$hierarchy = umiHierarchy::getInstance();

		list($template_block, $template_block_empty, $template_block_search_empty, $template_line) = def_module::loadTemplates("catalog/".$template, "objects_block", "objects_block_empty", "objects_block_search_empty", "objects_block_line");

		$hierarchy_type_id = umiHierarchyTypesCollection::getInstance()->getTypeByName("catalog", "object")->getId();

		$category_id = $this->analyzeRequiredPath($path);

		if($category_id === false && $path != KEYWORD_GRAB_ALL) {
			throw new publicException(getLabel('error-page-does-not-exist', null, $path));
		}

		$category_element = $hierarchy->getElement($category_id);

		$per_page = ($limit) ? $limit : $this->per_page;
		$curr_page = getRequest('p');
		if($ignore_paging) $curr_page = 0;

		$sel = new umiSelection;
		$sel->setElementTypeFilter();
		$sel->addElementType($hierarchy_type_id);

		if($path != KEYWORD_GRAB_ALL) {
			$sel->setHierarchyFilter();
			$sel->addHierarchyFilter($category_id, $i_need_deep);
		}
		
		

		$sel->setPermissionsFilter();
		$sel->addPermissions();

		$hierarchy_type = umiHierarchyTypesCollection::getInstance()->getType($hierarchy_type_id);
		$type_id = umiObjectTypesCollection::getInstance()->getBaseType($hierarchy_type->getName(), $hierarchy_type->getExt());


		if($path === KEYWORD_GRAB_ALL) {
			$curr_category_id = cmsController::getInstance()->getCurrentElementId();
		} else {
			$curr_category_id = $category_id;
		}


		if($path != KEYWORD_GRAB_ALL) {
			$type_id = $hierarchy->getDominantTypeId($curr_category_id, $i_need_deep, $hierarchy_type_id);
		}

		if(!$type_id) {
			$type_id = umiObjectTypesCollection::getInstance()->getBaseType($hierarchy_type->getName(), $hierarchy_type->getExt());
		}

		// убираем товары, которых нет в наличии
		$common_quantity = regedit::getInstance()->getVal("//modules/settings_site/hide_null_quantity");
		if($common_quantity && $type_id){
			$common_quantity_field_id = umiObjectTypesCollection::getInstance()->getType($type_id)->getFieldId('common_quantity');
			$sel->addPropertyFilterMore($common_quantity_field_id, 1);
		}
		
		if($type_id) {
			$this->autoDetectOrders($sel, $type_id);
			$this->autoDetectFilters($sel, $type_id);

			if($this->isSelectionFiltered) {
				$template_block_empty = $template_block_search_empty;
				$this->isSelectionFiltered = false;
			}
		} else {
			$sel->setOrderFilter();
			$sel->setOrderByName();
		}

		if($curr_page !== "all") {
			$curr_page = (int) $curr_page;
			$sel->setLimitFilter();
			$sel->addLimit($per_page, $curr_page);
		}

		if($field_id) {
			if (is_numeric($field_id)) {
				$sel->setOrderByProperty($field_id, $asc);
			} else {
				if ($type_id) {
					$field_id = umiObjectTypesCollection::getInstance()->getType($type_id)->getFieldId($field_id);
					if ($field_id) {
						$sel->setOrderByProperty($field_id, $asc);
					} else {
						$sel ->setOrderByOrd($asc);
					}
				} else {
					$sel ->setOrderByOrd($asc);
				}
			}
		}
		else {
			$sel ->setOrderByOrd($asc);
		}


		$result = umiSelectionsParser::runSelection($sel);
		$total = umiSelectionsParser::runSelectionCounts($sel);

		if(($sz = sizeof($result)) > 0) {
			$block_arr = Array();

			$lines = Array();
			for($i = 0; $i < $sz; $i++) {
				$element_id = $result[$i];
				$element = umiHierarchy::getInstance()->getElement($element_id);

				if(!$element) continue;

				$line_arr = Array();
				$line_arr['attribute:id'] = $element_id;
				$line_arr['attribute:alt_name'] = $element->getAltName();
				$line_arr['attribute:link'] = umiHierarchy::getInstance()->getPathById($element_id);
				$line_arr['xlink:href'] = "upage://" . $element_id;
				$line_arr['node:text'] = $element->getName();

				$lines[] = self::parseTemplate($template_line, $line_arr, $element_id);

				$this->pushEditable("catalog", "object", $element_id);
				umiHierarchy::getInstance()->unloadElement($element_id);
			}

			$block_arr['subnodes:lines'] = $lines;
			$block_arr['numpages'] = umiPagenum::generateNumPage($total, $per_page);
			$block_arr['total'] = $total;
			$block_arr['per_page'] = $per_page;
			$block_arr['category_id'] = $category_id;

			if($type_id) {
				$block_arr['type_id'] = $type_id;
			}

			return self::parseTemplate($template_block, $block_arr, $category_id);
		} else {
			$block_arr['numpages'] = umiPagenum::generateNumPage(0, 0);
			$block_arr['lines'] = "";
			$block_arr['total'] = 0;
			$block_arr['per_page'] = 0;
			$block_arr['category_id'] = $category_id;

			return self::parseTemplate($template_block_empty, $block_arr, $category_id);
		}

	}
	
	public function notice_of_item($id = false){
		$email = getRequest('email_notice');
		$json = getRequest('json');
		$id = getRequest('param0');
		if(!$email) {
			$error = array("error" => "Отсутствует E-mail'a");
			if($json) {
				echo json_encode($error);
				exit();
			} else return $error;
		}
		if(!$id) $id = cmsController::getInstance()->getCurrentElementId();
		
		$hierarchy = umiHierarchy::getInstance();
		$element = $hierarchy->getElement($id);
		$list_of_subscribers = $element->getValue('list_of_subscribers');
		
		
		if($list_of_subscribers){
			$list_of_subscribers = explode(';', $list_of_subscribers);
		} else {
			$list_of_subscribers = array();
		}
		
		if(!in_array($email, $list_of_subscribers)) $list_of_subscribers[] = $email;
		$list_of_subscribers = implode(';', $list_of_subscribers);
		$element->setValue('list_of_subscribers', $list_of_subscribers);
		$element->commit();
		
		$success = array('success' => 'Ваш e-mail успешно записан.', 'success-title' => 'Спасибо!');
		
		if($json) {
			echo json_encode($success);
			exit();
		} else return $success;
	}
	
	public function importImage($id = false){
		$id = ($id) ? $id : getRequest('param0');
		if(!$id) $id = cmsController::getInstance()->getCurrentElementId();
		$hierarchy = umiHierarchy::getInstance();
		$element = $hierarchy->getElement($id);
		$photo_new_field = $element->getValue('photo_new_field');
		if(empty($photo_new_field)) return;
		
		$name = $element->getName();
		$photoArray = explode(';', $photo_new_field);
		$photoArrayResult = array();
		foreach($photoArray as $key => $path){
			if(!$path) continue;
			$pathinfo = pathinfo($path);
			
			$photoArrayResult[] = array(
				'name' => $name,
				'altName' => $name,
				'src' => $path,
				'type' => mb_strtoupper($pathinfo['extension'], 'UTF-8')
			);
		};
		$photoResult = json_encode($photoArrayResult, JSON_FORCE_OBJECT);
		$element->setValue('tigra21_image_gallery', $photoResult);
		$element->commit();
		return $hierarchy->unloadElement($id);
	}
	
	public function importImageAll(){
		return "Depricate";
		$hierarchy = umiHierarchy::getInstance();
		$pages = new selector('pages');
		$pages->types('hierarchy-type')->name('catalog', 'object');
		
		foreach($pages as $page){
			$id = $page->id;
			$this->importImage($id);
		}
		
		return "all right";
	}
	
};
?>