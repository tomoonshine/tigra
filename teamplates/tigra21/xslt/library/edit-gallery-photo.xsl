<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:umi="http://www.umi-cms.ru/TR/umi"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:udt="http://umi-cms.ru/2007/UData/templates"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                exclude-result-prefixes="xsl date udt xlink">
 
    <xsl:output encoding="utf-8" method="html" indent="no" />
    <xsl:variable name="pid" select="udata/page/@id" />
    <xsl:variable name="object-id" select="udata/page/@object-id" />
    <xsl:variable name="module" select="udata/page/basetype/@module" />
    <xsl:variable name="method" select="udata/page/basetype/@method" />
    
    <xsl:template match="/">
        <div id="edit_photo_{$pid}" class="modal hide fade" tabindex="-1">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <div class="hgroup title">
                    <h3>Редактирование фотогалереи</h3>
                </div>
            </div>
            <div class="modal-body">
                 <xsl:apply-templates select=".//property" />
            </div>
            <div class="modal-footer">  
                <div class="pull-right">
                    <button class="btn btn-primary button">
                       <i class="fa fa-check"></i> &#160; Сохранить изменения
                    </button>
                </div>
            </div>
        </div>
        
        <link type="text/css" rel="stylesheet" href="/styles/skins/mac/design/css/custom.style.css" />
    </xsl:template>
    
    <xsl:template match="property" />
    <xsl:template match="property[@name='photo_new_field']">
        
        <xsl:variable name="folder_custom">
            <xsl:choose>
                <xsl:when test="$module='catalog'">
                    <xsl:text>./images/</xsl:text><xsl:value-of select="$module" /><xsl:text>/</xsl:text><xsl:value-of select="$method" /><xsl:text>/</xsl:text><xsl:value-of select="$pid" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>./images/cms/data/</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <div class="field full_width field_drag_photo" id="{generate-id()}" umi:folder="{$folder_custom}"
                    umi:input-name="data[{$object-id}][{@name}]">
            <ul class="uploaded_photo">
               <xsl:apply-templates select="value" mode="split">
                    <xsl:with-param name="worddiv" select="';'"/>
                </xsl:apply-templates>
                <li class="drag_photo"
                    data-folder="{$folder_custom}"
                    data-inputname="data[{$object-id}][{@name}]"
                ><label>+<input type="file" name="{@name}" /></label></li>
                <li class="clear" />
            </ul>
            <label for="{generate-id()}">
                <textarea name="data[{$object-id}][{@name}]" id="{generate-id()}">
                    <xsl:value-of select="value" />
                </textarea>
            </label>
        </div>
    </xsl:template>
    
    <xsl:template name="token">
     <xsl:param name="token"/>
     <xsl:variable name="folder_custom">
        <xsl:choose>
            <xsl:when test="$module='catalog'">
                <xsl:text>./images/</xsl:text><xsl:value-of select="$module" /><xsl:text>/</xsl:text><xsl:value-of select="$method" /><xsl:text>/</xsl:text><xsl:value-of select="$pid" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>./images/cms/data/</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
     <xsl:if test="$token">
         <li>
            <img src="{document(concat('udata://content/makeThumbnailCare/(.', $token,')/auto/100////1/(', $folder_custom,')'))/udata/src}" alt="" title="" data-original-src="{$token}" />
            <span class="close">x</span>
        </li>
    </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="split" match="text()" mode="split">
        <xsl:param name="str" select="."/>
        <xsl:param name="worddiv" select="','"/>
        
        <xsl:choose>
         
         <xsl:when test="contains($str,$worddiv)">
          <xsl:call-template name="token">
           <xsl:with-param name="token" select="substring-before($str, $worddiv)"/>
          </xsl:call-template>
          <xsl:call-template name="split"> 
           <xsl:with-param name="str" select="substring-after($str, $worddiv)"/>
           <xsl:with-param name="worddiv" select="$worddiv"/>
          </xsl:call-template>
         </xsl:when>
         
         <xsl:otherwise>
          <xsl:call-template name="token">
           <xsl:with-param name="token" select="$str"/>
          </xsl:call-template>
         </xsl:otherwise>
         
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>