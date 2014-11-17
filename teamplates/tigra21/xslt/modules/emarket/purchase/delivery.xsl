<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink">

	<!-- Выбор адреса доставки -->
	<xsl:template match="purchasing[@stage = 'delivery'][@step = 'address']">
		<xsl:apply-templates select="//steps" />
		<form id="delivery_address" method="post" action="{$lang-prefix}/emarket/purchase/delivery/address/do">
		<h4>
			<xsl:text>&choose-delivery-address;:</xsl:text>
		</h4>
			<xsl:apply-templates select="items" mode="delivery-address" />
			<div>
				<input type="submit" value="&continue;" class="button big" />
			</div>
		</form>
		<script>
			jQuery('#delivery_address').submit(function(){
				var input = jQuery('input:radio:checked', this);
				if (typeof input.val() == 'undefined' || input.val() == 'new') {
					if (typeof input.val() == 'undefined') {
						jQuery('input:radio[value=new]', this).attr('checked','checked');
					}
					return site.forms.data.check(this);
				}
			});
		</script>
	</xsl:template>
	
	<xsl:template match="items" mode="delivery-address">
		<input type="hidden" name="delivery-address" value="new" />
		<xsl:apply-templates select="//delivery/items" mode="delivery-self" />
		<xsl:apply-templates select="document(../@xlink:href)//field" mode="form" />
	</xsl:template>

	<xsl:template match="items[count(item) &gt; 0]" mode="delivery-address">
		<xsl:apply-templates select="item" mode="delivery-address" />
		<xsl:if test="count(//delivery/items) &gt; 0">
			<h4>
				<xsl:text>&choose-self-delivery;:</xsl:text>
			</h4>
			<xsl:apply-templates select="//delivery/items" mode="delivery-self" />
			<h4>
				<xsl:text>&or-new-delivery-address;:</xsl:text>
			</h4>
		</xsl:if>

		<div>
			<label>
				<input type="radio" name="delivery-address" value="new" />
				<xsl:text>&new-delivery-address;</xsl:text>
			</label>
		</div>

		<div id="new-address">
			<xsl:apply-templates select="document(../@xlink:href)//field" mode="form" />
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="delivery-address">
		<xsl:variable name="address_object" select="document(concat('uobject://', @id))//property" />
		<div class="clearfix">
		<label class="f_left">
			<input type="radio" name="delivery-address" value="{@id}" class="not-save">
				<xsl:attribute name="data-city">[<xsl:apply-templates select="$address_object[@name='city']/value/item" mode="get-data-value" />]</xsl:attribute>
			</input>
			<xsl:apply-templates select="$address_object" mode="delivery-address" /></label><a href="{$lang-prefix}/emarket/delAddress/{@id}" class="fa fa-times" title="удалить адрес"></a>
		</div>
	</xsl:template>	

	<xsl:template match="item[@id='self']" mode="delivery-address">
		<div class="form_element">
			<label>
				<input type="radio" name="delivery-address" value="{@id}" />
				<xsl:text></xsl:text>
			</label>
		</div>
	</xsl:template>

	<xsl:template match="property" mode="delivery-address">
		<xsl:value-of select="value" />
		<xsl:text>, </xsl:text>
	</xsl:template>
	
	<xsl:template match="property[@type = 'relation']" mode="delivery-address">
		<xsl:value-of select="value/item/@name" />
		<xsl:text>, </xsl:text>
	</xsl:template>
	
	<xsl:template match="property[position() = last()]" mode="delivery-address">
		<xsl:value-of select="value" />
	</xsl:template>
	
	
	<xsl:template match="items" mode="delivery-address_new">
		<xsl:variable name="form-field" select="document(concat('udata://data/getCreateForm/', ../@type_id))//field" />
		<div class="box-header">
			<hr />
			<h3>2. Выберите способ доставки</h3>
		</div>
		<input type="radio" name="delivery-address" value="new" checked="checked" class="nor-styler not-view" />
		<div class="control-group row-fluid box-content">
			<xsl:apply-templates select="$form-field[@name='city']" mode="form-address-city" />
		</div>
		<div id="delivery-choose">
		    <div class="custom-wrap">
    			<xsl:apply-templates select="//delivery/items" mode="delivery-self" />
    			<xsl:apply-templates select="../../delivery_choose" mode="delivery-choose_new" />
		    </div>
		</div>
		<div class="row-fluid order-comments">
			<label>
				<div class="title-wrap"><span class="title">Добавить комментарий к заказу</span></div>
				<div class="order-comments-textarea">
					<textarea name="order_comments" class="span8"></textarea>
				</div>
			</label>
		</div>
		<div class="other-field-address">
			<div class="control-group">
				<xsl:apply-templates select="$form-field[@name='index']" mode="form-address-span2" />
				<xsl:apply-templates select="$form-field[@name='street']" mode="form-address-span5" />
				<xsl:apply-templates select="$form-field[@name='house']" mode="form-address-span1" />
				<xsl:apply-templates select="$form-field[@name='flat']" mode="form-address-span2" />
				<div class="clearfix"></div>
			</div>
			<div class="control-group">
				<xsl:apply-templates select="$form-field[@name='order_comments']" mode="form-address-comments" />
				<div class="clearfix"></div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="items[count(item) &gt; 0]" mode="delivery-address_new">
		<xsl:variable name="form-field" select="document(../@xlink:href)//field" />
		
		<div class="box-header">
			<hr />
			<h3>2. Выберите способ доставки</h3>
		</div>
		
		<div class="control-group row-fluid box-content">
			<xsl:apply-templates select="$form-field[@name='city']" mode="form-address-city" />
		</div>
	
		<div id="delivery-choose">
		    <div class="custom-wrap">
			     <xsl:apply-templates select="../../delivery_choose" mode="delivery-choose_new" />
		    </div>
		</div>
		<div id="new-address" class="margint20">
		    <div id="address-choose">
                <div class="custom-wrap"> 
        			<div class="control-group row-fluid marginb20">
        				<div class="control-group row-fluid">
        					<div class="span5">Выбрать ранее введённый адрес</div>
        					 <div class="span7">
        						<xsl:apply-templates select="item" mode="delivery-address" />
        					 </div>
        				</div>
        				<div class="control-group row-fluid">
        					<div class="span5">Новый адрес</div>
        					 <div class="span7">
        						<input type="radio" name="delivery-address" class="not-save" value="new" />
        					 </div>
        				</div>
        			</div>
				</div>
			</div>
		</div>
		<div class="row-fluid order-comments">
			<label>
				<div class="title-wrap"><span class="title">Добавить комментарий к заказу</span></div>
				<div class="order-comments-textarea">
					<textarea name="order_comments" class="span8"></textarea>
				</div>
			</label>
		</div>
		<div class="other-field-address">
			<div class="control-group">
				<xsl:apply-templates select="$form-field[@name='index']" mode="form-address-span2" />
				<xsl:apply-templates select="$form-field[@name='street']" mode="form-address-span5" />
				<xsl:apply-templates select="$form-field[@name='house']" mode="form-address-span1" />
				<xsl:apply-templates select="$form-field[@name='flat']" mode="form-address-span2" />
				<div class="clearfix"></div>
			</div>
			<div class="control-group">
				<xsl:apply-templates select="$form-field[@name='order_comments']" mode="form-address-comments" />
				<div class="clearfix"></div>
			</div>
		</div>
	</xsl:template>


	<!-- Выбор способа доставки -->
	<xsl:template match="purchasing[@stage = 'delivery'][@step = 'choose']">
		<xsl:apply-templates select="//steps" />
		<form method="post" action="{$lang-prefix}/emarket/purchase/delivery/choose/do">
			<h4>
				<xsl:text>&delivery-agent;:</xsl:text>
			</h4>
			<xsl:apply-templates select="items" mode="delivery-choose" />
			<div>
				<input type="submit" value="&continue;" class="button big" />
			</div>
		</form>
	</xsl:template>
	
	<xsl:template match="item" mode="delivery-choose"> 
		<xsl:variable name="delivery-price" select="@price"/>

		<div>
			<label>
				<input type="radio" name="delivery-id" value="{@id}">
					<xsl:apply-templates select="." mode="delivery-choose-first" />
				</input>
				<xsl:value-of select="@name" />
				
				<xsl:call-template  name="delivery-price" >
					<xsl:with-param name="price" select="$delivery-price"/>
				</xsl:call-template >
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="delivery_choose" mode="delivery-choose_new">
		<!-- <hr/>
		<h3>Способ доставки</h3> -->
		<xsl:apply-templates select="items/item" mode="delivery-choose_new" />
	</xsl:template>
	
	<xsl:template match="item" mode="delivery-choose_new"> 
		<xsl:variable name="delivery-price" select="@price"/>
		<div class="control-group row-fluid control-group-{@id} delivery-choose">
			<div class="span5"><xsl:value-of select="@name" /></div>
			 <div class="span7">                                                    
				 <label>
					<input type="radio" class="not-save" name="delivery-id" value="{@id}" data-price="{@price}">
						<xsl:attribute name="data-city">[<xsl:apply-templates select="document(concat('uobject://', @id,'.list_of_cities'))//value/item" mode="get-data-value" />]</xsl:attribute>
						<xsl:attribute name="data-payment">[<xsl:apply-templates select="document(concat('uobject://', @id,'.method_of_payment'))//value/item" mode="get-data-value" />]</xsl:attribute>
						<xsl:attribute name="data-request-address"><xsl:apply-templates select="document(concat('uobject://', @id,'.request_address'))//value" mode="get-data-value" /></xsl:attribute>
					</input>
					<xsl:call-template  name="delivery-price" >
						<xsl:with-param name="price" select="$delivery-price"/>
					</xsl:call-template >
				 </label>
			 </div>                                    
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="delivery-self">
		<xsl:variable name="delivery-price" select="@price"/>
		<div class="control-group row-fluid control-group-{@id} delivery-choose">
			<div class="span5"><xsl:value-of select="@name" /></div>
			 <div class="span7">                                                    
				 <label>
					<input type="radio" class="not-save self-true" name="delivery-address" value="delivery_{@id}" data-price="{@price}">
						<xsl:attribute name="data-city">[<xsl:apply-templates select="document(concat('uobject://', @id,'.list_of_cities'))//value/item" mode="get-data-value" />]</xsl:attribute>
						<xsl:attribute name="data-payment">[<xsl:apply-templates select="document(concat('uobject://', @id,'.method_of_payment'))//value/item" mode="get-data-value" />]</xsl:attribute>
						<xsl:attribute name="data-request-address"><xsl:apply-templates select="document(concat('uobject://', @id,'.request_address'))//value" mode="get-data-value" /></xsl:attribute>
					</input>
					<xsl:call-template  name="delivery-price" >
						<xsl:with-param name="price" select="$delivery-price"/>
					</xsl:call-template >
				 </label>
			 </div>                                    
		</div>
	</xsl:template>

	<xsl:template match="item" mode="delivery-choose-first">
			<xsl:if test="@active = 'active'">
				<xsl:attribute name="checked" select="'checked'" />
			</xsl:if>
	</xsl:template>
	
	<xsl:template match="item[1]" mode="delivery-choose-first">
		<xsl:attribute name="checked" select="'checked'" />
	</xsl:template>

	<xsl:template name="delivery-price">
		<xsl:param name="price" select="0"/>
		<xsl:if test="$price &gt; 0">
			<xsl:variable name="formatted-price" select="document(concat('udata://emarket/applyPriceCurrency/', $price))/udata" />
			
			<xsl:text> + </xsl:text> 
			<xsl:choose>
				<xsl:when test="$formatted-price/price">
					<xsl:apply-templates select="$formatted-price" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$price" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="value" mode="get-data-value"> 
		<xsl:value-of select="." />
	</xsl:template>
	
	<xsl:template match="item" mode="get-data-value"> 
		<xsl:value-of select="@id" /><xsl:text>,</xsl:text>
	</xsl:template>
	
	<xsl:template match="item[position() = last()]" mode="get-data-value"> 
		<xsl:value-of select="@id" />
	</xsl:template>
	
</xsl:stylesheet>