<?php
abstract class __search_new_catalog extends catalog_custom  {

	
	
	public function MaxMinPrice($path_id=NULL,$field=NULL,$dataType = NULL, $i_need_deep=NULL,$limit=NULL,$p=0) {
			$hierarchy = umiHierarchy::getInstance();
			
			if(!is_numeric($path_id) && $path_id) $path_id = $hierarchy->getIdByPath($path_id);
			
               if(!$i_need_deep) $i_need_deep=5;
               if(!$field) $field='price';
               if(!$path_id) $path_id='/';
			   $id_Type = $hierarchy->getDominantTypeId($path_id, $i_need_deep);
				//$id_Type = 83;
			    
			   if (!$dataType) $dataType = 'float';
			   
              $sel = new selector('pages');
				//$sel->types('hierarchy-type')->name('catalog', 'object');
               $sel->types('object-type')->id($id_Type);
               $sel->where('domain')->equals(2);
               $sel->where($field)->equals(0);
               $sel->where('hierarchy')->page($path_id)->childs($i_need_deep);
               if($limit)
                    $offset = NULL;
                    $offset = $p*$limit;
                    $sel->limit($offset, $limit);
               $sql_query_string=$sel->query();
			   
			   $field_id = $sel->where($field)->fieldId;
			   $field_sql = "oc_".$field_id."_lj.".$dataType."_val";
			  
			   $needle = "(".$field_sql." = '0') AND ";
			   $sql_query_string = str_replace($needle, '', $sql_query_string);
			   $sql_query_string = str_replace('SQL_CALC_FOUND_ROWS h.id as id, h.rel as pid', 'MAX('.$field_sql.') ,MIN('.$field_sql.')', $sql_query_string);
			  
			/*	print_r($sel->types('hierarchy-type'));
				exit();
              
              
                 $sql="SELECT MAX(oc_257_lj.float_val) ,MIN(oc_257_lj.float_val)
					FROM cms3_hierarchy h, cms3_object_types t, cms3_permissions p, cms3_hierarchy_relations hr, cms3_objects o
					LEFT JOIN cms3_object_content oc_257_lj ON oc_257_lj.obj_id=o.id AND oc_257_lj.field_id = '257'
					WHERE o.type_id IN (80, 117, 119, 122, 121, 124) AND t.id = o.type_id AND h.type_id IN (55) AND h.lang_id = '1' AND h.is_deleted = '0' AND h.is_active = '1' AND (p.rel_id = h.id AND p.level & 1 AND p.owner_id IN(13)) AND h.id = hr.child_id AND (hr.level <= 5 AND hr.rel_id = $path_id) AND h.obj_id = o.id
					ORDER BY h.ord ASC";*/
              
              
              
               $result_max = l_mysql_query($sql_query_string);
               list($max,$min) = mysql_fetch_row(l_mysql_query($sql_query_string));
               return array('min'=>$min, 'max'=>$max);
	}
		  
	public static function protectStringVariable($stringVariable = "") {
			$stringVariable = htmlspecialchars($stringVariable);
			return $stringVariable;
		} 
	
	public function search_new($category_id = false, $depth = 1, $group_names = "", $template = "default", $type_id = false) {
		if(!$template) $template = "default";

		if($type_id === false) {
			$category_id = $this->analyzeRequiredPath($category_id);
			if(!$category_id) return "";
		}


		list($template_block, $template_block_empty, $template_block_line, $template_block_line_text,
			$template_block_line_relation, $template_block_line_item_relation, $template_block_line_item_relation_separator,
			$template_block_line_price, $template_block_line_boolean, $template_block_line_symlink) =

			self::loadTemplates("catalog/".$template, "search_block", "search_block_empty",
			"search_block_line", "search_block_line_text", "search_block_line_relation",
			"search_block_line_item_relation", "search_block_line_item_relation_separator",
			"search_block_line_price", "search_block_line_boolean", "search_block_line_symlink");

		$block_arr = Array();

		if($type_id === false) {
			$type_id = umiHierarchy::getInstance()->getDominantTypeId($category_id, $depth);
		}

		if(is_null($type_id)) return "";

		if(!($type = umiObjectTypesCollection::getInstance()->getType($type_id))) {
			trigger_error("Failed to load type", E_USER_WARNING);
			return "";
		}
		
		$resultObj = $this->filterField($category_id, $type_id, $depth);
		if(empty($resultObj)) return array();
		
		$resultObjTest = $this->filterField($category_id, $type_id, $depth, true);
		
		if ($resultObjTest) {
			foreach($resultObjTest as $keyT => $valT) {
				if (!isset($resultObj[$keyT])) {$resultObj[$keyT]['hidden'] = $valT;continue;}
				foreach($valT as $key => $val) {
					if (!in_array($val,$resultObj[$keyT])) $resultObj[$keyT]['hidden'][] = $val;
				}
			}
		}
		//print_r($resultObjTest);print_r($resultObj);exit("11");
		
		$fields = Array();
		$groups = Array();
		$lines = Array();

		$group_names = trim($group_names);
		if($group_names) {
			$group_names_arr = explode(" ", $group_names);
    			foreach($group_names_arr as $group_name) {
				if(!($fields_group = $type->getFieldsGroupByName($group_name))) {
				} else {
					$groups[] = $fields_group;
				}
			}
		} else {
			$groups = $type->getFieldsGroupsList();
		}


		$lines_all = Array();
		$groups_arr = Array();

		foreach($groups as $fields_group) {
			$fields = $fields_group->getFields();

			$group_block = Array();
			$group_block['attribute:name'] = $fields_group->getName();
			$group_block['attribute:title'] = $fields_group->getTitle();

			$lines = Array();

			foreach($fields as $field_id => $field) {
				if(!$field->getIsVisible()) continue;
				if(!$field->getIsInFilter()) continue;

				$line_arr = Array();

				$field_type_id = $field->getFieldTypeId();
				$field_type = umiFieldTypesCollection::getInstance()->getFieldType($field_type_id);

				$data_type = $field_type->getDataType();

				$line = Array();
				switch($data_type) {
					case "relation": {
						$line = $this->parseSearchRelationNew($field, $template_block_line_relation, $template_block_line_item_relation, $template_block_line_item_relation_separator, $resultObj);
						break;
					}

					case "text": {
						$line = $this->parseSearchTextNew($field, $template_block_line_text);
						break;
					}

					case "date": {
						$line = $this->parseSearchDateNew($field, $template_block_line_text);
						break;
					}

					case "string": {
						$line = $this->parseSearchTextNew($field, $template_block_line_text);
						break;
					}

					case "wysiwyg": {
						$line = $this->parseSearchTextNew($field, $template_block_line_text);
						break;
					}

					case "float":
					case "price": {
			    			$line = $this->parseSearchPriceNew($field, $template_block_line_price, $category_id, $resultObj,$depth);
						break;
					}

					case "int": {
						$line = $this->parseSearchIntNew($field, $template_block_line_text, $category_id, $resultObj,$depth);
						break;
					}

					case "boolean": {
						$line = $this->parseSearchBooleanNew($field, $template_block_line_boolean);
						break;
					}

					case "symlink": {
						$line = $this->parseSearchSymlinkNew($field, $template_block_line_symlink, $category_id, $resultObj);
						break;
					}

					default: {
						$line = "[search filter for \"{$data_type}\" not specified]";
						break;
					}
				}

				if (self::isXSLTResultMode()) {
					if (is_array($line)) {
					$line['attribute:data-type'] = $data_type;
				}
				}

				$line_arr['void:selector'] = $line;

				if (self::isXSLTResultMode()) {
					$lines[] = $line;
				} else {
					$lines[] = $tmp = self::parseTemplate($template_block_line, $line_arr);
					$lines_all[] = $tmp;
				}
			}


			if(empty($lines)) {
				continue;
			}

			$group_block['nodes:field'] = $lines;
			$groups_arr[] = $group_block;

		}

		$block_arr['void:items'] = $block_arr['void:lines'] = $lines_all;
		$block_arr['nodes:group'] = $groups_arr;
		$block_arr['attribute:category_id'] = $category_id;
		$block_arr['attribute:type_id'] = $type_id;

		if(!$groups_arr && !$lines && !$this->isXSLTResultMode()) {
			return $template_block_empty;
		}

		return self::parseTemplate($template_block, $block_arr);
	}
	
	
		
	public function filterField($path_id = false, $type_id=false, $depth=1, $request=false) {
		$hierarchy = umiHierarchy::getInstance();
		$arr = array();
		$resRequest = array();
		if(!is_numeric($path_id) && $path_id) $path_id = $hierarchy->getIdByPath($path_id);
		if (!$path_id) $path_id='/';
		
		
		if($type_id === false) {
			$type_id = $hierarchy->getDominantTypeId($path_id, $depth);
		}
		
		if(!($type = umiObjectTypesCollection::getInstance()->getType($type_id))) {
			trigger_error("Failed to load type", E_USER_WARNING);
			return "";
		}
		
		if ($request) {
			$resRequest['fields_filter'] = getRequest('fields_filter');
			$_REQUEST['fields_filter'] = array();
			if(getRequest('order_filter')){
				$resRequest['order_filter'] = getRequest('order_filter');
				$_REQUEST['order_filter'] = null;
			}
		}
				
		$catalogObjects = $this->getObjectsListNew($template = 'default', $path_id, 1000, true, $depth, false, true, $request);
		if ($request) {
			$_REQUEST['fields_filter'] = $resRequest['fields_filter'];
			if(isset($resRequest['order_filter'])) $_REQUEST['order_filter'] = $resRequest['order_filter'];
		}
		
		//print_r($_REQUEST);exit();
		if (!isset($catalogObjects['lines'])) return array();
			foreach($catalogObjects['lines']['nodes:item'] as $key => $object) {
				$page = $hierarchy->getElement($object['attribute:id']);
				foreach($type->getFieldsGroupsList() as $fieldsGroup) {
					foreach($fieldsGroup->getFields() as $field) {
						if(!$field->getIsVisible()) continue;
						
						if(!$field->getIsInFilter()) continue;
						
						if ($page->getValue($field->getName())) {
							if (!isset($arr[$field->getName()])) {
								if( is_array($page->getValue($field->getName())) ) {
										foreach($page->getValue($field->getName()) as $value) {
											
											if (is_object($value)) {
												if (!isset($arr[$field->getName()])) $arr[$field->getName()][] = $value->id; else {
													if(!in_array($value->id, $arr[$field->getName()])) $arr[$field->getName()][] = $value->id;
												}
											} else {
												if (!isset($arr[$field->getName()])) $arr[$field->getName()][] = $value; else {
													if(!in_array($value, $arr[$field->getName()])) $arr[$field->getName()][] = $value;
												}
											}
										/* 
											if (!isset($arr[$field->getName()])) { $arr[$field->getName()][] = $value; } elseif (is_object($value)) {
												$id_test = $value->id;
												var_dump($arr[$field->getName()]);
												var_dump(in_array($id_test, $arr[$field->getName()]));exit();
												if(!in_array($value->id, $arr[$field->getName()])) $arr[$field->getName()][] = $value->id;
											} else {
												if(!in_array($value, $arr[$field->getName()])) $arr[$field->getName()][] = $value;
											}
											
											if(!in_array($value, $arr[$field->getName()])) $arr[$field->getName()][] = $value; */
										}
									}
									else $arr[$field->getName()][] = $page->getValue($field->getName());
							} elseif (!in_array($page->getValue($field->getName()), $arr[$field->getName()])) {
									if( is_array($page->getValue($field->getName())) ) {
											foreach($page->getValue($field->getName()) as $value) {
												if (is_object($value)) {
													if(!in_array($value->id, $arr[$field->getName()])) $arr[$field->getName()][] = $value->id;
												} else{
													if(!in_array($value, $arr[$field->getName()])) $arr[$field->getName()][] = $value;
												}
											}
										}
									else $arr[$field->getName()][] = $page->getValue($field->getName());
							}
						}
					}
				}
			}
		//print_r($arr);exit();
		
		return (!empty($arr))?$arr:false;
	}
	
	public function parseSearchRelationNew(umiField $field, $template, $template_item, $template_separator, $objects=false) {
		$block_arr = Array();

		$name = $field->getName();
		$title = $field->getTitle();

		$guide_id = $field->getGuideId();
		$guide_items = umiObjectsCollection::getInstance()->getGuidedItems($guide_id);

		$fields_filter = getRequest('fields_filter');
		$value = getArrayKey($fields_filter, $name);

		$items = Array();
		$i = 0;
		$sz = sizeof($guide_items);

		$is_tpl = !def_module::isXSLTResultMode();
		if (!$is_tpl) $template_item = true;

		$unfilter_link = "";

		foreach($guide_items as $object_id => $object_name) {
			if (is_array($value)) {
				$selected = (in_array($object_id, $value)) ? "selected" : "";
			}
			else {
				$selected = ($object_id == $value) ? "selected" : "";
			}

			if ($template_item) {
				$line_arr = Array();
				$line_arr['attribute:id'] = $line_arr['void:object_id'] = $object_id;
				$line_arr['node:object_name'] = $object_name;

				$params = $_GET;
				unset($params['path']);
				unset($params['p']);
				$params['fields_filter'][$name] = $object_id;
				$filter_link = "?" . http_build_query($params, '', '&amp;');

				unset($params['fields_filter'][$name]);
				$unfilter_link = "?" . http_build_query($params, '', '&amp;');

				$line_arr['attribute:filter_link'] = $filter_link;
				$line_arr['attribute:unfilter_link'] = $unfilter_link;
				//print_r($objects);exit();
				if (!$objects) $line_arr['attribute:visible'] = 'visible'; else {
					if(isset($objects[$name])){
						foreach ($objects[$name] as $k => $v) {
							if ($object_id == $v) $line_arr['attribute:visible'] = 'visible';
							if (isset($objects[$name]['hidden'])){
								for ($i=0;$i<sizeOf($objects[$name]['hidden']);$i++){
									if ($object_id == $objects[$name]['hidden'][$i]) $line_arr['attribute:visible'] = 'hidden';
									//print_r($objects[$name]['hidden'][$i]); echo ", ";
								}
							}
						}
						
						if (!in_array($object_id, $objects[$name]) && !array_key_exists('attribute:visible', $line_arr)) {unset($line_arr);continue;}
					} else {unset($line_arr);continue;}
				}

				if ($selected) {
					$line_arr['attribute:selected'] = "selected";
				}

				$items[] = def_module::parseTemplate($template_item, $line_arr);

				if (++$i < $sz) {
					if ($is_tpl) {
						$items[] = $template_separator;
					}
				}
			}
			else {
				$items[] = "<option value=\"{$object_id}\" {$selected}>{$object_name}</option>";
			}
		}

		$block_arr['attribute:unfilter_link'] = $unfilter_link;
		$block_arr['attribute:name'] = $name;
		$block_arr['attribute:title'] = $title;
		$block_arr['subnodes:values'] = $block_arr['void:items'] = $items;
		$block_arr['void:selected'] = ($value) ? "" : "selected";
		return def_module::parseTemplate($template, $block_arr);
	}

	public function parseSearchTextNew(umiField $field, $template, $objects=false) {
		$block_arr = Array();

		$name = $field->getName();
		$title = $field->getTitle();

		if ($fields_filter = getRequest('fields_filter')) {
			$value = (string) getArrayKey($fields_filter, $name);
		}
		else $value = NULL;

		$block_arr['attribute:name'] = $name;
		$block_arr['attribute:title'] = $title;
		$block_arr['value'] = self::protectStringVariable($value);

		return def_module::parseTemplate($template, $block_arr);
	}

	public function parseSearchPriceNew(umiField $field, $template, $cat_id=false, $objects=false,$depth=1) {
		$block_arr = Array();

		$name = $field->getName();
		$title = $field->getTitle();
		$dataType = 'float';
			//print_r($objects);exit();
		unset($objects[$name]['hidden']);
		if(isset($objects[$name])) $cuurentObj = $objects[$name]; else $cuurentObj[] = 0;

		$fields_filter = getRequest('fields_filter');
		$value = (array) getArrayKey($fields_filter, $name);
			
		if ($cat_id) $arr = $this->MaxMinPrice($cat_id, $name, $dataType, $depth);
		
		$value_from =	(getArrayKey($value, 0))? getArrayKey($value, 0): min($cuurentObj);
		$value_to	=	(getArrayKey($value, 1))? getArrayKey($value, 1): max($cuurentObj);
		
		$block_arr['attribute:name'] = $name;
		$block_arr['attribute:title'] = $title;
		$block_arr['value_from'] = self::protectStringVariable($value_from);
		$block_arr['value_to'] = self::protectStringVariable($value_to);
		if (isset($arr)) {$block_arr['min'] = $arr['min'];$block_arr['max'] = $arr['max'];}
		return def_module::parseTemplate($template, $block_arr);
	}

	public function parseSearchIntNew(umiField $field, $template, $cat_id=false, $objects=false, $depth=1) {

		$block_arr = Array();
		

		$name = $field->getName();
		$title = $field->getTitle();
		$dataType = $field->getFieldType()->getDataType();
		
		unset($objects[$name]['hidden']);
		if(isset($objects[$name])) $cuurentObj = $objects[$name];
		
		$fields_filter = getRequest('fields_filter');
		$value = (array) getArrayKey($fields_filter, $name);
		
		if ($cat_id) $arr = $this->MaxMinPrice($cat_id, $name, $dataType,$depth);
		
		if(empty($cuurentObj)) $cuurentObj[] = 0;
		
		$value_from =	(getArrayKey($value, 0))? getArrayKey($value, 0): min($cuurentObj);
		$value_to	=	(getArrayKey($value, 1))? getArrayKey($value, 1): max($cuurentObj);

		$block_arr['attribute:name'] = $name;
		$block_arr['attribute:title'] = $title;
		$block_arr['value_from'] = intval($value_from);
		$block_arr['value_to'] = intval($value_to);
		
		if (isset($arr)) {$block_arr['min'] = $arr['min'];$block_arr['max'] = $arr['max'];}

		return def_module::parseTemplate($template, $block_arr);
	}

	public function parseSearchBooleanNew(umiField $field, $template, $objects=false) {
		$block_arr = Array();

		$name = $field->getName();
		$title = $field->getTitle();

		$fields_filter = getRequest('fields_filter');
		$value = (array) getArrayKey($fields_filter, $name);

		$block_arr['attribute:name'] = $name;
		$block_arr['attribute:title'] = $title;
		$block_arr['checked'] = ((bool) getArrayKey($value, 0)) ? " checked" : "";
		return def_module::parseTemplate($template, $block_arr);
	}

	public function parseSearchDateNew(umiField $field, $template, $objects=false) {
		$block_arr = Array();

		$name = $field->getName();
		$title = $field->getTitle();

		if($fields_filter = getRequest('fields_filter')) {
			$value = (array) getArrayKey($fields_filter, $name);
		} else {
			$value = NULL;
		}

		$block_arr['attribute:name'] = $name;
		$block_arr['attribute:title'] = $title;

		$from = getArrayKey($value, 0);
		$to = getArrayKey($value, 1);

		$values = Array(
			"from"	=> self::protectStringVariable($from),
			"to"	=> self::protectStringVariable($to)
		);
		$block_arr['value'] = $values;
		return def_module::parseTemplate($template, $block_arr);
	}

	public function parseSearchSymlinkNew(umiField $field, $template, $category_id, $objects=false) {
		$block_arr = Array();
		$items = Array();

		$name = $field->getName();
		$title = $field->getTitle();

		$sel = new selector('pages');
		$sel->types('hierarchy-type');
		$sel->where('hierarchy')->page($category_id)->childs(1);

		$guide_items = array();

		foreach($sel->result as $element) {
			if ($value = $element->getValue($name)) {
				foreach($value as $object) {
					$guide_items[$object->id] = $object->name;
				}
			}
		}

		$fields_filter = getRequest('fields_filter');
		$value = getArrayKey($fields_filter, $name);

		$is_tpl = !def_module::isXSLTResultMode();
		$unfilter_link = "";

		foreach($guide_items as $object_id => $object_name) {
			if (is_array($value)) {
				$selected = (in_array($object_id, $value)) ? "selected" : "";
			}
			else {
				$selected = ($object_id == $value) ? "selected" : "";
			}

			if ($is_tpl) {
				$items[] = "<option value=\"{$object_id}\" {$selected}>{$object_name}</option>";
			}
			else {
				$line_arr = Array();
				$line_arr['attribute:id'] = $line_arr['void:object_id'] = $object_id;
				$line_arr['node:object_name'] = $object_name;

				$params = $_GET;
				unset($params['path']);
				unset($params['p']);
				$params['fields_filter'][$name] = $object_id;

				$filter_link = "?" . http_build_query($params, '', '&amp;');

				unset($params['fields_filter'][$name]);
				$unfilter_link = "?" . http_build_query($params, '', '&amp;');

				$line_arr['attribute:filter_link'] = $filter_link;
				$line_arr['attribute:unfilter_link'] = $unfilter_link;
				
				if (!$objects) $line_arr['attribute:visible'] = 'visible'; else {
					if(isset($objects[$name])){
						if (in_array($object_id, $objects[$name])) $line_arr['attribute:visible'] = 'visible'; else $line_arr['attribute:visible'] = 'hidden';
					}
				}

				if ($selected) $line_arr['attribute:selected'] = "selected";

				$items[] = def_module::parseTemplate('', $line_arr);
			}
		}

		$block_arr['attribute:unfilter_link'] = $unfilter_link;
		$block_arr['attribute:name'] = $name;
		$block_arr['attribute:title'] = $title;
		$block_arr['subnodes:values'] = $block_arr['void:items'] = $items;
		$block_arr['void:selected'] = ($value) ? "" : "selected";

		return def_module::parseTemplate($template, $block_arr);
	}
	
	public function getObjectsListNew($template = "default", $path = false, $limit = false, $ignore_paging = false, $i_need_deep = 0, $field_id = false, $asc = true, $request=false) {
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
			$sel->addPropertyFilterMore($common_quantity_field_id, 0);
		}
		
		if($type_id) {
			//$this->autoDetectOrders($sel, $type_id);
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

			return self::parseTemplate($template_block_empty, $block_arr, $category_id);;
		}

	}
	public function addFilterParams($name=NULL,$value=NULL){
          if(!$name || !$value) return;
          $_REQUEST['fields_filter'][$name]=$value;
          return ;         
     }
	 	
};
?>