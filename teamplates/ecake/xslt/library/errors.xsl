<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="udata[@module = 'system' and @method = 'listErrorMessages']" />

	<xsl:template match="udata[@module = 'system' and @method = 'listErrorMessages'][count(items/item) &gt; 0]">
		<div class="alert alert-error">
			<button class="close" type="button" data-dismiss="alert">×</button>
			<strong>&errors;:</strong>
			<div class="errors">
				<ul>
					<xsl:apply-templates select="items/item" mode="error" />
				</ul>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="error">
		<li>
			<xsl:value-of select="." />
		</li>
	</xsl:template>


	<xsl:template match="error">
		<div class="alert alert-error">
			<button class="close" type="button" data-dismiss="alert">×</button>
			<strong>&errors;:</strong>
			<div class="errors">
				<ul>
					<li>
						<xsl:value-of select="." />
					</li>
				</ul>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>