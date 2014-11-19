<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="authorization.xsl" />
	<xsl:include href="registration.xsl" />
	<xsl:include href="view-author.xsl" />
	<xsl:include href="forget.xsl" />
	<xsl:include href="restore.xsl" />
	
	<!-- шаблоны для продавцов -->
	<xsl:include href="seller_registration.xsl" />
	<xsl:include href="seller_settings.xsl" />
	
	
	<xsl:template match="result[@method='electee_item_view']" mode="main_template">
		<div class="container">
			<div class="row">
				<div class="span12">
					<h1>Мои закладки:</h1>
					<xsl:apply-templates select="document('udata://users/electee_item_view/')/udata"  mode="short-view-new-viewing" />
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method='electee_item_view']" mode="short-view-new-viewing" />
	<xsl:template match="udata[@method='electee_item_view'][not(lines/item)]" mode="short-view-new-viewing">
		<div>У вас пока нет закладок</div>
	</xsl:template>
	
	<xsl:template match="udata[@method='electee_item_view'][lines/item]" mode="short-view-new-viewing">
		<ul class="product-list isotope objects" id="catalog">
			<xsl:apply-templates select="lines/item" mode="short-view">
				<xsl:with-param name="cart_items" select="$cart/udata/items" />
			</xsl:apply-templates>
			<div class="clear" />
		</ul>
	</xsl:template>
	
</xsl:stylesheet>