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
							<!-- старый шаблон категорий -->
							<!-- <xsl:apply-templates select="document('udata://catalog/getCategoryList//36/100/1')/udata" mode="left-column-main" /> -->
							<!-- новый шаблон категорий -->
							<!-- <xsl:apply-templates select="document('udata://data/getSubCategory/240')/udata" mode="left-column-main" /> -->
							<div class="widget Categories is-default hidden-phone">
								<h3 class="widget-title widget-title ">Каталог</h3>
								<xsl:value-of select="document(concat('udata://data/GetMagazCatalog/',$domain))/udata/htmlcode" disable-output-escaping="yes" />
<!-- 								<div id ="categoryList">
									<div href="" onClick="getCategoryList('{$domain}')" >asdasd</div>
								</div> -->
							</div>
<!-- 							<script>
								function on(sdf) {
								alert(sdf);	
								getCategoryList(sdf);
								}
								on('<xsl:value-of select="$domain" />');
								
							</script> -->
<!-- 								getCategoryList("<xsl:value-of select="$domain" />"); -->						
							
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
									<xsl:apply-templates select="document(concat('udata://news/lastlist/(',$domain,'/promotionsandnews)/notemplate/2/1/?extProps=anons_pic'))/udata" mode="widget-stock" />
<!-- 									<xsl:apply-templates select="document('udata://news/lastlist/37/notemplate/2/1/?extProps=anons_pic')/udata" mode="widget-stock" /> -->
								</div>
							</div>
							
							

							<!-- вывод товаров на главной странице -->
							
							<div id="query"></div> <!-- это надо для фотографий чтобы увеличивались -->
							
							<!-- старый шаблон вывода товаров -->
							<!-- <xsl:apply-templates select="document('usel://getObject/?name_property=best_offers&amp;limit=12')/udata" mode="special-offers" /> -->
							
							<!-- наша новая выборка из магазинов random-->
							<!-- <xsl:apply-templates select="document('udata://data/getProducts/240/10')/udata" mode="select_on_main_page" /> -->
								<ul class="product-list-main isotope objects" id="catalog">
									<xsl:value-of select="document(concat('udata://data/getSubCategoryCatalogMagaz/240/10/',$domain))/udata/htmlcode" disable-output-escaping="yes" />
								</ul>
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
	
</xsl:stylesheet>