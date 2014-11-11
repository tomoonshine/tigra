<?php
class emarket_custom extends def_module {

    public function fast_purchasing_xslt(){
	  $order = $this->getBasketOrder();
	  $orderId = $order->id;
	  $customer = selector::get('object')->id($order->customer_id);
	 
	  $result = array(
	  'attribute:id'	=> ($orderId),
	  'xlink:href'	=> ('uobject://' . $orderId));
	 
	  if(!permissionsCollection::getInstance()->isAuth()){
	    $result['customer']	= array('full:object' => $customer);
	  }
	  
	  $urlPrefix = cmsController::getInstance()->getUrlPrefix() ? (cmsController::getInstance()->getUrlPrefix() . '/') : '';
	 
	  $result['delivery']	= $this->customerDeliveryList('notemplate');
	  $result['delivery_choose']	= $this->renderDeliveryList($order, 'notemplate');
	  $result['payment']	= $this->renderPaymentsList_custom($order, 'notemplate');
	  $result['submit_url']	= $this->pre_lang .'/'. $urlPrefix . 'emarket/purchase/result/successful/';
	  return  $result;
	}
 
	public function renderPaymentsList_custom(order $order, $template) {
	  list($tpl_block, $tpl_item) = def_module::loadTemplates("./tpls/emarket/payment/{$template}.tpl", 'payment_block', 'payment_item');
	
	  $payementIds = payment::getList(); $items_arr = array();
	  $currentPaymentId = $order->getValue('payment_id');
	  foreach($payementIds as $paymentId) {
	    $payment = payment::get($paymentId);
	    if($payment->validate($order) == false) continue;
	    $paymentObject = $payment->getObject();
	    $paymentTypeId = $paymentObject->getValue('payment_type_id');
	    $paymentTypeName = umiObjectsCollection::getInstance()->getObject($paymentTypeId)->getValue('class_name');
	 
	    if( $paymentTypeName == 'social') continue;
	 
	    $item_arr = array(
	    'attribute:id'			=> $paymentObject->id,
	    'attribute:name'		=> $paymentObject->name,
	    'attribute:type-name'	=> $paymentTypeName,
	    'xlink:href'			=> $paymentObject->xlink
	    );
	 
	    if($paymentId == $currentPaymentId) {
			$item_arr['attribute:active'] = 'active';
	    }
	 
	    $items_arr[] = def_module::parseTemplate($tpl_item, $item_arr, false, $paymentObject->id);
	  }
	    return array('items' => array('nodes:item'	=> $items_arr));
	 
	}
	 
	 
	public function saveinfo(){
		
		$order = $this->getBasketOrder(false);
		//сохранение регистрационных данных
		$cmsController = cmsController::getInstance();
		$data = $cmsController->getModule('data');
		$customer_id = customer::get()->id;
		$fio_full_new = trim(getRequest("full_name"));
		$arr = explode(' ', $fio_full_new);
		$arr[1] = (isset($arr[1])) ? $arr[1] : $arr[0];
		$_REQUEST['data'][$customer_id]['lname'] = $arr[0];
		$_REQUEST['data'][$customer_id]['fname'] = $arr[1];
		$_REQUEST['data'][$customer_id]['father_name'] = $arr[2];
	 
	  $data->saveEditedObject($customer_id, false, true);
	  
	  //сохранение способа доставки
	  $deliveryId = getRequest('delivery-id');
	  if($deliveryId){
	    $delivery = delivery::get($deliveryId);
	    $deliveryPrice = (float) $delivery->getDeliveryPrice($order);
	    $order->setValue('delivery_id', $deliveryId);
	    $order->setValue('delivery_price', $deliveryPrice);
	  }
	  //сохранение адреса доставки
	  $addressId = getRequest('delivery-address');
	  if($addressId == 'new') {
	    $controller = cmsController::getInstance();
		$collection = umiObjectsCollection::getInstance();
		$types      = umiObjectTypesCollection::getInstance();
		$typeId     = $types->getBaseType("emarket", "delivery_address");
		$customer   = customer::get();
		$addressId  = $collection->addObject("Address for customer #".$customer->id, $typeId);
		$dataModule = $controller->getModule("data");
		if($dataModule) {
			$dataModule->saveEditedObjectWithIgnorePermissions($addressId, true, true);
		}
		if (!$customer->delivery_addresses) {
			$customer->delivery_addresses = array($addressId);
		} else {
			$customer->delivery_addresses = array_merge( $customer->delivery_addresses, array($addressId) );
		}
	  }
	  $order->delivery_address = $addressId;
	 
	  //сохранение способа оплаты и редирект на итоговую страницу, либо страницу подтверждения оплаты.
		$order->setValue('payment_id', getRequest('payment-id'));
		if($order_comments = getRequest('order_comments')){
			$order->setValue('order_comments', $order_comments);
		}
	  $order->refresh();
	 
	  $paymentId = getRequest('payment-id');
	  if(!$paymentId) {
	    $this->errorNewMessage(getLabel('error-emarket-choose-payment'));
	    $this->errorPanic();
	  }
	  $payment = payment::get($paymentId);
	 
	  if($payment instanceof payment) {
	    $paymentName = $payment->getCodeName();
	    $url = "{$this->pre_lang}/".cmsController::getInstance()->getUrlPrefix()."emarket/purchase/payment/{$paymentName}/";
	  } else {
	    $url = "{$this->pre_lang}/".cmsController::getInstance()->getUrlPrefix()."emarket/cart/";
	  }
	  $this->redirect($url);
	}
	
	public function setPromocode($promocode, $bonus, $deposite) {
		$order = $this->getBasketOrder();
		if($order->isEmpty() && $stage != 'result') {
		   throw new publicException('%error-market-empty-basket%');
		}
		
		$objColl = umiObjectsCollection::getInstance();
		$objectOrder = $objColl->getObject($order->id);
		if($objectOrder instanceof umiObject){
		
			if ($promocode) {$promocode = ($promocode) ? $promocode : getRequest('promocode');$order->promo_code = $promocode;}
			if ($bonus) $this->custom_setBonusDiscount($bonus);
			if ($deposite) {$field_name = "deposit"; $this->custom_setBonusDiscount($deposite, $field_name);}
			
			$order->refresh();
		}

		$this->redirect($this->pre_lang . '/'.cmsController::getInstance()->getUrlPrefix() . 'emarket/cart/');
	}
	
	public function setPromokodBonus() {
		$order = $this->getBasketOrder();
		if($order->isEmpty()) {
			throw new publicException('%error-market-empty-basket%');
		}
		$objColl = umiObjectsCollection::getInstance();
		$objectOrder = $objColl->getObject($order->id);
		$result = false;
		if($objectOrder instanceof umiObject){
			if(getRequest('promocode')){
				$promokod = getRequest('promocode');
				$order->promo_kod = $promokod;
				$order->commit();
				$result = $this->order($order->id);
			}
			if(getRequest('bonus') || getRequest('bonus')===0 || getRequest('bonus') === '0'){
				$bonus = getRequest("bonus");
				$bonus = $bonus > 0 ? $bonus : 0;
				$order->setBonusDiscount($bonus);
				$order->refresh();
				$result = $this->renderBonusSpec();
			}
		}
		//$order->commit();
		
		if((bool) getRequest('json') == true){
			echo json_encode($result);
			exit();
		} else $this->redirect($this->pre_lang . '/'.cmsController::getInstance()->getUrlPrefix() . 'emarket/cart/');
	}
	
	public function delAddress($id){
		$refererUrl = getServer('HTTP_REFERER');
		if (!$id || $id==NULL || empty($id)) return $this->redirect($this->pre_lang . $refererUrl);
		$customer = customer::get();
		if (!$customer) return $this->redirect($this->pre_lang . $refererUrl);
		
		$deliveryAddresses = $customer->getValue('delivery_addresses');
		foreach($deliveryAddresses as $key => $idDel) {
			if($id == $idDel) $keyRem = $key; 
		}
		unset($deliveryAddresses[$keyRem]);
		$customer->setValue('delivery_addresses', $deliveryAddresses);
		$customer->commit();
		return $this->redirect($this->pre_lang . $refererUrl);
    }
	
	//получаем информация о бонусах определенного заказа (только в том случае, если мы запрашиваем собственный заказ или если это текущий заказ)
	public function renderBonusSpec($order_id=NULL) {
		if(!$order_id) $order = $this->getBasketOrder();
		else{
			$customer_id = customer::get()->id;
			$objects = umiObjectsCollection::getInstance();
			$order = order::get($order_id);		
			
			if(!$order){
				throw new publicException('Заказ не найден.');
			} 
			if($order->customer_id != $customer_id){
				throw new publicException('Вы не являетесь автором заказа.');
			} 
		}
		$template = 'default';
		list($tpl_block) = def_module::loadTemplates("emarket/payment/" . $template, 'bonus_block');
		$customer = customer::get($order->getCustomerId());

		$count_bonus_buying = 0;
		if ($discount = bonusDiscount::search($order)) {
			$price = $order->getActualPrice();
			$count_bonus_buying = $price - $discount->recalcPrice($price);
		}	
		
			
		$block_arr = array(
		'bonus'	=> $this->formatCurrencyPrice(array(
		'reserved_bonus'		=> $order->getBonusDiscount(),
		//'count_bonus_buying'	=> $this->countBonusBuying($order->getItems()),// устаревший вариант расчета бонусов (см. ниже)
		'count_bonus_buying'	=> $count_bonus_buying,
		'available_bonus'		=> $customer->bonus,
		'spent_bonus'			=> $customer->spent_bonus,
		'reserved_deposit'		=> $order->deposit,
		'available_deposit'		=> $customer->deposit,
		'spent_deposit'			=> $customer->spent_deposit,
		'actual_total_price' 	=> $order->getActualPrice(),
		))
		);
		$block_arr['void:reserved_bonus'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $order->getBonusDiscount())));
		$block_arr['void:available_bonus'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $customer->bonus)));
		$block_arr['void:spent_bonus'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $customer->spent_bonus)));
		$block_arr['void:available_deposit'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $customer->deposit)));
		$block_arr['void:spent_deposit'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $customer->spent_deposit)));
		$block_arr['void:actual_total_price'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $order->getActualPrice())));
		

		return def_module::parseTemplate($tpl_block, $block_arr);
	}
	
	/* устаревшая функция работающая со значением босов записанных внутри товара, в поле bonus */
	/* protected function countBonusBuying($orderItems) {
		$orderItems = ($orderItems) ? $orderItems : $order->getItems();
		$bonusSum = 0;
		foreach($orderItems as $orderItem) {
			$element = $orderItem->getItemElement();
			if($element instanceof umiHierarchyElement) {
				$orderItemAmount = $orderItem->getAmount();
				$bonusItem = ($element->bonus)? $element->bonus : $this->getParentBonus($element->getParentId());
				$bonusItem = $bonusItem > 0 ? $bonusItem : 0;
				$bonusSum = $bonusSum + $bonusItem * $orderItemAmount;
			}
		}
		return $bonusSum;
	} */
		
	function getParentBonus($element_id){			
		if (!$element_id) return 0;
		$hierarchy = umiHierarchy::getInstance();
		$element = $hierarchy->getElement($element_id);
		
		$bonus = ($element->bonus)? $element->bonus : $this->getParentBonus($element->getParentId());
					
		return $bonus;
	}
	
	public function custom_getDefaultDomain($id, $qr_code_size, $user_text = NULL){
		$collection = domainsCollection::getInstance();
		$domain = $collection->getDefaultDomain();
		$host = $domain->getHost();
		return array('host' => $host);
    }
	
	/*
	*Отправка писем по id заказа
	*@order_id - id заказа
	*@return - просто строку 'kk' если отправка прошла успешна.
	*/
	public function mailTest($order_id){
		$changedProperty = 'status_id';
		$codeName = 'waiting';
		if(!$order_id) $order_id = getRequest('param0');
			//$order_tmp = $this->getBasketOrder();
			$order = order::get($order_id);
			
			//$this->sendCustomerNotificationCust($order, $changedProperty, $codeName);
			$this->sendManagerNotificationCust($order);
		return 'kk';
	}

	/*вывод тела письма при оформлении заказа*/
	public function sendManagerNotificationCust(order $order) {
			$regedit  = regedit::getInstance();
			$cmsController = cmsController::getInstance();
			$domains = domainsCollection::getInstance();
			$domainId = $cmsController->getCurrentDomain()->getId();
			$defaultDomainId = $domains->getDefaultDomain()->getId();

			if ($regedit->getVal("//modules/emarket/manager-email/{$domainId}")) {
				$emails	= $regedit->getVal("//modules/emarket/manager-email/{$domainId}");
				$fromMail = $regedit->getVal("//modules/emarket/from-email/{$domainId}");
				$fromName = $regedit->getVal("//modules/emarket/from-name/{$domainId}");

			} elseif ($regedit->getVal("//modules/emarket/manager-email/{$defaultDomainId}")) {
				$emails	= $regedit->getVal("//modules/emarket/manager-email/{$defaultDomainId}");
				$fromMail = $regedit->getVal("//modules/emarket/from-email/{$defaultDomainId}");
				$fromName = $regedit->getVal("//modules/emarket/from-name/{$defaultDomainId}");

			} else {
				$emails	  = $regedit->getVal('//modules/emarket/manager-email');
				$fromMail = $regedit->getVal("//modules/emarket/from-email");
				$fromName = $regedit->getVal("//modules/emarket/from-name");
			}

			$letter = new umiMail();

			$recpCount = 0;
			foreach (explode(',' , $emails) as $recipient) {
				$recipient = trim($recipient);
				if (strlen($recipient)) {
					$letter->addRecipient($recipient);
					$recpCount++;
				}
			}
			if(!$recpCount) return;

			list($template) = def_module::loadTemplatesForMail("emarket/mail/default", "neworder_notification");
			try {
				$payment = payment::get($order->payment_id);
				$paymentName 	= $payment->name;
				$paymentStatus  = order::getCodeByStatus($order->getPaymentStatus());
			} catch(coreException $e) {
				$paymentName 	= "";
				$paymentStatus 	= "";
			}
			$param = array();
			$param["order_id"]       = $order->id;
			$param["order_name"]     = $order->name;
			$param["order_number"]   = $order->number;
			$param["payment_type"]   = $paymentName;
			$param["payment_status"] = $paymentStatus;
			$param["price"]          = $order->getActualPrice();
			$param["domain"]         = cmsController::getInstance()->getCurrentDomain()->getCurrentHostName();
			$content = def_module::parseTemplateForMail($template, $param);
			$buffer = outputBuffer::current();
				$buffer->charset('utf-8');
				$buffer->contentType('text/html');
				$buffer->clear();
				$buffer->push($content);
				$buffer->end();
		}
		
	/*вывод тела письма при оформлении заказа*/
	public function sendCustomerNotificationCust(order $order, $changedStatus, $codeName) {
			$customer = umiObjectsCollection::getInstance()->getObject($order->getCustomerId());
			$email    = $customer->email ? $customer->email : $customer->getValue("e-mail");
			if($email) {
				$name  = $customer->lname . " " .$customer->fname . " " . $customer->father_name;
				$langs = cmsController::getInstance()->langs;
				$statusString = "";
				$subjectString = $langs['notification-status-subject'];
				$regedit = regedit::getInstance();
				switch($changedStatus) {
					case 'status_id' : {
						if ($regedit->getVal('//modules/emarket/no-order-status-notification')) return;
						if($codeName == 'waiting') {
							$paymentStatusCodeName = order::getCodeByStatus($order->getPaymentStatus());
							$pkey = 'notification-status-payment-' . $paymentStatusCodeName;
							$okey = 'notification-status-' . $codeName;
							$statusString = ($paymentStatusCodeName == 'initialized') ?
												 ( (isset($langs[$okey]) ? ($langs[$okey] . " " . $langs['notification-and']) : "") . (isset($langs[$pkey]) ? (" ".$langs[$pkey]) : "" ) ) :
											( (isset($langs[$pkey]) ? ($langs[$pkey] . " " . $langs['notification-and']) : "") . (isset($langs[$okey]) ? (" ".$langs[$okey]) : "" ) );
							$subjectString = $langs['notification-client-neworder-subject'];
						} else {
							$key = 'notification-status-' . $codeName;
							$statusString = isset($langs[$key]) ? $langs[$key] : "_";
						}
						break;
					}
					case 'payment_status_id': {
						if ($regedit->getVal('//modules/emarket/no-payment-status-notification')) return;
						$key = 'notification-status-payment-' . $codeName;
						$statusString = isset($langs[$key]) ? $langs[$key] : "_";
						break;
					}
					case 'delivery_status_id': {
						if ($regedit->getVal('//modules/emarket/no-delivery-status-notification')) return;
						$key = 'notification-status-delivery-' . $codeName;
						$statusString = isset($langs[$key]) ? $langs[$key] : "_";
						break;
					}
				}
				$collection = umiObjectsCollection::getInstance();
				$paymentObject = $collection->getObject($order->payment_id);
				if($paymentObject) {
					$paymentType   = $collection->getObject($paymentObject->payment_type_id);
					$paymentClassName = $paymentType->class_name;
				} else {
					$paymentClassName = null;
				}
				$templateName  = ($paymentClassName == "receipt") ? "status_notification_receipt" : "status_notification";
				list($template) = def_module::loadTemplatesForMail("emarket/mail/default", $templateName);
				$param = array();
				$param["order_id"]   = $order->id;
				$param["order_name"] = $order->name;
				$param["order_number"] = $order->number;
				$param["status"]     = $statusString;

				$domain = cmsController::getInstance()->getCurrentDomain();

				$currentHost = getServer('HTTP_HOST');
				$param["domain"] = $domain->getCurrentHostName();
 
				if($paymentClassName == "receipt") {
					$param["receipt_signature"] = sha1("{$customer->id}:{$customer->email}:{$order->order_date}");
				}
				$content = def_module::parseTemplateForMail($template, $param);

				$buffer = outputBuffer::current();
				$buffer->charset('utf-8');
				$buffer->contentType('text/html');
				$buffer->clear();
				$buffer->push($content);
				$buffer->end();
				
			}
		}
	
	public function custom_setBonusDiscount($bonus, $field_name){
		$bonus = $bonus > 0 ? $bonus : 0;
		$field_name = ($field_name) ? $field_name : 'bonus';
		$spent = 'spent_'.$field_name;
			
		$emarket = cmsController::getInstance()->getModule('emarket');
		$order = order::get($this->getBasketOrder(false)->id);
	
		$defaultCurrency = $emarket->getDefaultCurrency();
		$currency = $emarket->getCurrentCurrency();
		
		$bonus = $bonus * $currency->nominal * $currency->rate;
		$bonus = $bonus  / $defaultCurrency->rate / $defaultCurrency->nominal;
		$bonus = round($bonus, 2);
			
		$bonus = $bonus > $order->getActualPrice() ? $order->getActualPrice() : $bonus; 
		
		$customerId = customer::get()->id;
		$customer = umiObjectsCollection::getInstance()->getObject($customerId);
							
		if ($order->$field_name > 0) {
			$customer->$field_name = $customer->$field_name + $order->$field_name;
			$customer->$spent = $customer->$spent - $order->$field_name;
		}
		
		if ($customer->$field_name < $bonus) $bonus = $customer->$field_name; 
						
		$order->$field_name = $bonus;
		$customer->$field_name = $customer->$field_name - $bonus;
		$customer->$spent = $customer->$spent + $bonus;
		$customer->commit();
	}
	
	public function event_order_refresh(iUmiEventPoint $event){
		if($event->getMode() == "after") {
			$order = $event->getRef('order');
			$deposit = $order->deposit;
			$actualPrice = &$event->getRef('actualPrice');
			$actualPrice -= (float) $deposit;
		}
	}
	/**
	 * Вывести список покупок (содержимое корзины)
	 *
	 * @param string $template
	 *
	 * @return mixed
	 */
	public function cart_new($template = 'default') {
		$customer_id = (int) getCookie('customer-id');

		if (!permissionsCollection::getInstance()->isAuth() && !$customer_id){
			list($tpl_block_empty) = def_module::loadTemplates("emarket/".$template, 'order_block_empty');
			$result = array(
				'attribute:id' => 'dummy',
				'summary' => array('amount' => 0),
				'steps' => $this->getPurchaseSteps($template, null)
			);

			return def_module::parseTemplate($tpl_block_empty, $result);
		}

		$order = $this->getBasketOrder();
		if($order->name != 'dummy') {
			$order->refresh();
		}

		return $this->order_new($order->getId(), $template);
	}
	
	/**
	* Вывести информацию о заказе $orderId
	*
	* @param bool $orderId Номер заказа
	* @param string $template Шаблон(для tpl)
	*
	* @return mixed
	* @throws publicException если не указан номер заказа или заказ не существует
	* @throws publicException недостаточно прав
	*/
	public function order_new($orderId = false, $template = 'default') {
		if(!$template) $template = 'default';
		$permissions = permissionsCollection::getInstance();

		$orderId = (int) ($orderId ? $orderId : getRequest('param0'));
		if(!$orderId) {
			throw new publicException("You should specify order id");
		}

		$order = order::get($orderId);
		if($order instanceof order == false) {
			throw new publicException("Order #{$orderId} doesn't exists");
		}

		if(!$permissions->isSv() && ($order->getName() !== 'dummy') &&
		   (customer::get()->getId() != $order->customer_id) &&
		   !$permissions->isAllowedMethod($permissions->getUserId(), "emarket", "control")) {
			throw new publicException(getLabel('error-require-more-permissions'));
		}

		list($tpl_block, $tpl_block_empty) = def_module::loadTemplates("emarket/".$template,
			'order_block', 'order_block_empty');

		$discount = $order->getDiscount();

		$totalAmount = $order->getTotalAmount();
		$originalPrice = $order->getOriginalPrice();
		$actualPrice = $order->getActualPrice();
		$deliveryPrice = $order->getDeliveryPrice();
		$bonusDiscount = $order->getBonusDiscount();
		$depositDiscount = $order->deposit;

		if($originalPrice == $actualPrice) {
			$originalPrice = null;
		}

		$discountAmount = ($originalPrice) ? $originalPrice + $deliveryPrice - $actualPrice - $bonusDiscount - $depositDiscount : 0;

		$result = array(
			'attribute:id'	=> ($orderId),
			'xlink:href'	=> ('uobject://' . $orderId),
			'customer'		=> ($order->getName() == 'dummy') ? null : $this->renderOrderCustomer($order, $template),
			'subnodes:items'=> ($order->getName() == 'dummy') ? null : $this->renderOrderItems($order, $template),
			'delivery'		=> $this->renderOrderDelivery($order, $template),
			'summary'		=> array(
				'amount'		=> $totalAmount,
				'price'			=> $this->formatCurrencyPrice(array(
					'original'		=> $originalPrice,
					'delivery'		=> $deliveryPrice,
					'actual'		=> $actualPrice,
					'discount'		=> $discountAmount,
					'bonus'			=> $bonusDiscount,
					'deposit'		=> $depositDiscount
				))
			),
			'steps' => $this->getPurchaseSteps($template, null)
		);

		if ($order->number) {
			$result['number'] = $order->number;
			$result['status'] = selector::get('object')->id($order->status_id);
		}

		if(sizeof($result['subnodes:items']) == 0) {
			$tpl_block = $tpl_block_empty;
		}

		$result['void:total-price'] = $this->parsePriceTpl($template, $result['summary']['price']);
		$result['void:delivery-price'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $deliveryPrice)));
		$result['void:bonus'] = $this->parsePriceTpl($template, $this->formatCurrencyPrice(array('actual' => $bonusDiscount)));
		$result['void:total-amount'] = $totalAmount;

		$result['void:discount_id'] = false;
		if($discount instanceof discount) {
			$result['discount'] = array(
				'attribute:id'		=> $discount->id,
				'attribute:name'	=> $discount->getName(),
				'description'		=> $discount->getValue('description')
			);
			$result['void:discount_id'] = $discount->id;
		}
		return def_module::parseTemplate($tpl_block, $result, false, $order->id);
	}
	
	public function getResellerDiscount(){
		$permissions = permissionsCollection::getInstance();
		if(!$permissions->isAuth())	return array('resellerDiscount' => 0);
		
		// создаем скидку
		$discount_value = 10;// процент скидки, которую нужно перезаписать в скидку пользователя
		$user = customer::get();
		
		//$discountRule = discountRule::getList();
		$summ = $this->getPricesSum_custom();
		//print_r($this->getPricesSum_custom());
		//exit();
		
		if($user){
			$discount = null;
			// ищем скидку, точнее сначала правило
			$rules = new selector('objects');
			//$rules->types('hierarchy-type')->name('catalog', 'object');
			$rules->types('object-type')->name('emarket', 'discount_rule_type');
			//$rules->types('object-type')->id(43);
			// 23 - На пользователей - справочник "Типы правил для скидок"
			$rules->where('id')->equals(67);
			//$rules->where('users')->equals($user->id);
			//$rules->limit(0, 1);
			//exit($rules->query());
			
			
			
			$arr_rules = array();
			foreach($rules->result as $rule){
				//exit('sffg');
				$arr_rules[$rule->id] = $rule->name;
			}
			
			print_r($arr_rules);
			exit();
			
			if(count($arr_rules) > 0){
				// ищем скидку с найденным правилом
				$discounts = new selector('objects');
				$discounts->types('object-type')->name('emarket', 'discount');
				// 15 - На заказ - справочник "Тип скидки"
				$discounts->where('discount_type_id')->equals(15);
				$discounts->where('discount_rules_id')->equals($arr_rules);
				$discounts->limit(0, 1);
				$discount = $discounts->first;
				//var_dump($arr_rules);exit;
				if($discount){
					// работаем с модификатором скидки
					$discount_modificator_id = $discount->discount_modificator_id;
					$discount_modificator = umiObjectsCollection::getInstance()->getObject($discount_modificator_id);
					if($discount_modificator){
						$proc = (float) $discount_modificator->proc;
						if($discount_value != $proc){
							$discount_modificator->setValue('proc', $discount_value);
							$discount_modificator->commit();
						}                     
					}
					//var_dump($user->id, $discount_value, $discount->id);exit;
				}
			}
		}
	}
	
	protected function getPricesSum_custom() {
		$orders = $this->getCustomerOrders_custom();

		$price = 0;
		foreach($orders as $orderObject) {
			$order = order::get($orderObject->id);
			$price += $order->getActualPrice();
		}

		return $price;
	}

	protected function getCustomerOrders_custom() {

		static $customerOrders = null;
		if(!is_null($customerOrders)) {
			return $customerOrders;
		}
		$customer = customer::get();

		$cmsController = cmsController::getInstance();
		$domain = $cmsController->getCurrentDomain();
		$domainId = $domain->getId();

		$sel = new selector('objects');
		$sel->types('object-type')->name('emarket', 'order');
		$sel->where('customer_id')->equals($customer->id);
		$sel->where('domain_id')->equals($domainId);
		$sel->where('status_id')->equals(order::getStatusByCode('ready'));
		return $customerOrders = $sel->result;
	}
	
	
	/*функция для вывода заказов пользователя с возможностью указать статус через массив /emarket/ordersListStatus?status[]=canceled&status[]=rejected*/
	public function ordersListStatus($template = 'default', $sort = "asc",$status_arr=NULL) {
		list($tplBlock, $tplBlockEmpty, $tplItem) = def_module::loadTemplates(
			"emarket/" . $template,
			'orders_block',
			'orders_block_empty',
			'orders_item'
		);
		
		$domainId = cmsController::getInstance()->getCurrentDomain()->getId();

		$select = new selector('objects');
		$select->types('object-type')->name('emarket', 'order');
		$select->where('customer_id')->equals(customer::get()->getId());
		$select->where('name')->isNull(false);
		
		$status_val=array();
		if(!$status_arr) $status_arr = $_REQUEST['status'];
		if($status_arr && is_array($status_arr)){
			
			foreach($status_arr as $status){
				unset($statusId);
				$statusId = order::getStatusByCode($status);
				$status_val[]=$statusId;
				$status_name[]=$status;
			}
			if(sizeof($status_val) > 0) $select->where('status_id')->equals($status_val);
		}
		
		
		$select->where('domain_id')->equals($domainId);

		if(in_array($sort, array("desc"))) {
			call_user_func(array($select->order('id'), $sort));
		}

		if($select->length == 0) {
			$tplBlock = $tplBlockEmpty;
		}

		$itemsArray = array();
		foreach($select->result as $order) {
			$item = array(
				'attribute:id' => $order->id,
				'attribute:name' => $order->name,
				'attribute:type-id' => $order->typeId,
				'attribute:guid' => $order->GUID,
				'attribute:type-guid' => $order->typeGUID,
				'attribute:ownerId' => $order->ownerId,
				'xlink:href' => $order->xlink,
			);

			$itemsArray[] = def_module::parseTemplate($tplItem, $item, false, $order->id);
		}
		$result = array('subnodes:items' => $itemsArray,'status'=>$status_val);
		$result['status'] = array('nodes:item'=>$status_name);
		return def_module::parseTemplate($tplBlock, $result);
	}
	
	/*маркеры типа новинка, популярное и скидка*/
	public function markerType($elementId=NULL) {
		$hierarchy = umiHierarchy::getInstance();
		$element = $hierarchy->getElement($elementId);
		$block_arr=array();
		if($element instanceof umiHierarchyElement) {
			$line_arr=array();
			
			// akcii
			if($element->hit_product) $line_arr[]=array('attribute:name'=>'hit_product','attribute:value'=>'Хит');
			if($element->new_product) $line_arr[]=array('attribute:name'=>'new_product','attribute:value'=>'Новинка');
			if($element->sale_product) $line_arr[]=array('attribute:name'=>'sale_product','attribute:value'=>'Распродажа');
			// discount
			$discount = itemDiscount::search($element);
			if($discount instanceof discount){
				$modificator = $discount->getDiscountModificator();
				$proc = $modificator->proc;
				$line_arr[]=array('attribute:name'=>'discount','attribute:value'=>$proc.'%');
			}
			
			
			$block_arr=array('nodes:item'=>$line_arr);
		}

		return $block_arr;
	}
	
	/*вывод суммарной стоимости готовых заказов пользователя
	
	<udata module="emarket" method="ordersTotalSum">
	  <price name="Российский рубль" code="RUR" rate="1" nominal="1" suffix="руб">
		<total>1272</total>
	  </price>
	</udata>
	*/
	public function ordersTotalSum() {
		$customer = customer::get();

		$cmsController = cmsController::getInstance();
		$domain = $cmsController->getCurrentDomain();
		$domainId = $domain->getId();

		$sel = new selector('objects');
		$sel->types('object-type')->name('emarket', 'order');
		$sel->where('customer_id')->equals($customer->id);
		$sel->where('domain_id')->equals($domainId);
		$sel->where('status_id')->equals(order::getStatusByCode('ready'));
		$orders = $customerOrders = $sel->result;
			
		$price = 0;
		foreach($orders as $orderObject) {
			$order = order::get($orderObject->id);
			$price += $order->getActualPrice();
		}
		return array('price'=>$this->formatCurrencyPrice(array('total'=>$price)));
		//return $price;
	}
	
	/*повторно положить в корзину уже готовый заказ*/
	public function repeatorder(){
		$_REQUEST['no-redirect']=1;
		$this->basket('remove_all');
		$permissions = permissionsCollection::getInstance();
		$userId = $permissions->getUserId();
		$objects = umiObjectsCollection::getInstance();
		$order_id = (int) getRequest('param0');
		$order = $objects->getObject($order_id);


		if(!$order || $order->customer_id != $userId){
			$referer = getServer('HTTP_REFERER');
			$this->redirect($referer);
		} 

		$orderItems = $order->order_items;
		if(is_array($orderItems)) {
			foreach($orderItems as $orderItemId) {

				$orderItem = orderItem::get($orderItemId);
				if($orderItem) {
					$element = $orderItem->getItemElement();
					if($element){

						$element_id = $element->id;
						
						$_REQUEST['no-redirect'] = 1;
						$_REQUEST['amount'] = $orderItem->item_amount;
						$options_arr = array();
						foreach($orderItem->options as $item){
							$index = $item['varchar'];
							$options_arr[$index] = $item['rel'];
						}
						if(count($options_arr)) $_REQUEST['options'] = $options_arr;
						$this->basket('put', 'element', $element_id);
					}
				}
			}
		}
		return $this->redirect($this->pre_lang . 'emarket/cart/');
		//$referer = getServer('HTTP_REFERER');
		//$this->redirect($referer);
	}

	
	//sms event start. send sms for admin
	public function onOrderMake(iUmiEventPoint $event) {
		if($event->getMode() == "after" && $event->getParam("old-status-id") != $event->getParam("new-status-id")) {
			$regedit = regedit::getInstance();
			$notice_new_order = $telefon = $regedit->getVal("//modules/smsmanager/notice_new_order");
			
			$order = $event->getRef("order");
		 	$cmsController=cmsController::getInstance();              
	        $module_smsmanager = $cmsController->getModule("smsmanager");     
			$changedProperty="status_id";
			$statusId = $order->getValue($changedProperty);
			$codeName = order::getCodeByStatus($statusId);
			if($codeName == 'waiting') {
				$order_number = $order->getValue('number'); 
				/*$phone=NULL;
				$settings_page_id = 486; // id страницы настроек
				$settings_page = umiHierarchy::getInstance()->getElement($settings_page_id, true);
				if($settings_page instanceof umiHierarchyElement) {
					$phone=$settings_page->manager_phone;
				}*/
				if($notice_new_order) {
					$template = "Поступил новый заказ № $order_number";
					$params = null;      				
					$module_smsmanager->send($params,$order->getName(), true, NULL, NULL, $order->getId());
				}
				
				$customer_id=$order->customer_id;
				$customer =  umiObjectsCollection::getInstance()->getObject($customer_id);
					if(!$customer) return;
				$phone=$customer->getValue('phone');
					if(!$phone) $phone=$customer->getValue('telefon');
				$template="Ваш заказ успешно оформлен";
				$params=null;
				$id = $order->getId();
				$module_smsmanager->send($params,$order->getName(), false, $phone, false, $id, $statusId);
			}
		}
	}
	
	//send sms for user when order delivered		
	public function onDelivered(iUmiEventPoint $event) {						
		   $cmsController=cmsController::getInstance(); 
			$collection = domainsCollection::getInstance();
			$domain = $collection->getDefaultDomain();
			$host = $domain->getHost();
			
	       $module_smsmanager = $cmsController->getModule("smsmanager");                             
	       $object = $event->getRef("object");
		   
		   $typeId = umiObjectTypesCollection::getInstance()->getBaseType('emarket', 'order');              
           if($object->getTypeId() != $typeId) {
                return;              
           }  
		if($event->getMode() == "before") {
			$data = getRequest("data");				
			$id   = $object->getId();				
			$newOrderStatus    = getArrayKey($data[$id], 'status_id');				
			if($newOrderStatus != $object->getValue("status_id") ){
				$codeName = order::getCodeByStatus($newOrderStatus);					
				$order_number = $object->getValue('number');
				
				$customer_id=$object->getValue("customer_id");
				$customer =  umiObjectsCollection::getInstance()->getObject($customer_id);
				if(!$customer) return;
				$phone=$customer->getValue('phone');
				if(!$phone) $phone=$customer->getValue('telefon');
				$params=null;
				$module_smsmanager->send($params,$object->getName(), false, $phone, false, $id, $newOrderStatus);	
			}			
		} 		
	}
	
	public function oneClickPurchase($idItem, $json = true) {
		
		$referer = getServer('HTTP_REFERER');
		$customer_id = customer::get()->id;
		$objects = umiObjectsCollection::getInstance();
		$userObject = $objects->getObject($customer_id);
		$idItem = ($idItem) ? $idItem : 'all';
		$errors = false;
		
		$fio_full_new = trim(getRequest('fio_full'));
		$email_cus = trim(getRequest('email_cus'));
		$phone = trim(getRequest('phone'));
		
		/*if (!$email_cus) {
			if ($json) {
				echo json_encode(array("error"=>"E-mail обязательное поле"));
				exit();
			} else {
				$this->errorNewMessage(getLabel('E-mail обязательное поле'));
				$errors = true;
			}
		}*/
		
		$arr = explode(' ', $fio_full_new);
		$oUsersMdl = cmsController::getInstance()->getModule("users");
		$is_auth = $oUsersMdl->is_auth();
		if(!isset($arr[1]) && $is_auth) {$arr[1] = $arr[0]; $arr[0] = ""; }
		
		$arrVlaue = array("lname" => $arr[0], "fname" => $arr[1], "father_name" => $arr[2]);
		
		$validFullName = ($is_auth) ? $this->validFullName('users','user', $arrVlaue) : $this->validFullName('emarket', 'customer', $arrVlaue);
		
		if ($validFullName){
			$massageError = $validFullName['massage'];
			unset($validFullName['massage']);
			$massageError .= "обязательное поле";
			
			foreach($validFullName as $value){
				if($value) {
					if ($json) {
						echo json_encode(array("error"=> $massageError));
						exit();
					} else {
						$this->errorNewMessage(getLabel($massageError));
						$errors = true;
					}
				}
			}
		}
		
		if (!$phone) {
			if ($json) {
				echo json_encode(array("error"=>"Телефон обязательное поле"));
				exit();
			} else {
				$this->errorNewMessage(getLabel('Телефон обязательное поле'));
    			$errors = true;
			}
		}
			
		if ($errors) $this->errorPanic();
		 
		$userObject->setValue('lname', $arr[0]);
		$userObject->setValue('fname', $arr[1]);
		$userObject->setValue('father_name', $arr[2]);
		if ($email_cus) $userObject->setValue('email', $email_cus);
		$userObject->setValue('phone', $phone);
		$userObject->commit();
		
		if ($idItem != 'all') {
			/*
			foreach ($order->getItems() as $orderItem) {
				$order->removeItem($orderItem);
			}*/
			
			$_REQUEST['no-redirect'] = 1;
			$this->basket('remove_all');
			$_REQUEST['amount'] = getRequest('amount_window');
			$_REQUEST['options'] = getRequest('options');
			$this->basket('put', 'element', $idItem);
		}
		
		//$order = order::create();
		//$itemsCurrentBasket = false;
		
		$order = $this->getBasketOrder();
		$order->setValue('one_click_purchase', 1);
		$order->commit();
		$order->order();
		
		//$newBasket = $this->getBasketOrder();		
		/*if($itemsCurrentBasket){
			foreach($itemsCurrentBasket as $key => $orderItem){
				$_REQUEST['no-redirect'] = 1;
				$_REQUEST['amount'] = $orderItem->getAmount();
				$_REQUEST['options'] = $orderItem->getOptions();
				$this->basket('put', 'element', $orderItem->getItemElement()->id);
			}
		}*/
		
		//unset($itemsCurrentBasket);
		
		if ($idItem == 'all') return $this->redirect('/emarket/purchase/result/successful/');
		
		if ($json) {
			echo json_encode("Заказ успешно оформлен");
			exit();
		} else return $this->redirect($referer.'?okfastorder=1');
	}
	
	/*вывод информации о последнем заказе текущего пользователя*/
	public function renderlastOrder() {
		$customer_id = customer::get()->id;
		$cmsController = cmsController::getInstance();
		$domain = $cmsController->getCurrentDomain();
		$domainId = $domain->getId();
		
		$sel = new selector('objects');
		$sel->types('object-type')->name('emarket', 'order');
		$sel->where('customer_id')->equals($customer_id);
		$sel->where('name')->isNull(false);
		//$sel->where('domain_id')->equals($domainId);
		$sel->order('order_date')->desc();
		$sel->limit(0, 1);
		if(!$object = $sel->first){
			return '--'.$sel->length();
			throw new publicException('Заказ не найден');
		}
		$bonus = $this->renderBonusSpec($object->id);
		return array('full:object'=>$object,'bonus'=>$bonus);
	}
	
	/* печать заказа */
	public function print_order($order_id=NULL) {
		$customer_id = customer::get()->id;
		
		if(!$order_id) $order_id = getRequest('param0');
		if(!$order_id){
			$cmsController = cmsController::getInstance();
			$domain = $cmsController->getCurrentDomain();
			$domainId = $domain->getId();
			
			//поиск последнего заказа для текущего пользователя
			$sel = new selector('objects');
			$sel->types('object-type')->name('emarket', 'order');
			$sel->where('customer_id')->equals($customer_id);
			$sel->where('name')->isNull(false);
			$sel->where('domain_id')->equals($domainId);
			$sel->order('order_date')->desc();
			$sel->limit(0, 1);
			if(!$object = $sel->first){
				throw new publicException('Ошибка вывода заказ на печать. У вас нет заказов.');
			}
		}else{
			$objects = umiObjectsCollection::getInstance();
			$object = $objects->getObject($order_id);		
			
			if(!$object){
				throw new publicException('Ошибка вывода заказ на печать. Заказ не найден.');
			} 
			if($object->customer_id != $customer_id){
				throw new publicException('Ошибка вывода заказ на печать. Вы не являетесь автором заказа.');
			} 
		}

		if($object){
			$typeId = umiObjectTypesCollection::getInstance()->getBaseType('emarket', 'order');
			if($object->getTypeId() != $typeId) {
				throw new wrongElementTypeAdminException(getLabel("error-unexpected-element-type"));
			}
			$orderId = $object->getId();
			$uri = "uobject://{$orderId}/?transform=sys-tpls/emarket-order-printable.xsl";
			//$uri = "uobject://{$orderId}/";
			$result = file_get_contents($uri);
			
		}else{
			throw new publicException('Ошибка вывода заказ на печать. Заказ не найден.');
		}
		
		$buffer = outputBuffer::current();
		$buffer->charset('utf-8');
		$buffer->contentType('text/html');
		//$buffer->contentType('text/xml');
		$buffer->clear();
		$buffer->push($result);
		$buffer->end();
		return ;
	}
	
	public function validFullName($module = "users", $method = "user", $arr = array()){
		$objectTypes = umiObjectTypesCollection::getInstance();
		$fieldsCollection = umiFieldsCollection::getInstance();
		
		$objectTypeId = $objectTypes->getBaseType($module, $method);
		$objectType = $objectTypes->getType($objectTypeId);		
		
		$values['lname']   = $fieldsCollection->getField($objectType->getFieldId('lname'));
		$values['fname'] = $fieldsCollection->getField($objectType->getFieldId('fname'));
		$values['father_name']   = $fieldsCollection->getField($objectType->getFieldId('father_name'));
		
		$result = "";
		foreach($values as $key => $value){
			if($value->getIsRequired()) {
				$result['massage'] .= $value->getTitle() . " ";
				if(empty($arr[$key])) $result[$key] = true;
			}
		};
		
		return (!empty($result)) ? $result : false;
	}
	
	public function getPromocodeTest(){
		$sel = new selector('objects');
		$sel->types('object-type')->name('emarket', 'discount_rule_type');
		$sel->where('rule_codename')->equals('promocode');
		if(!$sel->first) return "";
		$objectsCollection = umiObjectsCollection::getInstance();
		
		$result = $sel->first;
		$rule_discount_types = $result->getValue('rule_discount_types');
		$resultId = $result->getId();
	
		foreach ($rule_discount_types as $id){
			$object = $objectsCollection->getObject($id);
			if(!$object instanceof umiObject) continue;
			
			foreach ($this->getAllDiscounts($object->getValue('codename')) as $discount){
				$discount_rules_id = $discount->getValue('discount_rules_id');
				foreach($discount_rules_id as $id){
					$object = $objectsCollection->getObject($id);
					if(!$object instanceof umiObject) continue;
					$rule_type_id = $object->getValue('rule_type_id');
					if($resultId ==$rule_type_id){return array('attribute:promocode' => true); };
				}
			}
		}
		return;
	}
	
	public function refreshActualPriceDiscount($e) {
	   if($e->getMode() == "after") {
			$order_tmp = $e->getRef('order');
			$order = order::get($order_tmp->id);
			$orderItems = $order->getItems();
			
			$discount = orderDiscount::search($order);
			if(!$discount) return;
			$actualPrice = &$e->getRef('actualPrice');
			$priceWithDisc = $actualPriceThis = 0;
			
			foreach($orderItems as $item) {
				$element = $item->getItemElement();
				if (itemDiscount::search($element)) {
					$priceWithDisc += $item->getTotalActualPrice();
					continue;
				}
				$actualPriceThis += $item->getTotalActualPrice();
			}

			$actualPrice = $discount->recalcPrice($actualPriceThis);
			$actualPrice += $priceWithDisc;
			$actualPrice += (float) $order->delivery_price;
			$actualPrice -= (float) $order->getBonusDiscount();
			return ;
		}
	}
};
?>