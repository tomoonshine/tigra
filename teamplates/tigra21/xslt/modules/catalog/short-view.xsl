<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="page|item" mode="short-view">
		<xsl:param name="from_recent" select="false()" />
		<xsl:param name="cart_items" select="$cart/items" />
		<xsl:param name="settings_catalog" select="$settings_catalog" />
		<xsl:param name="method" select="$method" />
		<xsl:param name="lang-prefix" select="$lang-prefix" />
		
		<xsl:variable name="object" select="document(concat('upage://', @id))/udata" />
		<xsl:variable name="shop" select="document(concat('udata://data/getShopName/', @id))/udata" />
		<xsl:variable name="price" select="document(concat('udata://emarket/price/', @id,'//0'))/udata" />
		<xsl:variable name="elecTest" select="document(concat('udata://users/electee_test/', @id))/udata/result" />
		<xsl:variable name="is_options">
			<xsl:apply-templates select="$object/page/properties" mode="is_options" />
		</xsl:variable>
		<xsl:variable name="settings_common_quantity">
			<xsl:choose>
				<xsl:when test="$settings_catalog[@name='common_quantity'] and $object//property[@name = 'common_quantity']/value &gt; 0">1</xsl:when>
				<xsl:when test="not($settings_catalog[@name='common_quantity'])">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose> 
		</xsl:variable>
		
		<li class="standard" umi:region="row" umi:element-id="{@id}" data-price="{$price/price/actual}">

			<div class="image">
				<a href="{@link}" class="image-link" umi:element-id="{@id}" title="{$object/page/name}">
					<!-- Картинка -->
					<div class="image_crop_block">
						<xsl:apply-templates select="document(concat('udata://content/parseFileContent/', @id,'/tigra21_image_gallery'))/udata" mode="parseImageCatalog">
							<xsl:with-param name="width" select="'270'"/>
							<xsl:with-param name="height" select="'340'"/>
							<xsl:with-param name="class" select="'primary'"/>
							<xsl:with-param name="settings_catalog" select="$settings_catalog"/>
						</xsl:apply-templates>
					</div>
					<xsl:apply-templates select="document(concat('udata://emarket/markerType/',@id))/udata" mode="market-type"/>
				</a>
				<xsl:if test="$settings_catalog[@name='electee']">
					<xsl:if test="$method='electee_item_view'"><div class="electee-wrap-delete">
						<a href="/users/electee_delete/{@id}" class="fa fa-times-circle del_electee_item" data-id-sticky="#sticky-electee"></a>
					</div></xsl:if>
				</xsl:if>
				<xsl:if test="$settings_catalog[@name='viewed']">
					<xsl:if test="$method='getRecentPages'"><div class="electee-wrap-delete">
						<a href="/content/delRecentPage/{@id}" class="fa fa-times-circle del_electee_item" data-id-sticky="#sticky-recent-pages"></a>
					</div></xsl:if>
				</xsl:if>
				<xsl:if test="$settings_catalog[@name='electee']">
					<xsl:if test="not($method='electee_item_view')">
						<div class="electee-wrap">
							<a href="#" class="fa fa-star-o" data-delete-url="/users/electee_delete/{@id}" data-add-url="/users/electee_item/{@id}" data-untext="Отменить" data-text="В избранное" data-id-sticky="#sticky-electee" data-placement="right" title="В избранное">
								<xsl:choose>
									<xsl:when test="$elecTest = '1'"><xsl:attribute name="href"><xsl:text>/users/electee_delete/</xsl:text><xsl:value-of select="@id" /></xsl:attribute><xsl:attribute name="class">fa fa-star del_electee_item</xsl:attribute><xsl:attribute name="title">Отменить</xsl:attribute></xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="href"><xsl:text>/users/electee_item/</xsl:text><xsl:value-of select="@id" /></xsl:attribute><xsl:attribute name="class">fa fa-star-o add_electee_item</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						</div>
					</xsl:if>
				</xsl:if>
			</div>
			<div class="title">
				<a href="{@link}" title="{$object/page/name}">
					<div class="prices">
						<xsl:apply-templates select="$price/price" mode="discounted-price" />
					</div>
					<h3><xsl:value-of select="$object/page/name" /></h3>
				</a>
				
				<div class="item_properties">
					<p>Характеристики:</p>
					<ul class="list-border">
						<li>?Бренд: Bruno Amaranti</li>
						<li>?Материал: Кожа</li>
						<li>?Цвет: Черный</li>
					</ul>
				</div>
				
				<div class="btn_line add_from_list btn_line_{@id}">
					<div class="prices">
						<xsl:apply-templates select="$price/price" mode="discounted-price" />
					</div>
					<div class="starrating goodstooltip__starrating">
						<span data-starrate="{$object//property[@name='summ_rating']/value}"  class="starlight"></span>
					</div>
					<a	href="http://{$shop/domain}" title="{$shop/name}" class="btn btn-small btn-primary button options basket_list ">
						<xsl:value-of select="$shop/name" />
					</a>
					<i class="fa fa-spinner fa-spin"></i>
					
				</div>
		<!-- 		<a href="{@link}" title="{$object/page/name}">
					<div class="prices">
						<xsl:apply-templates select="$price/price" mode="discounted-price" />
					</div>
					<h3 umi:element-id="{@id}" umi:field-name="name"><xsl:value-of select="document(concat('udata://content/getAnonsOrContent/', @id ,'/65///1/'))/udata" disable-output-escaping="yes" /></h3>
				</a>
				
				<div class="item_properties">
					<p>Характеристики:</p>
					<xsl:apply-templates select="$object//group[@name = 'item_properties']" mode="item_properties">
						<xsl:with-param name="stop-position" select="'3'" />
					</xsl:apply-templates>
				</div>
				<div class="btn_line add_from_list btn_line_{@id}">
				    <div class="prices">
						<xsl:apply-templates select="$price/price" mode="discounted-price" />
                    </div>
					<div class="starrating goodstooltip__starrating">
						<span data-starrate="{$object//property[@name='summ_rating']/value}"  class="starlight"></span>
					</div>
					<xsl:choose>
						<xsl:when test="$settings_common_quantity = 0">
							<span class="label label-important"><strong>Нет в наличии</strong></span>
						</xsl:when>
						<xsl:otherwise>
							<a	id="add_basket_{@id}" class="btn btn-small btn-primary button options basket_list options_{$is_options}" href="{$lang-prefix}/emarket/basket/put/element/{@id}">
								<xsl:variable name="element_id" select="@id" />
								<xsl:choose>
									<xsl:when test="$cart_items and $cart_items/item[page/@id = $element_id]"><xsl:text>В корзине</xsl:text></xsl:when>
									<xsl:otherwise><xsl:text>Купить</xsl:text></xsl:otherwise>
								</xsl:choose>
							</a>
							<i class="fa fa-spinner fa-spin"></i>
						</xsl:otherwise>
					</xsl:choose>
				</div> -->
			</div>
		</li>
	</xsl:template>

	<xsl:template match="properties" mode="is_options">
		<xsl:value-of select="false()" />
	</xsl:template>

	<xsl:template match="properties[group[@name = 'catalog_option_props']/property[not(@name='additional_items')]]" mode="is_options">
		<xsl:value-of select="true()" />
	</xsl:template>
	
	<!-- markerType -->
	<xsl:template match="udata" mode="market-type" />
	<xsl:template match="udata[item]" mode="market-type">
		<div class="badge_lay">
			<xsl:apply-templates select="item" mode="market-type"/>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="market-type">
		<span class="badge badge-sale badge-sale-i{@name}"><xsl:value-of select="@value" /></span><span class="badge-spr"></span>
	</xsl:template>
	<xsl:template match="item[@name='discount']" mode="market-type">
		<span class="badge badge-sale badge-sale-i{@name}"><xsl:text>- </xsl:text><xsl:value-of select="@value" /></span>
	</xsl:template>
	
	<xsl:template match="page|item" mode="short-view-widget">
        <xsl:param name="from_recent" select="false()" />
        <xsl:param name="cart_items" select="false()" />
         <xsl:param name="get-old-price" select="false()"   />
        <xsl:variable name="object" select="document(concat('upage://', @id))/udata" />
        <xsl:variable name="price" select="document(concat('udata://emarket/price/', @id,'//1'))/udata" />
        <xsl:variable name="old-price" select="$object//property[@name = 'old_price']/value" />
       
        <li test="{$get-old-price}">
            <div class="image">
                <a title="{$object/page/name}" href="{@link}">
					<xsl:apply-templates select="document(concat('udata://content/parseFileContent/', @id,'/tigra21_image_gallery'))/udata" mode="parseImageCatalog">
						<xsl:with-param name="width" select="'52'"/>
						<xsl:with-param name="height" select="'67'"/>
						<xsl:with-param name="class" select="'gravatar'"/>
						<xsl:with-param name="settings_catalog" select="$settings_catalog"/>
					</xsl:apply-templates>
                    <!-- <xsl:apply-templates select="$object//property[@name = 'photo_new_field']/value" mode="split">
                        <xsl:with-param name="worddiv" select="';'"/>
                        <xsl:with-param name="width" select="'52'"/>
                        <xsl:with-param name="height" select="'67'"/>
                        <xsl:with-param name="one" select="true()"/>
                        <xsl:with-param name="class" select="'gravatar'"/>
                    </xsl:apply-templates> -->
                </a>
            </div>
            <div class="desc">
                <h6><a href="{@link}"><xsl:value-of select="$object/page/name" /></a></h6>
                <div class="price">
					<xsl:apply-templates select="$price/price" mode="discounted-price" />
                </div>
                <div class="starrating rating goodstooltip__starrating">
                    <span data-starrate="{$object//property[@name='summ_rating']/value}"  class="starlight"></span>
                </div>
            </div>
        </li>
    </xsl:template>
	
	
	<xsl:template match="group" mode="item_properties">
		<xsl:param name="stop-position" />
		<ul class="list-border">
			<xsl:apply-templates select="property" mode="item_properties">
				<xsl:with-param name="stop-position" select="$stop-position" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:template match="property" mode="item_properties" />
	<xsl:template match="property[not(value = '')]" mode="item_properties">
		<xsl:param name="stop-position" />
		<xsl:choose>
            <xsl:when test="not($stop-position)">
                <li><xsl:value-of select="concat(title, ':')" /><xsl:text> </xsl:text><xsl:value-of select="value" /></li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="position() &lt;= $stop-position">
                   <li><xsl:value-of select="concat(title, ':')" /><xsl:text> </xsl:text><xsl:value-of select="value" /></li>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>
	
	<xsl:template match="property[not(value = '') and @type='file']" mode="item_properties">
		<li><a href="{value}" target="_blank"><xsl:value-of select="title" /></a></li>
	</xsl:template>
	
	<xsl:template match="property[value/item]" mode="item_properties">
		<xsl:param name="stop-position" />
		<xsl:choose>
			<xsl:when test="not($stop-position)">
				<li><xsl:value-of select="concat(title, ':')" /><xsl:text> </xsl:text><xsl:apply-templates select="value/item" mode="item_properties" /></li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="position() &lt;= $stop-position">
					<li><xsl:value-of select="concat(title, ':')" /><xsl:text> </xsl:text><xsl:apply-templates select="value/item" mode="item_properties" /></li>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="item" mode="item_properties">
		<xsl:value-of select="@name" /><xsl:text>, </xsl:text>
	</xsl:template>
	<xsl:template match="item[position() = last()]" mode="item_properties">
		<xsl:value-of select="@name" />
	</xsl:template>
	
	<xsl:template name="token">
		<xsl:param name="token"/>
		<xsl:param name="width" select="'auto'"/>
		<xsl:param name="height" select="'auto'"/>
		<xsl:param name="gallery" select="false()"/>
		<xsl:param name="fancybox" select="false()"/>
		<xsl:param name="fancybox-width" select="'auto'"/>
		<xsl:param name="fancybox-height" select="'auto'"/>
		<xsl:param name="fancybox-big-width" select="'auto'"/>
		<xsl:param name="fancybox-big-height" select="'auto'"/>
		<xsl:param name="wrapper-item-a" select="false()" />
		<xsl:param name="wrapper-item-li" select="false()" />
		<xsl:param name="wrapper-item-li-a" select="false()" />
		<xsl:param name="data-name" select="''" />
		<xsl:param name="data-zoom" select="false()" />
		<xsl:param name="position" select="0" />
		<xsl:param name="nameItem" select="''" />
		<!-- <xsl:param name="full" select="'care'" /> -->
		<xsl:param name="full" select="''" />
		<xsl:param name="element-id" />
		<xsl:param name="field-name" />
		<xsl:param name="settings_catalog" />
		
		<xsl:if test="$token">
			<xsl:choose>
				<xsl:when test="$wrapper-item-a = true()">
					<a data-index="{$position}">
					    <xsl:if test="$nameItem"><xsl:attribute name="title"><xsl:value-of select="$nameItem" /></xsl:attribute></xsl:if>
						<xsl:if test="$fancybox = true()">
							<xsl:attribute name="href">
								<xsl:call-template name="all-thumbnail-path">
									<xsl:with-param name="width" select="$fancybox-big-width" />
									<xsl:with-param name="height" select="$fancybox-big-height" />
									<xsl:with-param name="path" select="$token" />
                                    <xsl:with-param name="full" select="$full" />
									<xsl:with-param name="quality" select="'100'" />
									<xsl:with-param name="only-src" select="true()" />
									<xsl:with-param name="settings_catalog" select="$settings_catalog" />
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="$gallery = true()">
							<xsl:attribute name="rel">gallery</xsl:attribute>
						</xsl:if>
						<xsl:if test="$data-name"><xsl:attribute name="{$data-name}">
							<xsl:call-template name="all-thumbnail-path">
								<xsl:with-param name="width" select="$fancybox-width" />
								<xsl:with-param name="height" select="$fancybox-height" />
								<xsl:with-param name="path" select="$token" />
                                <xsl:with-param name="full" select="$full" />
								<xsl:with-param name="quality" select="'100'" />
								<xsl:with-param name="only-src" select="true()" />
								<xsl:with-param name="settings_catalog" select="$settings_catalog" />
							</xsl:call-template>
						</xsl:attribute></xsl:if>
						<xsl:call-template name="all-thumbnail-path">
							<xsl:with-param name="width" select="$width" />
							<xsl:with-param name="height" select="$height" />
							<xsl:with-param name="path" select="$token" />
                            <xsl:with-param name="full" select="$full" />
							<xsl:with-param name="quality" select="'100'" />
							<xsl:with-param name="nameItem" select="$nameItem" />
							<xsl:with-param name="gallery-split" select="true()" />
							<xsl:with-param name="element-id" select="$element-id" />
							<xsl:with-param name="field-name" select="$field-name" />
							<xsl:with-param name="settings_catalog" select="$settings_catalog" />
						</xsl:call-template>
					</a>
				</xsl:when>
				<xsl:when test="$wrapper-item-li = true()">
					<li>
						<xsl:call-template name="all-thumbnail-path">
							<xsl:with-param name="width" select="$width" />
							<xsl:with-param name="height" select="$height" />
							<xsl:with-param name="path" select="$token" />
                            <xsl:with-param name="full" select="$full" />
							<xsl:with-param name="quality" select="'100'" />
							<xsl:with-param name="nameItem" select="$nameItem" />
							<xsl:with-param name="gallery-split" select="true()" />
                            <xsl:with-param name="element-id" select="$element-id" />
                            <xsl:with-param name="field-name" select="$field-name" />
							<xsl:with-param name="settings_catalog" select="$settings_catalog" />
						</xsl:call-template>
					</li>
				</xsl:when>
				<xsl:when test="$wrapper-item-li-a = true()">
					<li>
						<a data-index="{$position}">
						    <xsl:if test="$nameItem"><xsl:attribute name="title"><xsl:value-of select="$nameItem" /></xsl:attribute></xsl:if>
							<xsl:if test="$fancybox = true()">
								<xsl:attribute name="href">
									<xsl:call-template name="all-thumbnail-path">
										<xsl:with-param name="width" select="$fancybox-big-width" />
										<xsl:with-param name="height" select="$fancybox-big-height" />
										<xsl:with-param name="path" select="$token" />
                                        <xsl:with-param name="full" select="$full" />
										<xsl:with-param name="quality" select="'100'" />
										<xsl:with-param name="only-src" select="true()" />
										<xsl:with-param name="settings_catalog" select="$settings_catalog" />
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$gallery = true()">
								<xsl:attribute name="rel">fancybox-thumb</xsl:attribute>
							</xsl:if>
							<xsl:if test="$position = 0">
								<xsl:attribute name="class">active</xsl:attribute>
							</xsl:if>
							<xsl:if test="$data-name"><xsl:attribute name="{$data-name}">
								<xsl:call-template name="all-thumbnail-path">
									<xsl:with-param name="width" select="$fancybox-width" />
									<xsl:with-param name="height" select="$fancybox-height" />
									<xsl:with-param name="path" select="$token" />
                                    <xsl:with-param name="full" select="$full" />
									<xsl:with-param name="quality" select="'100'" />
									<xsl:with-param name="only-src" select="true()" />
									<xsl:with-param name="settings_catalog" select="$settings_catalog" />
								</xsl:call-template>
							</xsl:attribute></xsl:if>
							<xsl:call-template name="all-thumbnail-path">
								<xsl:with-param name="width" select="$width" />
								<xsl:with-param name="height" select="$height" />
								<xsl:with-param name="path" select="$token" />
                                <xsl:with-param name="full" select="$full" />
								<xsl:with-param name="quality" select="'100'" />
								<xsl:with-param name="nameItem" select="$nameItem" />
								<xsl:with-param name="gallery-split" select="true()" />
                                <xsl:with-param name="element-id" select="$element-id" />
                                <xsl:with-param name="field-name" select="$field-name" />
								<xsl:with-param name="settings_catalog" select="$settings_catalog" />
							</xsl:call-template>
						</a>
					</li>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="zoomSrc">
						<xsl:if test="$data-zoom">
							<xsl:call-template name="all-thumbnail-path">
								<xsl:with-param name="width" select="'1024'" />
								<xsl:with-param name="height" select="'1024'" />
								<xsl:with-param name="path" select="$token" />
								<xsl:with-param name="full" select="$full" />
								<xsl:with-param name="quality" select="'100'" />
								<xsl:with-param name="only-src" select="true()" />
								<xsl:with-param name="settings_catalog" select="$settings_catalog" />
							</xsl:call-template>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name="all-thumbnail-path">
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
						<xsl:with-param name="path" select="$token" />
						<xsl:with-param name="full" select="$full" />
						<xsl:with-param name="quality" select="'100'" />
						<xsl:with-param name="data-zoom" select="$zoomSrc" />
						<xsl:with-param name="nameItem" select="$nameItem" />
						<xsl:with-param name="gallery-split" select="true()" />
                        <xsl:with-param name="element-id" select="$element-id" />
                        <xsl:with-param name="field-name" select="$field-name" />
						<xsl:with-param name="settings_catalog" select="$settings_catalog" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="split" match="text()" mode="split">
		<xsl:param name="str" select="."/>
		<xsl:param name="worddiv" select="','"/>
		<xsl:param name="one" select="false()"/>
		<xsl:param name="width" select="'auto'"/>
		<xsl:param name="height" select="'auto'"/>
		<xsl:param name="fancybox" select="false()"/>
		<xsl:param name="fancybox-width" select="'auto'"/>
		<xsl:param name="fancybox-height" select="'auto'"/>
		<xsl:param name="fancybox-big-width" select="'auto'"/>
		<xsl:param name="fancybox-big-height" select="'auto'"/>
		<xsl:param name="wrapper-item-a" select="false()" />
		<xsl:param name="wrapper-item-li" select="false()" />
		<xsl:param name="wrapper-item-li-a" select="false()" />
		<xsl:param name="data-name" select="''" />
		<xsl:param name="data-zoom" select="false()" />
		<xsl:param name="position" select="0" />
		<xsl:param name="gallery" select="false()" />
		<xsl:param name="nameItem" select="''" />
		<!-- <xsl:param name="full" select="'care'" /> -->
		<xsl:param name="full" select="''" />
        <xsl:param name="element-id" />
        <xsl:param name="field-name" />
		<xsl:param name="settings_catalog" select="$settings_catalog" />
		
		<xsl:choose>
			<xsl:when test="contains($str,$worddiv)">
				<xsl:call-template name="token">
					<xsl:with-param name="token" select="substring-before($str, $worddiv)"/>
					<xsl:with-param name="width" select="$width"/>
					<xsl:with-param name="height" select="$height"/>
					<xsl:with-param name="fancybox" select="$fancybox"/>
					<xsl:with-param name="wrapper-item-a" select="$wrapper-item-a"/>
					<xsl:with-param name="wrapper-item-li" select="$wrapper-item-li"/>
					<xsl:with-param name="wrapper-item-li-a" select="$wrapper-item-li-a"/>
					<xsl:with-param name="fancybox-width" select="$fancybox-width" />
					<xsl:with-param name="fancybox-height" select="$fancybox-height" />
					<xsl:with-param name="fancybox-big-width" select="$fancybox-big-width" />
					<xsl:with-param name="fancybox-big-height" select="$fancybox-big-height" />
					<xsl:with-param name="data-name" select="$data-name" />
					<xsl:with-param name="position" select="$position" />
					<xsl:with-param name="data-zoom" select="$data-zoom" />
					<xsl:with-param name="gallery" select="$gallery" />
					<xsl:with-param name="nameItem" select="$nameItem" />
					<xsl:with-param name="full" select="$full" />
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
                    <xsl:with-param name="settings_catalog" select="$settings_catalog" />
				</xsl:call-template>
				<xsl:if test="$one = false()">
					<xsl:call-template name="split"> 
						<xsl:with-param name="str" select="substring-after($str, $worddiv)"/>
						<xsl:with-param name="worddiv" select="$worddiv"/>
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
						<xsl:with-param name="fancybox" select="$fancybox"/>
						<xsl:with-param name="wrapper-item-a" select="$wrapper-item-a"/>
						<xsl:with-param name="wrapper-item-li" select="$wrapper-item-li"/>
						<xsl:with-param name="wrapper-item-li-a" select="$wrapper-item-li-a"/>
						<xsl:with-param name="fancybox-width" select="$fancybox-width" />
						<xsl:with-param name="fancybox-height" select="$fancybox-height" />
						<xsl:with-param name="fancybox-big-width" select="$fancybox-big-width" />
						<xsl:with-param name="fancybox-big-height" select="$fancybox-big-height" />
						<xsl:with-param name="data-name" select="$data-name" />
						<xsl:with-param name="data-zoom" select="$data-zoom" />
						<xsl:with-param name="position" select="$position+1" />
						<xsl:with-param name="gallery" select="$gallery" />
						<xsl:with-param name="nameItem" select="$nameItem" />
					    <xsl:with-param name="full" select="$full" />
                        <xsl:with-param name="element-id" select="$element-id" />
                        <xsl:with-param name="field-name" select="$field-name" />
						<xsl:with-param name="settings_catalog" select="$settings_catalog" />
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="token">
					<xsl:with-param name="token" select="$str"/>
					<xsl:with-param name="width" select="$width"/>
					<xsl:with-param name="height" select="$height"/>
					<xsl:with-param name="wrapper-item-a" select="$wrapper-item-a"/>
					<xsl:with-param name="wrapper-item-li" select="$wrapper-item-li"/>
					<xsl:with-param name="wrapper-item-li-a" select="$wrapper-item-li-a"/>
					<xsl:with-param name="fancybox-width" select="$fancybox-width" />
					<xsl:with-param name="fancybox-height" select="$fancybox-height" />
					<xsl:with-param name="fancybox-big-width" select="$fancybox-big-width" />
					<xsl:with-param name="fancybox-big-height" select="$fancybox-big-height" />
					<xsl:with-param name="data-name" select="$data-name" />
					<xsl:with-param name="data-zoom" select="$data-zoom" />
					<xsl:with-param name="position" select="$position" />
					<xsl:with-param name="gallery" select="$gallery" />
					<xsl:with-param name="nameItem" select="$nameItem" />
					<xsl:with-param name="full" select="$full" />
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
					<xsl:with-param name="settings_catalog" select="$settings_catalog" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="udata" mode="parseImageCatalog" />
	<xsl:template match="udata[items/item]" mode="parseImageCatalog">
		<xsl:param name="data-zoom" select="false()"/>
		<xsl:param name="width" select="'370'"/>
		<xsl:param name="height" select="'370'"/>
		<xsl:param name="class" select="''"/>
		<xsl:param name="settings_catalog" />
		<xsl:param name="full" select="''" />
		
		<xsl:apply-templates select="items/item[1]" mode="parseImageCatalog">
			<xsl:with-param name="data-zoom" select="$data-zoom"/>
			<xsl:with-param name="width" select="$width"/>
			<xsl:with-param name="height" select="$height"/>
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="settings_catalog" select="$settings_catalog"/>
			<xsl:with-param name="full" select="$full"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- картинка -->
	<xsl:template match="item" mode="parseImageCatalog">
		<xsl:param name="data-zoom" select="false()"/>
		<xsl:param name="width" select="'370'"/>
		<xsl:param name="height" select="'370'"/>
		<xsl:param name="class" select="''"/>
		<xsl:param name="settings_catalog" />
		<xsl:param name="full" select="''" />
		
		<xsl:variable name="path" select="@src" />
		<xsl:variable name="zoomSrc">
			<xsl:call-template name="all-thumbnail-path">
				<xsl:with-param name="width" select="'1024'" />
				<xsl:with-param name="height" select="'1024'" />
				<xsl:with-param name="path" select="$path" />
				<xsl:with-param name="full" select="'care'" />
				<xsl:with-param name="quality" select="'100'" />
				<xsl:with-param name="only-src" select="true()" />
				<xsl:with-param name="settings_catalog" select="$settings_catalog" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="all-thumbnail-path">
			<xsl:with-param name="width" select="$width" />
			<xsl:with-param name="height" select="$height" />
			<xsl:with-param name="path" select="$path" />
			<xsl:with-param name="quality" select="'100'" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="gallery-split" select="true()" />
			<xsl:with-param name="data-zoom" select="$zoomSrc" />
			<xsl:with-param name="nameItem" select="text()" />
			<xsl:with-param name="full" select="$full" />
			<xsl:with-param name="settings_catalog" select="$settings_catalog" />
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
