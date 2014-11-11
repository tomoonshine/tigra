<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- common for catalog  objects pages -->
	<xsl:template match="result[@module='catalog' and @method='object']" mode="main_template">
		<xsl:attribute name="class">main main-product</xsl:attribute>
		<xsl:apply-templates select="." />
	</xsl:template>
	
	<xsl:template match="/result[@module = 'catalog' and @method = 'object']">
	   
		<script type="text/javascript" charset="utf-8" src="{$template-resources}js/price-options.js"></script>
		<xsl:if test="$settings_catalog[@name='viewed']">
			<xsl:value-of select="document(concat('udata://content/addRecentPage/', $document-page-id))/udata" />
		</xsl:if>
		
		<xsl:variable name="cart_items" select="$cart/udata/items" />
		<xsl:variable name="elecTest" select="document(concat('udata://users/electee_test/', page/@id))/udata/result" />
		<xsl:variable name="imageItems" select="document(concat('udata://content/parseFileContent/', $document-page-id,'/ecake_image_gallery'))/udata" />
		 <xsl:variable name="settings_common_quantity">
			<xsl:choose>
				<xsl:when test="$settings_catalog[@name='common_quantity'] and .//property[@name = 'common_quantity']/value &gt; 0">1</xsl:when>
				<xsl:when test="not($settings_catalog[@name='common_quantity'])">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose> 
		</xsl:variable>
		<!-- Product content -->
		<section class="product">
			<!-- Product info -->
			<section class="product-info">
				<div class="container">
					<section class="product-line row">
						<div class="span7">
							<div class="hidden-phone">
								<xsl:apply-templates select="document('udata://core/navibar/')" mode="object-view" />
							</div>
						</div>
						<div class="span5">
						<xsl:apply-templates select="document(concat('udata://catalog/Next_Prev/', $document-page-id))/udata" />
						</div>
					</section>
					<div class="row">
						<div class="span4">
							<div class="product-images">
								<div class="box">
									<div class="primary" id="photo_object">
									    <xsl:if test="$settings_catalog[@name='zoom']"><xsl:attribute name="class">primary zoom-true</xsl:attribute></xsl:if>
										<xsl:apply-templates select="$imageItems" mode="parseImageCatalog">
											<xsl:with-param name="width" select="'370'"/>
											<xsl:with-param name="height" select="'370'"/>
											<xsl:with-param name="data-zoom" select="true()"/>
											<xsl:with-param name="settings_catalog" select="$settings_catalog"/>
											<xsl:with-param name="full" select="'care'"/>
										</xsl:apply-templates>
										<!-- <xsl:apply-templates select=".//property[@name = 'photo_new_field']/value" mode="split">
											<xsl:with-param name="worddiv" select="';'"/>
											<xsl:with-param name="width" select="'370'"/>
											<xsl:with-param name="height" select="'370'"/>
											<xsl:with-param name="one" select="true()"/>
											<xsl:with-param name="fancybox" select="true()"/>
											<xsl:with-param name="full" select="'care'"/>
											<xsl:with-param name="data-zoom" select="true()"/>
											<xsl:with-param name="nameItem" select=".//property[@name='h1']/value"/>
										</xsl:apply-templates> -->
										<xsl:apply-templates select="document(concat('udata://emarket/markerType/', $document-page-id))/udata" mode="market-type"/>
									</div>
									<xsl:apply-templates select="$imageItems" mode="parseImage" />
									<!-- <xsl:apply-templates select=".//property[@name = 'photo_new_field']" mode="split" /> -->
									<div class="social">
										<div id="sharrre">
											<script type="text/javascript" src="//yandex.st/share/share.js" charset="utf-8"></script>
											<div class="yashare-auto-init" data-yashareL10n="ru" data-yashareQuickServices="yaru,vkontakte,facebook,twitter,odnoklassniki,moimir,gplus" data-yashareTheme="counter"></div> 
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="span8">
							<!-- Product content -->
							<div class="product-content">
								<div class="box">
									<!-- Tab panels' navigation -->
									<ul class="nav nav-tabs">
										<li class="active">
											<a href="#product" data-toggle="tab">
												<i class="fa fa-bars fa-lg"></i>
												<span class="hidden-phone">Товар</span>
											</a>
										</li>
										<!-- <xsl:apply-templates select=".//property[@name = '&property-description;']" mode="tab" /> -->
										
										<xsl:if test=".//property[@name = 'information_description']/value or .//group[@name = 'item_properties']/property/value">
											<li>
												<a href="#description" data-toggle="tab">
													<i class="fa fa-info-circle fa-lg"></i>
													<span class="hidden-phone">Информация</span>
												</a>
											</li>
										</xsl:if>
										<li>
										
											<a href="#ratings" data-toggle="tab" id="ratingsTab">
												<i class="fa fa-comments-o fa-lg"></i>
												<span class="hidden-phone">Отзывы</span>
											</a>
										</li>
										<xsl:if test="$settings_common_quantity = 1">
											<li>
												<a href="#oneclick" data-toggle="tab">
													<i class="fa fa-hand-o-down fa-lg"></i>
													<span class="hidden-phone">Заказ в 1 клик</span>
												</a>
											</li>
										</xsl:if>
									</ul>
									<!-- End Tab panels' navigation -->


									<!-- Tab panels container -->

									<div class="tab-content">
										<!-- Product tab -->
										<div class="tab-pane active" id="product">
											<form method="post">
												<xsl:if test="$settings_common_quantity = 1">
													<xsl:attribute name="id"><xsl:value-of select="concat('add_basket_',page/@id)"/></xsl:attribute>
													<xsl:attribute name="class"><xsl:text>options</xsl:text></xsl:attribute>
													<xsl:attribute name="action"><xsl:value-of select="concat($lang-prefix,'/emarket/basket/put/element/',page/@id,'/')"/></xsl:attribute>
												</xsl:if>
												<div class="wrapper-ratting"><span class="text-ratting">Оценка покупателей</span>
													<div class="starrating goodstooltip__starrating">
														<span data-starrate="{.//property[@name='summ_rating']/value}"  class="starlight"></span>
													</div>
													<xsl:apply-templates select="document('udata://comments/countComments')" mode="countComments-object" />
												</div>
												<div class="details">
													<h1>
														<xsl:value-of select=".//property[@name='h1']/value" />
													</h1>
													<div class="meta">
														<xsl:apply-templates select=".//property[@name = 'artikul']" />
														<xsl:apply-templates select=".//property[@name = 'brand']" mode="brand" />
													</div>
													<div class="prices">
													    <xsl:apply-templates select="document(concat('udata://emarket/price/', page/@id,'//0/'))/udata" mode="discounted-price-object" />
													<div class="clearfix" />
													</div>
												</div>
												
												<xsl:apply-templates select=".//group[@name = 'catalog_option_props']" mode="radio-option" />
												<xsl:apply-templates select=".//property[@name = 'color']" mode="radio-button" />
												<xsl:choose>
													<xsl:when test="$settings_common_quantity = 0">
														<div class="alert alert-error clearfix"><a class="subscribe-item pull-right" data-toggle="modal" href="{$lang-prefix}/catalog/notice_of_item/{$document-page-id}#subsribe-item">
															<i class="fa fa-envelope"></i> Сообщить о поступлении</a>
															<strong><i class="fa fa-exclamation-circle"></i> Нет в наличии</strong>
														</div>
													</xsl:when>
													<xsl:otherwise>
														<div class="add-to-cart">
															<div class="btn_line btn_line_{page/@id}">
																<div class="goodsCount goodsCount_amount inline">
																	<span>Количество</span>
																	<a class="down" href="#"><i class="fa fa-minus-square-o fa-lg"></i></a>
																	<input type="text" value="1" name="amount" />
																	<a class="up" href="#"><i class="fa fa-plus-square-o fa-lg"></i></a>
																</div>
																<button class="btn btn-primary btn-large button" type="submit" id="add_basket_{$document-page-id}">
																	 <xsl:variable name="element_id" select="$document-page-id" />
																	<xsl:choose>
																		<xsl:when test="$cart/items and $cart/items/item[page/@id = $element_id]"><xsl:text>В корзине</xsl:text></xsl:when>
																		<xsl:otherwise><xsl:text>Купить</xsl:text></xsl:otherwise>
																	</xsl:choose>
																</button>
																<i class="fa fa-spinner fa-spin"></i>
																<span class="text-spinner">Добавление в корзину...</span>
															</div>
														</div>
													</xsl:otherwise>
												</xsl:choose> 
											</form>
											<xsl:apply-templates select=".//property[@name = '&property-description;']" />
										</div>
										<!-- End id="product" -->

										<!-- Description tab -->
										<div class="tab-pane" id="description">
											<xsl:apply-templates select=".//property[@name = 'information_description']" mode="information_description" />
											<xsl:apply-templates select=".//group[@name = 'item_properties']" mode="item_properties" />
											<xsl:apply-templates select="document(concat('udata://content/parseFileContent/', $document-page-id,'/ecake_file_gallery'))/udata" mode="parseFile" />
										</div>
										<!-- End id="description" -->

										
										<!-- Ratings tab -->
										<div class="tab-pane" id="ratings">
											<xsl:apply-templates select="document('udata://comments/insert?extProps=rating_int')"  />
										</div>
										<!-- End id="ratings" -->
										<!-- Oneclick tab -->
										<xsl:if test="$settings_common_quantity = 1">
											<div class="tab-pane oneclick" id="oneclick">
												<p>Вы можете оформить заказ в 1 клик прямо в карточке товара, заполнив форму ниже</p>
												<form action="{$lang-prefix}/emarket/oneClickPurchase/{$document-page-id}" method="post" id="fastorder" >
													<fieldset>
														<div class="control-group">
															<label class="">
															<!-- <input type="text" name="fio_full" placeholder="Фамилия Имя Отчество" /> -->
															<input type="text" name="fio_full" value="" placeholder="Фамилия Имя Отчество" ><xsl:if test="$user-info//group[@name='short_info']/property[@name='fname']/value and not($user-type='guest')"><xsl:attribute name="value"><xsl:apply-templates select="$user-info//group[@name='short_info']/property" mode="full_name" /></xsl:attribute></xsl:if></input></label>
														</div>
														<div class="control-group">
															<label class=""><input type="text" name="phone" placeholder="Телефон" value=""><xsl:if test="$user-info///property[@name='phone']/value and not($user-type='guest')"><xsl:attribute name="value"><xsl:value-of select="$user-info///property[@name='phone']/value" /></xsl:attribute></xsl:if></input>
															</label>
														</div>
														<div class="control-group">
															<label><input type="text" name="email_cus" placeholder="E-mail" ><xsl:if test="$user-info///property[@name='e-mail']/value and not($user-type='guest')"><xsl:attribute name="value"><xsl:value-of select="$user-info///property[@name='e-mail']/value" /></xsl:attribute></xsl:if></input>
															</label>
														</div>
														<xsl:apply-templates select=".//group[@name = 'catalog_option_props']" mode="radio-option" />
														<div class="goodsCount goodsCount_amount">
															<span>Количество</span>
															<a class="down" href="#"><i class="fa fa-minus"> </i></a>
															<input type="text" value="1" name="amount_window" />
															<a class="up" href="#"><i class="fa fa-plus"></i></a>
														</div>
														<div class="btn_line">
															<input type="submit" class="btn btn-turquoise" value="Оформить заказ"/>
															<i class="fa fa-spinner fa-spin"></i>
															<span class="text-spinner">Идёт оформление заказа...</span>
														</div>
													</fieldset>
												</form>
											</div>
										</xsl:if>
									</div>
									<!-- End tab panels container -->

								</div>
								<xsl:if test="$settings_catalog[@name='electee']">
									<div class="electee-wrap">
										<a href="#" class="fa fa-star-o" data-delete-url="/users/electee_delete/{page/@id}" data-add-url="/users/electee_item/{page/@id}" data-untext="Отменить" data-placement="left" data-text="В избранное"  data-id-sticky="#sticky-electee" title="В избранное">
											<xsl:choose>
												<xsl:when test="$elecTest = '1'"><xsl:attribute name="href"><xsl:text>/users/electee_delete/</xsl:text><xsl:value-of select="page/@id" /></xsl:attribute><xsl:attribute name="class">fa fa-star del_electee_item</xsl:attribute><xsl:attribute name="title">Отменить</xsl:attribute></xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="href"><xsl:text>/users/electee_item/</xsl:text><xsl:value-of select="page/@id" /></xsl:attribute><xsl:attribute name="class">fa fa-star-o add_electee_item</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
										</a>
									</div>
								</xsl:if>
							</div>
							<!-- End class="product-content" -->

						</div>
					</div>
					</div>
			</section>
			<!-- End class="product-info" -->


			<!-- Related products -->
				<xsl:apply-templates select="document(concat('udata://catalog/sortArrayRand/', $document-page-id,'/4/'))/udata" mode="recommended_items" />
			<!-- End class="products-related" -->
		</section>
	</xsl:template>

	<xsl:template match="property[@name = '&property-description;']">
		<div class="short-description" itemprop="description">
			<div umi:element-id="{../../../@id}" umi:field-name="{@name}" umi:empty="&item-description;">
				<xsl:value-of select="value" disable-output-escaping="yes" />
			</div>
		</div>
	</xsl:template>
	
	
	
	<xsl:template match="property[@name = '&property-description;' and value = '']">
		<div class="short-description" itemprop="description">
			<div umi:element-id="{../../../@id}" umi:field-name="{@name}" umi:empty="&item-description;">
			
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="property" mode="information_description">
		<div><xsl:value-of select="value" disable-output-escaping="yes" /></div>
	</xsl:template>
	
	<xsl:template match="property[@name = 'artikul']" />
	<xsl:template match="property[@name = 'artikul' and not(value = '')]">
		<div class="sku">
			<i class="fa fa-pencil-square-o"></i>
			Артикул: <xsl:value-of select="value" />
		</div>
	</xsl:template>
	
	<xsl:template match="property[@name = 'brand']" mode="brand" />
	<xsl:template match="property[@name = 'brand'][value/item]" mode="brand">
		<div class="categories">
			<xsl:apply-templates select="value/item" mode="brand" /> 
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="brand">
		<span title="{@name}"><xsl:value-of select="@name" /></span>
	</xsl:template>
	
	<xsl:template match="item[position() = 1]" mode="brand">
		<span>
			<i class="fa fa-tags"></i>
			<span title="{@name}"><xsl:value-of select="@name" /></span>
		</span>
	</xsl:template>
	
	<xsl:template match="group" mode="table">
		<table class="object">
			<thead>
				<tr>
					<th colspan="2">
						<xsl:value-of select="concat(title, ':')" />
					</th>
				</tr>
			</thead>
			<tbody umi:element-id="{../../@id}">
				<xsl:apply-templates select="property" mode="table" />
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="property" mode="table">
		<tr>
			<xsl:apply-templates select="title" mode="table"/>
			<xsl:apply-templates select="value" mode="table"/>
		</tr>
	</xsl:template>
	<xsl:template match="property/title" mode="table">
		<td>
			<span>
				<xsl:apply-templates select="document(concat('utype://', ../../../../@type-id, '.', ../../@name))/udata/group/field[@name = ../@name]/tip" mode="tip" />
				<xsl:value-of select="." />
			</span>
		</td>
	</xsl:template>
	<xsl:template match="property/value" mode="table">
		<td umi:field-name="{../@name}">
			<xsl:apply-templates select=".." />
		</td>
	</xsl:template>
	<xsl:template match="property[@type='symlink']/value" mode="table">
		<td umi:field-name="{../@name}" umi:type="catalog::object">
			<xsl:apply-templates select=".." />
		</td>
	</xsl:template>
	<xsl:template match="property[@type='wysiwyg']/value" mode="table">
		<td umi:field-name="{../@name}">
			<xsl:value-of select="." disable-output-escaping="yes" />
		</td>
	</xsl:template>
	<xsl:template match="group" mode="div">
		<div class="item_properties">
			<div>
				<xsl:value-of select="concat(title, ':')" />
			</div>
			<xsl:apply-templates select="property" mode="div" />
		</div>
	</xsl:template>

	<xsl:template match="property" mode="div">
		<xsl:apply-templates select="document(concat('utype://', ../../../@type-id, '.', ../@name))/udata/group/field[@name = ./@name]/tip" mode="tip" />
		<xsl:value-of select="title" />
		<xsl:text>: </xsl:text>
		<span umi:field-name="{@name}"><xsl:apply-templates select="." /></span>
		<xsl:text>; </xsl:text>
	</xsl:template>
	
	<xsl:template match="property[last()]" mode="div">
		<xsl:apply-templates select="document(concat('utype://', ../../../@type-id, '.', ../@name))/udata/group/field[@name = ./@name]/tip" mode="tip" />
		<xsl:value-of select="title" />
		<xsl:text>: </xsl:text>
		<span umi:field-name="{@name}"><xsl:apply-templates select="." /></span>
		<xsl:text>. </xsl:text>
	</xsl:template>
	
	<xsl:template match="property[@name = 'udachno_sochetaetsya_s']" mode="div">
		<xsl:apply-templates select="document(concat('utype://', ../../../@type-id, '.', ../@name))/udata/group/field[@name = ./@name]/tip" mode="tip" />
		<xsl:value-of select="title" />
		<xsl:text>: </xsl:text>
		<span umi:type="catalog::object" umi:field-name="{@name}"><xsl:apply-templates select="value/page" mode="div" /></span>
		<xsl:text>; </xsl:text>
	</xsl:template>
	
	<xsl:template match="property[@name = 'udachno_sochetaetsya_s' and last()]" mode="div">
		<xsl:apply-templates select="document(concat('utype://', ../../../@type-id, '.', ../@name))/udata/group/field[@name = ./@name]/tip" mode="tip" />
		<xsl:value-of select="title" />
		<xsl:text>: </xsl:text>
		<span umi:type="catalog::object" umi:field-name="{@name}"><xsl:apply-templates select="value/page" mode="div" /></span>
		<xsl:text>. </xsl:text>
	</xsl:template>
	
	<xsl:template match="page" mode="div">	
		<a href="{@link}">
			<xsl:value-of select="name" />
		</a>
		<xsl:text>, </xsl:text>
	</xsl:template>
	
	<xsl:template match="page[last()]" mode="div">	
		<a href="{@link}">
			<xsl:value-of select="name" />
		</a>
	</xsl:template>
	
	
	<xsl:template match="group" mode="table_options">
		<xsl:if test="count(//option) &gt; 0">
			<h4><xsl:value-of select="concat(title, ':')" /></h4>
			<xsl:apply-templates select="property" mode="table_options" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="group" mode="select-option">
		<xsl:if test="count(//option) &gt; 0">
			<div class="options">
				<div class="row-fluid">
					<div class="span6">
						<div class="control-group">
							<xsl:apply-templates select="property" mode="select-option" />
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="property" mode="radio-button" />
	<xsl:template match="property[value]" mode="radio-button">
	    <div class="options">
    	    <div class="options-row">
                <span class=""><xsl:value-of select="concat(title, ':')" /></span>
                <div class="color-group">
                     <xsl:apply-templates select="document(concat('udata://catalog/getPropertyLinked/', $document-page-id,'/', @name ,'/additional_items/'))/udata/items" mode="radio-button" />
                </div>
            </div>
        </div>
	</xsl:template>
	
	<xsl:template match="items" mode="radio-button" />
	<xsl:template match="items[item]" mode="radio-button">
		<xsl:copy-of select="item" />
	    <xsl:apply-templates select="item" mode="radio-button">
	        <xsl:sort select="@name" />
	    </xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="item" mode="radio-button">
       <a class="color-box active"><xsl:if test="@html_color"><xsl:attribute name="style">background: <xsl:value-of select="@html_color" /></xsl:attribute></xsl:if></a>
    </xsl:template>
	<xsl:template match="item[@link]" mode="radio-button">
       <a class="color-box" href="{@link}"><xsl:if test="@html_color"><xsl:attribute name="style">background: <xsl:value-of select="@html_color" /></xsl:attribute></xsl:if></a>
    </xsl:template>
	
	<xsl:template match="group" mode="radio-option">
		<xsl:if test="count(//option) &gt; 0">
			<div class="options">
				<xsl:apply-templates select="property" mode="radio-option" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="property" mode="table_options">
		<table class="object">
			<thead>
				<tr>
					<th colspan="3">
						<xsl:value-of select="concat(title, ':')" />
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="value/option" mode="table_options" />
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="option" mode="table_options">
		<tr>
			<td style="width:20px;">
				<input type="radio" name="options[{../../@name}]" value="{object/@id}">
					<xsl:if test="position() = 1">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
			</td>
			<td>
				<xsl:value-of select="object/@name" />
			</td>
			<td align="right">
				<xsl:value-of select="@float" />
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="tip" mode="tip">
		<xsl:attribute name="title">
			<xsl:apply-templates />
		</xsl:attribute>
		<xsl:attribute name="style">
			<xsl:text>border-bottom:1px dashed; cursor:help;</xsl:text>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="property" mode="select-option" />
	<xsl:template match="property[value/option]" mode="select-option">
		<label>
			<span><xsl:value-of select="concat(title, ':')" /></span>
			<select name="options[{@name}]">
				<xsl:apply-templates select="value/option" mode="select-option" />
			</select>
		</label>
	</xsl:template>
	
	<xsl:template match="property" mode="radio-option" />
	<xsl:template match="property[value/option]" mode="radio-option">
	    <div class="options-row">
    		<span class=""><xsl:value-of select="concat(title, ':')" /></span>
    		<div class="btn-group" data-toggle="buttons-radio">
    		     <xsl:apply-templates select="value/option" mode="radio-option" />
    		</div>
		</div>
	</xsl:template>
	
	<xsl:template match="option" mode="select-option">
		<option value="{object/@id}">
			<xsl:if test="position() = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="object/@name" />
		</option>
	</xsl:template>
	
	<xsl:template match="option" mode="radio-option">
	    <!-- <button type="button" class="btn btn-primary small"><xsl:if test="position() = 1"><xsl:attribute name="class">btn btn-primary active</xsl:attribute></xsl:if> -->
	    <label class="btn btn-primary small"><xsl:if test="position() = 1"><xsl:attribute name="class">btn btn-primary active</xsl:attribute></xsl:if>
    	    <input name="options[{../../@name}]" type="radio" value="{object/@id}" data-float="{@float}" class="not-styler">
    	        <xsl:if test="position() = 1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
    	    </input>
    	     <xsl:value-of select="object/@name" />
	    </label>
	    <!-- </button> -->
	</xsl:template>
	
	<xsl:template match="property" mode="split" />
	<xsl:template match="property[not(value='')]" mode="split">
		<xsl:variable name="testNextImg" select="substring-after(value/text(), ';')" />
		<div class="thumbs" id="gallery">
			<xsl:if test="not($testNextImg)"><xsl:attribute name="style"><xsl:text>display: none;</xsl:text></xsl:attribute></xsl:if>
			<ul class="thumbs-list">
				<xsl:apply-templates select="value/text()" mode="split">
					<xsl:with-param name="worddiv" select="';'"/>
					<xsl:with-param name="width" select="'68'"/>
					<xsl:with-param name="height" select="'65'"/>
					<xsl:with-param name="full" select="'care'"/>
					<xsl:with-param name="fancybox" select="true()"/>
					<xsl:with-param name="fancybox-big-width" select="'370'"/>
					<xsl:with-param name="fancybox-big-height" select="'370'"/>
					<xsl:with-param name="fancybox-width" select="'1024'"/>
					<xsl:with-param name="fancybox-height" select="'1024'"/>
					<xsl:with-param name="wrapper-item-li-a" select="true()"/>
					<xsl:with-param name="gallery" select="true()"/>
					<xsl:with-param name="data-name" select="'data-zoom-image'" />
				</xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="udata" mode="parseImage" />
	<xsl:template match="udata[items/item]" mode="parseImage">
		<div class="thumbs" id="gallery">
			<xsl:if test="count(items/item) &lt; 2"><xsl:attribute name="style"><xsl:text>display: none;</xsl:text></xsl:attribute></xsl:if>
			<ul class="thumbs-list">
				<xsl:apply-templates select="items/item" mode="parseImage" />
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="parseImage">
		<xsl:variable name="path" select="@src" />
		<li>
			<a data-index="{position() - 1}">
				<xsl:attribute name="href">
					<xsl:call-template name="all-thumbnail-path">
						<xsl:with-param name="width" select="'370'" />
						<xsl:with-param name="height" select="'370'" />
						<xsl:with-param name="path" select="$path" />
						<xsl:with-param name="quality" select="'100'" />
						<xsl:with-param name="only-src" select="true()" />
						<xsl:with-param name="full" select="'care'"/>
						<xsl:with-param name="settings_catalog" select="$settings_catalog" />
					</xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="rel">fancybox-thumb</xsl:attribute>
				<xsl:if test="position() = 1">
					<xsl:attribute name="class">active</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="data-zoom-image">
					<xsl:call-template name="all-thumbnail-path">
						<xsl:with-param name="width" select="'1024'" />
						<xsl:with-param name="height" select="'1024'" />
						<xsl:with-param name="path" select="$path" />
						<xsl:with-param name="quality" select="'100'" />
						<xsl:with-param name="only-src" select="true()" />
						<xsl:with-param name="full" select="'care'"/>
						<xsl:with-param name="settings_catalog" select="$settings_catalog" />
					</xsl:call-template>
				</xsl:attribute>
				<xsl:call-template name="all-thumbnail-path">
					<xsl:with-param name="width" select="'68'" />
					<xsl:with-param name="height" select="'65'" />
					<xsl:with-param name="path" select="$path" />
					<xsl:with-param name="quality" select="'100'" />
					<xsl:with-param name="full" select="'care'" />
					<xsl:with-param name="gallery-split" select="true()" />
					<xsl:with-param name="settings_catalog" select="$settings_catalog" />
				</xsl:call-template>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="udata" mode="parseFile" />
	<xsl:template match="udata[items/item]" mode="parseFile">
		<div class="file-items">
			<xsl:apply-templates select="items/item" mode="parseFile" />
		</div>
	</xsl:template>
	<xsl:template match="item" mode="parseFile">
		<xsl:variable name="token" select="concat('/styles/skins/mac/design/css/icon-files/', @type,'.png')" />
		<div><a href="{@src}" target="_blank">
			<xsl:call-template name="all-thumbnail-path">
				<xsl:with-param name="width" select="'25'" />
				<xsl:with-param name="height" select="'25'" />
				<xsl:with-param name="path" select="$token" />
				<xsl:with-param name="quality" select="'100'" />
				<xsl:with-param name="full" select="'care'" />
			</xsl:call-template><xsl:value-of select="@name" />
		</a></div>
	</xsl:template>

</xsl:stylesheet>