<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink">

	<xsl:template match="udata[@method = 'registrate']" mode="seller_registration">
		<form enctype="multipart/form-data" method="post" action="{$lang-prefix}/users/registrate_pre_do/"  id="registrate" >
			<div class="box">
				<div class="hgroup title">
					<h3>Регистрация в качестве продавца</h3>
					<h5>Зарегистрировавшись вы сможете создать свой магазин и добавить в него товары</h5>
					<input type="hidden" name="seller" value="true" />
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
<!-- 						<xsl:apply-templates select="$fields[not(@name='phone' or @name='fname' or @name='lname' or @name='father_name' or @name='electee_objects')]" mode="with-wrapper-registrate" /> -->
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
	
	
</xsl:stylesheet>