<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="/result[@module = 'news'][@method = 'rubric']">
		<xsl:apply-templates select="document('udata://news/lastlist/?extProps=publish_time,anons,anons_pic,user_author')" />
	</xsl:template>

	<xsl:template match="udata[@method = 'lastlist']">
		<section class="post-list isotope" umi:button-position="top right" umi:element-id="{$document-page-id}" umi:region="list" umi:module="news" umi:method="lastlist" umi:sortable="sortable">
            <xsl:apply-templates select="items/item" mode="news-list" />
        </section>
		<xsl:apply-templates select="total" />
	</xsl:template>


	<xsl:template match="item" mode="news-list">
		 <article class="post post-grid isotope-item" umi:element-id="{@id}" umi:region="row">
                <div class="box">
                    <div class="box-image">
                        <a href="{@link}">
                            <xsl:call-template name="all-thumbnail-path">
                                <xsl:with-param name="width" select="'420'" />
                                <!-- <xsl:with-param name="height" select="'315'" /> -->
                                <xsl:with-param name="path" select=".//property[@name = 'anons_pic']/value" />
                                <xsl:with-param name="full" select="'care'" />
                                <xsl:with-param name="quality" select="'100'" />
                            </xsl:call-template>
                        </a>
                    </div>
                    <div class="box-header">
                        <h3> <a href="{@link}" umi:field-name="name" umi:delete="delete" umi:empty="&empty-page-name;"><xsl:value-of select="node()" /></a></h3>
                        <ul class="post-meta">
                            <xsl:apply-templates select=".//property[@name = 'user_author']" mode="user_author" />
                            <li><i class="icon-calendar"></i> &nbsp; <xsl:value-of select="document(concat('udata://system/convertDate/', @publish_time,'/(d/m/Y)'))/udata" /></li>
                            <xsl:apply-templates select="document(concat('udata://comments/countComments/', @id))" />
                        </ul>
                    </div>
                     <xsl:apply-templates select=".//property[@name = 'anons']" mode="anons-content" />
                    <div class="box-footer">
                        <div class="pull-right">
                            <a class="btn btn-small" href="{@link}" title="">
                                Читать далее &nbsp; <i class="icon-chevron-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </article>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'lastlist']" mode="widget-stock"/>
	<xsl:template match="udata[@method = 'lastlist'][items/item]" mode="widget-stock" >
	    <xsl:param name='class-widget' select="'widget Productsonsale'" />
	    <div class="{$class-widget}">
            <h3 class="widget-title widget-title "><xsl:value-of select="items/item[1]/@lent_name" /></h3>
            <ul class="adverts">
                <xsl:apply-templates select="items/item" mode="widget-stock-list" />
            </ul>
         </div>
    </xsl:template>


    <xsl:template match="item"  mode="widget-stock-list">
        <li>
            <a href="{@link}">
                <xsl:choose>
                    <xsl:when test=".//property[@name = 'anons_pic']/value">
                        <xsl:attribute name="class">advert</xsl:attribute>
                        <xsl:call-template name="all-thumbnail-path">
                            <xsl:with-param name="width" select="'220'" />
                            <xsl:with-param name="height" select="'220'" />
                            <xsl:with-param name="path" select=".//property[@name = 'anons_pic']/value" />
                            <xsl:with-param name="full" select="'care'" />
                            <xsl:with-param name="quality" select="'100'" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="text()" />
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </li>
    </xsl:template>
    
    <xsl:template match="property"  mode="anons-content">
        <div class="box-content">
            <xsl:value-of select="value" disable-output-escaping="yes" />
        </div>
    </xsl:template>
    
    <xsl:template match="property"  mode="user_author">
        <li><i class="icon-user"></i> &nbsp; <xsl:value-of select="value" /></li>
    </xsl:template>
    
    <xsl:template match="udata[@method = 'lastlist']" mode="footer-stock"/>
    <xsl:template match="udata[@method = 'lastlist'][items/item]" mode="footer-stock" >
        <xsl:param name='class-widget' select="'widget Productsonsale'" />
        <h6><xsl:value-of select="items/item[1]/@lent_name" /></h6>
        <ul class="list-chevron links">
            <xsl:apply-templates select="items/item" mode="footer-stock-list" />
        </ul>
    </xsl:template>
    
    <xsl:template match="item"  mode="footer-stock-list">
        <li>
            <a href="{@link}"><xsl:value-of select="." /></a>
            <small><xsl:value-of select="document(concat('udata://system/convertDate/', @publish_time,'/(d.m.Y)'))/udata" /></small>
        </li>
    </xsl:template>
    
</xsl:stylesheet>