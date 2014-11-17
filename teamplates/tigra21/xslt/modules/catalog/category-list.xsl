<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<xsl:template match="udata[@method = 'getCategoryList']">
		<ul umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:button-position="top right">
			<xsl:apply-templates select="//item" />
		</ul>
	</xsl:template>

	<xsl:template match="udata[@method = 'getCategoryList']//item">
		<li umi:element-id="{@id}" umi:region="row">
			<a href="{@link}" umi:field-name="name" umi:delete="delete" umi:empty="&empty-section-name;">
				<xsl:value-of select="." />
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getCategoryList']" mode="view-block" />
	<xsl:template match="udata[@method = 'getCategoryList'][items/item]" mode="view-block">
		<ul class="product-list getCategoryList" umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:button-position="top right">
			<xsl:apply-templates select="//item" mode="view-block" />
		</ul>
	</xsl:template>

	<xsl:template match="udata[@method = 'getCategoryList']//item" mode="view-block">
		<xsl:variable name="photo">
			<xsl:choose>
				<xsl:when test=".//property[@name = 'photo']/value"><xsl:value-of select=".//property[@name = 'photo']/value" /></xsl:when>
				<xsl:otherwise>&empty-photo;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li umi:element-id="{@id}" umi:region="row" class="standard">
			<a href="{@link}" umi:field-name="name" umi:delete="delete" umi:empty="&empty-section-name;" class="title">
				<xsl:value-of select="text()" />
			</a>
			<a href="{@link}" class="wrapper-image">
				<xsl:call-template name="all-thumbnail-path">
					<xsl:with-param name="width" select="'270'"/>
					<xsl:with-param name="height" select="'340'"/>
					<xsl:with-param name="path" select="$photo" />
					<xsl:with-param name="full" select="'care'" />
					<xsl:with-param name="quality" select="'100'" />
				</xsl:call-template>
			</a>
			<xsl:apply-templates select="document(concat('udata://catalog/getCategoryList/void/', @id, '//1/'))" mode="sub-view-block" />
		</li>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getCategoryList']" mode="sub-view-block" />
	<xsl:template match="udata[@method = 'getCategoryList'][items/item]" mode="sub-view-block">
		<div class="title" umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:button-position="top right">
			<xsl:apply-templates select="//item[position() &lt;= 3]" mode="sub-view-block" />
			<xsl:if test="count(//item) &gt; 3"><a class="all-category" href="{document(concat('udata://content/getLink/', @category-id))/udata}">Посмотреть все</a></xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getCategoryList']//item" mode="sub-view-block">
		<a href="{@link}" umi:field-name="name" umi:delete="delete" umi:empty="&empty-section-name;">
			<xsl:value-of select="text()" />
		</a>
	</xsl:template>

</xsl:stylesheet>