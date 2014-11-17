<?php
	new umiEventListener('order-status-changed', 'emarket', 'onOrderMake');
	new umiEventListener('systemModifyObject', 'emarket', 'onDelivered');
	new umiEventListener('order_refresh', 'emarket', 'refreshActualPriceDiscount');
 ?>