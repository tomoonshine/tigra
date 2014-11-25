<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink">

	<xsl:template match="result[@method = 'registrate']" />
	<xsl:template match="result[@method = 'registrate']" mode="main_template">
		<section class="reset_password">
			<div class="container">
				<div class="row">
					<div class="span6 offset3">	 
						<xsl:apply-templates select="document('udata://users/registrate')" />	
					</div>
				</div>
			</div>	
		</section>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'registrate']">
		<form enctype="multipart/form-data" method="post" action="{$lang-prefix}/users/registrate_pre_do" onsubmit="site.forms.data.save(this); return site.forms.data.check(this);" id="registrate" >
			<div class="box">
				<div class="hgroup title">
					<h3>Регистрация</h3>
					<h5><!-- Зарегистрированные пользователи получают доступ к истории заказов и скидкам. --></h5>
				</div>
				<div class="box-content">
					<xsl:apply-templates select="$errors" />
					<xsl:variable name="fields" select="document(@xlink:href)/udata/group/field" />
					
					<div class="row-fluid">
						<div class="span12">
						    <xsl:apply-templates select="$fields[@name='fname']" mode="registrate-fname">
								<xsl:with-param name="required_lname" select="$fields[@name='lname']/@required" />
								<xsl:with-param name="required_father_name" select="$fields[@name='father_name']/@required" />
						    </xsl:apply-templates>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
						    <div class="control-group required">
								<label class="control-label" for="email">E-mail&#160;<i class="fa fa-asterisk"></i></label>
								<div class="controls">
									<input class="span12" type="text" id="email" name="email" value="" />
								</div>
							</div>
						</div>
						<div class="span6">
						    <xsl:apply-templates select="$fields[@name='phone']" mode="registrate" />
						</div>
						<!-- <xsl:apply-templates select="$fields[not(@name='phone' or @name='fname' or @name='lname' or @name='father_name' or @name='electee_objects')]" mode="with-wrapper-registrate" /> -->
					</div>
					<div class="row-fluid">
						<div class="span6">
							<div class="control-group required">
								<label class="control-label" for="password">&password; <i class="fa fa-asterisk"></i></label>
								<div class="controls">
									<input type="password" name="password" id="password" value="" class="span12" />
								</div>
							</div>
						</div>
						<div class="span6">
							<div class="control-group required">
								<label class="control-label" for="password_confirm">&password-confirm; <i class="fa fa-asterisk"></i></label>
								<div class="controls">
									<input type="password" name="password_confirm" id="password_confirm" value="" class="span12" />
								</div>
							</div>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span12">
							<div class="control-group required">
								<div class="controls">
									<input type="hidden" id="agree" name="agree" value="true" />
									<input data-id-hidden="agree" type="checkbox" value="1" checked="checked" />С настоящей <a href="{document('upage://380')/udata/page/@link}" target="_blank">политикой конфиденциальности</a> ознакомлен, с условиями согласен. Подтверждаю свое согласие.<i class="fa fa-asterisk"></i>
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
						<button class="btn btn-primary btn-small" type="submit" value="Register">
							&registration-do; &#160; <i class="fa fa-check"></i>
						</button>
						<i class="fa fa-spinner fa-spin"></i>
						<span class="text-spinner">Идёт регистрация...</span>
					</div>                                            
				</div>
			</div>
		</form>
	</xsl:template>

	<xsl:template match="result[@method = 'registrate_done']">		
		<xsl:apply-templates select="document('udata://users/registrate_done')/udata"/>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'registrate_done']">
		<xsl:choose>
			<xsl:when test="result = 'without_activation'">
				<p>
					Уважемый(ая), <xsl:value-of select="$user-info//property[@name='lname']/value" />&#160;<xsl:value-of select="$user-info//property[@name='fname']/value" />&#160;<xsl:value-of select="$user-info//property[@name='father_name']/value" />! 
				</p>

				<p>
					Спасибо за регистрацию на сайте <strong><xsl:value-of select="$domain" /></strong>
				</p>
				<p>
					Приятных покупок!
					<!-- <xsl:text>&registration-done;</xsl:text> -->
				</p>
			</xsl:when>
			<xsl:when test="result = 'error'">
				<h4>
					<xsl:text>&registration-error;</xsl:text>
				</h4>
			</xsl:when>
			<xsl:when test="result = 'error_user_exists'">
				<h4>
					<xsl:text>&registration-error-user-exists;</xsl:text>
				</h4>
			</xsl:when>
			<xsl:otherwise>
				<h4>
					<xsl:text>&registration-done;</xsl:text>
				</h4>
				<p>
					<xsl:text>&registration-activation-note;</xsl:text>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	
	
	<xsl:template match="result[@method = 'activate']">
		<xsl:variable name="activation-errors" select="document('udata://users/activate')/udata/error" />
		
		<xsl:choose>
			<xsl:when test="count($activation-errors)">
				<xsl:apply-templates select="$activation-errors" />
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:text>&account-activated;</xsl:text>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- User settings -->
	<xsl:template match="result[@method = 'settings']">
		<xsl:apply-templates select="document('udata://users/settings')" />
	</xsl:template>
	
	<xsl:template match="udata[@method = 'settings']">

<!-- 		<div class="pull-right"><strong>Кол-во бонусов: </strong> <xsl:choose><xsl:when test="$user-info////property[@name='bonus']/value"> <strong><xsl:value-of select="$user-info////property[@name='bonus']/value" /></strong></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose><xsl:text> </xsl:text><strong> руб. </strong></div> -->




		<p class="lead">Персональная информация</p>                                               
		<form action="{$lang-prefix}/users/settings_do_pre"  method="post" enctype="multipart/form-data" id="settings-form">
		<table class="table" id="acc_info">
			<tbody>
				<tr>
					<th>ФИО</th>
					<td>
						<input type="text" name="full_name"  readonly="" value="{concat($user-info//property[@name = 'lname']/value,' ',$user-info//property[@name = 'fname']/value,' ',$user-info//property[@name = 'father_name']/value)}"/>
					</td>
				</tr> 
				<tr>
					<th>Телефон</th>
					<td>
						<input type="text" name="data[{$user-id}][phone]" readonly="" value="{$user-info//property[@name = 'phone']/value}" class="phone-valid"/>
						 
					</td>
				</tr>
				<tr>
					<th>E-mail</th>
					<td>
						<input type="text" name="email" readonly="" value="{$user-info//property[@name = 'e-mail']/value}"/>
						 
					</td>
				</tr>
				<tr>
					<th>Пароль</th>
					<td>
						<input type="password" name="password" readonly="" />                                                                
					</td>
				</tr>
				<tr>
					<th>Подтверждение пароля</th>
					<td>
						<input type="password" name="password_confirm" readonly="" />                                                                
					</td>
				</tr> 
				<!-- <xsl:apply-templates select="document(concat('udata://data/getEditForm/', $user-id))" /> -->
				<tr>
					<th></th>
					<td>
						<a href="#" class="btn btn-turquoise btn-small" id="lk-edit-btn">Редактировать</a>    
						<input type="button" class="hide btn btn-small" id="lk-cancel-btn" value="Отменить" />
						<input type="submit" class="hide btn btn-turquoise btn-small" value="Cохранить" />
					</td>
				</tr>
			</tbody>
		</table>
		</form>
		<xsl:apply-templates select="document('udata://emarket/customerDeliveryList')" />
	</xsl:template>
	
	<xsl:template name="registrate">
		<div id="register" class="modal hide fade" tabindex="-1">
			<form enctype="multipart/form-data" method="post" action="{$lang-prefix}/users/registrate_pre_do" onsubmit="site.forms.data.save(this); return site.forms.data.check(this);">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<div class="hgroup title">
						<h3>Регистрация</h3>
						<h5>Зарегистрированные пользователи получают доступ к истории заказов и скидкам.</h5>
					</div>
				</div>
				<div class="modal-body">
					<div class="row-fluid">
						<div class="span12">
							<div class="control-group required">
								<label class="control-label" for="full_name">Фамилия Имя Отчество</label>
								<div class="controls">
									<input class="span12" type="text" id="full_name" name="data[new][fname]" value="" />
								</div>
							</div>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
							<div class="control-group required">
								<label class="control-label" for="email">Email</label>
								<div class="controls">
									<input class="span12" type="text" id="email" name="email" value="" autocomplete="off" />
								</div>
							</div>
						</div>
						<div class="span6">
							<div class="control-group">
								<label class="control-label" for="phone">Телефон</label>
								<div class="controls">
									<input class="span12 phone-valid" type="text" id="phone" name="data[new][phone]" value="" autocomplete="off" />
								</div>
							</div>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
							<div class="control-group required">
								<label class="control-label" for="password">&password;</label>
								<div class="controls">
									<input type="password" name="password" id="password" value="" class="span12" autocomplete="off" />
								</div>
							</div>
						</div>
						<div class="span6">
							<div class="control-group required">
								<label class="control-label" for="password_confirm">&password-confirm;</label>
								<div class="controls">
									<input type="password" name="password_confirm" id="password_confirm" value="" class="span12" autocomplete="off" />
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<div class="btn_line">
						<button class="btn btn-primary btn-small" type="submit" value="Register">
							&registration-do; &#160; <i class="fa fa-check"></i>
						</button>
						<i class="fa fa-spinner fa-spin"></i>
						<span class="text-spinner">Идёт регистрация...</span>
					</div>
				</div>
			</form>
		</div>
	</xsl:template>
	
</xsl:stylesheet>