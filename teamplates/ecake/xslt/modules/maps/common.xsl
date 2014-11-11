<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- общий шаблон для страниц типа карты -->
	<xsl:template match="result[(@module='maps' and  @method='rubric') or (page/@type-id = '129')]" mode="main_template">
		<section class="static_page_1">
			<div class="container">
				<div class="row">
					<div class="span12">
						<section class="static-page">
                            <div class="row-fluid">
								<div class="span3">
									<!-- Static page navigation -->
						            <xsl:apply-templates select="document('udata://menu/draw/687')/udata" mode="left_menu"/>
									<!-- End static page navigation -->
								</div>
								<div class="span9">
									<div class="content">
										<xsl:apply-templates select="." mode="header" />
										<xsl:apply-templates select="." />							
									</div>
								</div>
							</div>
						</section>
					</div>
				</div>
			</div>
		</section>
	</xsl:template>
	
	
	<xsl:template match="result[@module='maps' and  @method='rubric']" >

		<xsl:value-of select=".//property[@name = 'content']/value" disable-output-escaping="yes" />
		<hr />
	
		<link href="{$template-resources}css/map.css" rel="stylesheet" type="text/css" />
		
		<xsl:apply-templates select="document(concat('udata://data/getCreateForm/',141,'/notemplate/(parametry_dlya_filtracii)/'))/udata" mode="map_filter"/>
		<div class="row-fluid row-collapse">
			<div class="span4">
				<ol class="active-stores" id="td-store-locator-results">
				</ol>
			</div>
			<div class="span8">
				<div id="mapsID" style="min-width:500px;height:480px" >загрузка карты...</div>
			</div>
		</div>
		<!--
		<div class="clrfix map_common_block">
			<dl class="projects-list">
				<img class="loader" src="{$template-resources}img/loader.gif" />
				<dl class="projects-list-content">
				</dl>	
			</dl>	
			
		</div> -->
		
		<script src="http://api-maps.yandex.ru/2.0/?load=package.full&amp;mode=release&amp;lang=ru-RU" type="text/javascript" />
		<script src="{$template-resources}js/ymap.js" type="text/javascript"></script>
	</xsl:template>

	<!-- шаблоны для вывда полей для фильтра -->
	<xsl:template match="udata[@method = 'getCreateForm']" mode="map_filter" />
	<xsl:template match="udata[@method = 'getCreateForm' and //field]" mode="map_filter">
		<form class="filter grey_bg clrfix relative">
			<xsl:apply-templates select="//field[@type = 'relation']" mode="map_filter" />
			<div class="text_loader">Подождите, идет загрузка...</div>
			<div class="overlay_form" />
		</form>
	</xsl:template>
	
	<xsl:template match="field[@type = 'relation']" mode="map_filter">
		<div class="map_filter_item fn_{@name}">
			<span>
				<xsl:value-of select="@title" />
			</span>
			<select type="text" id="{@name}" name="fields_filter[{@name}]">
				<xsl:if test="@multiple = 'multiple'">
					<xsl:attribute name="multiple">multiple</xsl:attribute>
				</xsl:if>
				<option value=""><xsl:value-of select="concat('-',@title, '-')" /></option>
				
				<xsl:apply-templates select="document(concat('udata://maps/guide_list/',@type-id))/udata/item" mode="form" />
			</select>
		</div>
	</xsl:template>
  

</xsl:stylesheet>