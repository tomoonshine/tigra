<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template match="result[page/@id='573']" mode="main_template">
		<section class="static_page_1">
			<div class="container">
				<div class="row">
					<div class="span12">
						<section class="static-page">
                            <div class="row-fluid">
								<div class="content">
									<xsl:apply-templates select="." mode="header" />
									<!-- <xsl:apply-templates select="." /> -->
	
									<!-- <xsl:apply-templates select="udata(" /> -->
								</div>
							</div>
						</section>
					</div>
				</div>
			</div>
		</section>
	</xsl:template>
	
</xsl:stylesheet>