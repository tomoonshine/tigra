<?php
class search_custom extends search {
	public function search_doN($template = "default", $search_string = "", $search_types = "", $search_branches = "", $per_page = 0) {
               list(
                    $template_block, $template_line, $template_empty_result, $template_line_quant
               ) = def_module::loadTemplates("search/".$template,
                    "search_block", "search_block_line", "search_empty_result", "search_block_line_quant"
               );

               // поисковая фраза :
               if (!$search_string) $search_string = (string) getRequest('search_string');
               $search_string = rawurldecode($search_string); // декодируем строчку из адресной строки. Используем вместо  urldecode , функецию rawurldecode так как с предыдущей теряем + в строке запроса
               $search_string = str_replace(array('"', "'","."), "%", $search_string); // заменяем запрещенные символы на %
               $search_string = trim($search_string, " \t\r\n%"); // обрезаем переносы
               $search_string = htmlspecialchars($search_string);  // экранируем все спец символы
               $search_string = mysql_real_escape_string($search_string); // экранируем запрос для sql

               if (!$search_string) return $this->insert_form($template);

               $lines = Array();
              
               $p = (int) getRequest('p');
               if (!$per_page) $per_page = intval(getRequest('per_page'));
               if (!$per_page) $per_page = $this->per_page;
               $i = $per_page * $p;
			   
			   $common_quantity = regedit::getInstance()->getVal("//modules/settings_site/hide_null_quantity");
              
				$pages = new selector('pages');
				$pages->types('hierarchy-type')->name('catalog', 'object');
				//if ($common_quantity) $pages->where('common_quantity')->eqmore(1);
				$pages->where('name')->like('%'.$search_string.'%');
				
				//$sql = $pages->query();
				//print_r($sql);exit();
				$pages->limit($i, $per_page); // offset,limit
				$total = $pages->length;
			   
				
				if (!$total){
					$pages->flush();
					$pages = new selector('pages');
					$pages->types('hierarchy-type')->name('catalog', 'object');
					$pages->where('artikul')->like('%'.$search_string.'%');
					//if ($common_quantity) $pages->where('common_quantity')->equals(1);
					$total = $pages->length;
				}


               foreach($pages as $element) {
                    $line_arr = Array();

                    $element_id = $element->id;
                    $element = umiHierarchy::getInstance()->getElement($element_id);
					$array_image = json_decode(trim($element->getValue('tigra21_image_gallery')), true);
					
					if(!empty($array_image)) {
						$pathinfo = pathinfo($array_image[0]['src']);
						$src_image = $pathinfo['dirname'].'/thumb_admin/'.$pathinfo['basename'];
					}
					
                    $line_arr['void:num'] = ++$i;
                    $line_arr['attribute:id'] = $element_id;
                    $line_arr['attribute:name'] = $element->getName();
                    $line_arr['attribute:link'] = umiHierarchy::getInstance()->getPathById($element_id);
                    $line_arr['attribute:src_image'] = $src_image;
                    //$line_arr['attribute:common_quantity'] = $element->getValue('common_quantity');
                    $line_arr['xlink:href'] = "upage://" . $element_id;
                    //$line_arr['node:context'] = searchModel::getInstance()->getContext($element_id, $search_string);
                    $lines[] = def_module::parseTemplate($template_line, $line_arr, $element_id);

                    $this->pushEditable(false, false, $element_id);
                   
                    umiHierarchy::getInstance()->unloadElement($element_id);
               }

               $block_arr['subnodes:items'] = $block_arr['void:lines'] = $lines;
               $block_arr['total'] = $total;
               $block_arr['per_page'] = $per_page;

               return def_module::parseTemplate(($total > 0 ? $template_block : $template_empty_result), $block_arr);
          }
};
?>