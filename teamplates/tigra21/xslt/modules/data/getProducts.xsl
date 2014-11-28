<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	
	
	<xsl:template match="udata[@method='getProducts']" mode="select_on_main_page">
		<ul class="product-list isotope objects list_view" id="catalog" style="position: relative; height: 3066px;">
			<!-- <xsl:apply-templates select="items/item" mode="select_on_main_page" /> -->
			<div class="clear" />
		</ul>
	</xsl:template>
	
	<xsl:template match="item" mode="select_on_main_page">
		
		<xsl:variable name="price" select="document(concat('udata://emarket/price/', @pageId,'//0'))/udata" />
		<xsl:variable name="object" select="document(concat('upage://', @pageId))/udata" />
		
		<li class="standard">
			<div class="image">
				<a href="{@link}" class="image-link" title="{@name}">
					<div class="image_crop_block">
						<xsl:apply-templates select="document(concat('udata://content/parseFileContent/', @pageId,'/tigra21_image_gallery'))/udata" mode="parseImageCatalog">
							<xsl:with-param name="width" select="'270'"/>
							<xsl:with-param name="height" select="'340'"/>
							<xsl:with-param name="class" select="'primary'"/>
							<xsl:with-param name="settings_catalog" select="$settings_catalog"/>
						</xsl:apply-templates>
					</div>
				</a>
				<div class="electee-wrap">
					<a href="#" class="fa fa-star-o add_electee_item" data-delete-url="/users/electee_delete/336" data-add-url="/users/electee_item/336" data-untext="Отменить" data-text="В избранное" data-id-sticky="#sticky-electee" data-placement="right" title="" data-original-title="В избранное"></a>
					<!-- <a href="/users/electee_item/336" class="fa fa-star-o add_electee_item" data-delete-url="/users/electee_delete/336" data-add-url="/users/electee_item/336" data-untext="Отменить" data-text="В избранное" data-id-sticky="#sticky-electee" data-placement="right" title="" data-original-title="В избранное"></a> -->
				</div>
			</div>
		<div class="title">
			<a href="{@link}" title="{@name}">
				<div class="prices">
					<xsl:apply-templates select="$price/price" mode="discounted-price" />
				</div>
				<h3><xsl:value-of select="@name" /></h3>
			</a>
			<div class="item_properties">
				<p>Характеристики:</p>
				<ul class="list-border">
					<li>?Бренд: Bruno Amaranti</li>
					<li>?Материал: Кожа</li>
					<li>?Цвет: Черный</li>
				</ul>
			</div>
			<div class="btn_line add_from_list btn_line_{@pageId}">
				<div class="prices">
					<xsl:apply-templates select="$price/price" mode="discounted-price" />
				</div>
				<div class="starrating goodstooltip__starrating">
					<span data-starrate="{$object//property[@name='summ_rating']/value}"  class="starlight"></span>
				</div>
				<a	href="http://{@domain}" title="{@shopName}" class="btn btn-small btn-primary button options basket_list ">
					<xsl:value-of select="@shopName" />
				</a>
				<i class="fa fa-spinner fa-spin"></i>
				
			</div>
		</div>
		</li>
	</xsl:template>
	
	
	
	
	
<!--  Старый шаблон вывода товаров

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
				<a href="http://{@domain}" title="{@shopName}">
					<h3>
						<xsl:value-of select="@shopName" />
					</h3>
				</a>
				<a href="{@link}" title="{@name}">
					<h3 umi:element-id="{@pageId}" umi:field-name="name">
						<xsl:value-of select="@name" />
					</h3>
					<div class="prices">
						<xsl:apply-templates select="$price/price" mode="discounted-price" />
					</div>
				</a>
				<div class="btn_line add_from_list btn_line_{@p}">
					<i class="fa fa-spinner fa-spin"></i>
				</div>
				<div style="margin:20px">
				</div>
			</div>
			
		</li>
	</xsl:template>
	 -->
</xsl:stylesheet>