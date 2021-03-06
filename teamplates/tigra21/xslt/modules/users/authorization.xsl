<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Для Зарегистрированных пользователей -->
	<xsl:template match="user">
		<div class="span4">

			<ul class="inline pull-right">
				<li>
					<a href="http://tigra21.ru/users/login/#login" >
						<span>Войти в кабинет <i class="b-head-control-panel__link-icon b-head-control-panel__icon-enter"></i></span>
					</a>
				</li>
				<li>
					<a title="Выйти" href="http://tigra21.ru/users/logout"> Выйти</a>
				</li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="property[@name = 'fname' or @name = 'lname' or @name = 'father_name']">
		<xsl:value-of select="value" />
		<xsl:text> </xsl:text>
	</xsl:template>
	
	
	<!-- Для неавторизованных пользователей -->
	<xsl:template match="user[@type = 'guest']">
		<div class="span4">
			<ul class="inline pull-right">
				<li>|</li>
				<li>
					<a href="http://tigra21.ru/users/login/#login" >
						<span>Войти в кабинет <i class="b-head-control-panel__link-icon b-head-control-panel__icon-enter"></i></span>
					</a>
				</li>
				<span>
					<a title="Зарегистрироваться" id="header__authBlock_reg" data-toggle="modal">
						<div class="b-head-control-panel__drop-down">
							<i class="b-head-control-panel__link-icon b-head-control-panel__icon-register"></i>Зарегистрироваться 

							<i class="b-head-control-panel__drop-down-arrow icon-black-down-arrow"></i>
							<ul class="b-head-control-panel__drop-down-menu">
								<li class="b-head-control-panel__drop-down-item ">
									<a href="http://tigra21.ru/registraciya/" class="b-head-control-panel__link b-head-control-panel__link_layout_with-icon">
										<i class="b-head-control-panel__link-icon b-head-control-panel__icon-case"></i>
										<span class="b-head-control-panel__link-text">Как продавец</span>
									</a>
								</li>
								<li class="b-head-control-panel__drop-down-item ">
									<a href="http://tigra21.ru/users/registrate" class="b-head-control-panel__link b-head-control-panel__link_layout_with-icon">
										<i class="b-head-control-panel__link-icon b-head-control-panel__icon-user"></i>
										<span class="b-head-control-panel__link-text">Как покупатель</span>
										
									</a>
								</li>
							</ul>
						</div>
					</a>
			  </span>
			</ul>
		</div>
		<!-- <div class="span3">
			<ul class="inline pull-right">
				<li><a href="http://tigra21.ru/users/login/#login" title="Войти" id="header__authBlock_enter" data-toggle="modal"><i class="fa fa-user"></i> Вход</a></li>
				<li>|</li>
				<li><a href="http://tigra21.ru/users/registrate" title="Зарегистрироваться" id="header__authBlock_reg" data-toggle="modal">Регистрация</a></li>
			</ul>
		</div> -->
	</xsl:template>

	
	<xsl:template match="udata[@method='getLoginzaProvider']">
		<div class="loginza_block"> 
			<script src="http://loginza.ru/js/widget.js" type="text/javascript"></script>
			<a href="{widget_url}" class="loginza">
				<img src="http://loginza.ru/img/sign_in_button_gray.gif" alt="Войти через loginza"/>
			</a>
		</div>
	</xsl:template>

	<xsl:template match="result[@method = 'login' or @method = 'login_do' or @method = 'loginza' or @method = 'auth']" />
	<xsl:template match="result[@method = 'login' or @method = 'login_do' or @method = 'loginza' or @method = 'auth']" mode="main_template">
		<!-- Reset password -->
		<section class="reset_password">
			<div class="container">
				<div class="row">
					<div class="span6 offset3">
						<div class="box">
							<xsl:if test="@not-permitted = 1">
								<p><xsl:text>&user-not-permitted;</xsl:text></p>
							</xsl:if>
							<xsl:if test="user[@type = 'guest'] and (@method = 'login_do' or @method = 'loginza')">
								<div class="alert alert-error">
									<button class="close" type="button" data-dismiss="alert">×</button>
									<p><xsl:text>&user-reauth;</xsl:text></p>
								</div>
							</xsl:if>
							<xsl:apply-templates select="document('udata://users/auth/')/udata" />
						</div>
					</div>
				</div>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="udata[@module = 'users'][@method = 'auth']">
		<div class="hgroup title">
			<h3>Авторизация</h3>
		</div>
		<form method="post" action="http://tigra21.ru/users/login_do/" class="login-form">
			<input type="hidden" name="from_page" value="{from_page}" />
			<div class="box-content">
				<div class="row-fluid">
					<div class="span6">
						<div class="control-group">
							<label class="control-label" for="email">Email</label>
							<div class="controls">
								<input class="span12" type="text" id="email" name="login" value="" />
							</div>
						</div>
					</div>
					<div class="span6">
						<div class="control-group">
							<label class="control-label" for="email">&password;</label>
							<div class="controls">
								<input class="span12" type="password" id="email" name="password" value="" />
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="buttons">
				<div class="pull-right">
					<xsl:apply-templates select="document('udata://users/getUrlAuth/')/udata" />
				</div>
				<div class="btn_line">
					<button class="btn btn-primary btn-small" type="submit" value="Submit">
						&log-in;
					</button><xsl:text> </xsl:text>
					<a href="http://tigra21.ru/users/forget">Забыли пароль?</a>
					<i class="fa fa-spinner fa-spin"></i>
					<span class="text-spinner">Авторизация...</span>
				</div>		
			</div>
		</form>
	</xsl:template>

	<xsl:template match="udata[@module = 'users'][@method = 'auth'][user_id]">
		<div>
			<xsl:text>&welcome; </xsl:text>
			<xsl:choose>
				<xsl:when test="translate(user_name, ' ', '') = ''"><xsl:value-of select="user_login" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="user_name" /> (<xsl:value-of select="user_login" />)</xsl:otherwise>
			</xsl:choose>
		</div>
		<div>
			<a href="http://tigra21.ru/users/logout">
				<xsl:text>&log-out;</xsl:text>
			</a>
			<xsl:text> | </xsl:text>
			<a href="http://tigra21.ru/users/settings">
				<xsl:text>&office;</xsl:text>
			</a>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getUrlAuth']" />
	<xsl:template match="udata[@method = 'getUrlAuth'][items/item]">
		<ul class="auth-social clearfix">
			<xsl:apply-templates select="items/item" mode="getUrlAuth" />
		</ul>
	</xsl:template>
	
	<xsl:template match="item" mode="getUrlAuth" >
		<li><a href="{@link}"><xsl:value-of select="text()" /></a></li>
	</xsl:template>
	
	<xsl:template match="item[@ico]" mode="getUrlAuth">
		<li><a href="{@link}"><img src="{@ico}" alt="{text()}" title="{text()}" width="24" height="24" /></a></li>
    </xsl:template>
	
	<xsl:template name="login">
		<div id="login" class="modal hide fade" tabindex="-1">
			<form enctype="multipart/form-data" method="post" action="http://tigra21.ru/users/login_do">
				<input type="hidden" name="from_page" value="{from_page}" />
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<div class="hgroup title">
						<h3>Авторизация</h3>
					</div>
				</div>
				<div class="modal-body">
					<div class="row-fluid">
						<div class="span6">
							<div class="control-group">
								<label class="control-label" for="email">Email</label>
								<div class="controls">
									<input class="span12" type="text" id="email" name="login" value="" />
								</div>
							</div>
						</div>
						<div class="span6">
							<div class="control-group">
								<label class="control-label" for="password">&password;</label>
								<div class="controls">
									<input type="password" name="password" id="password" value="" class="span12" />
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<div class="pull-right">
						<xsl:apply-templates select="document('udata://users/getUrlAuth/')/udata" />
					</div>
					<div class="btn_line">
						<button class="btn btn-primary btn-small" type="submit" value="Submit">&log-in;</button>
						<a href="http://tigra21.ru/users/forget" class="link-to-forgetpsw">Забыли пароль?</a>
						<i class="fa fa-spinner fa-spin"></i>
						<span class="text-spinner">Авторизация...</span>
					</div>
				</div>
			</form>
		</div>
	</xsl:template>

</xsl:stylesheet>