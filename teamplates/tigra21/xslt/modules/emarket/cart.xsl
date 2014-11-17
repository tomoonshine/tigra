<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="getPromocodeTest" select="document('udata://emarket/getPromocodeTest/')/udata" />
	<!-- common for catalog  objects pages -->
	<xsl:template match="result[@module='emarket' and @method='cart']" mode="main_template">
		<xsl:apply-templates select="." />
	</xsl:template>
	
	<xsl:template match="result[@method = 'cart']">
		<!-- Cart container -->
		<section class="cart">
			<div class="container">
				<div class="row basket">
					<xsl:apply-templates select="document('udata://emarket/cart')/udata" />
				</div>
			</div>	
		</section>         
		<!-- End Cart container -->
	</xsl:template>

	<xsl:template match="udata[@method = 'cart']">
		<div class="span12">
			<!-- Cart -->
					<div class="content">
						<h1>Корзина</h1>
						<p>Ваша корзина пуста.</p>
						<p style="font-size:197px; text-align:center; color:#dddddd;"><i class="fa fa-shopping-cart"></i></p>
					</div>
		</div>
	</xsl:template>

	<xsl:template match="udata[@method = 'cart'][count(items/item) &gt; 0]">
		<script type="text/javascript" src="{$template-resources}js/jquery.fast.purchase.js"></script>
		<xsl:variable name="fast_purchasing_xslt" select="document('udata://emarket/fast_purchasing_xslt/')/udata" />
		<xsl:variable name="renderBonusSpec" select="document('udata://emarket/renderBonusSpec/')/udata" />
		
		<div class="span9">
			<div class="box">
				<form enctype="multipart/form-data" action="" method="post" >
					<script type="text/javascript" charset="utf-8">
					<![CDATA[
						window.paymentId = null;
					]]>
					</script>
					<div class="box-header">
						<h3>Ваша корзина</h3>
					</div>

					<div class="">
						<div class="cart-items">
							<table class="styled-table cart">
								<thead>
									<tr>
										<th class="col_product text-left">Товар</th>
										<th class="col_single text-right hidden-phone">Стоимость</th>
										<th class="col_qty text-center">Кол-во</th>
										<th class="col_total text-right">Сумма</th>
										<th class="col_remove text-right"></th>
									</tr>
								</thead>

								<tbody>									
									<xsl:apply-templates select="items/item" />
								</tbody>
							</table>
						</div>
					</div>

					<div class="box-footer">
						<div class="pull-left">
							<a href="/" class="txtdn">
								<i class="fa fa-chevron-left"></i> Назад
							</a>			
						</div>

					</div>
				</form>			
			</div>
			
			<div class="box">
				<xsl:apply-templates select="$errors" />
				<form enctype="multipart/form-data" action="{$lang-prefix}/emarket/saveinfo" method="post" id="cart_form">
					<xsl:if test="$user-type='guest'"><xsl:attribute name="class">notSubmit</xsl:attribute></xsl:if>
					<xsl:variable name="customer_id" select="$fast_purchasing_xslt/customer/object/@id" />
					<div class="box-header">
						<h3>1. Укажите контактную информацию</h3>
					</div>
					
					<div class="row-fluid box-content">
					    <div class="personal-info-register">
    						<div class="control-group">
    							 <label class="required">
    								<span class="span5">Электронная почта
    								</span>
    								<input type="text" name="data[{$customer_id}][email]" value="" class="span7 my_input email_valid" id="input_40"><xsl:if test="$user-info///property[@name='e-mail']/value and not($user-type='guest')"><xsl:attribute name="value"><xsl:value-of select="$user-info///property[@name='e-mail']/value" /></xsl:attribute><xsl:attribute name="class">span7 my_input email_valid auth_true</xsl:attribute></xsl:if><xsl:if test="not($customer_id)"><xsl:attribute name="name">data[<xsl:value-of select="$user-id" />][email]</xsl:attribute></xsl:if></input>
    							 </label>                                    
    						</div>
    						<div class="control-group">
    							 <label class="required">
    								<span class="span5">
    									Телефон
    								</span>
    								<input type="text" name="data[{$customer_id}][phone]" value="" class="span7 my_input phone-valid" id="input_268" ><xsl:if test="$user-info///property[@name='phone']/value and not($user-type='guest')"><xsl:attribute name="value"><xsl:value-of select="$user-info///property[@name='phone']/value" /></xsl:attribute></xsl:if><xsl:if test="not($customer_id)"><xsl:attribute name="name">data[<xsl:value-of select="$user-id" />][phone]</xsl:attribute></xsl:if></input>
    							 </label>                                    
    						</div>
    						<div class="control-group">
    							 <label class="required">
    								<span class="span5">Фамилия Имя Отчество 
    								</span>
    								<input type="text" name="full_name" value="" class="span7 my_input" id="input_full_name"><xsl:if test="$user-info//group[@name='short_info']/property[@name='fname']/value and not($user-type='guest')"><xsl:attribute name="value"><xsl:apply-templates select="$user-info//group[@name='short_info']/property" mode="full_name" /></xsl:attribute></xsl:if></input>
    							 </label>                                    
    						</div>
						</div>
						<div id="other_field" style="display: none">
							<xsl:if test="not($user-type='guest')"><xsl:attribute name="style" /></xsl:if>
							<xsl:apply-templates select="$fast_purchasing_xslt/delivery" mode="delivery-address_new" />
							<div id="payment-choose">
							    <div class="custom-wrap">
								    <xsl:apply-templates select="$fast_purchasing_xslt/payment" mode="payment_new" />
							    </div>
							</div>
						</div>
					</div>
					<div class="box-footer">
						<input type="submit" value="Оформить заказ" class="btn btn-primary pull-right" />
						<div class="text-center loading-order">
							<i class="fa fa-spinner fa-spin fa-2x"></i> Подождите, заказ оформляется...
						</div>
					</div>
				</form>
				<script type="text/javascript" charset="utf-8">
				<![CDATA[
					jQuery('#cart_form1').submit(function(){
						var _this = $(this);
						if (window.paymentId) {
							var checkPaymentReceipt = function(id) {
								if (jQuery(':radio:checked', _this).hasClass('receipt')) {
									var url = '/emarket/saveinfo/';
									var win = window.open("", "_blank", "width=710,height=620,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no");
									win.document.write("<html><head><" + "script" + ">location.href = '" + url + "?payment-id=" + _this.serialize() + "'</" + "script" + "></head><body></body></html>");
									win.focus();
									return false;
								}
							}
							return checkPaymentReceipt(window.paymentId);
						}
						else return true;
					});
				]]>
			</script>
			</div>                            
		</div>
		<div class="span3">
			<div class="fixed" id="summary_basket">
				<xsl:apply-templates select="summary" />

				<xsl:if test="not($user-type='guest') and $renderBonusSpec/bonus/available_bonus">
					<div class="coupon">
						<div class="box">
							<div class="hgroup title">
								<h5>У Вас бонусов:<strong>&#160;<xsl:value-of select="$currency-prefix" />
									<span class="available_bonus"><xsl:value-of select="$renderBonusSpec/bonus/available_bonus" /><xsl:if test="not($renderBonusSpec/bonus/available_bonus)">0</xsl:if></span>&#160;<xsl:value-of select="$currency-suffix" /></strong></h5>
							</div>
							<form enctype="multipart/form-data" action="{$lang-prefix}/emarket/setPromokodBonus" method="post">
								<div class="input-append">
									<input id="coupon_code" value="" type="text" name="bonus" placeholder="Оплата бонусами"  />
									<button type="submit" class="btn" value="Apply" name="set_coupon_code">
										<i class="fa fa-check"></i>
									</button>
								</div>
								<div class="btn_line">
									<i class="fa fa-spinner fa-spin"></i>
									<span class="text-spinner">Подождите...</span>
								</div>
							</form>			
						</div>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="udata[@method = 'cart']//item">
		<xsl:variable name="object" select="document(concat('upage://',page/@id))/udata"/>
		<xsl:variable name="artikul" select="$object//property[@name = 'artikul']/value"/>
		<tr class="cart_item_{@id}">
			<td class="col_product text-left">
				<div class="image visible-desktop">
					<a href="{$lang-prefix}{page/@link}">
						<xsl:apply-templates select="document(concat('udata://content/parseFileContent/', page/@id,'/tigra21_image_gallery'))/udata" mode="parseImageCatalog">
							<xsl:with-param name="width" select="'60'"/>
							<xsl:with-param name="height" select="'60'"/>
							<xsl:with-param name="settings_catalog" select="$settings_catalog"/>
						</xsl:apply-templates>
					</a>
				</div>
				<div class="h5">
					<a href="{$lang-prefix}{page/@link}"><xsl:value-of select="$object/page/name" /><xsl:if test="$artikul"> (<xsl:value-of select="$artikul" />)</xsl:if></a>
				</div>
				<xsl:apply-templates select="options" mode="optionCart" />
			</td>
			<td class="col_single text-right hidden-phone">
				<xsl:value-of select="$currency-prefix" /><xsl:if test="price/original"><div><strike><span class="single-price"><xsl:value-of select="format-number(price/original, '### ###', 'price')" /></span>&#160;<xsl:value-of select="$currency-suffix" /></strike></div></xsl:if><span class="single-price"><xsl:value-of select="format-number(price/actual, '### ###', 'price')" />
				</span>&#160;<xsl:value-of select="$currency-suffix" />
			</td>
			<td class="col_qty text-center">
			   <div class="goodsCount">
					<a href="#" id="amount_down_{@id}" class="down hidden-phone"><i class="fa fa-chevron-down"></i></a>
					<input type="text" id="amount_new_{@id}" name="amount" value="{amount}" class="amount" />
					<input type="hidden" id="amount_old_{@id}" value="{amount}" />
					<a href="#" id="amount_up_{@id}" class="up hidden-phone"><i class="fa fa-chevron-up"></i></a>
				</div>
			</td>
			<td class="col_total text-right">
				<xsl:value-of select="$currency-prefix" /><span class="total-price cart_item_price_{@id}"><xsl:value-of select="format-number(total-price/actual, '### ###', 'price')" /></span>&#160;<xsl:value-of select="$currency-suffix" />
			</td>
			<td class="col_remove text-center">
				<a href="{$lang-prefix}/emarket/basket/remove/item/{@id}" id="del_basket_{@id}" class="del">
					<i class="fa fa-trash-o fa-lg"></i>
				</a>
			</td>
		</tr>
	</xsl:template>
	

	<xsl:template match="udata[@method = 'cart']/summary">
	<xsl:variable name="renderBonusSpec" select="document('udata://emarket/renderBonusSpec/')/udata" />
		<!-- Cart details -->
		<div class="cart-details">
			<div class="box">
				<div class="hgroup title">
					<h3>Всего к оплате</h3>
				</div>

				<ul class="price-list">
					<li>Сумма заказа: <strong><xsl:value-of select="$currency-prefix" /><span class="cart_summary">
						<xsl:choose>
							<xsl:when test="price/original">
								<xsl:apply-templates select="price/original" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="price/actual" />
							</xsl:otherwise>
						</xsl:choose> 
					</span>&#160;<xsl:value-of select="$currency-suffix" /></strong></li>
					<li>Скидка к заказу: <strong><xsl:value-of select="$currency-prefix" />
					<span class="cart_discount">
						<xsl:choose> 
							<xsl:when test="price/discount">
								<xsl:value-of select="format-number(price/discount, '### ###', 'price')" />
							</xsl:when>
							<xsl:otherwise>
								0
							</xsl:otherwise>
						</xsl:choose>
					</span>
					&#160;<xsl:value-of select="$currency-suffix" /></strong></li>
					<li>Доставка: <strong><xsl:value-of select="$currency-prefix" />
					<span class="delivery_price">
						<xsl:choose>
							<xsl:when test="delivery">
								<xsl:value-of select="format-number(delivery, '### ###', 'price')" />
							</xsl:when>
							<xsl:otherwise>
								0
							</xsl:otherwise>
						</xsl:choose>
					</span>
					&#160;<xsl:value-of select="$currency-suffix" /></strong></li>
					<xsl:if test="not($user-type='guest') and $renderBonusSpec/bonus/available_bonus">
					<li>Оплачено бонусами: <strong><xsl:value-of select="$currency-prefix" />
					<span class="reserved_bonus">
						<xsl:value-of select="$renderBonusSpec/bonus/reserved_bonus" /><xsl:if test="not($renderBonusSpec/bonus/reserved_bonus)">0</xsl:if>
					</span>
					&#160;<xsl:value-of select="$currency-suffix" /></strong></li>
					</xsl:if>
					<li class="important">Итого: <strong><xsl:value-of select="$currency-prefix" /><span data-price="{price/actual}" class="cart_summary_all"><xsl:apply-templates select="price/actual" /></span>&#160;<xsl:value-of select="$currency-suffix" /></strong> </li>
					<xsl:if test="$getPromocodeTest/@promocode">
						<li class="wrapper-promocode">
							<a href="javascript: void(0);" id="usePromocode">Использовать промокод</a>
							<form enctype="multipart/form-data" action="{$lang-prefix}/emarket/setPromokodBonus" method="post" class="margint0">
								<div class="input-append">
									<input id="coupon_code" value="" type="text" name="promocode" placeholder="Введите ваш промо-код" class="span2" />
									<button type="submit" class="btn" value="Apply" name="set_coupon_code" >
										<i class="fa fa-check"></i>
									</button>
								</div>
								<div class="btn_line">
									<i class="fa fa-spinner fa-spin"></i>
									<span class="text-spinner">Подождите...</span>
								</div>
							</form>	
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
		<!-- End class="cart-details" -->
		<div id="auth-cart" class="auth-register-cart hide" tabindex="-1" role="dialog">
            <div class="span12">
                <button type="button" class="close popover-close">×</button>
                <h3>Вы уже зарегистрированы</h3>
				<div class="control-group clearfix">
					<label class="control-label" for="email">Введите пароль</label>
					<div class="controls pull-left"><input class="span12 password_fast_reg" type="password" value="" /></div>
                    <div class="pull-right">
						<button class="btn btn-primary btn-mini-cart modal-auth">
							&#160; <i class="fa fa-check"></i>
						</button>
					</div>
                </div>
            </div>
        </div>
        <!-- <div id="register-cart" class="auth-register-cart modal hide fade" tabindex="-1" role="dialog"> -->
        <div id="register-cart" class="auth-register-cart hide" tabindex="-1" role="dialog">
			<button type="button" class="close popover-close">×</button>
			<h5>Регистрация позволит вам получать скидки и выгодные предложения.</h5>
			<div class="control-group clearfix">
				<label class="control-label" for="email">Просто придумайте пароль</label>
				<div class="controls"><input class="span12 password_fast_reg" type="password" value="" /></div>

				<div class="pull-left">
					<a class="popover-close" aria-hidden="true">
						Продолжить без регистрации
					</a>
				</div>
				<div class="pull-right">
					<button class="btn btn-primary btn-mini modal-auth">
						Зарегистрироваться &#160; <i class="fa fa-check"></i>
					</button>
				</div>
			</div>
        </div>
	</xsl:template>

	<xsl:template match="delivery[.!='']" mode="cart">
		<div class="info">
			<xsl:text>&delivery;: </xsl:text>
			<xsl:value-of select="$currency-prefix" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="." />
			<xsl:text> </xsl:text>
			<xsl:value-of select="$currency-suffix" />
		</div>
	</xsl:template>
	
	<xsl:template match="property" mode="full_name">
		<xsl:value-of select="concat(' ', value)" />
	</xsl:template>
	
	<xsl:template match="property[position() = 1]" mode="full_name">
		<xsl:value-of select="value" />
	</xsl:template>
	
	<xsl:template match="property[@name='electee_objects']" mode="full_name" />
	
	<xsl:template match="property[@name='phone']" mode="full_name" />
	
	<xsl:template match="options" mode="optionCart" />
	<xsl:template match="options[option]" mode="optionCart">
		<ul class="options">
			<xsl:apply-templates select="option" mode="optionCart" />
		</ul>
	</xsl:template>
	<xsl:template match="option" mode="optionCart">
		<xsl:variable name="name-field" select="document(concat('udata://catalog/getFieldTitleOpt/', @element_id,'/', @field-name ,'/'))/udata" />
		<li><xsl:value-of select="concat($name-field, ': ', @name)" /></li>
	</xsl:template>
</xsl:stylesheet>