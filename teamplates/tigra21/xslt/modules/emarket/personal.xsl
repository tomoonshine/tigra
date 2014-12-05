<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- cabinet templates -->
	<xsl:template match="result[(@module='users' and @method='settings') or (@module='emarket' and @method='ordersListStatus') or (@module='dispatches' and @method='subscribe') or (page/@id='745') or (page/@id='866') or (page/@id='895') or (page/@id='896') or (page/@id='914')]" mode="main_template">
		<!-- Static page 1 -->
		<section class="static_page_1">
			<div class="container">
				<div class="row">
					<div class="span12">
						<section class="static-page">
							<div class="row-fluid">
								<div class="span3">
									<!-- Static page navigation -->
									<ul class="nav nav-tabs nav-stacked">
										<li>
											<xsl:if test="@module='users' and @method='settings'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
											<a href="http://tigra21.ru/users/settings" title="Профиль" class="title">Профиль</a>
										</li>
									<!-- 	<li>
											<xsl:if test="@module='emarket' and @method='ordersListStatus' and not(udata/status/item)"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
											<a href="http://tigra21.ru/emarket/ordersListStatus" title="Заказы" class="title">Заказы</a>
											<ul>
												<li >
													<xsl:if test="@module='emarket' and @method='ordersListStatus' and udata/status/item='waiting'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
													<a href="http://tigra21.ru/emarket/ordersListStatus?status[]=waiting" title="Новые заказы" class="title" >Новые заказы</a>
												</li>
												<li>
													<xsl:if test="@module='emarket' and @method='ordersListStatus'  and udata/status/item='ready'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
													<a href="http://tigra21.ru/emarket/ordersListStatus?status[]=ready" title="Готовые заказы" class="title" >Готовые заказы</a>
												</li>
												<li>
													<xsl:if test="@module='emarket' and @method='ordersListStatus' and udata/status/item='canceled'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
													<a href="http://tigra21.ru/emarket/ordersListStatus?status[]=canceled&amp;status[]=rejected" title="Отменённые заказы" class="title" >Отменённые заказы</a>
												</li>
											</ul>
										</li> -->
										<li>
											<xsl:if test="@module='dispatches' and @method='subscribe'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
											<a href="http://tigra21.ru/dispatches/subscribe" title="Подписки" class="title">Подписки</a>
										</li>
										
										<xsl:if test="document(concat('uobject://',user/@id,'.groups'))//value/item/@id = 10196">
											<li>
												<xsl:if test="page/@id='745'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
												<a href="http://tigra21.ru/nastrojki_magazina/" title="Настройки магазина" class="title">Настройки магазина</a>
											</li>
											<li>
												<xsl:if test="page/@id='895'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
												<a href="http://tigra21.ru/stranicy_dlya_lichnogo_kabineta/informaciya_dlya_posetitelej/" title="Информация для посетителей" class="title">Информация для посетителей</a>
											</li>
											<li>
												<xsl:if test="page/@id='914'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
												<a href="http://tigra21.ru/stranicy_dlya_lichnogo_kabineta/slajder/" title="Слайдер" class="title">Слайдер</a>
											</li>
											<li>
												<xsl:if test="page/@id='866'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
												<a href="http://tigra21.ru/tovary/" title="Товары" class="title">Товары</a>
											</li>
											<li>
												<xsl:if test="page/@id='896'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
												<a href="http://tigra21.ru/stranicy_dlya_lichnogo_kabineta/akcii_i_novosti/" title="Акции" class="title">Акции, Новости</a>
											</li>
											<li>
												<!-- <xsl:if test="@module='dispatches' and @method='subscribe'"><xsl:attribute name="class">active</xsl:attribute></xsl:if> -->
												<a href="#" title="Рассылки" class="title">Рассылки</a>
											</li>
										</xsl:if>
									</ul>                                       
								</div>

								<div class="span9">
									<div class="content">
										
										 <div class="clearfix breadcrumb_lay">
											<!-- <xsl:apply-templates select="document('udata://core/navibar/')" /> -->
											<h1 class="pull-left">Личный кабинет</h1>
										</div>
										<xsl:choose>
											<xsl:when test="@module='emarket' and @method='ordersListStatus' and udata/status/item='waiting'">
												<xsl:apply-templates select="." >
													<xsl:with-param name="block-title" select="'Новые заказы'" />
												</xsl:apply-templates>
											</xsl:when>
											<xsl:when test="@module='emarket' and @method='ordersListStatus' and udata/status/item='ready'">
												<xsl:apply-templates select="." >
													<xsl:with-param name="block-title" select="'Готовые заказы'" />
												</xsl:apply-templates>
											</xsl:when>
											<xsl:when test="@module='emarket' and @method='ordersListStatus' and udata/status/item='canceled'">
												<xsl:apply-templates select="." >
													<xsl:with-param name="block-title" select="'Отменённые заказы'" />
												</xsl:apply-templates>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="$errors" />
												<xsl:apply-templates select="." />
											</xsl:otherwise>
										</xsl:choose> 
										
									</div>
								</div>
							</div>
						</section>
					</div>
				</div>
			</div>
		</section> 
		
	</xsl:template>
	
	
	
	<xsl:template match="/result[@method = 'personal']">
		<script>
			function tabChange(tab, prefix) {
				var i, tabs = tab.parentNode;
				for (i=0; tabs.childNodes.length > i; i++) {
					var tab_in = tabs.childNodes[i];
					if (tab_in.nodeName == "#text") continue;
					tab_in.className = "";
				}
				tab.className = "act";
				var con_tabs = jQuery('.' + prefix + tabs.className);
				var con_tabs_arr = con_tabs[0].childNodes;
				for (i=0; con_tabs_arr.length > i; i++) {
					var con_tab = con_tabs_arr[i];
					if (con_tab.nodeName == "#text") continue;
					con_tab.style.display = "none";
				}
				var con_tab_act = document.getElementById(prefix + tab.id);
				con_tab_act.style.display = "block";
			}
		</script>

		<div class="tabs">
			<div id="tab_profile" class="act" onclick="tabChange(this, 'con_');">Персональная информация</div>
			<div id="tab_orders" onclick="tabChange(this, 'con_');">Заказы</div>
		</div>

		<div class="con_tabs">
			<xsl:apply-templates select="document('udata://user/settings')" />
			<xsl:apply-templates select="document('udata://emarket/ordersList')" />
		</div>
	</xsl:template>
</xsl:stylesheet>