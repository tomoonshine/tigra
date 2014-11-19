<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	
	<!-- common for simple pages -->
	<xsl:template match="result" mode="main_template">
		<section class="static_page_1">
			<div class="container">
				<div class="row">
					<div class="span12">
						<section class="static-page">
                            <div class="row-fluid">
								<div class="content">
									<xsl:apply-templates select="." mode="header" />
									<xsl:apply-templates select="." />			
								</div>
							</div>
						</section>
					</div>
				</div>
			</div>
		</section>
	</xsl:template>

	<!-- шаблон для главной -->
	<xsl:template match="result[page/@is-default=1]" mode="main_template">
		<!-- Home content -->
		<section class="home">
	                                                          
			<section class="featured">
				<div class="container">
					<div class="row">
						<div class="span3">
							
							
							<!-- Categories widget -->
							<xsl:apply-templates select="document('udata://catalog/getCategoryList//36/100/1')/udata" mode="left-column-main" />
							<xsl:apply-templates select="document('udata://data/getSubCategory/199')/udata" mode="left-column-main" />
							
							
							<!-- <xsl:apply-templates select="document('usel://getObject/?name_property=best_offers&amp;limit=3')/udata" mode="widget-category">
							    <xsl:with-param name='title' select="'Лучшие предложения'" />
							    <xsl:with-param name='class-widget' select="'widget LatestProductReviews visible-phone'" />
							</xsl:apply-templates> -->
							

							
							<!-- Новинки-->
							<xsl:apply-templates select="document('usel://getObject/?name_property=new_product&amp;limit=3')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Новинки магазинов'" />
                                <xsl:with-param name='class-widget' select="'widget_left  LatestProducts'" />
								<xsl:with-param name='link' select="'/catalog/getObjectDiscount/?usel=new'" />
                            </xsl:apply-templates>
							
							
							
							
							<!-- Скидки -->
							<xsl:apply-templates select="document('udata://catalog/getObjectDiscount/3/')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Скидки магазинов'" />
                                <xsl:with-param name='class-widget' select="'widget_left Productsonsale'" />
								<xsl:with-param name='link' select="'/rubric/discount/'" />
                                <xsl:with-param name='get-old-price' select="true()" />
                            </xsl:apply-templates>
							
							<xsl:if test="$settings_social_widget">
								<div class="widget hidden-phone">
									<xsl:value-of select="$settings_social_widget" disable-output-escaping="yes" />
								</div>
							</xsl:if>
						</div>
						
						<div class="span6 hidden-phone">  
							<div class="row">
								<!-- Slider -->
								<!-- Выводим слайдер (mode в /modules/content/common.xsl) -->	
								<div class="span4">
									<xsl:apply-templates select="document('udata://content/menu///285?extProps=photo,link')/udata" mode="slider" />
								</div>

								<!-- Акции магазинов -->
								<div class="span2">
									<xsl:apply-templates select="document('udata://news/lastlist/37/notemplate/2/1/?extProps=anons_pic')/udata" mode="widget-stock" />
								</div>
							</div>
							
							

							<!-- вывод товаров на главной странице -->
							<div id="query"></div>
							<xsl:apply-templates select="document('usel://getObject/?name_property=best_offers&amp;limit=12')/udata" mode="special-offers" />

							<!-- Контент -->
							<xsl:value-of select=".//property[@name = 'content']/value" disable-output-escaping="yes" />
						</div>
						
						<!-- Правая панель (рекламные банеры, Только сегодня) -->
						<div class="span3">
							
							<div class="widget_right Productsonsale">
							<!-- Рекламные банеры -->
								<h3 class="widget-title widget-title ">Рекламные баннеры</h3>
								<ul class="adverts">
									<li>
										<xsl:apply-templates select="$settings//property[@name='img_1']" mode="widget-category-img1"/>
									</li>
									<li>
										<xsl:apply-templates select="$settings//property[@name='img_2']" mode="widget-category-img2"/>
									</li>
									<li>
										<xsl:apply-templates select="$settings//property[@name='img_3']" mode="widget-category-img3"/>
									</li>
								</ul>
							</div>
			
							<!-- Тлько сегодня -->
							<xsl:apply-templates select="$settings//property[@name='only_today']" mode="widget-category" />
							
						</div>
						
					</div>	
				</div>
			</section>	

			<!-- Promos -->
				<section class="promos hidden-phone">
					<div class="container">
						<div class="row">
								<xsl:apply-templates select="$settings//property[@name='info_block_1']" mode="widget-category-info"/>
								<xsl:apply-templates select="$settings//property[@name='info_block_2']" mode="widget-category-info"/>
								<xsl:apply-templates select="$settings//property[@name='info_block_3']" mode="widget-category-info"/>
						</div>
					</div>
				</section>
			<!-- End class="promos" --> 
		</section>
		<!-- End class="home" -->
		
	</xsl:template>
	
	
	<xsl:template match="result[@module = 'content']">
		<div umi:element-id="{$document-page-id}" umi:field-name="content" umi:empty="&empty-page-content;">
			<xsl:value-of select=".//property[@name = 'content']/value" disable-output-escaping="yes" />
		</div>
	</xsl:template>
	
	<xsl:template match="result" mode="header">
		<h1>
			<xsl:value-of select="@header" />
		</h1>
	</xsl:template>
	
	<xsl:template match="result[@pageId]" mode="header">
		<h1 umi:element-id="{@pageId}" umi:field-name="h1" umi:empty="&empty-page-name;">
			<xsl:value-of select="@header" />
		</h1>
	</xsl:template>

	<!--  Slider  -->
    <xsl:template match="udata[@method = 'menu'][items/item]" mode="slider">
         <section class="slider-top hidden-phone">
				<div class="fotorama" data-transition="crossfade" data-arrows="true" data-click="false" data-autoplay="true" data-loop="true" data-fit="cover">
                    <xsl:apply-templates select="items/item" mode="slider" />
                </div>
        </section>
    </xsl:template>

    <xsl:template match="item" mode="slider">
		<div data-img="{.//property[@name = 'photo']/value}">
			<a href="{.//property[@name = 'link']/value}"></a>
		</div>
    </xsl:template>
    
    <xsl:template match="result[@module = 'content' and (page/@type-id = '129')]">
        <div umi:element-id="{$document-page-id}" umi:field-name="content" umi:empty="&empty-page-content;">
            <xsl:value-of select=".//property[@name = 'content']/value" disable-output-escaping="yes" />
        </div>
        <hr />
        <xsl:apply-templates select=".//property[@name = 'address']" mode="maps" />
        <div class="row-fluid">
            <xsl:apply-templates select=".//property[@name = 'address']" mode="contact_property" />
            <xsl:apply-templates select=".//property[@name = 'call_us']" mode="contact_property" />
            <xsl:apply-templates select=".//property[@name = 'support']" mode="contact_property" />
        </div>
        <h6>Напишите нам:</h6>
        <xsl:apply-templates select="document('udata://webforms/add/146')/udata" />
    </xsl:template>
    
    <xsl:template match="property" mode="contact_property" />
    <xsl:template match="property[@name = 'address' or @name = 'call_us' or @name = 'support']" mode="contact_property" />
    <xsl:template match="property[@name = 'address'][value]" mode="contact_property">
        <div class="span4">
            <h5><i class="fa fa-map-marker fa-lg pd-rt"></i> <xsl:value-of select="title" /></h5>
            <div umi:element-id="{$document-page-id}" umi:field-name="{@name}" umi:empty="&empty-page-content;">
                <xsl:value-of select="value" disable-output-escaping="yes" />
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="property[@name = 'call_us']" mode="contact_property">
        <div class="span4">
            <h5><i class="fa fa-phone fa-lg pd-rt"></i> <xsl:value-of select="title" /></h5>
            <div umi:element-id="{$document-page-id}" umi:field-name="{@name}" umi:empty="&empty-page-content;">
                <xsl:value-of select="value" disable-output-escaping="yes" />
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="property[@name = 'support']" mode="contact_property">
        <div class="span4">
            <h5><i class="fa fa-medkit fa-lg pd-rt"></i> <xsl:value-of select="title" /></h5>
            <div umi:element-id="{$document-page-id}" umi:field-name="{@name}" umi:empty="&empty-page-content;">
                <xsl:value-of select="value" disable-output-escaping="yes" />
            </div>
        </div>
    </xsl:template>
    <xsl:template match="property" mode="maps"/>
    <xsl:template match="property[@name = 'address']" mode="maps" />
    <xsl:template match="property[@name = 'address'][value]" mode="maps">
        <div id="maps" data-yandex-value="{value}" style="width: 100%;height: 320px;">Загрузка карты...</div>
        <hr />
        <script src="http://api-maps.yandex.ru/2.0/?load=package.full&amp;mode=release&amp;lang=ru-RU" type="text/javascript" />
        <script src="{$template-resources}js/ymapOne.js" type="text/javascript"></script>
    </xsl:template>
    
    <xsl:template match="property" mode="widget-category" />
    <xsl:template match="property[value]" mode="widget-category">
        <!-- <div class="{$class-widget}"> -->
		<div class="widget_right">
            <h3 class="widget-title widget-title"><xsl:value-of select="title" /></h3>
            <xsl:value-of select="value" disable-output-escaping="yes" />
        </div>
    </xsl:template>

    <xsl:template match="property" mode="widget-category-info" />
    <xsl:template match="property[value]" mode="widget-category-info">
    	<div class="span4">
	    	<div class="box border-top">
				<xsl:value-of select="value" disable-output-escaping="yes" />
			</div>  
		</div>  
    </xsl:template>

    <xsl:template match="property" mode="widget-category-img1" />
    <xsl:template match="property[value]" mode="widget-category-img1">
    	<a class="advert" href="{$settings//property[@name = 'link_to_img_1']/value}">
    		<img src="{value}" class="super_img" width="220" />
		</a>  
    </xsl:template>

    <xsl:template match="property" mode="widget-category-img2" />
    <xsl:template match="property[value]" mode="widget-category-img2">
    	<a class="advert" href="{$settings//property[@name = 'link_to_img_2']/value}">
    		<img src="{value}" class="super_img" width="220" />
		</a>  
    </xsl:template>

    <xsl:template match="property" mode="widget-category-img3" />
    <xsl:template match="property[value]" mode="widget-category-img3">
    	<a class="advert" href="{$settings//property[@name = 'link_to_img_3']/value}">
    		<img src="{value}" class="super_img" width="220" />
		</a>  
    </xsl:template>
    
    <xsl:template match="udata" mode="settings_social" />
    <xsl:template match="udata[items/item]" mode="settings_social">
        <!-- Social icons -->
        <div class="social">
            <h6>Мы в соц. сетях</h6>
            <ul class="social-icons">
                <xsl:apply-templates select="items/item" mode="settings_social" />
            </ul>
        </div>
        <!-- End class="social" -->
    </xsl:template>
    
    <xsl:template match="item" mode="settings_social" />
    <xsl:template match="item[@url]" mode="settings_social">
        <li>
            <a class="" href="{@url}" title="{@name}" target="_blank"><xsl:value-of select="@name" /></a>
        </li>
    </xsl:template>
	
    <xsl:template match="item[@ico and @url]" mode="settings_social">
        <li>
            <a class="" href="{@url}" title="{@name}" target="_blank">
				<img src="{@ico}" alt="{@name}" title="{@name}" width="24" height="24" />
			</a>                       
        </li>
    </xsl:template>
	
	<xsl:template match="item" mode="footer-pay">
		<div class="confidence">
			<h6>Способы оплаты</h6>
			<img src="{text()}" alt="tigra21" />
		</div>
	</xsl:template>
	
	<xsl:template match="result[.//property/@name='menu_sidebar']" mode="main_template">
		<section class="static_page_1">
			<div class="container">
				<div class="row">
					<div class="span12">
						<section class="static-page">
                            <div class="row-fluid">
								<div class="span3">
									<!-- Static page navigation -->
						              <xsl:apply-templates select=".//property[@name='menu_sidebar']" mode="left_menu"/>
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
	
	<xsl:template match="property[@name='menu_sidebar']" mode="left_menu">
		<xsl:apply-templates select="document(concat('udata://menu/draw/', value/item[1]/@id ))/udata" mode="left_menu"/>
	</xsl:template>

	<xsl:include href="404.xsl" />
	<xsl:include href="recentPages.xsl" />
	<xsl:include href="sticky.xsl" />

	<!-- Модуль используеться для разработки -->
	<xsl:include href="test.xsl" />
	
	
</xsl:stylesheet>