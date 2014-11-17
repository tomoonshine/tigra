<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi"
	xmlns:xlink="http://www.w3.org/TR/xlink">

	<xsl:template match="/result[@module = 'news'][@method = 'item']">
            <article class="post post-full">
                <div class="box">
                    <div class="box-header">
                        <xsl:apply-templates select="/result" mode="header" />
                        <ul class="post-meta">
                            <xsl:apply-templates select=".//property[@name = 'user_author']" mode="user_author" />
                            <li><i class="icon-calendar"></i> &nbsp; <xsl:value-of select="document(concat('udata://system/convertDate/', .//property[@name = 'publish_time']/value/@unix-timestamp,'/(d/m/Y)'))/udata" /></li>
                            <xsl:apply-templates select="document(concat('udata://comments/countComments/', $document-page-id))" />
                        </ul>
                    </div>
                    <div class="box-content" umi:element-id="{$document-page-id}" umi:field-name="content" umi:empty="&empty-page-content;">
                        <xsl:value-of select=".//property[@name = 'content']/value" disable-output-escaping="yes" />
                    </div>
                </div>
            </article>
            <xsl:apply-templates select="document(concat('udata://comments/insert/', $document-page-id))" mode="comment-news" />
	</xsl:template>
	
	<xsl:template match="udata[@method = 'related_links']" />
	
	<xsl:template match="udata[@method = 'related_links' and count(items/item)]">
		<h4>
			<xsl:text>&news-realted;</xsl:text>
		</h4>

		<ul>
			<xsl:apply-templates select="items/item" mode="related" />
		</ul>
	</xsl:template>
	
	<xsl:template match="item" mode="related">
		<li umi:element-id="{@id}">
			<a href="{@link}" umi:field-name="news">
				<xsl:value-of select="." />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>