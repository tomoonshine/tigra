<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template match="udata[@method = 'getRecentPages']" mode="right" />
	<xsl:template match="udata[@method = 'getRecentPages'][items]" mode="right">
		<div class="infoblock">
			<div class="title"><h2>&recent-pages-block;</h2></div>
			<div class="body">
				<div class="in">
					<strong>&recent-pages-text;: </strong>
					<ol class="recentPages">
						<xsl:apply-templates select="items/item" mode="recentPages" />
						<li class="last">
							<a class="button" href="{$lang-prefix}/content/getRecentPages">&recent-pages-all;</a>
						</li>
					</ol>
				</div>
			</div>
		</div>
	
	</xsl:template>

	<xsl:template match="item" mode="recentPages">
		<li>
			<a title="Удалить" class="first" href="/content/delRecentPage/{@id}">&#215;</a> 
			<a href="{@link}"><xsl:value-of select="@name" /></a>
		</li>
	</xsl:template>
	
	
	<xsl:template match="result[@module = 'content' and @method = 'getRecentPages']"  mode="main_template">
		<div class="container">
			<div class="row">
				<div class="span12">
					<h1><xsl:value-of select="@header" />:</h1>
					<xsl:apply-templates select="$getRecentPages" />
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getRecentPages']">
		<p>&recent-pages-empty;</p>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getRecentPages'][items]">
		<ul class="product-list isotope objects" id="catalog">
			<xsl:apply-templates select="items/item" mode="short-view">
				<xsl:with-param name="cart_items" select="$cart/udata/items" />
			</xsl:apply-templates>
			<div class="clear" />
		</ul>
	</xsl:template>

</xsl:stylesheet>