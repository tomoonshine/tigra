<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	
	<xsl:template match="udata[@method='getProducts']" mode="select_on_main_page">
		<ul class="product-list-main isotope objects" id="catalog">
			<xsl:apply-templates select="items/item" mode="select_on_main_page" />
			<div class="clear" />
		</ul>
	</xsl:template>
	
	<xsl:template match="item" mode="select_on_main_page">
		
		<xsl:variable name="price" select="document(concat('udata://emarket/price/', @pageId,'//0'))/udata" />
		<xsl:variable name="object" select="document(concat('upage://', @pageId))/udata" />
		
		<li class="standard" umi:region="row" umi:element-id="{@pageId}">
			<div class="image">
				<a href="{@link}" class="image-link" umi:element-id="{@pageId}" title="{@name}">
					<div class="image_crop_block" style="width:170px; height: 170px">
						<img src="{@image}" width="170" class="primary" alt="{@name}" title="{@name}" />
					</div>
				</a>
			</div>
			<div class="title">
				<a href="{@link}" title="{@name}">
					<div class="prices">
						<xsl:apply-templates select="$price/price" mode="discounted-price" />
					</div>
					<h3 umi:element-id="{@pageId}" umi:field-name="name">
						<xsl:value-of select="@name" />
					</h3>
				</a>
<!-- 				<div class="item_properties">
					<p>Характеристики:</p>
					<xsl:apply-templates select="$object//group[@name = 'item_properties']" mode="item_properties">
						<xsl:with-param name="stop-position" select="'3'" />
					</xsl:apply-templates>
				</div> -->
				<div class="btn_line add_from_list btn_line_{@p}">

<!-- 					<div class="starrating goodstooltip__starrating">
						<span data-starrate="{$object//property[@name='summ_rating']/value}"  class="starlight"></span>
					</div>
					<a id="add_basket" class="btn btn-small btn-primary button options basket_list options" href="{@link}">
						<xsl:text>Купить</xsl:text>
					</a> -->
					<i class="fa fa-spinner fa-spin"></i>
				</div>
				<div style="margin:20px">
				</div>
			</div>
			
		</li>
	</xsl:template>
	
</xsl:stylesheet>