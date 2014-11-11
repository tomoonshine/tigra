<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink">

	<xsl:template match="result[@method = 'forget']" />
	<xsl:template match="result[@method = 'forget']" mode="main_template">
		<section class="reset_password">
			<div class="container">
				<div class="row">
					<div class="span6 offset3">
						<div class="box">
							<div class="hgroup title">
								<h3>Восстановление пароля</h3>
							</div>
							<form method="post" action="/users/forget_do/">
								<div class="box-content">
									<xsl:apply-templates select="$errors" />
									<div class="row-fluid">
										<div class="span12">
											<div class="control-group">
												<label class="control-label" for="email">Email</label>
												<div class="controls">
													<input class="span12" type="text" id="email" name="forget_login" value="" />
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="buttons">
									<div class="btn_line">
										<button class="btn btn-primary btn-small" type="submit" value="Submit">
											&forget-button;
										</button>
										<i class="fa fa-spinner fa-spin"></i>
										<span class="text-spinner">Подождите...</span>
									</div>				
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="result[@method = 'forget_do']">
		<p>
			<xsl:text>&registration-activation-note;</xsl:text>
		</p>
	</xsl:template>
</xsl:stylesheet>