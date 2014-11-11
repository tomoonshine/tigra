<?php
class users_custom extends def_module {
        //TODO: Write here your own macroses
		
		public function __construct($self) {
			$self->__loadLib("/__auth_social.php", (dirname(__FILE__)));
			$self->__implement("__auth_social_".get_class($self));
			
		}
        
        public function viewed_objects_add(){
			$viewed = regedit::getInstance()->getVal("//modules/settings_site/viewed");
			if(!$viewed) return;
               //$_SESSION['viewed_objects']='';
               $hierarchy = umiHierarchy::getInstance();
            
               $watching_id = cmsController::getInstance()->getCurrentElementId();
               $watching_page = $hierarchy->getElement($watching_id);
            
               if(!$watching_page) return ;            
               // block for auth user
               if($this->is_auth()) {
                    $user_id = $this->user_id;
                    $user_object = umiObjectsCollection::getInstance()->getObject($user_id);
                    $viewed_objects = $user_object->viewed_objects;
                 
                    // try to find and place first
                    foreach($viewed_objects as $key=>$viewed_object){
                         if($watching_id == $viewed_object->id){                           
                              list($viewed_objects[0], $viewed_objects[$key]) = array($viewed_objects[$key], $viewed_objects[0]);
                           
                              $viewed_objects = array_slice($viewed_objects, 0, 20);
                              $user_object -> viewed_objects = $viewed_objects;
                              $user_object -> commit();
                              return ;
                         }
                    }
                    // add by first element
                    array_unshift($viewed_objects, $watching_id);
                    $viewed_objects = array_slice($viewed_objects, 0, 20);
                    $user_object -> viewed_objects = $viewed_objects;
                    $user_object -> commit();
                    return ;                 
               } else {
               // block for guest
                    $guest_id = umiObjectsCollection::getInstance()->getObjectIdByGUID('system-guest');
                    $_SESSION['user_id'] = $guest_id;
                    $tmp_viewed_objects = array();
                    if(!isset($_SESSION['viewed_objects'])) $_SESSION['viewed_objects'] = array();
                    $tmp_viewed_objects = $_SESSION['viewed_objects'];
					
                    // try to find and place first
                    foreach($tmp_viewed_objects as $key=>$viewed_object){
                         if($watching_id == $viewed_object){                           
                              list($tmp_viewed_objects[0], $tmp_viewed_objects[$key]) = array($tmp_viewed_objects[$key], $tmp_viewed_objects[0]);
                           
                              $tmp_viewed_objects = array_slice($tmp_viewed_objects, 0, 20);
                              $_SESSION['viewed_objects'] = $tmp_viewed_objects;
                              return ;
                         }
                    }
                    // add by first element
                    array_unshift($tmp_viewed_objects, $watching_id);
                    $tmp_viewed_objects = array_slice($tmp_viewed_objects, 0, 20);
                    $_SESSION['viewed_objects'] = $tmp_viewed_objects;
                    return ;
               }
        }
		
		public function electee_item($id){
			$electee = regedit::getInstance()->getVal("//modules/settings_site/electee");
			if(!$electee) return;
			$auth = $this->is_auth();
			if (!$id) $this->redirect($this->pre_lang . "/");
			
			$hierarchy = umiHierarchy::getInstance();
			$watching_page = $hierarchy->getElement($id);
			if(!$watching_page) return;
				$refererUrl = getServer('HTTP_REFERER');
			if($auth){
				$user_id = $this->user_id;
				$user_object = umiObjectsCollection::getInstance()->getObject($user_id);
			}
			$electee_objects = ($auth) ? $user_object->getValue('electee_objects') : $_SESSION['electee_objects'];
			$electee_objects = json_decode($electee_objects, true);
					
			if (!$electee_objects) $electee_objects = array();
                    // try to find and place first
				foreach($electee_objects as $electee_object){
					if($id == $electee_object){
						$this->redirect($this->pre_lang . $refererUrl);
					}
				}
                    // add by first element
				array_unshift($electee_objects, $id);
				$electee_objects = json_encode($electee_objects);
				
			if($auth){
				$user_object->setValue('electee_objects', $electee_objects);
				$user_object->commit();
			} else {
				$_SESSION['electee_objects'] = $electee_objects;
			}
				
			return $this->redirect($this->pre_lang . $refererUrl);
		}
		
		public function electee_delete($id){
			$electee = regedit::getInstance()->getVal("//modules/settings_site/electee");
			if(!$electee) return;
			$auth = $this->is_auth();
			if (!$id) $this->redirect($this->pre_lang . "/");
			
			$hierarchy = umiHierarchy::getInstance();
            $watching_page = $hierarchy->getElement($id);
            if(!$watching_page) return;
			$refererUrl = getServer('HTTP_REFERER');
			
			if($auth){
				$user_id = $this->user_id;
				$user_object = umiObjectsCollection::getInstance()->getObject($user_id);
			}
			$electee_objects = ($auth) ? $user_object->getValue('electee_objects') : $_SESSION['electee_objects'];
			$electee_objects = json_decode($electee_objects, true);
			$electee_objectsNew = array();
					
                    // try to find and place first
			foreach($electee_objects as $key=>$electee_object){
				if($id == $electee_object){
					$keyRem = $key;
				} else {
					$electee_objectsNew[] = $electee_object;
				}
			}
			
			$electee_objects = json_encode($electee_objectsNew);
			if($auth){
				$user_object->setValue('electee_objects', $electee_objects);
				$user_object->commit();
			} else {
				$_SESSION['electee_objects'] = $electee_objects;
			}
			
			return $this->redirect($this->pre_lang . $refererUrl);
		}
		
		public function electee_test($id){
			$electee = regedit::getInstance()->getVal("//modules/settings_site/electee");
			if(!$electee) return;
			$auth = $this->is_auth();
			if (!$id) $this->redirect($this->pre_lang . "/");
		
			$hierarchy = umiHierarchy::getInstance();
            $watching_page = $hierarchy->getElement($id);
            if(!$watching_page) return;
			
            if($auth){
				$user_id = $this->user_id;
				$user_object = umiObjectsCollection::getInstance()->getObject($user_id);
			}
			$session_electee_objects = (isset($_SESSION['electee_objects'])) ? $_SESSION['electee_objects'] : json_encode(array());
			$electee_objects = ($auth) ? $user_object->getValue('electee_objects') : $session_electee_objects;
			$electee_objects = json_decode($electee_objects, true);
			if (!$electee_objects) $electee_objects = array();
                
                    // try to find and place first
			foreach($electee_objects as $key=>$electee_object){
				if($id == $electee_object){
					return array('result' => true);
				}
			}
					
			return array('result' => false);
		}
		
	public function electee_item_view(){
		$electee = regedit::getInstance()->getVal("//modules/settings_site/electee");
		if(!$electee) return;
		$auth = $this->is_auth();
		$hierarchy = umiHierarchy::getInstance();
		$block_arr = Array();
        $line_arr = Array();
		$lines = Array();
		
		$refererUrl = getServer('HTTP_REFERER');
		
		if($auth){
			$user_id = $this->user_id;
			$user_object = umiObjectsCollection::getInstance()->getObject($user_id);
		}
		$session_electee_objects = (isset($_SESSION['electee_objects'])) ? $_SESSION['electee_objects'] : json_encode(array());
		$electee_objects = ($auth) ? $user_object->getValue('electee_objects') : $session_electee_objects;
		$electee_objects = json_decode($electee_objects, true);
		if (!$electee_objects) $electee_objects = array();
            
		foreach ($electee_objects as $electee_object){
			$page = $hierarchy->getElement($electee_object);
			if(!$page instanceof umiHierarchyElement) {unset($electee_object); continue;}
			$line_arr['attribute:id'] = $electee_object;
			$line_arr['attribute:name'] = $page->name;
			$line_arr['attribute:link'] = $hierarchy->getPathById($electee_object);
			$lines[] = $this->parseTemplate('', $line_arr);
		   $hierarchy->unloadElement($electee_object);
		}
		$block_arr['subnodes:lines'] = $lines;
		return def_module::parseTemplate('', $block_arr);
	}
       
// ???? ???????? ??? ?????? ????? ? ??????? ????????????? ??????? ??? ?????? ???? ?????  $rand_keys = array_rand ($viewed_objects,$random_count); ?????????? ?? ??????, ? 0
    public function viewed_objects_show(){
		$viewed = regedit::getInstance()->getVal("//modules/settings_site/viewed");
		if(!$viewed) return;
        $block_arr = Array();
        $line_arr = Array();
        if($this->is_auth()) {
            $user_id = $this->user_id;
            $user_object = umiObjectsCollection::getInstance()->getObject($user_id);
            $viewed_objects = $user_object->viewed_objects;
            $viewed_objects_size = sizeof($viewed_objects);
			if($viewed_objects_size>0){
                //random 1 element
                srand ((float) microtime() * 10000000);
                $random_count = 2;
                if($viewed_objects_size<2) $random_count = $viewed_objects_size;
                //$rand_keys = array_rand ($viewed_objects,3);
                if($random_count==1){
                         $id=$viewed_objects[0];//$viewed_object->id;
                              $line_arr['attribute:id'] = $id;
                              $lines[] = $this->parseTemplate('', $line_arr, $id);
                       
                    }
                    else{
						$rand_keys = array_rand ($viewed_objects,$random_count);
                         foreach($rand_keys as $rand_key){
                              $id=$viewed_objects[$rand_key];//$viewed_object->id;
                              $line_arr['attribute:id'] = $id;
                              $lines[] = $this->parseTemplate('', $line_arr, $id);
                         }
                    }
                $block_arr['subnodes:lines'] = $lines;
            }
            return $this->parseTemplate('', $block_arr);
        } else {
            (isset($_SESSION['viewed_objects'])) ? $tmp_viewed_objects = $_SESSION['viewed_objects']: $tmp_viewed_objects = array();
            
			$tmp_viewed_objects_size = sizeof($tmp_viewed_objects);
            if($tmp_viewed_objects_size>0){
                //random 1 element
                srand ((float) microtime() * 10000000);
                $random_count = 2;
                if($tmp_viewed_objects_size<2) $random_count = $tmp_viewed_objects_size;
                    if($random_count==1){
                              $id=$tmp_viewed_objects[0];//$viewed_object;
                              $line_arr['attribute:id'] = $id;
                              $lines[] = $this->parseTemplate('', $line_arr, $id);                      
                    }
                    else{
						$rand_keys = array_rand ($tmp_viewed_objects,$random_count);
                         foreach($rand_keys as $rand_key){
                              $id=$tmp_viewed_objects[$rand_key];//$viewed_object;
                              $line_arr['attribute:id'] = $id;
                              $lines[] = $this->parseTemplate('', $line_arr, $id);
                         }
                    }
                $block_arr['subnodes:lines'] = $lines;
            }
            return $this->parseTemplate('', $block_arr);
        }
        return ;
    }
	
	public function viewed_objects_show_new($test=false){
		$viewed = regedit::getInstance()->getVal("//modules/settings_site/viewed");
		if(!$viewed) return;
		
        $block_arr = Array();
		$viewed_objects = array();
        if($this->is_auth()) {
            $user_id = $this->user_id;
            $user_object = umiObjectsCollection::getInstance()->getObject($user_id);
			
			if ($user_object->viewed_objects) {
				foreach($user_object->viewed_objects as $obj){
                    $viewed_objects[] = $obj->id;
                }
			}
		} else {
			$viewed_objects = (isset($_SESSION['viewed_objects'])) ? $_SESSION['viewed_objects']: array();
		}
        $returnFunction = ($test==false)? $this->arr_view_object($viewed_objects) : $this->arr_view_object_all($viewed_objects);
        
		$block_arr['subnodes:lines'] = $returnFunction;
        return $this->parseTemplate('', $block_arr);
    }
	
    public function arr_view_object($tmp_viewed_objects){
        $line_arr = Array();
        $lines = Array();
		$hierarchy = umiHierarchy::getInstance();
               
        $tmp_viewed_objects_size = sizeof($tmp_viewed_objects);
		//print_r($tmp_viewed_objects);
			//		exit();
            if($tmp_viewed_objects_size>0){
                //random 1 element
				
                $random_count = 1;
                if($tmp_viewed_objects_size<$random_count) $random_count = $tmp_viewed_objects_size;
                   
                $test_keys = array_rand($tmp_viewed_objects, $random_count);
				if ($random_count==1) $rand_keys[] = $test_keys; else $rand_keys = $test_keys;
						 
                foreach($rand_keys as $rand_key){
                    $id=$tmp_viewed_objects[$rand_key];//$viewed_object;
					//$page = $hierarchy->getElement($id);
                    $line_arr['attribute:id'] = $id;
                    $line_arr['attribute:link'] = $hierarchy->getPathById($id);
					$line_arr['node:text'] = $hierarchy->getElement($id)->getName();
                    $lines[] = $this->parseTemplate('', $line_arr, $id);
                }
            }
            return $lines;
    }
	
	public function arr_view_object_all($tmp_viewed_objects){
		$hierarchy = umiHierarchy::getInstance();
        $line_arr = Array();
        $lines = Array();
            foreach($tmp_viewed_objects as $tmp_viewed_object){
                $id=$tmp_viewed_object;//$viewed_object;
                $line_arr['attribute:id'] = $id;
				$line_arr['attribute:link'] = $hierarchy->getPathById($id);
				$line_arr['node:text'] = $hierarchy->getElement($id)->getName();
                $lines[] = $this->parseTemplate('', $line_arr, $id);
			}
        return $lines;
    }
	
	public function registrate_do_new($template = "default") {
			if ($this->is_auth()) {
				$this->redirect($this->pre_lang . "/");
			}
			if (!($template = getRequest('template'))) {
				$template = 'default';
			}
			$objectTypes = umiObjectTypesCollection::getInstance();
			$regedit = regedit::getInstance();

			$refererUrl = getServer('HTTP_REFERER');
			$without_act = (bool) $regedit->getVal("//modules/users/without_act");

			$objectTypeId	= $objectTypes->getBaseType("users","user");
			if ($customObjectTypeId = getRequest('type-id')) {
				$childClasses = $objectTypes->getChildClasses($objectTypeId);
				if (in_array($customObjectTypeId, $childClasses)) {
					$objectTypeId = $customObjectTypeId;
				}
			}

			$objectType = $objectTypes->getType($objectTypeId);

			$this->errorSetErrorPage($refererUrl);
			
			$login = $this->validateLogin(getRequest('email'), false, true);
			$password = $this->validatePassword(getRequest('password'), getRequest('password_confirm'), getRequest('email'), true);
			$email = $this->validateEmail(getRequest('email'), false, !$without_act);

			//Captcha validation
			if (isset($_REQUEST['captcha'])) {
				$_SESSION['user_captcha'] = md5((int) getRequest('captcha'));
			}

			if (!umiCaptcha::checkCaptcha()) {
				$this->errorAddErrors('errors_wrong_captcha');
			}

			$this->errorThrow('public');

			$oEventPoint = new umiEventPoint("users_registrate");
			$oEventPoint->setMode("before");
			$oEventPoint->setParam("login",	$login);
			$oEventPoint->addRef("password", $password);
			$oEventPoint->addRef("email", $email);
			$this->setEventPoint($oEventPoint);

			//Creating user...
			$objectId = umiObjectsCollection::getInstance()->addObject($login, $objectTypeId);
			$activationCode = md5($login . time());

			$object = umiObjectsCollection::getInstance()->getObject($objectId);

			$object->setValue("login", $login);
			$object->setValue("password", md5($password));
			$object->setValue("e-mail", $email);

			$object->setValue("is_activated", $without_act);
			$object->setValue("activate_code", $activationCode);
			$object->setValue("referer", urldecode(getSession("http_referer")));
			$object->setValue("target", urldecode(getSession("http_target")));
			$object->setValue("register_date", umiDate::getCurrentTimeStamp());
			$object->setValue("referer", getSession("http_referer"));
			$object->setValue("target", getSession("http_target"));
			$object->setValue("register_date", umiDate::getCurrentTimeStamp());

			if ($without_act) {
				$_SESSION['cms_login'] = $login;
				$_SESSION['cms_pass'] = md5($password);
				$_SESSION['user_id'] = $objectId;

				session_commit();
			}

			$group_id = regedit::getInstance()->getVal("//modules/users/def_group");
			$object->setValue("groups", Array($group_id));
			
			cmsController::getInstance()->getModule('data');
			$data_module = cmsController::getInstance()->getModule('data');
			$data_module->saveEditedObject($objectId, true);
			
			 $fio_full_new = trim($object->getValue('fname'));
				$arr = explode(' ', $fio_full_new);
				$arr[1] = (isset($arr[1])) ? $arr[1] : $arr[0];
				$object->setValue('lname', $arr[0]);
				$object->setValue('fname', $arr[1]);
				$object->setValue('father_name', $arr[2]);
			
			$object->commit();

			if ($eshop_module = cmsController::getInstance()->getModule('eshop')) {
				$eshop_module->discountCardSave($objectId);
			}

			//Forming mail...
			list(
				$template_mail, $template_mail_subject, $template_mail_noactivation, $template_mail_subject_noactivation
			) = def_module::loadTemplatesForMail("users/register/".$template,
				"mail_registrated", "mail_registrated_subject", "mail_registrated_noactivation", "mail_registrated_subject_noactivation"
			);

			if ($without_act && $template_mail_noactivation && $template_mail_subject_noactivation) {
				$template_mail = $template_mail_noactivation;
				$template_mail_subject = $template_mail_subject_noactivation;
			}

			$mailData = array(
				'user_id' => $objectId,
				'domain' => $domain = $_SERVER['HTTP_HOST'],
				'activate_link' => "http://" . $domain . $this->pre_lang . "/users/activate/" . $activationCode . "/",
				'login' => $login,
				'password' => $password,
				'lname' => $object->getValue("lname"),
				'fname' => $object->getValue("fname"),
				'father_name' => $object->getValue("father_name"),
			);

			$mailContent = def_module::parseTemplateForMail($template_mail, $mailData, false, $objectId);
			$mailSubject = def_module::parseTemplateForMail($template_mail_subject, $mailData, false, $objectId);

			$fio = $object->getValue("lname") . " " . $object->getValue("fname") . " " . $object->getValue("father_name");

			$email_from = regedit::getInstance()->getVal("//settings/email_from");
			$fio_from = regedit::getInstance()->getVal("//settings/fio_from");


			$registrationMail = new umiMail();
			$registrationMail->addRecipient($email, $fio);
			$registrationMail->setFrom($email_from, $fio_from);
			$registrationMail->setSubject($mailSubject);
			$registrationMail->setContent($mailContent);
			$registrationMail->commit();
			$registrationMail->send();

			$oEventPoint = new umiEventPoint("users_registrate");
			$oEventPoint->setMode("after");
			$oEventPoint->setParam("user_id", $objectId);
			$oEventPoint->setParam("login", $login);
			$this->setEventPoint($oEventPoint);

			if ($without_act) {
				$this->redirect($this->pre_lang . "/users/registrate_done/?result=without_activation");
			} else {
				$this->redirect($this->pre_lang . "/users/registrate_done/");
			}
		}
	
	public function testEmailValid($email = null) {
		
		$email = ($email)? $email : getRequest('email');
			
		if (!$email) {
			return;
		}

		$sel = new selector('objects');
		$sel->types('object-type')->name('users', 'user');
		$sel->where('e-mail')->equals($email);
		$sel->limit(0, 1);

		if($sel->first) {
				$result = true;
			} else {
				$result = false;
		}
		//print_r($result);
		//exit();
		
		if (!defined('VIA_HTTP_SCHEME')) {
			echo json_encode($result);
				exit();
			} else {
			return $result;
		}
	}
	
	public function fastRegistrateAndLogin(){
		if ($this->is_auth()) {
			if (!defined('VIA_HTTP_SCHEME')) {
				$test = json_encode(array('text'=> 'Извините, Вы уже авторизованы. Пожалуйста, перезагрузите страницу.', 'classAlert' => 'info'));
				echo $test;
				exit();
			} else $this->redirect($this->pre_lang . "/");
		}
		$test_auth = json_decode(getRequest('test_auth'));
		
		if ($test_auth == TRUE) {
			$res = "";
			$login = getRequest('email_fast_reg');
			$password = getRequest('password_fast_reg');
			$skin_sel = getRequest('skin_sel');

			$from_page = getRequest('from_page');

			if(strlen($login) == 0) {
				if (!defined('VIA_HTTP_SCHEME')) {
					$test = json_encode(array('text' => $this->auth(), 'classAlert' => 'error'));
					echo $test;
					exit();
				} else return $this->auth();
			}

			$permissions = permissionsCollection::getInstance();
			$cmsController = cmsController::getInstance();

			$user = $permissions->checkLogin($login, $password);
			

			if($user instanceof iUmiObject) {
				$permissions->loginAsUser($user);

				if ($permissions->isSv($user->id)) {
					$session = session::getInstance();
					$session->set('user_is_sv', true);
					$session->set('csrf_token', md5(rand() . microtime()));
					$session->setValid();
				}

				$login = $user->getValue('login');

				session::commit();

				$oEventPoint = new umiEventPoint("users_login_successfull");
				$oEventPoint->setParam("user_id", $user->id);
				$this->setEventPoint($oEventPoint);

				if($cmsController->getCurrentMode() == "admin") {
					ulangStream::getLangPrefix();
					system_get_skinName();
					$this->chooseRedirect($from_page);
				} else {
					if (!defined('VIA_HTTP_SCHEME')) {
						$test = json_encode(array('text'=> 'Авторизация прошла успешно.', 'classAlert' => 'success', 'redirect' => true));
						echo $test;
						exit();
					} else {
						if(!$from_page) {
							$from_page = getServer('HTTP_REFERER');
						}
						$this->redirect($from_page ? $from_page : ($this->pre_lang . '/users/auth/'));
					}
				}

			} else {
				$oEventPoint = new umiEventPoint("users_login_failed");
				$oEventPoint->setParam("login", $login);
				$oEventPoint->setParam("password", $password);
				$this->setEventPoint($oEventPoint);

				$res = '<p><warning>Неверный логин / пароль</warning></p>';

				if($cmsController->getCurrentMode() == "admin") {
					throw new publicAdminException(getLabel('label-text-error'));
				} elseif (!defined('VIA_HTTP_SCHEME')) {
					$test = json_encode(array('text'=> 'Неверный логин или пароль', 'classAlert' => 'error'));
					echo $test;
					exit();
				} else return $this->auth();
			}

			if (!defined('VIA_HTTP_SCHEME')) {
				$test = json_encode(array('text'=> 'Неверный логин или пароль', 'classAlert' => 'error'));
				echo $test;
				exit();
			} else return $res;
		}
		
			if (!($template = getRequest('template'))) {
				$template = 'default';
			}
			$objectTypes = umiObjectTypesCollection::getInstance();
			$regedit = regedit::getInstance();

			$refererUrl = getServer('HTTP_REFERER');
			$without_act = (bool) $regedit->getVal("//modules/users/without_act");

			$objectTypeId	= $objectTypes->getBaseType("users","user");
			if ($customObjectTypeId = getRequest('type-id')) {
				$childClasses = $objectTypes->getChildClasses($objectTypeId);
				if (in_array($customObjectTypeId, $childClasses)) {
					$objectTypeId = $customObjectTypeId;
				}
			}

			$objectType = $objectTypes->getType($objectTypeId);

			$this->errorSetErrorPage($refererUrl);

			$login = $this->validateLogin(getRequest('email_fast_reg'), false, true);
			$password = $this->validatePassword(getRequest('password_fast_reg'), getRequest('password_fast_reg'), getRequest('email_fast_reg'), true);
			$email = $this->validateEmail(getRequest('email_fast_reg'), false, !$without_act);

			//Captcha validation
			if (isset($_REQUEST['captcha'])) {
				$_SESSION['user_captcha'] = md5((int) getRequest('captcha'));
			}

			if (!umiCaptcha::checkCaptcha()) {
				$this->errorAddErrors('errors_wrong_captcha');
			}

			$this->errorThrow('public');

			$oEventPoint = new umiEventPoint("users_registrate");
			$oEventPoint->setMode("before");
			$oEventPoint->setParam("login",	$login);
			$oEventPoint->addRef("password", $password);
			$oEventPoint->addRef("email", $email);
			$this->setEventPoint($oEventPoint);

			//Creating user...
			$objectId = umiObjectsCollection::getInstance()->addObject($login, $objectTypeId);
			$activationCode = md5($login . time());

			$object = umiObjectsCollection::getInstance()->getObject($objectId);

			$object->setValue("login", $login);
			$object->setValue("password", md5($password));
			$object->setValue("e-mail", $email);

			$object->setValue("is_activated", $without_act);
			$object->setValue("activate_code", $activationCode);
			$object->setValue("referer", urldecode(getSession("http_referer")));
			$object->setValue("target", urldecode(getSession("http_target")));
			$object->setValue("register_date", umiDate::getCurrentTimeStamp());
			$object->setValue("referer", getSession("http_referer"));
			$object->setValue("target", getSession("http_target"));
			$object->setValue("register_date", umiDate::getCurrentTimeStamp());

			if ($without_act) {
				$_SESSION['cms_login'] = $login;
				$_SESSION['cms_pass'] = md5($password);
				$_SESSION['user_id'] = $objectId;

				session_commit();
			}

			$group_id = regedit::getInstance()->getVal("//modules/users/def_group");
			$object->setValue("groups", Array($group_id));
			
			/* cmsController::getInstance()->getModule('data');
			$data_module = cmsController::getInstance()->getModule('data');
			$data_module->saveEditedObject($objectId, true); 
			
			 $fio_full_new = trim(getRequest('full_name'));
				$arr = explode(' ', $fio_full_new);
				$arr[1] = (isset($arr[1])) ? $arr[1] : $arr[0];
				$object->setValue('lname', $arr[0]);
				$object->setValue('fname', $arr[1]);
				$object->setValue('father_name', $arr[2]);*/
			
			$object->commit();

			if ($eshop_module = cmsController::getInstance()->getModule('eshop')) {
				$eshop_module->discountCardSave($objectId);
			}

			//Forming mail...
			list(
				$template_mail, $template_mail_subject, $template_mail_noactivation, $template_mail_subject_noactivation
			) = def_module::loadTemplatesForMail("users/register/".$template,
				"mail_registrated", "mail_registrated_subject", "mail_registrated_noactivation", "mail_registrated_subject_noactivation"
			);

			if ($without_act && $template_mail_noactivation && $template_mail_subject_noactivation) {
				$template_mail = $template_mail_noactivation;
				$template_mail_subject = $template_mail_subject_noactivation;
			}

			$mailData = array(
				'user_id' => $objectId,
				'domain' => $domain = $_SERVER['HTTP_HOST'],
				'activate_link' => "http://" . $domain . $this->pre_lang . "/users/activate/" . $activationCode . "/",
				'login' => $login,
				'password' => $password,
				'lname' => $object->getValue("lname"),
				'fname' => $object->getValue("fname"),
				'father_name' => $object->getValue("father_name"),
			);

			$mailContent = def_module::parseTemplateForMail($template_mail, $mailData, false, $objectId);
			$mailSubject = def_module::parseTemplateForMail($template_mail_subject, $mailData, false, $objectId);

			$fio = $object->getValue("lname") . " " . $object->getValue("fname") . " " . $object->getValue("father_name");

			$email_from = regedit::getInstance()->getVal("//settings/email_from");
			$fio_from = regedit::getInstance()->getVal("//settings/fio_from");


			$registrationMail = new umiMail();
			$registrationMail->addRecipient($email, $fio);
			$registrationMail->setFrom($email_from, $fio_from);
			$registrationMail->setSubject($mailSubject);
			$registrationMail->setContent($mailContent);
			$registrationMail->commit();
			$registrationMail->send();

			$oEventPoint = new umiEventPoint("users_registrate");
			$oEventPoint->setMode("after");
			$oEventPoint->setParam("user_id", $objectId);
			$oEventPoint->setParam("login", $login);
			$this->setEventPoint($oEventPoint);
			
			if (!defined('VIA_HTTP_SCHEME')) {
				$test = json_encode(array('text'=> 'Регистрация прошла успешно. Спасибо!', 'classAlert' => 'success',  'redirect' => true));
				echo $test;
				exit();
			}

			if ($without_act) {
				$this->redirect($this->pre_lang . "/users/registrate_done/?result=without_activation");
			} else {
				$this->redirect($this->pre_lang . "/users/registrate_done/");
			}
	}
	
	
	public function settings_do_pre() {
		//exit('aaa'.$customer_id);
		$customer_id = $this->user_id;
		$fio_full_new = trim(getRequest("full_name"));
		
		$arr = explode(' ', $fio_full_new);
		if(!isset($arr[1])){
			$arr[1] = $arr[0];
			$arr[0] = '';
		}
		//$arr[1] = (isset($arr[1])) ? $arr[1] : $arr[0];
		$_REQUEST['data'][$customer_id]['lname'] = $arr[0];
		$_REQUEST['data'][$customer_id]['fname'] = $arr[1];
		$_REQUEST['data'][$customer_id]['father_name'] = $arr[2];
		
		return $this->settings_do(); 
	}
	
	public function registrate_pre_do($template = "default") {
		$login = getRequest('email');
		$password = getRequest('password');
		$password_confirm = getRequest('password_confirm');
		$data = getRequest('data');
		$fio_full_new = trim(getRequest('full_name'));
		$phone = trim($data['new']['phone']);
		
		$refererUrl = getServer('HTTP_REFERER');
		$this->errorSetErrorPage($refererUrl);
		
		$error = false;
		
		if(isset($login)){
			$email = trim($login);
			$valid = $email ? $email : (bool) $email;
			//Validators
			if($email) {
				if (!umiMail::checkEmail($email)) {
					$this->errorNewMessage(getLabel('error-email-wrong-format'));
					$valid = false;
					$error = true;
				}
				
				if (!$this->checkIsUniqueEmail($email, $userId)) {
					$this->errorNewMessage(getLabel('error-email-exists'));
					$valid = false;
					$error = true;
				}
			}
			
			$_REQUEST['login'] = $login;
			$_REQUEST['email'] = $email;
		} else{
			$this->errorNewMessage("Вам необходимо указать логин");
			//$this->errorPanic();
		}
		
		if(isset($password)){
			if (isset($password_confirm) && $password_confirm === $password) {
				$_REQUEST['password'] = $password;
				$_REQUEST['password_confirm'] = $password_confirm;
			} else {
				$this->errorNewMessage("Пароли должны совпадать");
				$error = true;
				//$this->errorPanic();
			}
		} else{
			$this->errorNewMessage("Вам необходимо указать пароль");
			$error = true;
			//$this->errorPanic();
		}
		
		$arr = explode(' ', $fio_full_new);
		$oEmarketMdl = cmsController::getInstance()->getModule("emarket");		
		if(!isset($arr[1])) {$arr[1] = $arr[0]; $arr[0] = ""; }
		$arrVlaue = array("lname" => $arr[0], "fname" => $arr[1], "father_name" => $arr[2]);
		
		
		$validFullName = $oEmarketMdl->validFullName('users','user', $arrVlaue);
		
		
		if ($validFullName){
			$massageError = $validFullName['massage'];
			unset($validFullName['massage']);
			$massageError .= " обязательное поле для заполнения";
			
			foreach($validFullName as $value){
				if($value) {
					$this->errorNewMessage($massageError);
					$error = true;
				}
			}
		} else {
			$_REQUEST['data']['new']['lname'] = $arr[0];
			$_REQUEST['data']['new']['fname'] = $arr[1];
			$_REQUEST['data']['new']['father_name'] = $arr[2];
		}
		
		if($error) $this->errorPanic();
		
		$_REQUEST['data']['new']['phone'] = $phone;
		
		$this->registrate_do();
	}
	
	public function testAJAX(iUmiEventPoint $event){
		$userId = $event->getParam("user_id");
		$ajax = getRequest('ajax');
		
		if (!$ajax) return true;
		
		if($userId) {
			$text = 'successfull';
		}  else {
			$text = array('error' => 'Не верный логин или пароль');
		}
		echo json_encode($text);
		exit();
	}
	
	public function SettingsTestAJAX(iUmiEventPoint $event){
		if ($event->getMode() == 'before') return;
		if ($event->getMode() == 'after') {
			$ajax = getRequest('ajax');
			
			if (!$ajax) return true;
			
			if(!is_null(getRequest('_err')) == false) {
				$text = 'successfull';
			} else {
				$text = array('error' => 'Извините, что-то пошло не так.');
			}
			echo json_encode($text);
			exit();
		}
	}
	
	public function electee_item_setuser_login_do(iUmiEventPoint $event){
		$userId = $event->getParam("user_id");
		$this->electee_item_setuser($userId);
	}
	
	public function electee_item_setuser_registrate(iUmiEventPoint $event){
		if ($event->getMode() == 'before') return;
		if ($event->getMode() == 'after') {
			$userId = $event->getParam("user_id");
			$this->electee_item_setuser($userId);
		}
	}
	
	public function electee_item_setuser($userId = null){
		if (!$userId) return;
		$userObject = umiObjectsCollection::getInstance()->getObject($userId);
		$electee_objects = array();
		
		$electee_objects_users = json_decode($userObject->getValue('electee_objects'), true);
		$electee_objects_session = json_decode($_SESSION['electee_objects'], true);
		
		if (!$electee_objects_users) $electee_objects_users = array();
		if (!$electee_objects_session) $electee_objects_session = array();
		
		foreach ($electee_objects_session as $key => $value) {
			$resSearch = array_search($value, $electee_objects_users);
			if($resSearch === false) array_push($electee_objects_users, $value);
		}
		foreach ($electee_objects_users as $key => $value){
			$electee_objects[] = $value;
		}
		$userObject->setValue('electee_objects', json_encode($electee_objects));
		$userObject->commit();
		
		return;
	}
	
};
?>