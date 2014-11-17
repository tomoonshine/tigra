<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="price.xsl" />
	<xsl:include href="compare.xsl" />
	<xsl:include href="basket.xsl" />
	<xsl:include href="cart.xsl" />
	<xsl:include href="orders-list.xsl" />
	<xsl:include href="purchase.xsl" />
	<xsl:include href="personal.xsl" />
	<xsl:include href="compare.xsl" />
	
	<xsl:template match="amount">
		<xsl:value-of select="concat(., ' &amount-prefix;')" />
	</xsl:template>

	<xsl:template match="steps">
		<table class="steps-of-payment">
			<tr>
				<td class="complete">
					<a href="{$lang-prefix}/emarket/cart">&basket;</a>
				</td>
				<xsl:apply-templates select="item" mode="steps-of-payment" />
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="steps[../../@method = 'cart']">
		<table class="steps-of-payment">
			<tr>
				<td class="active">
					<a href="{$lang-prefix}/emarket/cart">&basket;</a>
				</td>
				<xsl:apply-templates select="item" mode="steps-of-payment" />
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="steps[../@step = 'successful']">
		<table class="steps-of-payment">
			<tr>
				<td class="complete">&basket;</td>
				<xsl:apply-templates select="item" mode="steps-of-payment">
					<xsl:with-param name="is_result" select="true()" />
				</xsl:apply-templates>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="item[@status = 'complete']" mode="steps-of-payment">
		<xsl:param name="is_result" />
		<xsl:choose>
			<xsl:when test="$is_result">
				<td class="{@status}"><xsl:value-of select="@name" /></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="{@status}"><a href="{$lang-prefix}{@link}"><xsl:value-of select="@name" /></a></td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="item[@status = 'active']" mode="steps-of-payment">
		<td class="{@status}">
			<xsl:value-of select="@name" />
		</td>
	</xsl:template>
	
	<xsl:template match="item[@status = 'incomplete']" mode="steps-of-payment">
		<td class="{@status}">
			<xsl:value-of select="@name" />
		</td>
	</xsl:template>
	
	<xsl:template match="item[@status = 'incomplete' and position() = last()]" mode="steps-of-payment">
		<td class="{@status} result">
			<xsl:value-of select="@name" />
		</td>
	</xsl:template>
	
	<xsl:template match="item[@status = 'active' and position() = last()]" mode="steps-of-payment">
		<td class="{@status} result">
			<xsl:value-of select="@name" />
		</td>
	</xsl:template>
	
	<xsl:template match="udata[@method='customerDeliveryList']" />
	<xsl:template match="udata[@method='customerDeliveryList'][items/item]">
		<p class="lead">Адреса доставки</p>
		<ul class="delivery-list">
			<xsl:apply-templates select="items/item" mode="customerDeliveryList" />
		</ul>
	</xsl:template>
	
	<xsl:template match="items/item" mode="customerDeliveryList">
		<xsl:variable name="address_object" select="document(concat('uobject://', @id))//property" />
		<li>
			<a href="{$lang-prefix}/emarket/delAddress/{@id}" class="btn btn-turquoise btn-small">Удалить</a>
			<span><xsl:apply-templates select="$address_object" mode="delivery-address" /></span>
			<div class="clearfix"></div>
		</li>
	</xsl:template>
	

</xsl:stylesheet>