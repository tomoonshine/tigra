<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<!-- top_menu -->
	<xsl:template match="udata[@module = 'menu' and @method = 'draw']" mode="top_menu">  
		<ul class="inline">
			<xsl:apply-templates select="item" mode="top_menu" />
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="top_menu">
		<li>
			<a href="{@link}" title="{@name}" umi:element-id="{@rel}" umi:region="row" umi:field-name="name" umi:empty="&empty-section-name;" umi:delete="delete">
				<xsl:value-of select="@name" />
			</a>	
		</li>
	</xsl:template>
	
	<xsl:template match="item[@is-active='0']" mode="top_menu" />
	
	<!-- main_menu -->
	<xsl:template match="udata[@module = 'menu' and @method = 'draw']" mode="main_menu">		
		<ul class="main-menu">
			<xsl:apply-templates select="item" mode="main_menu" />
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="main_menu">
		<li class="single-col" data-test="{count(item)}">
			<xsl:if test="items/item//item"><xsl:attribute name="class">multi-col</xsl:attribute></xsl:if>
			<a href="{@link}" title="{@name}" class="title" umi:element-id="{@rel}" ><xsl:value-of select="@name" /></a>
			<xsl:apply-templates select="items[item]" mode="sub_main_menu" />		
		</li>
	</xsl:template>
	<xsl:template match="item[@is-active='0']" mode="main_menu" />
	
	<xsl:template match="items[item]" mode="sub_main_menu">
		<div class="columns-menu"> 
			<!--<xsl:if test="@rel=112">
				<section class="popular-products span3" id="popular-products">
					<div class="lv1">Товар по акции</div>									
					<a class="pic" href="product.html">
						<span><img alt="" src="{$template-resources}images/content/catalog/thumbs/db_file_img_228_160xauto.jpg" /></span>
					</a>
					<p class="lead"><a href="product.html">Футболка</a></p>
					<div class="prices">
						 <del class="base">1300 руб</del> <span class="price">1000 руб</span></div>	
					<div class="product-dropdown">
						<a class="switcher" href="#"></a>
					</div>					
				</section>
			</xsl:if>-->
			<xsl:apply-templates select="item" mode="sub_main_menu_item">
				<xsl:with-param name="multi-col" select="true()" />
			</xsl:apply-templates>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="sub_main_menu_item">
		<xsl:param name="multi-col" select="''" />
		<ul class="span2">
			<li class="">
				<xsl:if test="$multi-col"><xsl:attribute name="class">megamenu-heading</xsl:attribute></xsl:if>
				<a href="{@link}" title="{@name}" class="title" umi:element-id="{@rel}" >
					<xsl:if test="../item/item"><xsl:attribute name="class">title lv1</xsl:attribute></xsl:if>
					<xsl:value-of select="@name" />
				</a>
				
			</li> 
			<xsl:apply-templates select="items/item" mode="sub_sub_main_menu_item" />	
		</ul>		
	</xsl:template>
	
	<xsl:template match="item" mode="sub_sub_main_menu_item">
		<li>
			<a href="{@link}" title="{@name}" class="title" umi:element-id="{@rel}" >
				<xsl:value-of select="@name" />
			</a>
			
		</li> 
		<xsl:apply-templates select="item" mode="sub_sub_main_menu_item" />		
	</xsl:template>
	
	
	<!-- bottom_menu -->
	<xsl:template match="udata[@module = 'menu' and @method = 'draw']" mode="bottom_menu">  
		<xsl:param name="block-title" select="''"/>
		<xsl:param name="block-class" select="''"/>
		
			<div class="{$block-class}">
				<h6><xsl:value-of select="$block-title"/></h6>
				<ul class="links">
					<xsl:apply-templates select="item" mode="bottom_menu" />										
				</ul>
			</div>
	</xsl:template>

	<xsl:template match="item" mode="bottom_menu">
		<li>
			<a href="{@link}" title="{@name}" umi:element-id="{@rel}">
				<xsl:value-of select="@name" />
			</a>	
		</li>
	</xsl:template>
    <xsl:template match="item[@is-active='0']" mode="bottom_menu" />
	
	
	<!-- left_menu -->
	<xsl:template match="udata[@module = 'menu' and @method = 'draw']" mode="left_menu">
		<ul class="nav nav-tabs nav-stacked">
			<xsl:apply-templates select="item" mode="left_menu" />
		</ul>
	</xsl:template>
	
	<xsl:template match="item" mode="left_menu">
		<li><xsl:if test="@id = $document-page-id"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
			<a href="{@link}" class="title" title="{@name}" umi:element-id="{@id}" umi:region="row" umi:field-name="name" umi:empty="&empty-section-name;" umi:delete="delete">
				<xsl:value-of select="@name" />
			</a>	
		</li>
	</xsl:template>
	
	<xsl:template match="item[@is-active='0']" mode="left_menu" />
	
	<!-- test menu -->
	<xsl:template match="udata[@module = 'menu' and @method = 'draw']|items" mode="test_menu">		
		<ul class="test-menu">
			<xsl:apply-templates select="item" mode="test_menu" />
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="test_menu">
		<li>
			<a href="{@link}" title="{@name}" class="title" ><xsl:value-of select="@name" /></a>
			<xsl:apply-templates select="items[item]" mode="test_menu" />		
		</li>
	</xsl:template>
	
	<xsl:template match="item[@status='active']" mode="test_menu">
		<li>
			<xsl:value-of select="@name" />
			<xsl:apply-templates select="items[item]" mode="test_menu" />		
		</li>
	</xsl:template>
	
	<!-- если страница выключена в структуре то не выводим её -->
	<xsl:template match="item[@is-active='0']" mode="test_menu" />
		
</xsl:stylesheet>