<?php
	new umiEventListener('users_login_successfull', 'users', 'electee_item_setuser_login_do');
	new umiEventListener('users_registrate', 'users', 'electee_item_setuser_registrate');
	new umiEventListener('users_login_failed', 'users', 'testAJAX');
	new umiEventListener('users_login_successfull', 'users', 'testAJAX');
	new umiEventListener('users_settings_do', 'users', 'SettingsTestAJAX');
 ?>