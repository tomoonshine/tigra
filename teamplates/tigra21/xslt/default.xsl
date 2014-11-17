<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink">

	<xsl:output encoding="utf-8" method="html" indent="yes"/>

	<xsl:variable name="errors"	select="document('udata://system/listErrorMessages')/udata"/>

	<xsl:variable name="lang-prefix" select="/result/@pre-lang" />
	<xsl:variable name="document-page-id" select="/result/@pageId" />
	<xsl:variable name="document-title" select="/result/@title" />
	<xsl:variable name="user-type" select="/result/user/@type" />
	<xsl:variable name="request-uri" select="/result/@request-uri" />
	<xsl:variable name="domain" select="/result/@domain" />
	<xsl:variable name="header" select="/result/@header" />
	<xsl:variable name="parents" select="/result/parents/page" />
	<xsl:variable name="parentID" select="/result/page/@parentId" />

	<xsl:variable name="user-id" select="/result/user/@id" />
	<xsl:variable name="user-info" select="document(concat('uobject://', $user-id))" />
	
	<xsl:variable name="module" select="/result/@module" />
	<xsl:variable name="method" select="/result/@method" />
	
	<xsl:variable name="view_catalog" select="document('udata://catalog/getViewCatalog/catalogView/')/udata" />
	<xsl:variable name="all_view" select="document('udata://catalog/getViewPagesCatalog/allView/')/udata" />
	
	<xsl:variable name="settings_site" select="document('udata://settings_site/getSettingsSite/')/udata/items/item" />
	<xsl:variable name="settings_catalog" select="document('udata://settings_site/getSettingsSiteCatalog/')/udata/items/item" />
	<xsl:variable name="settings_social" select="document('udata://settings_site/getSettingsSiteSocial/')/udata" />
	<xsl:variable name="settings_social_widget" select="$settings_social/widget" />
	<xsl:variable name="settings_contact" select="document('udata://settings_site/getSettingsSiteContact/')/udata/items/item" />
	<xsl:variable name="settings_cart" select="document('udata://settings_site/getCartSetting/')/udata/items/item" />
	
	<xsl:variable name="search-filter" select="document(concat('udata://catalog/search_new/', $document-page-id,'/100///'))/udata" />
	
	<xsl:variable name="is-two-columns" select="$module = 'emarket' and $method != 'compare' and $method != 'personal' and $method != 'ordersList'" />

	<xsl:param name="p">0</xsl:param>
	<xsl:param name="catalog" />
	<xsl:param name="search_string" />
	<xsl:param name="usel" />
	
	<!-- custom params -->
	<xsl:param name="template-resources" />
	<xsl:variable name="settings" select="document('upage://98')/udata"/>
	<xsl:variable name="electee_item" select="document('udata://users/electee_item_view/')/udata"/>
	<xsl:variable name="getRecentPages" select="document('udata://content/getRecentPages/')/udata"/>
	<xsl:variable name="cart" select="document('udata://emarket/cart')/udata"/>
	<xsl:variable name="currency-prefix" select="$cart/summary/price/@prefix" />
    <xsl:variable name="currency-suffix" select="$cart/summary/price/@suffix" />
    <xsl:decimal-format name="price" grouping-separator=" "/>
	<!-- /custom params -->

	<xsl:include href="layouts/default.xsl" />
	<xsl:include href="library/common.xsl" />
	<xsl:include href="modules/content/common.xsl" />
	<xsl:include href="modules/users/common.xsl" />
	<xsl:include href="modules/catalog/common.xsl" />
	<xsl:include href="modules/data/common.xsl" />
	<xsl:include href="modules/emarket/common.xsl" />
	<xsl:include href="modules/search/common.xsl" />
	<xsl:include href="modules/news/common.xsl" />
	<xsl:include href="modules/comments/common.xsl" />
	<xsl:include href="modules/webforms/common.xsl" />
	<xsl:include href="modules/dispatches/common.xsl" />
	<xsl:include href="modules/menu/common.xsl" />
	<xsl:include href="modules/core/common.xsl" />
	<xsl:include href="modules/maps/common.xsl" />
</xsl:stylesheet>