<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
		<xsl:template match="udata[@method='Next_Prev']" />
		<xsl:template match="udata[@method='Next_Prev' and curr_index]">
			<div class="pull-right next_prev-phone-mrgt">
				<xsl:apply-templates select="prev" /> 
				<xsl:apply-templates select="$parents" mode="back-link" />
				<!-- <xsl:if test="prev/@link">&#160;–&#160;</xsl:if><xsl:value-of select="curr_index" /> из <xsl:value-of select="total" /><xsl:if test="next/@link">&#160;–&#160;</xsl:if> -->
				<xsl:apply-templates select="next" />
			</div>
		</xsl:template>

		<xsl:template match="udata[@method='Next_Prev' and curr_index]/prev" />
		<xsl:template match="udata[@method='Next_Prev' and curr_index]/prev[@link]">
			<a href="{@link}" class="btn-aticle"><i class="fa fa-angle-double-left"></i> Пред. | </a>
		</xsl:template>

		<xsl:template match="udata[@method='Next_Prev' and curr_index]/next" />
		<xsl:template match="udata[@method='Next_Prev' and curr_index]/next[@link]">
			<a href="{@link}" class="btn-aticle"> | След. <i class="fa fa-angle-double-right"></i></a>
		</xsl:template>

		<xsl:template match="page" mode="back-link">
			<xsl:if test="@id = $parentID">
				<a href="{@link}" class="txtdn">Назад к списку</a>
			</xsl:if>
		</xsl:template>

</xsl:stylesheet>
