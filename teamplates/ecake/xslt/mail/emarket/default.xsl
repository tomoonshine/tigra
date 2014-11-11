<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="utf-8" method="html" indent="yes" />

	<xsl:decimal-format name="price" decimal-separator="," grouping-separator="&#160;"/>

	<!-- шаблон для клиента -->
	<xsl:template match="status_notification">
		<xsl:variable name="order_info" select="document(concat('uobject://',order_id))/udata"/>
		<xsl:variable name="customer_id" select="$order_info//property[@name='customer_id']/value/item/@id"/>
		<xsl:variable name="customer_info" select="document(concat('uobject://',$customer_id))/udata"/>

		<p>Здравствуйте, <xsl:value-of select="concat($customer_info//property[@name='lname']/value,' ',$customer_info//property[@name='fname']/value,' ',$customer_info//property[@name='father_name']/value)" /></p>

		<xsl:call-template name="order_common_info">
			<xsl:with-param name="order_id" select="order_id"/>
			<xsl:with-param name="order_info" select="$order_info"/>
			<xsl:with-param name="customer_info" select="$customer_info"/>
		</xsl:call-template>
	</xsl:template>

	<!-- шаблон для клиента при использовании способа оплаты "оплата по квитанции"-->
	<xsl:template match="status_notification_receipt">
		<xsl:variable name="order_info" select="document(concat('uobject://',order_id))/udata"/>
		<xsl:variable name="customer_id" select="$order_info//property[@name='customer_id']/value/item/@id"/>
		<xsl:variable name="customer_info" select="document(concat('uobject://',$customer_id))/udata"/>

		<p>Здравствуйте, <xsl:value-of select="concat($customer_info//property[@name='lname']/value,' ',$customer_info//property[@name='fname']/value,' ',$customer_info//property[@name='father_name']/value)" /></p>

		<xsl:text>Квитанцию на оплату вы можете получить, перейдя по </xsl:text>
		<a href="http://{domain}/emarket/receipt/{order_id}/{receipt_signature}/">
			<xsl:text>этой ссылке</xsl:text>
		</a>.

		<xsl:call-template name="order_common_info">
			<xsl:with-param name="order_id" select="order_id"/>
			<xsl:with-param name="order_info" select="$order_info"/>
			<xsl:with-param name="customer_info" select="$customer_info"/>
		</xsl:call-template>
	</xsl:template>

	<!-- шаблон для администратора -->
	<xsl:template match="neworder_notification">
		<xsl:variable name="order_info" select="document(concat('uobject://',order_id))/udata"/>
		<xsl:variable name="customer_id" select="$order_info//property[@name='customer_id']/value/item/@id"/>
		<xsl:variable name="customer_info" select="document(concat('uobject://',$customer_id))/udata"/>
		<xsl:variable name="one_click_purchase" select="$order_info//property[@name='one_click_purchase']/value" />

		<xsl:if test="$one_click_purchase">
			<h2>Заказ в один клик</h2>
		</xsl:if>

		<p>
			Поступил новый заказ с сайта<xsl:text> (</xsl:text>
			<a href="http://{domain}/admin/emarket/order_edit/{order_id}/">
				<xsl:text>Просмотр</xsl:text>
			</a>
			<xsl:text>)</xsl:text>
		</p>

		<xsl:call-template name="order_common_info">
			<xsl:with-param name="order_id" select="order_id"/>
			<xsl:with-param name="order_info" select="$order_info"/>
			<xsl:with-param name="customer_info" select="$customer_info"/>
		</xsl:call-template>
	</xsl:template>

	<!-- общий шаблон центральной части письма -->
	<xsl:template name="order_common_info">
		<xsl:param name="receipt" select="0" />
		<xsl:param name="order_id" />
		<xsl:param name="order_info" />
		<xsl:param name="customer_info" />

		<xsl:variable name="basket_info" select="document(concat('udata://emarket/order/', $order_id))/udata"/> 
		<xsl:variable name="payment" select="$order_info//property[@name='payment_id']/value/item/@name" />
		<xsl:variable name="address"  select="document(concat('uobject://',$order_info//property[@name='delivery_address']/value/item[1]/@id))/udata/object" />
		<xsl:variable name="table_style"  select="'clear:both;color:#666666 !important;font-family:arial,helvetica,sans-serif;font-size:11px;'" />
		<xsl:variable name="table_th_style"  select="'border:1px solid #ccc;border-right:none;border-left:none;padding:5px 10px 5px 10px !important;color:#333333 !important;'" />

		<table style="border:0px; text-align:left;" border="0" cellpadding="0" cellspacing="0" >
			<tbody>
				<tr>
					<td><b>Заказ №</b></td>
					<td><xsl:value-of select="order_number" /></td>
				</tr>
				<tr>
					<td><b>Дата заказа:</b></td>
					<td><xsl:apply-templates select="$order_info//property[@name='order_date']" /></td>
				</tr>
				<tr>
					<td><b>Статус заказа</b></td>
					<td><xsl:value-of select="$order_info//property[@name='status_id']/value/item/@name" /></td>
				</tr>
				<tr>
					<td><b>ФИО:</b></td>
					<td><xsl:value-of select="concat($customer_info//property[@name='lname']/value,' ',$customer_info//property[@name='fname']/value,' ',$customer_info//property[@name='father_name']/value)" /></td>
				</tr>
				<tr>
					<td><b>E-mail:</b></td>
					<td><xsl:apply-templates select="$customer_info//property[@name='email']" /><xsl:apply-templates select="$customer_info//property[@name='e-mail']" /></td>
				</tr>
				<tr>
					<td><b>Телефон:</b></td>
					<td><xsl:apply-templates select="$customer_info//property[@name='phone']" /></td>
				</tr>
				<xsl:if test="$address//property/value">
					<tr>
						<td><b>Адрес:</b></td>
						<td><xsl:apply-templates select="$address//property" mode="adress_property"/></td>
					</tr>  
				</xsl:if>                   
				<tr>
					<td><b>Способ доставки:</b></td>
					<td><xsl:apply-templates select="$order_info//property[@name='delivery_id']" /></td>
				</tr>
				<tr>
					<td><b>Способ оплаты:</b></td>
					<td><xsl:apply-templates select="$order_info//property[@name='payment_id']" /></td>
				</tr>
			</tbody>
		</table>
		<br /><br />
		<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0" style="{$table_style}">
			<tbody>
				<tr style="height: 20px;">
					<td style="{$table_th_style}" align="left"><xsl:text>&basket-item;</xsl:text></td>
					<td style="{$table_th_style}" align="right"><xsl:text>&price;</xsl:text></td>
					<td style="{$table_th_style}" align="right"><xsl:text>&amount;</xsl:text></td>
					<td style="{$table_th_style}" align="right"><xsl:text>&sum;</xsl:text></td>
				</tr>
				<xsl:apply-templates select="$basket_info/items" mode="order_id"/>
			</tbody>
		</table>
		<xsl:apply-templates select="$basket_info/summary" mode="summary" />
	</xsl:template>

	<!-- наименование в заказе -->
	<xsl:template match="udata//items/item" mode="order_id">
		<xsl:variable name="item_info" select="document(concat('upage://',page/@id,'.artikul'))//property"/>
		<xsl:variable name="item_td_style"  select="'padding:10px;'" />

		<tr>
			<td style="{$item_td_style}" align="left">
				<xsl:value-of select="@name" />
				<xsl:if test="$item_info/value"><div><xsl:value-of select="$item_info/title"/>:&#160;<xsl:value-of select="$item_info/value"/></div></xsl:if>
			</td>
			<td style="{$item_td_style}" align="right">
				<xsl:apply-templates select="price/actual" mode="price" />
			</td>
			<td style="{$item_td_style}" align="right">
				<xsl:apply-templates select="amount" />
			</td>
			<td style="{$item_td_style}" align="right">
				<xsl:apply-templates select="total-price" />
			</td>
		</tr>
	</xsl:template>
	
	<!-- итоговые числа -->
	<xsl:template match="summary" mode="summary">
		<xsl:variable name="summary_general_table_style" select="'border-top:1px solid #ccc;clear:both;color:#666666 !important;font-family:arial,helvetica,sans-serif;font-size:11px;width:100%'"/>
		<xsl:variable name="summary_values_table_style" select="'color:#666666 !important;font-family:arial,helvetica,sans-serif;font-size:11px;margin-top:20px;clear:both;width:100%;'"/>
		<xsl:variable name="summary_values_td_title_style" select="'width:390px;text-align:right;padding:0 10px 0 0;'"/>
		<xsl:variable name="summary_values_td_value_style" select="'width:90px;text-align:right;padding:0 5px 0 0;'"/>
		<xsl:variable name="summary_values_td_value_span_style" select="'color:#333333 !important;font-weight:bold;'"/>
		
		<table align="left" border="0" cellpadding="0" cellspacing="0" style="{$summary_general_table_style}">
			<tr>
				<td>
					<table border="0" cellpadding="0" cellspacing="0" style="{$summary_values_table_style}" align="right">
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Итого:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:choose>
									<xsl:when test="price/original">
										<xsl:apply-templates select="price/original" mode="price" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="price/actual" mode="price" />
									</xsl:otherwise>
								</xsl:choose> 
								
							</td>
						</tr>
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Скидка:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:choose>
									<xsl:when test="price/discount!=''">
										<xsl:apply-templates select="price/discount" mode="price" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="price/@prefix" mode="price" />
										0
										<xsl:apply-templates select="price/@suffix" mode="price" />
									</xsl:otherwise>
								</xsl:choose>										
							</td>
						</tr>
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Доставка:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:choose>
									<xsl:when test="price/delivery!=''">
										<xsl:apply-templates select="price/delivery" mode="price" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="price/@prefix" mode="price" />
										0
										<xsl:apply-templates select="price/@suffix" mode="price" />
									</xsl:otherwise>
								</xsl:choose>	
								
							</td>
						</tr>
						<xsl:if test="price/bonus!=''">
							<tr>
								<td style="{$summary_values_td_title_style}">
									<span style="{$summary_values_td_value_span_style}"><xsl:text>Оплачено бонусами:</xsl:text></span>
								</td>
								<td style="{$summary_values_td_value_style}">
									<xsl:apply-templates select="price/bonus" mode="price" />
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Итого к оплате:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:apply-templates select="price/actual" mode="price" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!-- шаблоны для полей разных типов -->
	<xsl:template match="property">
		<xsl:value-of select="value" />
	</xsl:template>

	<xsl:template match="property[@type = 'boolean'][value]">
		<xsl:text>&no;</xsl:text>
	</xsl:template>

	<xsl:template match="property[@type = 'boolean'][value = 1]|fields/field[@type = 'boolean']//value[.]">
		<xsl:text>&yes;</xsl:text>
	</xsl:template>

	<xsl:template match="property[@type = 'relation']">
		<xsl:apply-templates select="value/item" />
	</xsl:template>

	<xsl:template match="property[@type = 'symlink']">
		<xsl:apply-templates select="value/page" />
	</xsl:template>

	<xsl:template match="value/item">
		<xsl:value-of select="concat(@name, ', ')" />
	</xsl:template>

	<xsl:template match="value/item[position() = last()]">
		<xsl:value-of select="@name" />
	</xsl:template>

	<xsl:template match="value/page">
		<a href="{@link}">
			<xsl:value-of select="name" />
		</a>
	</xsl:template>

	<!-- шаблоны для вывода адреса -->
	<xsl:template match="property" mode="adress_property" />
	<xsl:template match="property[value]" mode="adress_property">
		<xsl:choose>
			<xsl:when test="@name='house'">д. </xsl:when>
			<xsl:when test="@name='flat'">кв. </xsl:when>
		</xsl:choose> 
		<xsl:value-of select="value" /><xsl:if test="not(position() = last())">,&#160;</xsl:if>
	</xsl:template>
	<xsl:template match="property[@type='relation' and value]" mode="adress_property" >
		<xsl:value-of select="value/item/@name" /><xsl:if test="not(position() = last())">,&#160;</xsl:if>
	</xsl:template>

	<!-- шаблоны для даты -->
	<xsl:template name="format-date">
		<xsl:param name="date" />
		<xsl:param name="pattern" select="'d.m.Y'" />
		<xsl:variable name="uri" select="concat('udata://system/convertDate/', $date, '/(', $pattern, ')')" />

		<xsl:value-of select="document($uri)/udata" />
	</xsl:template>

	<xsl:template match="property[@type = 'date']">
		<xsl:param name="pattern" select="'d.m.Y'" />
		<xsl:call-template name="format-date">
			<xsl:with-param name="date" select="value/@unix-timestamp" />
			<xsl:with-param name="pattern" select="$pattern" />
		</xsl:call-template>
		&#160;
		<xsl:call-template name="format-date">
			<xsl:with-param name="date" select="value/@unix-timestamp" />
			<xsl:with-param name="pattern" select="'G:i'" />
		</xsl:call-template>
	</xsl:template>

	<!-- шаблоны для поле типа цены -->
	<xsl:template match="total-price">
		<xsl:value-of select="concat(@prefix, ' ', format-number(actual, '#&#160;###,##','price'), ' ', @suffix)" />
	</xsl:template>    

	<xsl:template match="price">
		<xsl:value-of select="concat(@prefix, ' ', format-number(original, '#&#160;###,##','price'), ' ', @suffix)" />
	</xsl:template>

	<xsl:template match="price[not(original) or original = '']">
		<xsl:value-of select="concat(@prefix, ' ', format-number(actual, '#&#160;###,##','price'), ' ', @suffix)" />
	</xsl:template>
	
	<!-- спец шаблон для вывода цены -->
	<xsl:template match="actual|original|discount|delivery|bonus" mode="price">
		<xsl:apply-templates select="../../price/@prefix" mode="price" />
		<xsl:value-of select="format-number(., '#&#160;###,##','price')" />
		<xsl:apply-templates select="../../price/@suffix" mode="price" />
	</xsl:template>
		<xsl:template match="price/@prefix" mode="price">
			<xsl:value-of select="." /><xsl:text> </xsl:text>
		</xsl:template>
		<xsl:template match="price/@suffix" mode="price">
			<xsl:text> </xsl:text><xsl:value-of select="." />
		</xsl:template>

</xsl:stylesheet>