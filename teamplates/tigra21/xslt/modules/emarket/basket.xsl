<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

	<xsl:template match="udata[@module = 'emarket' and @method = 'cart']" mode="basket">
		<!-- Mini cart -->
		<div class="mini-cart" >
			<a href="{$lang-prefix}/emarket/cart" title="Перейти в корзину &rarr;">
				<span class="small_amount"><xsl:if test="summary[amount &gt; 0]"><xsl:attribute name="class">small_amount notEmpty</xsl:attribute></xsl:if><xsl:apply-templates select="summary" mode="small_basket"/></span>
			</a>									
		</div>
	</xsl:template>
	
	<xsl:template match="summary" mode="basket">
		Пока пусто
	</xsl:template>
	
	<xsl:template match="summary[amount &gt; 0]" mode="basket">
		<xsl:variable name="bought" select="amount" />
        <xsl:variable name="bought_last_char" select="number(substring($bought, string-length($bought)))" />
		
		<xsl:variable name="encode-str" select="php:function('urlencode', 'товар, товара, товаров')" />
		<strong class="stickyBasket__textAmount" data-amount="{amount}" ><xsl:value-of select="document(concat('udata://content/get_correct_str/', amount,'/', $encode-str,'/'))/udata" /></strong> на <xsl:apply-templates select="price/@prefix" /> <strong><xsl:apply-templates select="price/actual" /></strong> <xsl:apply-templates select="price/@suffix" />.
	</xsl:template>
	
	<xsl:template match="summary" mode="summary"><span class="only-price">Пока пусто</span><xsl:text> </xsl:text><a href="{$lang-prefix}/emarket/cart" class="btn btn-small" title="Перейти в корзину &rarr;">Оформить заказ</a></xsl:template>
	
	<xsl:template match="summary[amount &gt; 0]" mode="summary"><span class="only-price"><xsl:apply-templates select="price/@prefix" /> <xsl:choose>
							<xsl:when test="price/original">
								<xsl:apply-templates select="price/original" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="price/actual" />
							</xsl:otherwise>
						</xsl:choose>  <xsl:apply-templates select="price/@suffix" /></span><xsl:text> </xsl:text><a href="{$lang-prefix}/emarket/cart" class="btn btn-small btn-primary" title="Перейти в корзину &rarr;">Оформить заказ</a></xsl:template>
	
	<xsl:template match="summary" mode="small_basket">0</xsl:template>
	
	<xsl:template match="summary[amount &gt; 0]" mode="small_basket">
		<xsl:value-of select="amount" />
	</xsl:template>
	
	<xsl:template match="summary[amount &gt; 0]/price/@prefix">
		<xsl:value-of select="." />
		<xsl:text>&#160;</xsl:text>
	</xsl:template>
	
	<xsl:template match="summary[amount &gt; 0]/price/@suffix">
		<xsl:text>&#160;</xsl:text>
		<xsl:value-of select="." />
	</xsl:template>
	
	
</xsl:stylesheet>