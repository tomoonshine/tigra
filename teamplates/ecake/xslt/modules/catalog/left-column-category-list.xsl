<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">
<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<xsl:template match="udata[@method = 'getCategoryList']" mode="left-column">
		<ul class="catalog_menu" umi:button-position="bottom left"
			umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable">
			<xsl:apply-templates select="//item" mode="left-column" />
		</ul>
	</xsl:template>


	<xsl:template match="udata[@method = 'getCategoryList']//item" mode="left-column">
		<li umi:element-id="{@id}" umi:region="row">
			<span>
				<a href="{@link}" umi:field-name="name" umi:delete="delete" umi:empty="&empty-section-name;">
					<xsl:value-of select="." />
				</a>
			</span>
			<xsl:apply-templates select="document(concat('udata://catalog/getCategoryList/void/', @id, '//1/'))" />
		</li>
	</xsl:template>
	
	
	<xsl:template match="udata[@method = 'getCategoryList']" mode="left-column-category">
		<xsl:variable name="sub_items" select="document(concat('udata://catalog/getCategoryList//', $document-page-id, '/1/1/'))/udata" />
		<div class="children hidden-phone">
			<div class="box border-top paddingb0">
				<div class="hgroup title toggle-menu">
				<xsl:if test="not($sub_items/items/item)"><xsl:attribute name="class">hgroup title toggle-menu main-up</xsl:attribute></xsl:if>
					<h3><div class="f_right catalog_open"><span class="all">весь каталог</span><span class="hide-all">свернуть</span>
					</div>Каталог</h3>
					<div class="clearfix"></div>
				</div>
				<div class="wrapper-category-list">
					<ul class="category-list secondary" umi:button-position="bottom left" umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable">
						<xsl:if test="not($sub_items/items/item)"><xsl:attribute name="style">display: none</xsl:attribute>
						<xsl:attribute name="class">category-list secondary hideBlock</xsl:attribute></xsl:if>
						
						<xsl:apply-templates select="items/item" mode="left-column-main" />
					</ul>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="udata[@method = 'getCategoryList']//item" mode="left-column-category">
		<li umi:element-id="{@id}" umi:region="row">
			<xsl:if test="@id=$parents/@id or @id=$document-page-id"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
			<a href="{@link}" umi:field-name="name" umi:delete="delete" umi:empty="&empty-section-name;" title="{text()}"  class="title">
				<xsl:if test="@id=$document-page-id"><xsl:attribute name="class">active_link</xsl:attribute></xsl:if>
				<xsl:value-of select="text()" />
			</a>
			
			<xsl:if test="@id=$parents/@id or @id=$document-page-id">
				<xsl:apply-templates select="document(concat('udata://catalog/getCategoryList//', @id, '/1000/1/'))" mode="left-column-category-submenu" />
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match="udata[@method = 'getCategoryList']" mode="left-column-category-submenu">
		<ul umi:button-position="bottom left" umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable">
			<xsl:apply-templates select="items/item" mode="left-column-category" />
		</ul>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getCategoryList']" mode="left-column-main">
		<div class="widget Categories is-default hidden-phone">
			<h3 class="widget-title widget-title ">Каталог</h3>
			<ul class="category-list secondary" umi:button-position="bottom left" umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable">
				<xsl:apply-templates select="items/item" mode="left-column-main" />
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getCategoryList']//item" mode="left-column-main">
		<xsl:variable name="sub-item" select="document(concat('udata://catalog/getCategoryList//', @id, '//1/'))/udata" />
		<li umi:element-id="{@id}" umi:region="row">
			<a href="{@link}" umi:field-name="name" umi:delete="delete" umi:empty="&empty-section-name;" title="{text()}"  class="title"><xsl:if test="@id=$document-page-id"><xsl:attribute name="class">active_link</xsl:attribute></xsl:if>
				
				<xsl:value-of select="text()" />
				<xsl:if test="$sub-item/items/item">
					<i class="fa fa-chevron-down">
						<xsl:if test="@id=$parents/@id or @id=$document-page-id"><xsl:attribute name="class">fa fa-chevron-down fa-chevron-up</xsl:attribute></xsl:if>
					</i>
				</xsl:if>
			</a>
			<xsl:apply-templates select="$sub-item" mode="left-column-main-submenu" />
		</li>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getCategoryList']" mode="left-column-main-submenu" />
	<xsl:template match="udata[@method = 'getCategoryList'][items/item]" mode="left-column-main-submenu">
		<ul class="sub-menu" umi:button-position="bottom left" umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable">
			<xsl:if test="@category-id=$parents/@id or @category-id=$document-page-id"><xsl:attribute name="style">display: block</xsl:attribute></xsl:if>
			<xsl:apply-templates select="items/item" mode="left-column-main" />
		</ul>
	</xsl:template>
	
	

</xsl:stylesheet>