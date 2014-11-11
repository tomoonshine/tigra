<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- общий шаблон для стриц "лента новостей" и "новость" -->
	<xsl:template match="result[@module='news' and  (@method='rubric' or @method='item')]" mode="main_template">
		<!-- Blog post -->
		<section class="blog_post">
			<div class="container">
				<div class="row">
					<div class="span9">
						<xsl:apply-templates select="." />
					</div>
					<div class="span3">
						  <xsl:apply-templates select="document('usel://getObject/?name_property=best_offers&amp;limit=3')/udata" mode="widget-category">
							<xsl:with-param name='title' select="'Лучшие предложения'" />
							<xsl:with-param name='class-widget' select="'widget LatestProductReviews hidden-phone'" />
						</xsl:apply-templates>
						<xsl:apply-templates select="document('usel://getObject/?name_property=new_product&amp;limit=3')/udata" mode="widget-category">
							<xsl:with-param name='title' select="'Новинки'" />
							<xsl:with-param name='class-widget' select="'widget LatestProducts hidden-phone'" />
							<xsl:with-param name='link' select="'/catalog/getObjectDiscount/?usel=new'" />
						</xsl:apply-templates>
						<!-- End class="widget LatestProducts" -->
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
					</div>

				</div>
			</div>
		</section>
    </xsl:template>
	
	<xsl:include href="news-list.xsl" />
	<xsl:include href="news-item.xsl" />
	<xsl:include href="right-column-news.xsl" />
</xsl:stylesheet>