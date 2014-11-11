<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

	<xsl:include href="comments-list.xsl" />
	<xsl:include href="comments-list-news.xsl" />
	<xsl:include href="comment-view.xsl" />

	<xsl:template match="udata[@method = 'countComments']" />
	
	<xsl:template match="udata[@method = 'countComments'][. &gt; 0]">
	    <xsl:variable name="encode-str" select="php:function('urlencode', 'комментарий,комментария,комментариев')" />
	    <li><i class="icon-comment-alt"></i> &nbsp; <xsl:value-of select="document(concat('udata://content/get_correct_str/', text(),'/', $encode-str,'/'))/udata" /></li>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'countComments']" mode="countComments-object">
		<xsl:variable name="encode-str" select="php:function('urlencode', 'отзыв,отзыва,отзывов')" />
		<a href="#ratings" class="reviewsLink"><xsl:value-of select="document(concat('udata://content/get_correct_str/', text(),'/', $encode-str,'/'))/udata" /></a>
	</xsl:template>

</xsl:stylesheet>