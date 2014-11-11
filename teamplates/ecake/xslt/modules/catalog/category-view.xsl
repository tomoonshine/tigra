<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:variable name="depth"><xsl:choose><xsl:when test="$settings_catalog[@name='depth']='objects'">100</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:variable>

	<!-- common for catalog category  pages -->
	<xsl:template match="result[@module='catalog' and @method='category']" mode="main_template">
		<xsl:variable name="getCategoryList" select="document(concat('udata://catalog/getCategoryList/void/', $document-page-id, '/10000/1/?extProps=photo'))/udata" />
		<!-- Category content -->
		<section class="category">
			<div class="container">
				<div class="row">
					<div class="span3">
						<!-- Sidebar -->
						<aside class="sidebar">
							<xsl:apply-templates select="document('udata://catalog/getCategoryList//36/10000/1')/udata" mode="left-column-category" />
							
							<!-- Price filter -->
							<xsl:choose>
								<xsl:when test="$settings_catalog[@name='depth']='sub_catalog' and $getCategoryList[items/item]" ></xsl:when>
								<xsl:otherwise><xsl:apply-templates select="$search-filter" /></xsl:otherwise>
							</xsl:choose>
							<!-- End class="price-filter" -->
							<xsl:apply-templates select="document('usel://getObject/?name_property=best_offers&amp;limit=3')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Лучшие предложения'" />
                                <xsl:with-param name='class-widget' select="'widget LatestProductReviews hidden-phone'" />
                            </xsl:apply-templates>
                            <xsl:apply-templates select="document('usel://getObject/?name_property=new_product&amp;limit=3')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Новинки'" />
                                <xsl:with-param name='class-widget' select="'widget LatestProducts hidden-phone'" />
                            </xsl:apply-templates>
                            <!-- End class="widget LatestProducts" -->
                            
                            <!-- Adverts -->
                            <xsl:apply-templates select="document('udata://news/lastlist/37/notemplate/2/1/?extProps=anons_pic')/udata" mode="widget-stock">
                                <xsl:with-param name='class-widget' select="'widget Productsonsale hidden-phone'" />
                            </xsl:apply-templates>
                            <!-- End class="widget Partial" -->
                            <!-- Products on Sale -->
                            <xsl:apply-templates select="document('udata://catalog/getObjectDiscount/3/')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Скидки'" />
                                <xsl:with-param name='class-widget' select="'widget Productsonsale hidden-phone'" />
								<xsl:with-param name='link' select="'/rubric/discount/'" />
                                <xsl:with-param name='get-old-price' select="true()" />
                            </xsl:apply-templates>
                             <!-- This month only! widget -->
                            <xsl:apply-templates select="$settings//property[@name='only_today']" mode="widget-category">
                                <xsl:with-param name='class-widget' select="'widget Text hidden-phone'" />
                            </xsl:apply-templates>
                            <!-- End class="widget Text" -->
							<xsl:if test="$settings_social_widget">
								<div class="widget hidden-phone">
									<xsl:value-of select="$settings_social_widget" disable-output-escaping="yes" />
								</div>
							</xsl:if>
						</aside>
						<!-- End sidebar -->
					</div>
					<div class="span9">
						<!-- Products list -->
						<xsl:choose>
							<xsl:when test="$settings_catalog[@name='depth']='sub_catalog' and $getCategoryList[items/item]">
								<div class="row">
									<div class="span6">
										<div class="row-fluid breadcrumb_lay hidden-phone">
											<xsl:apply-templates select="document('udata://core/navibar/')" />
										</div>
										<div>
											<xsl:apply-templates select="." mode="header" />
										</div>
									</div>
								</div>
								<xsl:apply-templates select="$getCategoryList" mode="view-block" />
							</xsl:when>
							<xsl:otherwise>
								<div class="row">
									<div class="span6">
										<div class="row-fluid breadcrumb_lay hidden-phone">
											<xsl:apply-templates select="document('udata://core/navibar/')" />
										</div>
										<div>
											<xsl:apply-templates select="." mode="header" />
										</div>
									</div>
									<div class="span3 hidden-phone">
										<div class="row-fluid catalog_toolbar">
											<div class="panel-view-item change pull-right">
												<div class="btn slab">
													<xsl:if test="$view_catalog='tile'"><xsl:attribute name="class">btn slab act</xsl:attribute></xsl:if>
													<span rel="tooltip" title="Вид: плиткой"><i class="fa fa-th-large"></i></span>
												</div>
												<xsl:text> </xsl:text>
												
												<div class="btn list">
													<xsl:if test="$view_catalog='list'"><xsl:attribute name="class">btn list act</xsl:attribute></xsl:if>
													<span rel="tooltip" title="Вид: списком"><i class="fa fa-th-list"></i></span>
												</div>
												
											</div>
											<label class="pull-right slide-checkbox-wrapper"><xsl:if test="$all_view = 'true' or $all_view = ''"><xsl:attribute name="class">pull-right slide-checkbox-wrapper item-view</xsl:attribute></xsl:if><span class="label-slide page-view"><i class="fa fa-ellipsis-h"></i> <span class="btline">Показать по страницам</span></span><span class="label-slide item-view">
											<i class="fa fa-ellipsis-v"></i> <span class="btline">Показать все товары</span></span>
											<input type="checkbox" class="not-styler hide {$all_view}" id="all"><xsl:if test="$all_view = 'true' or $all_view = ''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></label>
										</div> 
									</div>
								</div>
								<xsl:apply-templates select="." />
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
			</div>
		</section>
		<!-- End class="category" -->
	</xsl:template>
	
	<xsl:template match="result[(@module='catalog' and @method='getObjectDiscount') or @pageId='434']" mode="main_template">
		<script type="text/javascript" src="{$template-resources}js/libs/ajaxScroll.js"></script>
		<xsl:variable name="getCategoryList" select="document(concat('udata://catalog/getCategoryList/void/', $document-page-id, '//1/?extProps=photo'))/udata" />
		<!-- Category content -->
		<section class="category">
			<div class="container">
				<div class="row">
					<div class="span3">
						<!-- Sidebar -->
						<aside class="sidebar">
							<xsl:apply-templates select="document('udata://catalog/getCategoryList//36/10000/1')/udata" mode="left-column-category" />
							<xsl:apply-templates select="document('usel://getObject/?name_property=best_offers&amp;limit=3')/udata" mode="widget-category">
                                <xsl:with-param name='title' select="'Лучшие предложения'" />
                                <xsl:with-param name='class-widget' select="'widget LatestProductReviews hidden-phone'" />
                            </xsl:apply-templates>
							<xsl:if test="not($usel='new')">
								<xsl:apply-templates select="document('usel://getObject/?name_property=new_product&amp;limit=3')/udata" mode="widget-category">
									<xsl:with-param name='title' select="'Новинки'" />
									<xsl:with-param name='link' select="'/catalog/getObjectDiscount/?usel=new'" />
									<xsl:with-param name='class-widget' select="'widget LatestProducts hidden-phone'" />
								</xsl:apply-templates>
							</xsl:if>
                            <!-- End class="widget LatestProducts" -->
                            
                            <!-- Adverts -->
                            <xsl:apply-templates select="document('udata://news/lastlist/37/notemplate/2/1/?extProps=anons_pic')/udata" mode="widget-stock">
                                <xsl:with-param name='class-widget' select="'widget Productsonsale hidden-phone'" />
                            </xsl:apply-templates>
							<xsl:if test="not(@pageId='5642') or $usel">
								<!-- End class="widget Partial" -->
								 <xsl:apply-templates select="document('udata://catalog/getObjectDiscount/3/')/udata" mode="widget-category">
									<xsl:with-param name='title' select="'Скидки'" />
									<xsl:with-param name='link' select="'/rubric/discount/'" />
									<xsl:with-param name='class-widget' select="'widget Productsonsale hidden-phone'" />
									<xsl:with-param name='get-old-price' select="true()" />
								</xsl:apply-templates>
							</xsl:if>
						   
                             <!-- This month only! widget -->
                            <xsl:apply-templates select="$settings//property[@name='only_today']" mode="widget-category">
                                <xsl:with-param name='class-widget' select="'widget Text hidden-phone'" />
                            </xsl:apply-templates>
                            <!-- End class="widget Text" -->
							<xsl:if test="$settings_social_widget">
								<div class="widget hidden-phone">
									<xsl:value-of select="$settings_social_widget" disable-output-escaping="yes" />
								</div>
							</xsl:if>
						</aside>
						<!-- End sidebar -->
					</div>
					<div class="span9">
						<!-- Products list -->
						<div class="row">
							<div class="span6">
								<div class="row-fluid breadcrumb_lay">
									<xsl:apply-templates select="document('udata://core/navibar/')" />
								</div>
								<div>
									<xsl:choose>
										<xsl:when test="$usel='new'"><h1>Новинки</h1></xsl:when>
										<xsl:otherwise><xsl:apply-templates select="." mode="header" /></xsl:otherwise>
									</xsl:choose>
								</div>
							</div>
							<div class="span3 hidden-phone">
								<div class="row-fluid catalog_toolbar">
									<div class="panel-view-item change pull-right">
										<div class="btn slab">
											<xsl:if test="$view_catalog='tile'"><xsl:attribute name="class">btn slab act</xsl:attribute></xsl:if>
											<span rel="tooltip" title="Вид: плиткой"><i class="fa fa-th-large"></i></span>
										</div>
										<xsl:text> </xsl:text>
										
										<div class="btn list">
											<xsl:if test="$view_catalog='list'"><xsl:attribute name="class">btn list act</xsl:attribute></xsl:if>
											<span rel="tooltip" title="Вид: списком"><i class="fa fa-th-list"></i></span>
										</div>
										
									</div>
									<label class="pull-right slide-checkbox-wrapper"><xsl:if test="$all_view = 'true' or $all_view = ''"><xsl:attribute name="class">pull-right slide-checkbox-wrapper item-view</xsl:attribute></xsl:if><span class="label-slide page-view">Показать по страницам</span><span class="label-slide item-view">Показать все товары</span>
									<input type="checkbox" class="not-styler hide {$all_view}" id="all"><xsl:if test="$all_view = 'true' or $all_view = ''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></label>
								</div> 
							</div>
						</div>
						<xsl:choose>
							<xsl:when test="$usel='new'">
								<xsl:apply-templates select="document('usel://getObject/?name_property=new_product&amp;limit=6')/udata" />
							</xsl:when>
							<xsl:otherwise><xsl:apply-templates select="document('udata://catalog/getObjectDiscount/')/udata" /></xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
			</div>
		</section>
		<!-- End class="category" -->
	</xsl:template>
	
	
	<xsl:template match="/result[@method = 'category']">
		<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListAmount//', page/@id, '///',$depth,'/'))/udata" />
		<xsl:value-of select=".//property[@name = 'descr']/value" disable-output-escaping="yes" />
	</xsl:template>

	<xsl:template match="/result[@method = 'category'][count(/result/parents/page) = 1]">
		<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListAmount//', page/@id, '///',$depth,'/'))/udata" />
		<xsl:value-of select=".//property[@name = 'descr']/value" disable-output-escaping="yes" />
	</xsl:template>

	<xsl:template match="/result[@method = 'category'][count(/result/parents/page) &gt; 1]">
		<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListAmount//', page/@id, '///',$depth,'/'))" />
		<xsl:value-of select=".//property[@name = 'descr']/value" disable-output-escaping="yes" />
	</xsl:template>

	<xsl:template match="udata[@method = 'getObjectsList' or @method = 'getObjectsListAmount']">
		<xsl:apply-templates select="document('udata://catalog/search')" />
		<div class="catalog" umi:element-id="{category_id}" umi:module="catalog" umi:method="getObjectsListAmount" umi:sortable="sortable" umi:add-method="popup">
			<xsl:text>&empty-category;</xsl:text>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getObjectsList'  or @method = 'getObjectsListAmount' ][total]">
			<ul class="product-list isotope objects" umi:element-id="{category_id}" umi:module="catalog" umi:method="getObjectsListAmount" umi:sortable="sortable" id="catalog">
			    <xsl:if test="$view_catalog='list'"><xsl:attribute name="class">product-list isotope objects list_view</xsl:attribute></xsl:if>
				<xsl:apply-templates select="lines/item" mode="short-view">
					<xsl:with-param name="cart_items" select="$cart/items" />
				</xsl:apply-templates>
				<div class="clear" />
			</ul>
		
		<xsl:apply-templates select="total">
			<xsl:with-param name="method-numpages" select="@method" />
			<xsl:with-param name="module-numpages" select="@module" />
			<xsl:with-param name="page-id" select="category_id" />
			<xsl:with-param name="lang-prefix" select="$lang-prefix" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getObject']">
		<ul class="product-list isotope objects" umi:element-id="{category_id}" umi:module="catalog" umi:method="getObjectsListAmount" umi:sortable="sortable" id="catalog">
			<xsl:if test="$view_catalog='list'"><xsl:attribute name="class">product-list isotope objects list_view</xsl:attribute></xsl:if>
			<xsl:apply-templates select="page" mode="short-view">
				<xsl:with-param name="cart_items" select="$cart/items" />
			</xsl:apply-templates>
			<div class="clear" />
		</ul>
		
		<xsl:apply-templates select="total" />
	</xsl:template>
	
	<xsl:template match="udata" mode="special-offers" />
	<xsl:template match="udata[page]" mode="special-offers">
		<ul class="product-list isotope objects" id="catalog">
			<xsl:apply-templates select="page" mode="short-view">
				<xsl:with-param name="cart_items" select="$cart/items" />
			</xsl:apply-templates>
			<div class="clear" />
		</ul>
	</xsl:template>
	
	<xsl:template match="udata" mode="widget-category" />
    <xsl:template match="udata[page]" mode="widget-category">
        <xsl:param name="title" select="''" />
        <xsl:param name="class-widget" select="'widget'" />
        <xsl:param name="link" select="'#'" />
        <div class="{$class-widget}">
            <h3 class="widget-title widget-title "><a href="{$link}"><xsl:value-of select="$title" /></a></h3>
            <ul class="product-list-small">
                <xsl:apply-templates select="page" mode="short-view-widget">
                    <xsl:with-param name="cart_items" select="$cart/items" />
                </xsl:apply-templates>
            </ul>
         </div>
    </xsl:template>
    
    <xsl:template match="udata[lines/item]" mode="widget-category">
        <xsl:param name="title" select="''" />
        <xsl:param name="class-widget" select="'widget'" />
		<xsl:param name="link" select="'#'" />
        <div class="{$class-widget}">
            <h3 class="widget-title widget-title "><a href="{$link}"><xsl:value-of select="$title" /></a></h3>
            <ul class="product-list-small">
                <xsl:apply-templates select="lines/item" mode="short-view-widget">
                    <xsl:with-param name="cart_items" select="$cart/items" />
                </xsl:apply-templates>
            </ul>
         </div>
    </xsl:template>
	
	<xsl:template match="udata[@method = 'getObjectDiscount']" priority="1">
			<ul class="product-list isotope objects" umi:element-id="{category_id}" umi:module="catalog" umi:method="getObjectsListAmount" umi:sortable="sortable" id="catalog">
			    <xsl:if test="$view_catalog='list'"><xsl:attribute name="class">product-list isotope objects list_view</xsl:attribute></xsl:if>
				<xsl:apply-templates select="lines/item" mode="short-view">
					<xsl:with-param name="cart_items" select="$cart/items" />
				</xsl:apply-templates>
				<div class="clear" />
			</ul>
		<xsl:apply-templates select="total" />
	</xsl:template>
	
	<xsl:template match="udata[@method = 'sortArrayRand']" mode="recommended_items" />
	<xsl:template match="udata[@method = 'sortArrayRand'][page]" mode="recommended_items">
			<section class="product-related">
				<div class="container">
					<div class="span12">
						<h2>Товары из этой категории</h2>
						<ul class="product-list isotope objects" id="catalog">
							<xsl:apply-templates select="page" mode="short-view">
								<xsl:with-param name="cart_items" select="$cart/items" />
							</xsl:apply-templates>
							<div class="clear" />
						</ul>
					</div>
				</div>
			</section>
	</xsl:template>
</xsl:stylesheet>