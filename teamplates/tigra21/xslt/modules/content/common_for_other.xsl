<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<!-- шаблон для главной -->
	<xsl:template match="result[page/@is-default=1][@domain!='tigra21.ru']" mode="main_template">
		<!-- Home content -->
		<section class="home">
	                                                          
			<section class="featured">
				<div class="container">
					<div class="row">
						<div class="span3">
							
							
							<!-- Категории товаров -->
							<div class="widget Categories is-default hidden-phone">
								<h3 class="widget-title widget-title ">Каталог</h3>
								<xsl:value-of select="document(concat('udata://data/GetMagazCatalog/',$domain))/udata/htmlcode" disable-output-escaping="yes" />
							</div>
				

							
							<!-- Новинки-->
							<xsl:apply-templates select="document('usel://getObject/?name_property=new_product&amp;limit=3')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Новинки'" />
                                <xsl:with-param name='class-widget' select="'widget_left  LatestProducts'" />
								<xsl:with-param name='link' select="'/catalog/getObjectDiscount/?usel=new'" />
                            </xsl:apply-templates>
							
							
							
							
							<!-- Скидки -->
							<xsl:apply-templates select="document('udata://catalog/getObjectDiscount/3/')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Скидки'" />
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
						
						<xsl:variable name="sliderId" select="document(concat('upage://',$domain,'/slider'))/udata/page/@id" />
						<div class="span6 hidden-phone">  
							<div class="row">
								<!-- Slider -->
								<!-- Выводим слайдер (mode в /modules/content/common.xsl) -->	
								<div class="span4">
									<xsl:apply-templates select="document(concat('udata://content/menu///',$sliderId,'?extProps=photo,link'))/udata" mode="slider" />
								</div>

								<!-- Акции магазинов -->
								<div class="span2">
									<xsl:apply-templates select="document(concat('udata://news/lastlist/(',$domain,'/promotionsandnews)/notemplate/2/1/?extProps=anons_pic'))/udata" mode="widget-stock" />
<!-- 									<xsl:apply-templates select="document('udata://news/lastlist/37/notemplate/2/1/?extProps=anons_pic')/udata" mode="widget-stock" /> -->
								</div>
							</div>
							<div class="span4">
							<!-- Контент -->
							<xsl:value-of select=".//property[@name = 'content']/value" disable-output-escaping="yes" />
							</div>

							<!-- вывод товаров на главной странице -->
							

							<!-- Новый вывод товаров -->
							<div id="goods_MAIN" class="span6" style="margin-left: -3px;">
								<div class="row">
									<div class="span3">
										<div class="row-fluid breadcrumb_lay hidden-phone">
											<ul class="breadcrumb pull-left">
											</ul>
										</div>
										<div><h1 id="title_MAIN">Все предложения</h1></div>
									</div>
									<div class="span3 hidden-phone">
										<div class="row-fluid catalog_toolbar">
											<div class="panel-view-item change pull-right">
												<div class="btn slab">
													<span rel="tooltip" title="" data-original-title="Вид: плиткой"><i class="fa fa-th-large"></i></span>
												</div>
												<div class="btn list act">
													<span rel="tooltip" title="" data-original-title="Вид: списком"><i class="fa fa-th-list"></i></span>
												</div>
											</div>
											<label class="pull-right slide-checkbox-wrapper item-view">
											</label>
										</div>
									</div>
								</div>
							
								<xsl:variable name="subCatalog" select="document(concat('udata://data/getSubCategoryCatalogMagaz/240/10/',$domain))/udata" />
								<ul class="product-list isotope objects list_view" id="catalog" style="position: relative; height: 3066px;">
									<xsl:value-of select="$subCatalog/htmlcode" disable-output-escaping="yes" />
									<!-- <div class="clear" /> -->
								</ul>
								
								<!-- вывод товаров -->
								<!-- <xsl:apply-templates select="document('udata://data/getProducts/240/10')/udata" mode="select_on_main_page" /> -->
								<div align="center" class="more-btn">
									<div id="selected_MAIN">Выбранно товаров: <xsl:value-of select="$subCatalog/selected"/></div>
									<div id="total_MAIN">Всего товаров: <xsl:value-of select="$subCatalog/total"/></div>
									<a onClick="LoadMoreShop();" id="more-btn" style="cursor:pointer">- - Сделать выборку ещё раз - -</a>
								</div>
							</div>
								
								

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
	
</xsl:stylesheet>