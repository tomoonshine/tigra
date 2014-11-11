<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet     version="1.0"
                    xmlns="http://www.w3.org/1999/xhtml"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:date="http://exslt.org/dates-and-times"
                    xmlns:udt="http://umi-cms.ru/2007/UData/templates"
                    xmlns:umi="http://www.umi-cms.ru/TR/umi"
                    xmlns:xlink="http://www.w3.org/TR/xlink"
                    exclude-result-prefixes="xsl date udt xlink">

     <xsl:output encoding="utf-8" method="html" indent="yes" />
    
     
     <xsl:template match="/">
        <xsl:apply-templates select="udata/items/item" mode="comment" />
		<hr />
		<xsl:apply-templates select="udata/total" mode="usual_paging" />
     </xsl:template>
   
     <xsl:template match="item" mode="comment">
		<article class="rating-item" umi:element-id="{@id}" umi:region="row">
			<div class="row-fluid">
				<div class="span9" umi:field-name="message" umi:delete="delete" umi:empty="&empty;" itemprop="description">
					<xsl:value-of select="text()" disable-output-escaping="yes" />
				</div>
				<div class="span3">
					<xsl:apply-templates select="document(@xlink:author-href)" />
					
					<small umi:field-name="publish_time" itemprop="datePublished">
						<xsl:attribute name="content">
							<xsl:call-template name="format-date">
								<xsl:with-param name="date" select="@publish_time" />
								<xsl:with-param name="pattern" select="'Y-m-d'" />
							</xsl:call-template>
						</xsl:attribute>
						<xsl:call-template name="format-date">
							<xsl:with-param name="date" select="@publish_time" />
						</xsl:call-template>
					</small>
					<div class="starrating goodstooltip__starrating">
						<span data-starrate="{round(.//property[@name='rating_int']/value)}"  class="starlight"></span>
					</div>
				</div>
			</div>
		</article>
	</xsl:template>
	
	<!-- viewAuthor -->
	<xsl:template match="udata[@method = 'viewAuthor']">
		<h6 umi:object-id="{user_id}" itemprop="author">
			<xsl:apply-templates select="fname" />
			<xsl:apply-templates select="lname" />
		</h6>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'viewAuthor']/fname|lname|nickname">
		<span umi:field-name="{local-name()}">
			<xsl:value-of select="." />
		</span>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<!-- date -->
	<xsl:template name="format-date">
		<xsl:param name="date" />
		<xsl:param name="pattern" select="'d.m.Y'" />
		<xsl:variable name="uri" select="concat('udata://system/convertDate/', $date, '/(', $pattern, ')')" />
		
		<xsl:value-of select="document($uri)/udata" />
	</xsl:template>
	
	<xsl:template match="property[@type = 'date']">
		<xsl:param name="pattern" select="'&default-date-format;'" />
		<xsl:call-template name="format-date">
			<xsl:with-param name="date" select="value/@unix-timestamp" />
			<xsl:with-param name="pattern" select="$pattern" />
		</xsl:call-template>
	</xsl:template>
	
	<!-- обычная пагинация -->
	<xsl:template match="total" mode="usual_paging" />
	<xsl:template match="total[. &gt; ../per_page]" mode="usual_paging">
		<xsl:variable name="per_page" select="../per_page" />
		<xsl:apply-templates select="document(concat('udata://system/numpages/', ., '/', $per_page))/udata" mode="usual_paging">
			<xsl:with-param name="per_page" select="$per_page" />
			<xsl:with-param name="total" select="text()" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'numpages']" mode="usual_paging" />
	<xsl:template match="udata[@method = 'numpages'][count(items)]" mode="usual_paging">
		<xsl:param name="per_page" />
		<xsl:param name="total" />
		<div class="pagination">
			<ul>
				<xsl:apply-templates select="toprev_link" mode="usual_paging" />
				<xsl:apply-templates select="items/item" mode="usual_paging" />
				<xsl:apply-templates select="tonext_link" mode="usual_paging" />
			</ul>
		</div>
		
	</xsl:template>
	
	<xsl:template match="item" mode="usual_paging">
		<li><a href="{@link}"><xsl:value-of select="." /></a></li>
	</xsl:template>
	
	<xsl:template match="item[@is-active = '1']" mode="usual_paging">
		<li class="active"><a href="{@link}"><xsl:value-of select="." /></a></li>
	</xsl:template>
	
	<xsl:template match="toprev_link" mode="usual_paging">
		<li><a href="{.}"><xsl:text>&lt;</xsl:text></a></li>
	</xsl:template>
	
	<xsl:template match="tonext_link" mode="usual_paging">
		<li><a href="{.}"><xsl:text>&gt;</xsl:text></a></li>
	</xsl:template>
   
   
   
</xsl:stylesheet>