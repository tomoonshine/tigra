<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:umi="http://www.umi-cms.ru/TR/umi"
				xmlns:xlink="http://www.w3.org/TR/xlink">

	<xsl:template match="/" mode="layout">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
		
		<html dir="ltr" lang="en" class="no-js">
			<head>
				<meta charset="UTF-8"/>
				<meta name="keywords" content="{//meta/keywords}" />
				<meta name="description" content="{//meta/description}" />
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<title><xsl:value-of select="$document-title" /></title>
				
				<xsl:if test="$settings_site[@name='favicon_image']">
					<link rel="icon" href="{$settings_site[@name='favicon_image']}" type="image/x-icon" />
				</xsl:if>

				<link rel="canonical" href="http://{concat(result/@domain, result/@request-uri)}" />

				<!-- BEGIN CSS -->
				<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/2.3.1/css/bootstrap.min.css" />
				<link rel="stylesheet" href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-responsive.min.css" />
				<link rel="stylesheet" type="text/css" href="{$template-resources}css/theme.css" />
				<link rel="stylesheet" type="text/css" href="{$template-resources}css/bem_common.css" />
				<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet" />
				<link href="{$template-resources}plugin/fotorama-4.5.1/fotorama.css" rel="stylesheet" />
				<link rel="stylesheet" type="text/css" href="{$template-resources}js/fancybox/jquery.fancybox.css" />
				<link rel="stylesheet" type="text/css" href="{$template-resources}plugin/tigra21-tinymse/tigra21.plugin.css" />
				<!-- END CSS -->
				
				<xsl:value-of select="document('udata://system/includeQuickEditJs')/udata" disable-output-escaping="yes" />
				<xsl:if test="$user-type='sv'">
				    <script src="/styles/common/js/compressed.js" type="text/javascript"></script>
				    <script src="{$template-resources}js/admin/umi-eip.custom.js" type="text/javascript"></script>
				    <script type="text/javascript" src="/styles/skins/mac/design/js/custom.events.upload-photo.js"></script>
				</xsl:if>

				
			</head>
			<body class="">
				<xsl:if test="$settings_cart[@name='viewCart']='bottom'"><xsl:attribute name="class">basket_small_bottom</xsl:attribute></xsl:if>
				<!-- for iPhone -->
					<input type="checkbox" class="not-styler hidden-phone hidden-tablet hidden-desktop" id="menu-left" />
					<input type="checkbox" class="not-styler hidden-phone hidden-tablet hidden-desktop" id="menu-right" />
					<div class="top visible-phone">
						<div class="clearfix">
							<div class="pull-left">
								<label for="menu-left">
									<span class="btn btn-navbar">
										<i class="fa fa-bars fa-fw"></i> Каталог
									</span>
								</label>
							</div>
							<xsl:if test="$method='category'">
								<div class="pull-right text-right">
									<label for="menu-right">
										<span class="btn btn-navbar">
											Фильтр <i class="fa fa-filter"></i> 
										</span>
									</label>
								</div>
							</xsl:if>
							<div class="pull-center text-center">
								<a href="/" title="&larr; На главную">
									<xsl:if test="$settings_site[@name='logo_site']">
										<img src="{$settings_site[@name='logo_site']/text()}" height="28"><xsl:attribute name="alt"><xsl:choose><xsl:when test="$settings_site[@name='alt_logo_site']"><xsl:value-of select="$settings_site[@name='alt_logo_site']/text()" /></xsl:when><xsl:otherwise>tigra21</xsl:otherwise></xsl:choose></xsl:attribute></img>
									</xsl:if>
								</a>
							</div>
						</div>
					</div>
					<div class="menu-iphone menu-iphone-left visible-phone">
						<ul>
							<xsl:apply-templates select="document('udata://catalog/getCategoryList//36/100/1')//item" mode="left-column-main"/>
						</ul>
					</div>
					<xsl:if test="$method='category'">
						<xsl:apply-templates select="$search-filter" mode="mobile-version" />
					</xsl:if>
				<!-- End -->
				<div class="wrapper">
					<!-- Header -->
					<div class="header hidden-phone">
						<!-- Top bar -->
						<div class="top">
							<div class="container">
								<div class="row">
									<div class="span8">
										<xsl:apply-templates select="document('udata://menu/draw/687')/udata" mode="top_menu"/>
									</div>
									<xsl:apply-templates select="/result/user" />
								</div>
							</div>
						</div>
						<!-- End class="top" -->

						<!-- Logo & Search bar -->
						<div class="bottom">
							<div class="container">
								<div class="row">
									<div class="span2">							
										<div class="logo">
											<a href="/" title="&larr; На главную">
											    <xsl:if test="$settings_site[@name='logo_site']">
												    <img src="{$settings_site[@name='logo_site']/text()}">
														<xsl:attribute name="alt">
															<xsl:choose>
																<xsl:when test="$settings_site[@name='alt_logo_site']">
																	<xsl:value-of select="$settings_site[@name='alt_logo_site']/text()" />
																</xsl:when>
																<xsl:otherwise>tigra21</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
													</img>
												</xsl:if>
											</a>
										</div>
									</div>

	<!-- контакты -->
									<div class="span3">
										<div class="phone-header">Портал Магазинов Города</div>
										<div class="address">РФ, Республика Чувашия, г. Чебоксары</div>
									 </div>
	<!-- поиск -->													
									<div class="span7">
										<div class="row-fluid">
											<div class="span12">
												<xsl:call-template name="search-form-new" />
											</div>
										</div>
									</div>
									
								</div>
							</div>
						</div>
						<!-- End class="bottom" -->
					</div>
					<!-- End class="header" -->            
					<!-- Navigation -->
					<nav class="navigation hidden-phone">
						<div class="container">
							<div class="row">
								<div class="span12">
									<div class="hidden-phone">
										<!-- Main menu (desktop) -->
										<xsl:apply-templates select="document('udata://menu/draw/764')/udata" mode="main_menu"/>
										<!-- End class="main-menu" -->
									</div>
								</div>

								<div class="span3 visible-desktop">
								</div>
							</div>
						</div>
					</nav>
					<!-- End class="navigation" -->


					<!-- Content section -->		
					<section class="main">
						<xsl:apply-templates select="result" mode="main_template"/>
					</section>
					<!-- End class="main" -->

					<!-- Footer -->
					<div class="footer hidden-phone">
						<div class="container">
							<div class="row">	
								<div class="social span4">	
									<xsl:apply-templates select="$settings_social" mode="settings_social" />
								</div>
								<div class="span4">							
									<div class="phone-header">
										<xsl:value-of select="$settings_contact[@name='phone']" />
									</div>
									<div class="address">
										<xsl:value-of select="$settings_contact[@name='address']" />
										<xsl:value-of select="$settings_contact[@name='mode-works']" />
									</div>
								</div>
								<div class="span4">				
									<!-- Newsletter subscription -->
									<xsl:apply-templates select="document('udata://dispatches/subscribe/')/udata" mode="subscribe-footer" />
								</div>
								
						</div>
							<a href="/admin"><i class="fa fa-lock fa-lg"></i></a>
					</div>
				</div>

					<!-- End id="footer" -->

					<!-- Credits bar -->
					<div class="credits">
						<div class="container">
							<div class="row">
								<div class="span8">
									<p>Copyright <xsl:value-of select="document('udata://system/convertDate/now/(Y)')/udata" />.<xsl:text> </xsl:text><xsl:value-of select="$settings_contact[@name='copyright']" /></p>
								</div>
								<div class="span4 text-right hidden-phone">
									<p>Разработка портала <a href="http://webvideomarket.ru/" target="_blank">"webvideomarket.ru"</a></p>
								</div>
							</div>
						</div>
					</div>
					<!-- End class="credits" -->                        
					<!-- Newsletter modal window -->
					<div id="newsletter_subscribe" class="modal hide fade" tabindex="-1">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
							<div class="hgroup title">
								<h3>Ура! Вы подписаны на наши новости.</h3>                        
							</div>
						</div>

						<div class="modal-footer">	
							<div class="pull-left">
								<button data-dismiss="modal" aria-hidden="true" class="btn btn-small">
									Закрыть &nbsp; <i class="fa fa-check"></i>
								</button>
							</div>
						</div>
					</div>
					<!-- End id="newsletter_subscribe" -->      
					
					<div id="addTocart" class="modal hide fade" tabindex="-1">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
							<div class="hgroup title">
								<h3>Спасибо за покупку</h3>                        
								<h5>Вы можете перейти в корзину для оформления заказа, чтобы продолжить покупки просто закройте это окно</h5>
							</div>
						</div>

						<div class="modal-footer">
							<div class="pull-left hidden-phone">
								<a href="#" data-dismiss="modal" aria-hidden="true" class="btn btn-primary btn-small">
									<i class="fa fa-chevron-left"></i> Продолжить покупки
								</a>
							</div>	
							<div class="pull-right">
								<a href="{$lang-prefix}/emarket/cart" aria-hidden="true" class="btn btn-primary btn-small">
									Перейти в корзину <i class="fa fa-chevron-right"></i>
								</a>
							</div>
						</div>
					</div>
					<xsl:if test="$method='object'">
						<div id="notEmptyCartFastOrder" class="modal hide fade" tabindex="-1">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
								<div class="hgroup title">
									<h3>Внимание!</h3>                        
									<h5>В вашей корзине есть товары, которые не будут учтены в заказе.</h5>
								</div>
							</div>
							<div class="modal-footer">
								<div class="pull-left">
									<a href="javascript: void(0);" data-dismiss="modal" aria-hidden="true" class="btn btn-primary btn-small">
										<i class="fa fa-chevron-left"></i> Отменить
									</a>
								</div>	
								<div class="pull-right">
									<a href="javascript: void(0);" aria-hidden="true" class="btn btn-primary btn-small" id="skipTest">
										Подтвердить <i class="fa fa-chevron-right"></i>
									</a>
								</div>
							</div>
						</div>
						<div id="subsribe-item" class="modal hide fade" tabindex="-1">
							<form action="{$lang-prefix}/catalog/notice_of_item/{$document-page-id}" method="post" >
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
									<div class="hgroup title">
										<h3>Введите e-mail для уведомления о поступлении.</h3>
										<!-- <h5></h5> -->
									</div>
								</div>
								<div class="modal-body">
									<div class="row-fluid">
										<div class="span6">
											<div class="control-group required">
												<!-- <label class="control-label" for="email">Email</label> -->
												<div class="controls">
													<input class="span12" type="text" name="email_notice" value="" />
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="modal-footer">
									<div class="btn_line">
										<div class="pull-left">
											<a href="javascript: void(0);" data-dismiss="modal" aria-hidden="true" class="btn btn-primary btn-small">
												<i class="fa fa-chevron-left"></i> Отменить
											</a>
										</div>
										<div class="pull-right">
											<button type="submit" aria-hidden="true" class="btn btn-primary btn-small">
												Подтвердить <i class="fa fa-chevron-right"></i>
											</button>
											<i class="fa fa-spinner fa-spin"></i>
											<span class="text-spinner">Подождите...</span>
										</div>
										<div class="pull-right hide close-wrapper-btn">
											<a href="javascript: void(0);" data-dismiss="modal" aria-hidden="true" class="btn btn-primary btn-small">
												Закрыть <i class="fa fa-times"></i>
											</a>
										</div>
									</div>
								</div>
							</form>
						</div>
					</xsl:if>
					<xsl:call-template name="sticky-block" />
				</div>
				<xsl:if test="$user-type='guest'">
					<xsl:call-template name="login" />
					<xsl:call-template name="registrate" />
				</xsl:if>	
				<xsl:apply-templates select="document('udata://webforms/add/171/')/udata" mode="callback" />
				<div class="overlay"></div>
				<!-- BEGIN JAVASCRIPTS -->
				<script src="{$template-resources}plugin/fotorama-4.5.1/fotorama.js"></script>
				<script type="text/javascript" src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
				<script type="text/javascript" src="{$template-resources}js/jquery.isotope.min.js"></script>
				<script src="{$template-resources}js/jquery.formstyler.min.js" type="text/javascript"></script>
				<script type="text/javascript" src="{$template-resources}js/jquery.elevateZoom-3.0.3.min.js"></script>
				<script type="text/javascript" src="{$template-resources}js/imagesloaded.js"></script>
				<script type="text/javascript" charset="utf-8" src="{$template-resources}js/fancybox/jquery.fancybox.pack.js"></script>
				<script type="text/javascript" charset="utf-8" src="{$template-resources}s_js/__common.js"></script>
				<script type="text/javascript" src="{$template-resources}js/libs/jquery.ui.touch-punch.min.js"></script>
				<script type="text/javascript" src="{$template-resources}js/jquery.tigra21.js"></script>
				
				<!-- дбавленые скрипты -->
				<script type="text/javascript" src="{$template-resources}js/additions/additions.js"></script>
				
				<!-- <script type="text/javascript" src="{$template-resources}plugin/tigra21-tinymse/jquery.tigra21.plugin.js"></script> -->
				<!-- END JAVASCRIPTS -->
				<xsl:value-of select="$settings_site[@name='settings_metric']/text()" disable-output-escaping="yes" />
				
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>