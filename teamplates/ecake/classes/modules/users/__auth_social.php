<?php
	abstract class __auth_social_users extends users_custom {
		static private $client_id_vk = 4421724; // ID приложения
		static private $client_secret_vk = 'IuaYUSNkNShkvmSPQTYk'; // Защищённый ключ
		
		static private $client_id_fb = 1419828534967287; // ID приложения
		static private $client_secret_fb = '00c0eaf0f92f40bac260681d3625f254'; // Защищённый ключ
		static private $paramArray = array();
		static private $paramArrayUrl = array('vk' => array('link' => 'http://oauth.vk.com/authorize', 'name' => 'Вконтакте'), 'fb' => array('link' => 'https://www.facebook.com/dialog/oauth', 'name' => 'Facebook'));
		
		
		private function redirect_uri($siffix = ''){
			$collection = domainsCollection::getInstance();
			$domain = $collection->getDefaultDomain();
			$url = null;
			$lang = $this->pre_lang;
			if ($domain instanceof domain) {
				$host = $domain->getHost();
				$url = 'http://'.$host.$lang.'/users/callback'.$siffix.'/';
			}
			return $url;
		}
		
		private function paramsArray(){
			$objectsCollection = umiObjectsCollection::getInstance();
			$arrayResult = array();
			$social_auth =  regedit::getInstance()->getVal("//modules/settings_site/social_auth");
			
			$social_auth = explode(';', $social_auth);
			
			foreach($social_auth as $key => $value){
				$object = $objectsCollection->getObject($value);
				$suffix = $object->getValue('suffix');
				$id_app = $object->getValue('id_app');
				$secret_key = $object->getValue('secret_key');
				$ico = $object->getValue('icon');
				if(!$suffix || !$id_app || !$secret_key) continue;
				
				$arrayResult[$suffix] = array(
					'client_id'     => $id_app,
					'client_secret' => $secret_key,
					'redirect_uri'  => self::redirect_uri(strtoupper($suffix)),
					'ico' => $ico
				);
			}
			return $arrayResult;
		}
		
		
		public function __construct() {
			parent::__construct();
			
			
		}
		
		public function getUrlAuth($nameSocial = 'all'){
			$config = self::paramsArray();
			$configURL = self::$paramArrayUrl;
			$lines = $block = array();
			
			foreach($config as $suffix => $value){
				$item = array();
				$params = array(
					'client_id'     => $value['client_id'],
					'scope' 		=> 'email',
					'redirect_uri'  => $value['redirect_uri'],
					'response_type' => 'code'
				);
				$urlCFG = $configURL[$suffix];
				$item['@link'] = $urlCFG['link'].'?'.urldecode(http_build_query($params));
				if($value['ico']) $item['@ico'] = $value['ico'];
				$item['node:text'] = $urlCFG['name'];
				$lines[] = $item;
			}
			$block['items']['nodes:item'] = $lines;
			return $block;
		}
		
		public function callbackVK(){
			$lang = $this->pre_lang;
			$code = getRequest('code');
			if(!$code) return $this->redirect($lang.'users/registrate/');
			$result = false;
			$config = self::paramsArray();
			$params = $config['vk'];
			$params['scope'] = 'offline,email';
			$params['code'] = $code;
			
			$token = json_decode(file_get_contents('https://oauth.vk.com/access_token?' . urldecode(http_build_query($params))), true);
			
			if (isset($token['access_token'])) {
				$params = array(
					'uids'         => $token['user_id'],
					'fields'       => 'offline,email,contacts',
					'access_token' => $token['access_token']
				);
				$userInfo = self::api('users.get', 'https://api.vk.com/method/', $params);
				if (isset($userInfo['response'][0]['uid'])) {
					$userInfo = $userInfo['response'][0];
					$userInfo['id'] = $userInfo['uid'];
					$userInfo['email'] = $token['email'];
					$userInfo['suffix'] = 'vk';
					return self::saveProfile($userInfo);
				}
			}
			return;
		}
		
		public function callbackFB(){
			$lang = $this->pre_lang;
			$code = getRequest('code');
			if(!$code) return $this->redirect($lang.'users/registrate/');
			$result = false;
			$config = self::paramsArray();
			$params = $config['fb'];
			$params['code'] = $code;
			
			$token = null;
			parse_str(file_get_contents('https://graph.facebook.com/oauth/access_token?' . http_build_query($params)), $token);
			if (isset($token['access_token'])) {
				$params = array('access_token' => $token['access_token']);
				$userInfo = self::api('me', 'https://graph.facebook.com/', $params);
				if (isset($userInfo['id'])) {
					$userInfo['siffix'] = 'fb';
					return self::saveProfile($userInfo);
				}
			}
			return;
		}
		
		private function api($method, $api_url = 'api.vk.com/method/', $params=false) {
			if (!$params) $params = array(); 
			ksort($params);
			$params['sig'] = md5($sig);
			$query = self::api_url($api_url,$method).'?'.urldecode(http_build_query($params));
			$res = file_get_contents($query);
			return json_decode($res, true);
		}
		
		private function api_url($api_url = 'api.vk.com/method/', $method) {
			if (!strstr($api_url, 'https://')) $api_url = 'https://'.$api_url.$method; 
				else $api_url = $api_url.$method; 
			return $api_url;
		}
		
		private function saveProfile($userInfo){
			$login = $userInfo['id'].'@'.$userInfo['suffix'].'.com';
		
			$mobile_phone = '';
			if(isset($userInfo['mobile_phone'])){
				$mobile_phone = (isset($userInfo['mobile_phone'])) ? $userInfo['mobile_phone'] : "";
			}
			$mail = (isset($userInfo['email'])) ? $userInfo['email'] : $login;
			
			$lang = $this->pre_lang;
			//if(!$login) return $this->redirect($lang.'users/registrate/');
			
			$sel = new selector('objects');
			$sel->types('object-type')->name('users', 'user');
			$sel->where('login')->equals($login);
			$user =  $sel->first;
			$from_page = getRequest("from_page");
			
			if($user instanceof iUmiObject){
				permissionsCollection::getInstance()->loginAsUser($user);
				session_commit();

				$this->redirect($from_page ? $from_page : ($lang . '/users/auth/'));
			}
			
			$objectTypes = umiObjectTypesCollection::getInstance();
			$objectTypeId = $objectTypes->getBaseType("users",	"user");
			$objectType = $objectTypes->getType($objectTypeId);
			
			$object_id = umiObjectsCollection::getInstance()->addObject($login, $objectTypeId);
			$object = umiObjectsCollection::getInstance()->getObject($object_id);
			
			$password = self::genRandomPassword();
			$first_name = $userInfo['first_name'];
			$last_name = $userInfo['last_name'];
			
			$object->setValue("login", $login);
			$object->setValue("password", md5($password));
			$object->setValue("e-mail", $mail);
			$object->setValue("fname", ($first_name));
			$object->setValue("lname", $last_name);
			
			if(!empty($mobile_phone)) $object->setValue("phone", $mobile_phone);
			
			$object->setValue("register_date", time());
			
			$object->setValue("activate_code", md5(uniqid(rand(), true)));
			
			$_SESSION['cms_login'] = $login;
			$_SESSION['cms_pass'] = md5($password);
			$_SESSION['user_id'] = $object_id;
			session_commit();

			$group_id = regedit::getInstance()->getVal("//modules/users/def_group");
			
			$data_module = cmsController::getInstance()->getModule('data');
			$data_module->saveEditedObject($object_id, true);
			
			$object->setValue("groups", Array($group_id));
			$object->setValue("is_activated", true);
			$object->commit();
			

			$this->redirect($from_page ? $from_page : ($this->pre_lang . '/users/auth/'));
			
		}
		
		private function genRandomPassword($len=6, $char_list='a-z,0-9') {
			$chars = array();
			// предустановленные наборы символов
			$chars['a-z'] = 'qwertyuiopasdfghjklzxcvbnm';
			$chars['A-Z'] = strtoupper($chars['a-z']);
			$chars['0-9'] = '0123456789';
			$chars['~'] = '~!@#$%^&*()_+=-:";\'/\\?><,.|{}[]';
			
			// набор символов для генерации
			$charset = '';
			// пароль
			$password = '';
			
			if (!empty($char_list)) {
				$char_types = explode(',', $char_list);
				
				foreach ($char_types as $type) {
					if (array_key_exists($type, $chars)) {
						$charset .= $chars[$type];
					} else {
						$charset .= $type;
					}
				}
			}
			
			for ($i=0; $i<$len; $i++) {
				$password .= $charset[ rand(0, strlen($charset)-1) ];
			}
			
			return $password;
		}
		
		
	}
?>