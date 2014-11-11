<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	<xsl:template match="/result[@method = 'search_do']" />
	<xsl:template match="/result[@method = 'search_do']" mode="main_template">
		<div class="container">
				<div class="row">
					<div class="span12">
						<xsl:apply-templates select="document('udata://search/search_do')" />
					</div>
				</div>
			</div>
	</xsl:template>
	
	<xsl:template match="/result[@method='search_doN']" />
	<xsl:template match="/result[@method='search_doN']" mode="main_template">
			<div class="container">
				<div class="row">
					<div class="span12">
						<xsl:apply-templates select="document('udata://search/search_doN')" />
					</div>
				</div>
			</div>
		</xsl:template>
	
	
	<xsl:template match="udata[@method = 'search_do' or @method = 'search_doN']">
		<h1>По вашему запросу ничего не найдено.</h1>
		<p>Попробуйте изменить запрос или воспользуйтесь меню каталога.</p>
		<p style="font-size:197px; text-align:center; color:#dddddd;"><i class="fa fa-search"></i></p>
	</xsl:template>
	
	<xsl:template match="udata[(@method = 'search_do' or @method = 'search_doN') and count(items/item)]">
		<h1>Результат поиска (<xsl:value-of select="total" />):</h1>
		<ul class="product-list isotope objects" id="catalog">
			<xsl:apply-templates select="items/item" mode="short-view">
				<xsl:with-param name="cart_items" select="$cart/udata/items" />
			</xsl:apply-templates>
			<div class="clear" />
		</ul>
		<xsl:apply-templates select="total" />
	</xsl:template>
	
</xsl:stylesheet>