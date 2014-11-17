<?php
class content_custom extends def_module {
	public static $array_addit_before = array();
     //TODO: Write here your own macroses
     /* makeThumbnailCare создание картинки максимального размера в указанной области без обрезаний и искажений
          $path - путь до файла вида ./templates/primebag/images/ex.jpg,
          $width, $height - ширина и высота допустимой области,
          $template = "default" - шаблон для tpl,
          $returnArrayOnly = false - вернуть результаты в виде массива ( для админки и особых ситуаций),
          $fixHeight = заполнить фон,
          TODO нет параметра quality надо добавить
     */
     public function makeThumbnailCare($path, $width, $height, $template = "default", $returnArrayOnly = false, $fixHeight = false, $admin = false, $thumbs_path = false) { 
          if(!$template) $template = "default";
		  
          $thumbs_path = ($thumbs_path) ? $thumbs_path : "./images/cms/thumbs/";
          $image = new umiImageFile($path);
          $file_name = $image->getFileName();
          $file_ext = $image->getExt();
          $thumbPath = ($admin) ? '/thumb_admin' : sha1($image->getDirName());
		  
          if (!is_dir($thumbs_path.$thumbPath)) {
               mkdir($thumbs_path.$thumbPath, 0755);
          } 
          $file_ext = strtolower($file_ext);
          $allowedExts = Array('gif', 'jpeg', 'jpg', 'png', 'bmp');
          if(!in_array($file_ext, $allowedExts)) return "";
		  if($admin){
			$file_name_new = $file_name;
		  } else {
			  $file_name = substr($file_name, 0, (strlen($file_name) - (strlen($file_ext) + 1)) );
			  $file_name_new = $file_name . "_" . $width . "_" . $height . "." . $file_ext;
		  }
          $path_new = $thumbs_path .$thumbPath."/". $file_name_new;
          if(!file_exists($path_new) || filemtime($path_new) < filemtime($path)) {
               if(file_exists($path_new)) {
                    unlink($path_new);
               }
               $width_src = $image->getWidth();
               $height_src = $image->getHeight();
               if($width_src <= $width && $height_src <= $height) {
                    copy($path, $path_new);
                    $real_width = $width;
                    $real_height = $height;
               } else {			   
                    if ($width == "auto" && $height == "auto"){
                         $real_height = $height_src;
                         $real_width = $width_src;
                    }elseif ($width == "auto" || $height == "auto"){
                         if ($height == "auto"){
                              $real_width = (int) $width;
                              $real_height = (int) round($height_src * ($width / $width_src));
                         }elseif($width == "auto"){
                              $real_height = (int) $height;
                              $real_width = (int) round($width_src * ($height / $height_src));
                         }
                    }else{
                         //для фона
                         if($fixHeight){
                              $real_width = $width;// для макс заданного контура
                              $real_height = $height;// для макс заданного контура
                         }
                         //определяем размеры картинки
                         if($width_src > $height_src) {//горизонт
                              $real_width = $width;
                              $real_height = (int) round($height_src * ($width / $width_src));							  
                              if($real_height > (int) $height){
                                   $real_height = (int) $height;
                                   $real_width = (int) round($width_src * ($real_height / $height_src));
                              }
                         }
                         else{
                              $real_height = (int) $height;
                              $real_width = (int) round($width_src * ($height / $height_src));
                              if($real_width > $width){
                                   $real_width = (int) $width;
                                   $real_height = (int) round($height_src * ($real_width / $width_src));
                              }
                         }
                    }
                    if($fixHeight){
                        $thumb = imagecreatetruecolor($width, $height);//width для макс заданного контура
                    }
                    else $thumb = imagecreatetruecolor($real_width, $real_height);
                    if($image->getExt() == "gif") {
                         $source = imagecreatefromgif($path);
                         $thumb_white_color = imagecolorallocate($thumb, 255, 255, 255);
                         imagefill($thumb, 0, 0, $thumb_white_color);
                         imagecolortransparent($thumb, $thumb_white_color);
                         imagealphablending($source, TRUE);
                         imagealphablending($thumb, TRUE);
                    } else if($image->getExt() == "png") {
                         $source = imagecreatefrompng($path);
                         $thumb_white_color = imagecolorallocate($thumb, 255, 255, 255);
                         imagefill($thumb, 0, 0, $thumb_white_color);
                         imagecolortransparent($thumb, $thumb_white_color);
                         imagealphablending($source, TRUE);
                         imagealphablending($thumb, TRUE);
                    } else {
                         $source = imagecreatefromjpeg($path);
                         $thumb_white_color = imagecolorallocate($thumb, 255, 255, 255);
                         imagefill($thumb, 0, 0, $thumb_white_color);
                         imagecolortransparent($thumb, $thumb_white_color);
                         imagealphablending($source, TRUE);
                         imagealphablending($thumb, TRUE);
                    }
                    //определяем координаты по середине полотна
                    $dstY = 0;
                    $dstX = 0;
                    if($fixHeight){
                         $dstX = round(($width - $real_width)/2);//для макс контура
                         $dstY = round(($height - $real_height)/2);
                    }
                    imagecopyresampled($thumb, $source, $dstX, $dstY, 0, 0, $real_width, $real_height, $width_src, $height_src);
                    if($image->getExt() == "png") {
                         imagepng($thumb, $path_new);
                    } else if($image->getExt() == "gif") {
                         imagegif($thumb, $path_new);
                    } else {
                         imagejpeg($thumb, $path_new, 100);
                    }
               }
          }
          //Parsing
          $value = new umiImageFile($path_new);
          $arr = Array();
          $arr['size'] = $value->getSize();
          $arr['filename'] = $value->getFileName();
          $arr['filepath'] = $value->getFilePath();
          $arr['src'] = $value->getFilePath(true);
          $arr['ext'] = $value->getExt();
          $arr['width'] = $value->getWidth();
          $arr['height'] = $value->getHeight();
          $arr['template'] = $template;
          if(cmsController::getInstance()->getCurrentMode() == "admin") {
               $arr['src'] = str_replace("&", "&amp;", $arr['src']);
          }
          // с
          if(cmsController::getInstance()->getCurrentMode() == "admin") {
               $arr['src'] = str_replace("&", "&amp;", $arr['src']);
          }
          if($returnArrayOnly) {
               return $arr;
          } else {
               list($tpl) = def_module::loadTemplates("thumbs/".$template, "image");
               return def_module::parseTemplate($tpl, $arr);
          }
	}
	public function getCookie($val = false) {
		if (!$val) return;
		$result = (!empty($_COOKIE[$val])) ? $_COOKIE[$val] : '';
		return $result;
	}
	public function getRequestTransform($val = false) {
		if (!$val) return;
		return getRequest($val);
	}
	
	public function additional_function_content(iUmiEventPoint $oEventPoint){
		if ($oEventPoint->getMode() === "before") return true;
		if ($oEventPoint->getMode() === "after") {
			$refElemnt = &$oEventPoint->getRef('element');
			$typeData = $refElemnt->getHierarchyType();
			$ext = $typeData->getExt();
			$name_type = $typeData->getName();
			
			if ($name_type!='catalog') return true;
			$structure = './images/'.$name_type.'/'.$ext.'/'.$refElemnt->getId();
			if (!is_dir($structure)) {
				if (!mkdir($structure, 0755, true)) {
					die('Не удалось создать директории...');
				}
			}
			
		}
		return true;
	}
	public function additional_function_content_rmdir(iUmiEventPoint $oEventPoint){
		$refElemnt = &$oEventPoint->getRef('element');
		$typeData = $refElemnt->getHierarchyType();
		$ext = $typeData->getExt();
		$name_type = $typeData->getName();
		if ($name_type!='catalog') return true;
		
		$structure = './images/'.$name_type.'/'.$ext.'/'.$refElemnt->getId().'/';
		$this->remove_u($structure);
		return true;
	}
	function remove_u($dir) 
	{
		if(is_file($dir)) return unlink($dir);					
		$dh=opendir($dir); 
		if($dh===false || $dh==NULL) return;
		while(false!==($file=readdir($dh))) 
		{				
			if($file=='.'||$file=='..') continue; 			
			$this->remove_u($dir."/".$file); 
		}		
		closedir($dh); 				
		return rmdir($dir); 
	}
	
	public function JSONparse($value, $exp = false){
		if (!$value) return;
		
		$valueDecode = (!$exp) ? json_decode(urldecode($value)) : explode(';', $value);
		
		$block_arr = Array();
		$lines = Array();
		
		foreach($valueDecode as $key => $value){
			$item_arr = array();
			$item_arr['attribute:id'] = $key;
			$item_arr['attribute:text'] = $value;
			$lines[] = $item_arr;
		}
		
		if (empty($lines)) return;
		$block_arr['nodes:item'] = $lines;
		
		return $block_arr;
	}
	
	public function get_correct_str($num, $str) {
		$array_str = explode(',', trim($str));
		
	    $val = $num % 100;
	
	    if ($val > 10 && $val < 20) return $num .' '. $array_str[2];
	    else {
	        $val = $num % 10;
	        if ($val == 1) return $num .' '. $array_str[0];
	        elseif ($val > 1 && $val < 5) return $num .' '. $array_str[1];
	        else return $num .' '. $array_str[2];
	    }
	}
	
	public function communicationProducts(iUmiEventPoint $oEventPoint){
		$hierarchy = umiHierarchy::getInstance();
		$array_addit_before = array();
		
		if ($oEventPoint->getMode() === "before") {
			$refElemnt = &$oEventPoint->getRef('element');
			$ref_id = $refElemnt->id;
			
			$page = $hierarchy->getElement($ref_id);
			
			if (!$page instanceof umiHierarchyElement) {
				throw new publicException(getLabel('error-page-does-not-exist')); 
			}
			
			$additional_items = $page->getValue('additional_items');
			$this->array_addit_before[] = $ref_id;
			
			if (!isset($additional_items)) return true;
			foreach($additional_items as $key => $item) {
				$id = $item->id;
				$this->array_addit_before[] = $id;
			}
			$hierarchy->unloadElement($ref_id);
			return true;
		}
		if ($oEventPoint->getMode() === "after") {
			$refElemnt = &$oEventPoint->getRef('element');
			$ref_id = $refElemnt->id;
			
			$page = $hierarchy->getElement($ref_id);
			if (!$page instanceof umiHierarchyElement) {
				throw new publicException(getLabel('error-page-does-not-exist')); 
			}
			
			$additional_items = $page->getValue('additional_items');
			
			if (!isset($additional_items)) return true;
			
			$array_add_all[] = $ref_id;
			$array_addit_before = $this->array_addit_before;
			
			foreach($additional_items as $item) {
				$array_add_all[] = $item->id;
			}
			
			foreach($array_add_all as $k => $item) {
				$array_add_all_not_this = $array_add_all;
				
				unset($array_add_all_not_this[$k]);
				if (!$array_add_all_not_this) continue;
				
				$page = $hierarchy->getElement($item);
				if (!$page instanceof umiHierarchyElement) {
					throw new publicException(getLabel('error-page-does-not-exist')); 
				}
				$page->setValue('additional_items', $array_add_all_not_this);
				
				$key_del = array_search($item, $array_addit_before);
				
				if($array_addit_before && ($key_del || $key_del == 0)) unset($array_addit_before[$key_del]);
				$page->commit();
					unset($page);
					$hierarchy->unloadElement($item);
				continue;
			}
			unset($additional_items);unset($array_add_all_not_this);unset($array_add_all);
			
			if ($array_addit_before){
				foreach($array_addit_before as $key => $value) {
					$page_add = $hierarchy->getElement($value);
					if (!$page_add instanceof umiHierarchyElement) {
						throw new publicException(getLabel('error-page-does-not-exist')); 
					}
					$page_add->setValue('additional_items', array());
					$page_add->commit();
					unset($page_add);
					$hierarchy->unloadElement($value);
					continue;
				}
			}
			
			return true;
		}
	}
	
	public function getLink($id = NULL) {
		if(!$id) return ;
		$h = umiHierarchy::getInstance();
		return $h->getPathById($id);
	}
	
	public function sendSubscribe(iUmiEventPoint $oEventPoint){
		if ($oEventPoint->getMode() === "before") return true;
		if ($oEventPoint->getMode() === "after") {
			$refElemnt = &$oEventPoint->getRef('element');
			$common_quantity = (int) $refElemnt->getValue('common_quantity');
			if($common_quantity > 0){
				$list_of_subscribers = $refElemnt->getValue('list_of_subscribers');
				if(!$list_of_subscribers) return true;
				
				$collection = domainsCollection::getInstance();
				$domain = $collection->getDefaultDomain();
				$host = false;
				if ($domain instanceof domain) {
					$host = $domain->getHost();
				}
				
				$list_of_subscribers = explode(';', $list_of_subscribers);
				$oMail = new umiMail();
				
				foreach($list_of_subscribers as $email){
					$email = trim($email);
					$oMail->addRecipient( $email, $email );
				};
				$link = "<a href='".umiHierarchy::getInstance()->getPathById($refElemnt->id)."' target='_blank'>".$refElemnt->getName()."</a>";
				$text = "Поступил товар ".$link; 
				
				$from = "no-replay@".$host;
				$oMail->setFrom($from, $from);
				$oMail->setSubject("Уведомление");
				$oMail->setContent($text);
				$oMail->commit();
				$oMail->send();
				$refElemnt->setValue('list_of_subscribers', '');
				$refElemnt->commit();
			}
		}
		return true;
	}
	
	public function parseFileContent($id = false, $field_name = false, $lowerType = false){
		if(!$id) return false;
		$field_name = ($field_name) ? $field_name : 'upload_file_custom';
		$lowerType = ($lowerType) ? $lowerType : false;
		
		$hierarchy = umiHierarchy::getInstance();
		$element = $hierarchy->getElement($id);
		$jsonFILE = $element->getValue($field_name); 
		
		$jsonFILE = json_decode($jsonFILE, true);
		$items = array();
		if(empty($jsonFILE)) return;
		
		foreach($jsonFILE as $key => $value ){
			$item = array();
			$item['attribute:name'] = $value['name'];
			$item['attribute:src'] = $value['src'];
			$item['attribute:type'] = ($lowerType) ? mb_strtolower($value['type'], 'UTF-8') : mb_strtoupper($value['type'], 'UTF-8');
			$item['node:text'] = $value['altName'];
			$items[] = $item;
		}
		$block_arr['items']['nodes:item'] = $items;
		return $block_arr;
	}
	
	public function getAnonsOrContent($id = null, $count = null, $fieldName = null, $getAnons = null, $getName = null){
		if(!$id) return;
		$hierarchy = $hierarchy = umiHierarchy::getInstance();
		$element = $hierarchy->getElement($id);
		$count = ($count) ? (int) $count : 200;
		$fieldName = ($fieldName) ? $fieldName : 'content';
		$getAnons = ($getAnons) ? (bool) $getAnons : false;
		$getName = ($getName) ? (bool) $getName : false;
		
		if(!$element instanceof umiHierarchyElement) return "Не удалось получить страницу.";
	
		$encoding="utf-8";
		if($getAnons){
			if($anons = $element->getValue('anons')) {
				return $anons;
			}
		}
		$threeDots = false;
		if($getName){
			$content = trim($element->getName());
		}elseif($content = $element->getValue($fieldName)){
			$content = preg_replace("/<[^<]+?>/", "", $content);
			$threeDots = true;
		}
		$content = html_entity_decode($content, ENT_QUOTES, $encoding);
		
		if($content && mb_strlen($content, $encoding) > $count){
			$content = mb_substr($content, 0, $count, $encoding);
			$content = rtrim($content, "!,.-");
			$content = substr($content, 0, strrpos($content, ' '));

			if($threeDots) $content = $content."...";
		}
		return $content;
	}
	
};
?>