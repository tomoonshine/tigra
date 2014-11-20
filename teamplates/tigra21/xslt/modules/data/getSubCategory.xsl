<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<!-- шаблон выводит категории товаров на главной странице-->
	<xsl:template match="udata[@method = 'getSubCategory']" mode="left-column-main">
	
			<script>
			var htmlDecode = function (value) { 
				return $('<div/>').html(value).text(); 
			} 
				function getCatalog(category,amount) {
					jQuery.ajax({
						url     : 'udata/data/getSubCategoryCatalog/'+category+'/'+amount,
						type    : 'GET',
						async	: false,
						dataType: 'xml',
						success  : outCatalog
					});
				}
				
				function outCatalog(data) {
					var htmlcode = data.getElementsByTagName('htmlcode')[0].innerHTML;
					document.getElementById('catalog').innerHTML = htmlDecode(htmlcode);
				}
				
				var oldActive_link;
				function changeActive(elm) {
					if(oldActive_link) oldActive_link.className = 'title';
					elm.className = 'active_link';
					oldActive_link = elm;
				}
			</script>

		
		<div class="widget Categories is-default hidden-phone">
			<h3 class="widget-title widget-title ">Каталог</h3>
			<ul class="category-list secondary">
				<xsl:apply-templates select="items/item" mode="left-column-main" />
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getSubCategory']//item" mode="left-column-main">
		<xsl:variable name="sub-item" select="document(concat('udata://data/getSubCategory/', @id))/udata" />
		<li>
			<a title="{@name}"  class="title"  onClick="changeActive(this);getCatalog({@id},10)"> 
				<xsl:value-of select="@name" />
				<xsl:if test="$sub-item/items/item">
					<i class="fa fa-chevron-down"></i>
				</xsl:if>
			</a>
			<xsl:apply-templates select="$sub-item" mode="left-column-main-submenu" />
		</li>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getSubCategory']" mode="left-column-main-submenu" />
	<xsl:template match="udata[@method = 'getSubCategory'][items/item]" mode="left-column-main-submenu">
		<ul class="sub-menu">
			<xsl:apply-templates select="items/item" mode="left-column-main" />
		</ul>
	</xsl:template>
	
	
	
	<!-- шаблон выводит категории товаров -->
	<xsl:template match="udata[@method='getSubCategory']" mode="left-column-main?????">
		<div class="children hidden-phone">
			<div class="box border-top paddingb0">
				<div class="hgroup title toggle-menu">
<!-- 				<xsl:if test="not($sub_items/items/item)">
					<xsl:attribute name="class">hgroup title toggle-menu main-up</xsl:attribute>
				</xsl:if> -->
					<h3>
					<div class="f_right catalog_open"><span class="all">весь каталог</span><span class="hide-all">свернуть</span>
					</div>Каталог</h3>
					<div class="clearfix"></div>
				</div>
				<div class="wrapper-category-list">
					<ul class="category-list secondary" umi:button-position="bottom left" umi:element-id="{@category-id}" umi:region="list" umi:module="catalog" umi:sortable="sortable">
						<!-- <xsl:if test="not($sub_items/items/item)">
							<xsl:attribute name="style">display: none</xsl:attribute>
							<xsl:attribute name="class">category-list secondary hideBlock</xsl:attribute>
						</xsl:if> -->
				
						<!-- <xsl:apply-templates select="items/item" mode="left-column-main" /> -->
					</ul>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>