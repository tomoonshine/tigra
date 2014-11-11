<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:udt="http://umi-cms.ru/2007/UData/templates"
	xmlns:xlink="http://www.w3.org/TR/xlink"
	exclude-result-prefixes="xsl date udt xlink">
 
    <xsl:output encoding="utf-8" method="html" indent="yes" />
    <xsl:include href="../../modules/catalog/short-view.xsl" />
    <xsl:include href="../../modules/emarket/price.xsl" />
    <xsl:include href="../../library/thumbnails.xsl" />
    <xsl:include href="../../library/numpages.xsl" />
	<xsl:decimal-format name="price" grouping-separator=" "/>
	
	<xsl:param name="lang-prefix" />
 
    <xsl:template match="/">
		<xsl:apply-templates select="udata" mode="catalog-ajax" />
    </xsl:template>
    
    
    <xsl:template match="udata" mode="catalog-ajax" />
    <xsl:template match="udata[lines/item]" mode="catalog-ajax">
		<xsl:variable name="search-filter" select="document('udata://content/getRequestTransform/search-filter/')/udata" />
		<xsl:variable name="settings_catalog" select="document('udata://settings_site/getSettingsSiteCatalog/')/udata/items/item" />
		<ul id="catalog-ajax" test="{$search-filter}">
		   <xsl:apply-templates select="lines/item" mode="short-view">
				<xsl:with-param name="settings_catalog" select="$settings_catalog" />
				<xsl:with-param name="method" select="@method" />
				<xsl:with-param name="lang-prefix" select="$lang-prefix" />
				<xsl:with-param name="cart_items" select="document('udata://emarket/cart/')/udata/items" />
			</xsl:apply-templates>
		</ul>
		<xsl:if test="$search-filter = '1'">
			<div id="numpages">
				<xsl:apply-templates select="document(concat('udata://system/numpages/', total, '/', per_page))/udata">
					<xsl:with-param name="per_page" select="per_page" />
					<xsl:with-param name="total" select="total" />
					<xsl:with-param name="method-numpages" select="@method" />
					<xsl:with-param name="module-numpages" select="@module" />
					<xsl:with-param name="page-id" select="category_id" />
					<xsl:with-param name="lang-prefix" select="$lang-prefix" />
				</xsl:apply-templates>
			</div>
		</xsl:if>
    </xsl:template>
    
</xsl:stylesheet>