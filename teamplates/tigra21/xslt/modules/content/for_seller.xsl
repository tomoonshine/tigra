<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template match="result[page/@id='744']" mode="main_template">
		<section class="main">
			<section class="reset_password">
				<div class="container">
					<div class="row">
						<div class="span6 offset3">
							<xsl:apply-templates select="document('udata://users/registrate')/udata" mode="seller_registration"/>
						</div>
					</div>
				</div>
			</section>
		</section>
	</xsl:template>
	
	
	
	
</xsl:stylesheet>