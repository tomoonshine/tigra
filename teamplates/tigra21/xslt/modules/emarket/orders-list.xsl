<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/result[@method = 'ordersList']">
		<p class="lead">Заказы</p>
		<xsl:apply-templates select="document('udata://emarket/ordersList//desc/')" />
	</xsl:template>
	
	<xsl:template match="/result[@method = 'ordersListStatus']">
		<xsl:param name="block-title" select="'Заказы'"/>
		
		<p class="lead"><xsl:value-of select="$block-title"/></p>
		В данной категории нет заказов.
	</xsl:template>
	
	<xsl:template match="/result[@method = 'ordersListStatus' and udata/items/item]">
		<xsl:param name="block-title" select="'Заказы'"/>
		
		<p class="lead"><xsl:value-of select="$block-title"/></p>
		<xsl:apply-templates select="udata[@method = 'ordersList' or @method = 'ordersListStatus']" />
	</xsl:template>
	
	<xsl:template match="/result[@method = 'ordersListStatus' and udata/items/item and udata/status/item='ready']">
		<xsl:param name="block-title" select="'Заказы'"/>
		
		<div class="pull-right ordersTotalSum"><span class="label label-info">Сумма заказов:&#160;<xsl:value-of select="$currency-prefix" /><span><xsl:value-of select="document('udata://emarket/ordersTotalSum')/udata/price/total" mode="discounted-price" /></span>&#160;<xsl:value-of select="$currency-suffix" /></span> </div>
		
		<p class="lead"><xsl:value-of select="$block-title"/></p>
		<xsl:apply-templates select="udata[@method = 'ordersList' or @method = 'ordersListStatus']" />
	</xsl:template>
	
	
	<xsl:template match="udata[@method = 'ordersList' or @method = 'ordersListStatus']">                                           
		<xsl:apply-templates select="items/item" mode="order" />
		<!-- <div id="con_tab_orders">
			<xsl:if test="$method = 'personal'">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			
			<table class="blue">
				<thead>
					<tr>
						<th class="name">
							<xsl:text>&order-number;</xsl:text>
						</th>
						
						<th class="name">
							<xsl:text>&order-status;</xsl:text>
						</th>
						<th class="name">
							<xsl:text>&order-method;</xsl:text>
						</th>
						<th>
							<xsl:text>&order-sum;</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="items/item" mode="order" />
				</tbody>
			</table>
		</div> -->
	</xsl:template>
	
	<xsl:template match="item" mode="order">
		<xsl:apply-templates select="document(concat('udata://emarket/order/', @id))/udata" >
			<xsl:with-param name="status" select="//status" />
		</xsl:apply-templates>
		<!-- <tr>
			<td colspan="4" class="separate"></td>
		</tr> -->
	</xsl:template>

	<!-- <xsl:template match="item[position() = last()]" mode="order">
		<xsl:apply-templates select="document(concat('udata://emarket/order/', @id))/udata" />
	</xsl:template> -->


	<xsl:template match="udata[@module = 'emarket'][@method = 'order']">
		<xsl:variable name="item_info" select="document(concat('uobject://',@id))/udata"/>
		<table class="styled-table">
			<thead>
				<tr>
					<th class="col_product text-left">Заказ #<xsl:value-of select="number" /> от <xsl:apply-templates select="$item_info//property[@name='order_date']" />
						<span class="small">Статус:  <span  class="theme-color"><xsl:if test="status/@id = 18"><xsl:attribute name="class">text-warning</xsl:attribute></xsl:if><xsl:value-of select="status/@name" /></span></span>
						
					</th>
			   
					<th class="col_qty text-center">Кол-во</th>
					<th class="col_total text-right"><a href="{$lang-prefix}/emarket/repeatorder/{@id}" class="btn btn-small btn-turquoise">Повторить</a></th>
				</tr>
			</thead>
			<tbody>									
				<xsl:apply-templates select="items/item" />
			</tbody>
		</table>
		
		
		<!-- <tr>
			<td class="name">
				<strong>
					<xsl:text>&number; </xsl:text>
					<xsl:value-of select="number" />
				</strong>
				<div>
					<xsl:text>&date-from; </xsl:text>
					<xsl:apply-templates select="document(concat('uobject://', @id, '.order_date'))//property" />
				</div>
			</td>
			<td class="name">
				<xsl:value-of select="status/@name" />
				<div>
					<xsl:text>&date-from-1; </xsl:text>
					<xsl:apply-templates select="document(concat('uobject://', @id, '.status_change_date'))//property" />
				</div>
			</td>
			<td>
				<xsl:apply-templates select="document(concat('uobject://', @id, '.payment_id'))//item/@name" />
			</td>
			<td>
				<xsl:apply-templates select="summary/price" mode="discounted-price"/>
			</td>
		</tr>
		
		<xsl:apply-templates select="items/item" />
		<xsl:apply-templates select="summary/price/delivery" />
		<xsl:apply-templates select="summary/price/discount" /> -->
	</xsl:template>
	
	<xsl:template match="udata[@method = 'order']/items/item">
		<xsl:variable name="item_brand" select="document(concat('upage://',page/@id,'.brand'))//value/item/@name"/>
		
		<tr>
			<td class="col_product text-left">
				<a href="{$lang-prefix}{page/@link}"><xsl:value-of select="@name" /></a>
				<xsl:if test="$item_brand"><p class="small"><xsl:value-of select="$item_brand"/></p></xsl:if>

			</td>
			
			<td class="col_qty text-center">
				<xsl:value-of select="amount" />
			</td>

			<td class="col_total text-right">
				<span class="total-price"><xsl:apply-templates select="total-price" /><!-- 1600 руб --></span>
			</td>
		</tr>
		
		<!-- <tr>
			<td colspan="3" class="name">
				<a href="{$lang-prefix}{page/@link}">
					<xsl:value-of select="@name" />
				</a>
			</td>

			<td>
				<xsl:apply-templates select="price" mode="discounted-price"/>
				<xsl:text> x </xsl:text>
				<xsl:apply-templates select="amount" />
				<xsl:text> = </xsl:text>
				<xsl:apply-templates select="total-price" />
			</td>
		</tr> -->
	</xsl:template>

	<xsl:template match="delivery[.!='']">
		<tr>
			<td colspan="3" class="name">
				<strong>Доставка</strong>
			</td>
			<td>
				<xsl:value-of select="." />
					<xsl:text> </xsl:text>
				<xsl:value-of select="../@suffix" />
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="discount[.!='']">
		<tr>
			<td colspan="3" class="name">
				<strong>Скидка</strong>
			</td>
			<td>
				<xsl:value-of select="." />
					<xsl:text> </xsl:text>
				<xsl:value-of select="../@suffix" />
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>