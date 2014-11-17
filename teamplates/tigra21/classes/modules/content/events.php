<?php

	new umiEventListener("systemCreateElement", "content", "additional_function_content");
	new umiEventListener("systemModifyElement", "content", "additional_function_content");
	new umiEventListener("systemDeleteElement", "content", "additional_function_content_rmdir");
	new umiEventListener("systemCreateElement", "content", "communicationProducts");
	new umiEventListener("systemModifyElement", "content", "communicationProducts");
	new umiEventListener("systemModifyElement", "content", "sendSubscribe");
	

?>