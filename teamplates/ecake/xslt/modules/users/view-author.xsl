<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@method = 'viewAuthor']">
		<h6 umi:object-id="{user_id}" itemprop="author">
			<xsl:apply-templates select="fname" />
			<xsl:apply-templates select="lname" />
		</h6>
		<!-- <span class="author-info" umi:object-id="{user_id}" itemprop="author">
			<xsl:apply-templates select="fname" />
			<xsl:apply-templates select="nickname" />
			<xsl:apply-templates select="lname" />
		</span> -->
	</xsl:template>
	
	<xsl:template match="udata[@method = 'viewAuthor']/fname|lname|nickname">
		<span umi:field-name="{local-name()}">
			<xsl:value-of select="." />
		</span>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'viewAuthor']" mode="viewAuthor-news">
        <h6 umi:object-id="{user_id}" itemprop="author">
            <a>
                <xsl:apply-templates select="fname" />
                <xsl:apply-templates select="lname" />
            </a>
        </h6>
    </xsl:template>
	
</xsl:stylesheet>