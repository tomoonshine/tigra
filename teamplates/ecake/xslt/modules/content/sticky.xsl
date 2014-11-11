<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	
	<xsl:template match="udata" mode="small_getRecentPages">
		<a href="{$lang-prefix}/content/getRecentPages/" class="fa fa-eye">
			<span class="sticky-text">Просмотренное</span>
			<span class="small_amount">0</span>
		</a>
	</xsl:template>
	
	<xsl:template match="udata[items/item]" mode="small_getRecentPages">
		<a href="{$lang-prefix}/content/getRecentPages/" class="fa fa-eye">
			<span class="sticky-text">Просмотренное</span>
			<span class="small_amount"><xsl:value-of select="count(items/item)" /></span>
		</a>
	</xsl:template>
	
	<xsl:template name="sticky-block">
		<div class="sticky-block-wrapper">
			<div>
				<xsl:if test="$settings_cart[@name='viewCart']='bottom'"><xsl:attribute name="class">container</xsl:attribute></xsl:if>
				<xsl:if test="not($method = 'cart')">
					<!-- Sticky cart -->
					<div class="mini-cart sticky-cart row" id="sticky-cart">
						<div class="stickyBasket__slide pull-left">                                                
							<div class="stickyBasket__text basket_info_summary">
								<xsl:apply-templates select="$cart/summary" mode="basket" />
							</div>
							<xsl:apply-templates select="$cart/summary" mode="summary" />
						</div>
						<a href="{$lang-prefix}/emarket/cart/" title="Перейти в корзину &rarr;" class="sticky-cart-img pull-right">
							<span class="sticky-text">Корзина</span>
							<span  class="small_amount"><xsl:if test="$cart/summary[amount &gt; 0]"><xsl:attribute name="class">small_amount notEmpty</xsl:attribute></xsl:if><xsl:apply-templates select="$cart/summary" mode="small_basket"/></span>
						</a>
					</div>
				</xsl:if>
				<xsl:if test="$settings_catalog[@name='electee']">
					<div class="stickyElectee" id="sticky-electee" title="Перейти в избранное">
						<xsl:if test="$electee_item[lines/item]"><xsl:attribute name="class">stickyElectee notEmpty </xsl:attribute></xsl:if>
						<xsl:apply-templates select="$electee_item" mode="small_electee"/>
					</div>
				</xsl:if>
				<xsl:if test="$settings_catalog[@name='viewed']">
					<div class="stickyElectee stickyRecent" id="sticky-recent-pages" title="Перейти в просмотренные товары">
						<xsl:if test="$getRecentPages[items/item]"><xsl:attribute name="class">stickyElectee notEmpty stickyRecent</xsl:attribute></xsl:if>
						<xsl:apply-templates select="$getRecentPages" mode="small_getRecentPages"/>
					</div>
				</xsl:if>
				<xsl:call-template name="btn-up" />
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template match="udata" mode="small_electee">
		<a href="{$lang-prefix}/users/electee_item_view/" class="fa fa-star">
			<span class="sticky-text">Избранное</span>
			<span class="small_amount">0</span>
		</a>
	</xsl:template>
	
	<xsl:template match="udata[lines/item]" mode="small_electee">
		<a href="{$lang-prefix}/users/electee_item_view/" class="fa fa-star">
			<span class="sticky-text">Избранное</span>
			<span class="small_amount"><xsl:value-of select="count(lines/item)" /></span>
		</a>
	</xsl:template>


	<xsl:template name="btn-up">
		<a href="#" class="upbtn" id="upbtn">
			<i class="fa fa-chevron-up fh-2x"></i> 
			<span class="sticky-text">Вверх</span>
		</a>
	</xsl:template>


</xsl:stylesheet>