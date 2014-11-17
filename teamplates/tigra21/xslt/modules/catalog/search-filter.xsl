<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:umi="http://www.umi-cms.ru/TR/umi"
		xmlns:xlink="http://www.w3.org/TR/xlink">
	<xsl:template match="udata[@method = 'search' or @method = 'search_new'][group]">
		<div class="price-filter hidden-phone">
			<div class="box border-top">
				<div class="catalogFilter">
					<form class="catalog_filter" data-cat="{$document-page-id}" data-module="{$module}" data-method="{$method}" data-type-id="{@type_id}" data-lang-prefix="{$lang-prefix}">
						<div class="hgroup title">
							<select name="order_filter" id="sort-field" class="order-link">
								<option>Сортировать (по-умолчанию)</option>
								<option data-order="price" value="1">Цена (по возрастанию)</option>
								<option data-order="price" value="0">Цена (по убыванию)</option>
								<option data-order="summ_rating" value="0">Самые популярные</option>
								<option data-order="new_product" value="0">Новинки</option>
								<option data-order="name" value="1">Название</option>
							</select>
						</div>
						<xsl:apply-templates select=".//field[@name='price']" mode="search" />
						<xsl:apply-templates select=".//field[not(@name='price')]" mode="search" />
					</form>
					<script type="text/javascript" src="{$template-resources}js/libs/jquery.address-1.5.min.js"></script>
					<script type="text/javascript" src="{$template-resources}js/libs/ajaxScroll.js"></script>
					<script type="text/javascript" src="{$template-resources}js/libs/search-filter.js"></script>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'search' or @method = 'search_new'][group]" mode="mobile-version">
		<div class="menu-iphone menu-iphone-right visible-phone">
			<form class="catalog_filter" data-cat="{$document-page-id}" data-module="{$module}" data-method="{$method}" data-type-id="{@type_id}" data-lang-prefix="{$lang-prefix}">
				<xsl:apply-templates select=".//field[@name='price']" mode="search" />
				<xsl:apply-templates select=".//field[not(@name='price')]" mode="search" />
			</form>
		</div>
	</xsl:template>
	

	<xsl:template match="field" mode="search">
		<div>
			<label>
				<span>
					<xsl:value-of select="@title" />
				</span>
				<input type="text" name="fields_filter[{@name}]" value="{value}" class="textinputs" />
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="field[@data-type = 'relation' or @data-type = 'symlink']" mode="search" />
    <xsl:template match="field[@data-type = 'relation' or @data-type = 'symlink'][values/item]" mode="search">
		<div class="filters-features-block category-filter">
			<xsl:if test="count(values/item/@selected) &gt; 0"><xsl:attribute name="class">filters-features-block category-filter active</xsl:attribute></xsl:if>
			<p class="lead"><xsl:value-of select="@title" />:</p>
			<span class="close clearBtn" data-type="{@data-type}"><i class="fa fa-times"></i></span> 
			<ul class="list-none">
				<xsl:apply-templates select="values/item" mode="search-check">
					<xsl:with-param name="name_input" select="@name" />
					<xsl:with-param name="dataType" select="@data-type" />
				</xsl:apply-templates>
			 </ul>
		</div>
	</xsl:template>
	
	
	<xsl:template match="field[(@data-type = 'relation' or @data-type = 'symlink') and @name='brand']" mode="search" />
	<xsl:template match="field[(@data-type = 'relation' or @data-type = 'symlink') and @name='brand'][values/item]" mode="search">
		<div class="filters-features-block category-filter">
			<xsl:if test="count(values/item/@selected) &gt; 0"><xsl:attribute name="class">filters-features-block category-filter active</xsl:attribute></xsl:if>
			<p class="lead">Бренд:</p>
			<span class="close clearBtn" data-type="{@data-type}"><i class="fa fa-times"></i></span> 
			<ul class="list-none">
				<xsl:apply-templates select="values/item" mode="search-check">
					<xsl:with-param name="name_input" select="@name" />
					<xsl:with-param name="dataType" select="@data-type" />
				</xsl:apply-templates>
			 </ul>
		</div>
	</xsl:template>
	
	<xsl:template match="field[(@data-type = 'relation' or @data-type = 'symlink') and (@name='color' or @name='cvet')]" mode="search" />
	<xsl:template match="field[(@data-type = 'relation' or @data-type = 'symlink') and (@name='color' or @name='cvet')][values/item]" mode="search">
		<div class="filters-features-block category-filter category-filter__color">
			<xsl:if test="count(values/item/@selected) &gt; 0"><xsl:attribute name="class">filters-features-block category-filter category-filter__color active</xsl:attribute></xsl:if>
			<p class="lead">Цвет:</p>
			<span class="close clearBtn" data-type="{@data-type}"><i class="fa fa-times"></i></span> 
			<ul class="list-none">
				<xsl:apply-templates select="values/item" mode="search-check-color">
					<xsl:with-param name="name_input" select="@name" />
					<xsl:with-param name="dataType" select="@data-type" />
				</xsl:apply-templates>
			 </ul>
		</div>
	</xsl:template>
	
	
	<xsl:template match="field/values/item" mode="search">
		<option value="{@id}">
			<xsl:copy-of select="@selected" />
			<xsl:value-of select="." />
		</option>
	</xsl:template>
	
	<xsl:template match="field/values/item" mode="search-check">
		<xsl:param name="name_input" select="''" />
		<xsl:param name="dataType" select="''" />
		<li><label><input type="checkbox" name="fields_filter[{$name_input}][{position()}]" value="{@id}" class="{$dataType}_{@id}">
			<xsl:if test="@selected"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if> 
			<xsl:if test="@visible = 'hidden'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if> 
		</input>
		<span class="filters-checkbox-title"><xsl:value-of select="text()" /></span></label></li>
	</xsl:template>
	
	<xsl:template match="field/values/item" mode="search-check-color">
		<xsl:param name="name_input" select="''" />
		<xsl:param name="dataType" select="''" />
		<xsl:variable name="color" select="document(concat('uobject://', @id,'.html_color'))//value" />
		<li><label><input type="checkbox" name="fields_filter[{$name_input}][{position()}]" value="{@id}" class="{$dataType}_{@id}">
			<xsl:if test="@selected"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
			<xsl:if test="@visible = 'hidden'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if> 
		</input>
		<xsl:if test="$color"><span class="color_box" style="background: {$color};"></span></xsl:if><span class="filters-checkbox-title"><xsl:value-of select="text()" /></span></label></li>
	</xsl:template>

	<xsl:template match="field[@data-type = 'boolean']" mode="search">
		<div>
			<label>
				<input type="checkbox" name="fields_filter[{@name}]" value="1">
					<xsl:if test="checked">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<xsl:value-of select="@title" />
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="field[@data-type = 'price']" mode="search">
		<div class="filters-features-block wrapper-slider category-filter marginb0 margint10 wrapper-slider-{@name}">
			<span class="close clearBtn_{@name}"><i class="fa fa-times"></i></span>
			<xsl:variable name="price_from">
				<xsl:choose>
					<xsl:when test="value_from"><xsl:value-of select="value_from" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="min" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="price_to">
				<xsl:choose>
					<xsl:when test="value_to"><xsl:value-of select="value_to" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="max" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<input type="hidden" value="{$price_from}" data-min="{min}" name="fields_filter[{@name}][0]" class="slider_from_{@name}" title="" />
			<input type="hidden" value="{$price_to}" data-max="{max}" name="fields_filter[{@name}][1]" class="slider_to_{@name}" title=""/>
			<p class="lead margint10 marginb0">Цена:</p>
			<div class="slider_search slider_{@name}" data-name="{@name}" data-min="{min}" data-max="{max}">
				<xsl:if test="value_from"><xsl:attribute name="data-from"><xsl:value-of select="value_from" /></xsl:attribute></xsl:if>
				<xsl:if test="value_to"><xsl:attribute name="data-to"><xsl:value-of select="value_to" /></xsl:attribute></xsl:if>
				<div class="ui-slider-range"></div>
				<a href="#" class="ui-slider-handle"></a>
				<a href="#" class="ui-slider-handle"></a>
			</div>
			<p class="lead marginb0"><span class="slider-label slider-label-{@name}"><span class="begin"><xsl:value-of select="format-number($price_from, '### ###', 'price')" /></span> – <span class="end"><xsl:value-of select="format-number($price_to, '### ###', 'price')" /></span> руб.</span></p>
		</div>
		<script type="text/javascript">
			<![CDATA[
				slider = "]]><xsl:value-of select="concat('.slider_', @name)" /><![CDATA[",
				sliderFrom = "]]><xsl:value-of select="concat('.slider_from_', @name)" /><![CDATA[",
				sliderTo = "]]><xsl:value-of select="concat('.slider_to_', @name)" /><![CDATA[";
				sliderMin = "]]><xsl:value-of select="min" /><![CDATA[";
				sliderMax = "]]><xsl:value-of select="max" /><![CDATA[";
			]]>
		</script>
	</xsl:template>
	
	<xsl:template match="field[@data-type = 'int' or @data-type = 'float']" mode="search">
		<div class="filters-features-block wrapper-slider category-filter marginb0 margint10 wrapper-slider-{@name}">
			<span class="close clearBtn_{@name}"><i class="fa fa-times"></i></span>
			<xsl:variable name="price_from">
				<xsl:choose>
					<xsl:when test="value_from"><xsl:value-of select="value_from" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="min" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="price_to">
				<xsl:choose>
					<xsl:when test="value_to"><xsl:value-of select="value_to" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="max" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<input type="hidden" value="{$price_from}" data-min="{min}" name="fields_filter[{@name}][0]" class="slider_from_{@name}" title="" />
			<input type="hidden" value="{$price_to}" data-max="{max}" name="fields_filter[{@name}][1]" class="slider_to_{@name}" title=""/>
			<p class="lead margint10 marginb0"><xsl:value-of select="concat(@title, ':')" /></p>
			<div class="slider_search slider_{@name}" data-name="{@name}" data-min="{min}" data-max="{max}">
				<xsl:if test="value_from"><xsl:attribute name="data-from"><xsl:value-of select="value_from" /></xsl:attribute></xsl:if>
				<xsl:if test="value_to"><xsl:attribute name="data-to"><xsl:value-of select="value_to" /></xsl:attribute></xsl:if>
				<div class="ui-slider-range"></div>
				<a href="#" class="ui-slider-handle"></a>
				<a href="#" class="ui-slider-handle"></a>
			</div>
			<p class="lead marginb0"><span class="slider-label slider-label-{@name}"><span class="begin"><xsl:value-of select="format-number($price_from, '### ###', 'price')" /></span> – <span class="end"><xsl:value-of select="format-number($price_to, '### ###', 'price')" /></span></span></p>
		</div>
		<script type="text/javascript">
			<![CDATA[
				slider = "]]><xsl:value-of select="concat('.slider_', @name)" /><![CDATA[",
				sliderFrom = "]]><xsl:value-of select="concat('.slider_from_', @name)" /><![CDATA[",
				sliderTo = "]]><xsl:value-of select="concat('.slider_to_', @name)" /><![CDATA[";
				sliderMin = "]]><xsl:value-of select="min" /><![CDATA[";
				sliderMax = "]]><xsl:value-of select="max" /><![CDATA[";
			]]>
		</script>
	</xsl:template>
	
	<!-- для поля "общее количество, выводим чекбокс -->
	<xsl:template match="field[@data-type = 'int' and @name = 'common_quantity']" mode="search">
		<div class="filters-features-block category-filter category-filter__{@name}">
			<xsl:if test="count(values/item/@selected) &gt; 0"><xsl:attribute name="class">filters-features-block category-filter <xsl:value-of select="concat('category-filter__',@name)"/> active</xsl:attribute></xsl:if>
			<p class="lead">Наличие:</p>
			<span class="close clearBtn" data-type="{@data-type}"><i class="fa fa-times"></i></span> 
			<ul class="list-none">
				<li><label><input type="checkbox" name="fields_filter[{@name}][0]" value="1" id="{@data-type}_{@id}">
					<xsl:if test="@selected"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if> 
					<xsl:if test="@visible = 'hidden'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if> 
				</input>
				<span class="filters-checkbox-title">в наличии</span></label></li>
			 </ul>
		</div>
	</xsl:template>
</xsl:stylesheet>