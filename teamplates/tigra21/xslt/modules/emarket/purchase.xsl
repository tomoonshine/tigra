<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="purchase/required.xsl" />
	<xsl:include href="purchase/delivery.xsl" />
	<xsl:include href="purchase/payment.xsl" />

	<xsl:template match="/result[@method = 'purchase']">
		<xsl:apply-templates select="document('udata://emarket/purchase')" />
	</xsl:template>
	
	<xsl:template match="purchasing">
		<h4>
			<xsl:text>Purchase is in progress: </xsl:text>
			<xsl:value-of select="concat(@stage, '::', @step, '()')" />
		</h4>
	</xsl:template>
	
	<xsl:template match="purchasing[@stage = 'result']">
		<p>
			<xsl:text>&emarket-order-failed;</xsl:text>
		</p>
	</xsl:template>
	
	<xsl:template match="purchasing[@stage = 'result' and @step = 'successful']">
		<xsl:variable name="order_info" select="document('udata://emarket/renderlastOrder/')/udata"/>
		<xsl:variable name="customer_info" select="document(concat('uobject://',$order_info//property[@name='customer_id']/value/item/@id))/udata"/>
		<xsl:variable name="bonus_info" select="$order_info/bonus"/>

		<div>
			<div class="span6">
			<h2>
				<xsl:value-of select="$order_info/object/@name" /> от	<xsl:value-of select="document(concat('udata://data/dateru/',$order_info//property[@name='order_date']/value/@unix-timestamp))/udata"/>
			</h2>
			<p style="margin-bottom: 35px;">
				Способ получения: <xsl:value-of select="$order_info//property[@name='delivery_id']/value/item/@name"/><br />
				<xsl:if test="$bonus_info//count_bonus_buying or $bonus_info//reserved_bonus">
					
					Бонус: 
					<xsl:if test="$bonus_info//reserved_bonus">
						потрачено <xsl:value-of select="concat(format-number($bonus_info//reserved_bonus, '### ###', 'price'),' ' ,$bonus_info/bonus/@suffix)"/>
					</xsl:if>
					<xsl:if test="$bonus_info//count_bonus_buying and $bonus_info//reserved_bonus">, </xsl:if>
					<xsl:if test="$bonus_info//count_bonus_buying">
						будет зачислено <xsl:value-of select="concat(format-number($bonus_info//count_bonus_buying, '### ###', 'price'),' ' ,$bonus_info/bonus/@suffix)"/>
					</xsl:if>
					<br />
				</xsl:if>
				Способ оплаты: <xsl:value-of select="$order_info//property[@name='payment_id']/value/item/@name"/><br />
				Сумма заказа: <xsl:apply-templates select="$order_info//property[@name='total_original_price']"/> руб. 
					
				<br />
				<xsl:if test="$order_info//property[@name='order_discount_id']/value/item">
					Скидка: <xsl:value-of select="format-number(($order_info//property[@name='total_original_price']/value - $order_info//property[@name='total_price']/value), '### ###', 'price')"/> руб.<br />
				</xsl:if>
				Итого: <xsl:apply-templates select="$order_info//property[@name='total_price']"/> руб. <br /><br />

				<xsl:if test="$customer_info//property[@name='e-mail']/value or $customer_info//property[@name='email']/value">Электронная почта: <xsl:value-of select="$customer_info//property[@name='e-mail']/value"/><xsl:value-of select="$customer_info//property[@name='email']/value"/><br /></xsl:if>
				<xsl:if test="$customer_info//property[@name='phone']/value">Телефон: <xsl:value-of select="$customer_info//property[@name='phone']/value"/><br /></xsl:if>
				
				
				
				<!-- Способ получения: <xsl:value-of select="$order_info//property[@name='delivery_id']/value/item/@name"/><br />
				Сумма заказа: <xsl:value-of select="$order_info//property[@name='total_price']/value"/> руб.<br />
				<xsl:if test="$order_info//property[@name='order_discount_id']/value/item">
					Скидка: <xsl:value-of select="($order_info//property[@name='total_original_price']/value - $order_info//property[@name='total_price']/value)"/> руб.<br />
				</xsl:if>
				<xsl:if test="$bonus_info//count_bonus_buying or $bonus_info//reserved_bonus">
					Бонус: 
					<xsl:if test="$bonus_info//reserved_bonus">
						потрачено <xsl:value-of select="$bonus_info//reserved_bonus"/>
					</xsl:if>
					<xsl:if test="$bonus_info//count_bonus_buying and $bonus_info//reserved_bonus">, </xsl:if>
					<xsl:if test="$bonus_info//count_bonus_buying">
						будет зачислено <xsl:value-of select="$bonus_info//count_bonus_buying"/>
					</xsl:if>
					<br />
				</xsl:if>
				Способ оплаты: <xsl:value-of select="$order_info//property[@name='payment_id']/value/item/@name"/><br /><br />

				<xsl:if test="$customer_info//property[@name='e-mail']/value or $customer_info//property[@name='email']/value">Электронная почта: <xsl:value-of select="$customer_info//property[@name='e-mail']/value"/><xsl:value-of select="$customer_info//property[@name='email']/value"/><br /></xsl:if>
				<xsl:if test="$customer_info//property[@name='phone']/value">Телефон: <xsl:value-of select="$customer_info//property[@name='phone']/value"/><br /></xsl:if> -->

			</p>
		</div>
		<div class="span6">
				
				<p><a href="/emarket/print_order/{$order_info/object/@id}" class="btn btn-small btn-primary" target="_blank">
				<i class="fa fa-print fa-lg"></i> Распечатать заказ</a></p>

				<p>&order-is-in-processing;</p>

			</div>
		</div>
	</xsl:template>
	
	<!-- шаблон для ошибок при выводе формы для печати -->
	<xsl:template match="result[@module = 'emarket' and @method = 'print_order']">
		<p style="margin-bottom: 35px;">
			 <xsl:value-of select=".//udata/error" disable-output-escaping="yes"/>
		</p>
		<div class="cart-buttons">
			<a href="{$lang-prefix}" class="toCatalog">&continue-shopping;</a>
		</div>
	</xsl:template>
</xsl:stylesheet>