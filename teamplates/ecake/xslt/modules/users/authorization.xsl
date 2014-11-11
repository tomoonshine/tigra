<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="user">
		<div class="span3">
			<ul class="inline pull-right">
				<li>
					<a title="Личный кабинет" href="{$lang-prefix}/users/settings/"><i class="fa fa-user"></i> Личный кабинет</a>				
				</li>
				<li>
					|
				</li>
				<li>
					<a title="Выйти" href="{$lang-prefix}/users/logout/"> Выйти</a>
				</li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="property[@name = 'fname' or @name = 'lname' or @name = 'father_name']">
		<xsl:value-of select="value" />
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="user[@type = 'guest']">
		<div class="span3">
			<ul class="inline pull-right">
				<li><a href="{$lang-prefix}/users/login/#login" title="Войти" id="header__authBlock_enter" data-toggle="modal"><i class="fa fa-user"></i> Вход</a></li>
				<li>|</li>
				<li><a href="{$lang-prefix}/users/registrate/" title="Зарегистрироваться" id="header__authBlock_reg" data-toggle="modal">Регистрация</a></li>
			</ul>
		</div>
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
		<form method="post" action="/users/login_do/" class="login-form">
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
					<a href="{$lang-prefix}/users/forget/">Забыли пароль?</a>
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
			<a href="{$lang-prefix}/users/logout/">
				<xsl:text>&log-out;</xsl:text>
			</a>
			<xsl:text> | </xsl:text>
			<a href="{$lang-prefix}/users/settings/">
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
			<form enctype="multipart/form-data" method="post" action="{$lang-prefix}/users/login_do/">
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
						<a href="{$lang-prefix}/users/forget/" class="link-to-forgetpsw">Забыли пароль?</a>
						<i class="fa fa-spinner fa-spin"></i>
						<span class="text-spinner">Авторизация...</span>
					</div>
				</div>
			</form>
		</div>
	</xsl:template>

</xsl:stylesheet>