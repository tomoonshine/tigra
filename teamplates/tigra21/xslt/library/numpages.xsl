<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="total" />
	<xsl:template match="total[. &gt; ../per_page]">
		<xsl:param name="method-numpages" />
		<xsl:param name="module-numpages" />
		<xsl:param name="per_page" select="../per_page" />
		<xsl:param name="page-id" selec="$document-page-id" />
		<xsl:param name="lang-prefix" selec="$lang-prefix" />
		
		<xsl:apply-templates select="document(concat('udata://system/numpages/', ., '/', $per_page))/udata">
			<xsl:with-param name="per_page" select="$per_page" />
			<xsl:with-param name="total" select="text()" />
			<xsl:with-param name="method-numpages" select="$method-numpages" />
			<xsl:with-param name="module-numpages" select="$module-numpages" />
			<xsl:with-param name="page-id" select="$page-id" />
			<xsl:with-param name="lang-prefix" select="$lang-prefix" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'numpages']" />
	<xsl:template match="udata[@method = 'numpages'][count(items)]">
		<xsl:param name="per_page" />
		<xsl:param name="total" />
		<xsl:param name="method-numpages" />
		<xsl:param name="module-numpages" />
		<xsl:param name="page-id" />
		<xsl:param name="lang-prefix" />
		<div class="numpages pagination text-center" data-per-page="{ceiling($total div $per_page)}" data-method="{$method-numpages}" data-module="{$module-numpages}" data-id="{$page-id}" data-lang-prefix="{$lang-prefix}">
			<ul class="pages">
				<xsl:apply-templates select="toprev_link" mode="usual_paging" />
				<xsl:apply-templates select="items/item" mode="usual_paging" />
				<xsl:apply-templates select="tonext_link" mode="usual_paging" />
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="numpages">
		<li>
			<a href="{@link}">
				<xsl:value-of select="." />
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="toprev_link">
		<a class="prev" href="{.}">
			<xsl:text>&previous-page;</xsl:text>
		</a>
	</xsl:template>
	
	<xsl:template match="tonext_link">
		<span>
			<xsl:text>|</xsl:text>
		</span>
		<a class="next" href="{.}">
			<xsl:text>&next-page;</xsl:text>
		</a>
	</xsl:template>

	<xsl:template match="item" mode="slider">
		<xsl:apply-templates select="preceding-sibling::item[1]" mode="slider_back" />
		<xsl:apply-templates select="following-sibling::item[1]" mode="slider_next" />
	</xsl:template>

	<xsl:template match="item" mode="slider_back">
		<a href="{@link}" title="&previous-page;" class="back" />
	</xsl:template>

	<xsl:template match="item" mode="slider_next">
		<a href="{@link}" title="&next-page;" class="next" />
	</xsl:template>
	
	<!-- обычная пагинация -->
	<xsl:template match="total" mode="usual_paging" />
	<xsl:template match="total[. &gt; ../per_page]" mode="usual_paging">
		<xsl:variable name="per_page" select="../per_page" />
		<xsl:apply-templates select="document(concat('udata://system/numpages/', ., '/', $per_page))/udata" mode="usual_paging">
			<xsl:with-param name="per_page" select="$per_page" />
			<xsl:with-param name="total" select="text()" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'numpages']" mode="usual_paging" />
	<xsl:template match="udata[@method = 'numpages'][count(items)]" mode="usual_paging">
		<xsl:param name="per_page" />
		<xsl:param name="total" />
		<div class="pagination">
			<ul>
				<xsl:apply-templates select="toprev_link" mode="usual_paging" />
				<xsl:apply-templates select="items/item" mode="usual_paging" />
				<xsl:apply-templates select="tonext_link" mode="usual_paging" />
			</ul>
		</div>
		
	</xsl:template>
	
	<xsl:template match="item" mode="usual_paging">
		<li><a href="{@link}"><xsl:value-of select="." /></a></li>
	</xsl:template>
	
	<xsl:template match="item[@is-active = '1']" mode="usual_paging">
		<li class="active"><a href="{@link}"><xsl:value-of select="." /></a></li>
	</xsl:template>
	
	<xsl:template match="toprev_link" mode="usual_paging">
		<li><a href="{.}"><xsl:text>&lt;</xsl:text></a></li>
	</xsl:template>
	
	<xsl:template match="tonext_link" mode="usual_paging">
		<li><a href="{.}"><xsl:text>&gt;</xsl:text></a></li>
	</xsl:template>

</xsl:stylesheet>