<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM     "ulang://i18n/constants.dtd:file">
 
<xsl:stylesheet     version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umi="http://www.umi-cms.ru/TR/umi">
    <xsl:template name="catalog-thumbnail">
        <xsl:param name="element-id" />
        <xsl:param name="field-name" />
        <xsl:param name="empty" />
        <xsl:param name="width">auto</xsl:param>
        <xsl:param name="height">auto</xsl:param>
        <xsl:variable name="property" select="document(concat('upage://', $element-id, '.', $field-name))/udata/property" />
        <xsl:call-template name="thumbnail">
            <xsl:with-param name="width" select="$width" />
            <xsl:with-param name="height" select="$height" />
            <xsl:with-param name="element-id" select="$element-id" />
            <xsl:with-param name="field-name" select="$field-name" />
            <xsl:with-param name="empty" select="$empty" />
            <xsl:with-param name="src">
                <xsl:choose>
                    <xsl:when test="$property/value">
                        <xsl:value-of select="$property/value" />
                    </xsl:when>
                    <xsl:otherwise>&empty-photo;</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
     
    <xsl:template name="thumbnail">
		<xsl:param name="src" />
		<xsl:param name="width">auto</xsl:param>
		<xsl:param name="height">auto</xsl:param>
		<xsl:param name="empty" />
		<xsl:param name="align" />
		<xsl:param name="item" />
		<xsl:param name="quality" select="'80'" />
		<xsl:param name="only-src" select="false()" />
		
		<xsl:param name="element-id" />
		<xsl:param name="field-name" />
		<xsl:choose>
			<xsl:when test="$only-src = true()">
				<xsl:apply-templates select="document(concat('udata://system/makeThumbnailFull/(.', $src, ')/', $width, '/', $height, '/void/0/1///', $quality))/udata" mode="only-src" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document(concat('udata://system/makeThumbnailFull/(.', $src, ')/', $width, '/', $height, '/void/0/1///', $quality))/udata">
					<xsl:with-param name="element-id" select="$element-id" />
					<xsl:with-param name="field-name" select="$field-name" />
					<xsl:with-param name="empty" select="$empty" />
					<xsl:with-param name="align" select="$align" />
					<xsl:with-param name="item" select="$item" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="udata[@module = 'system' and (@method = 'makeThumbnail' or @method = 'makeThumbnailFull')]">
		<xsl:param name="element-id" />
		<xsl:param name="field-name" />
		<xsl:param name="empty" />
		<xsl:param name="align" />
		<xsl:param name="item" />
		
		<img src="{src}" width="{width}" height="{height}">
			<xsl:if test="$element-id and $field-name">
				<xsl:attribute name="umi:element-id">
					<xsl:value-of select="$element-id" />
				</xsl:attribute>
				
				<xsl:attribute name="umi:field-name">
					<xsl:value-of select="$field-name" />
				</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$align">
				<xsl:attribute name="align">
					<xsl:value-of select="$align" />
				</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$empty">
				<xsl:attribute name="umi:empty">
					<xsl:value-of select="$empty" />
				</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$item = 1">
				<xsl:attribute name="itemprop">image</xsl:attribute>
			</xsl:if>			
		</img>
	</xsl:template>
 
    <!-- all-thumbnail -->
    <xsl:template name="all-thumbnail">
        <xsl:param name="element-id" />
        <xsl:param name="field-name" />
        <xsl:param name="empty_eip_value" select="'фото'"/>
        <xsl:param name="empty_img" select="'&empty-photo;'"/>
        <xsl:param name="width" select="'auto'" />
        <xsl:param name="height" select="'auto'" />
        <xsl:param name="alt" select="''" />
        <xsl:param name="title" select="''" />
        <xsl:param name="rel" select="''" />
        <xsl:param name="class" select="''" />
        <xsl:param name="id" select="''" />
        <xsl:param name="quality" select="80" />
        <xsl:param name="full" select="'full'" />
        <xsl:param name="bg" select="'false'" />
        <xsl:param name="only-src" select="false()" />
        <xsl:param name="gallery-split" select="false()" />
        <xsl:variable name="property" select="document(concat('upage://', $element-id, '.', $field-name))/udata/property" />
        <xsl:variable name="src">
            <xsl:choose>
                <xsl:when test="$property/value">
                    <xsl:value-of select="$property/value" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$empty_img" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$full='full'">
                <xsl:apply-templates select="document(concat('udata://system/makeThumbnailFull/(.', $src, ')/', $width, '/', $height, '/void/0/1/2//',$quality))/udata" mode="all-thumbnail">
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
                    <xsl:with-param name="empty_eip_value" select="$empty_eip_value" />
                    <xsl:with-param name="alt" select="$alt" />
                    <xsl:with-param name="title" select="$title" />
                    <xsl:with-param name="rel" select="$rel" />
                    <xsl:with-param name="class" select="$class" />
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="bg" select="$bg" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$full='care'">
                <xsl:apply-templates select="document(concat('udata://content/makeThumbnailCare/(.', $src, ')/', $width, '/', $height, '/void/0/0'))/udata" mode="all-thumbnail">
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
                    <xsl:with-param name="empty_eip_value" select="$empty_eip_value" />
                    <xsl:with-param name="alt" select="$alt" />
                    <xsl:with-param name="title" select="$title" />
                    <xsl:with-param name="rel" select="$rel" />
                    <xsl:with-param name="class" select="$class" />
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="bg" select="$bg" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$only-src = true()">
                <xsl:apply-templates select="document(concat('udata://content/makeThumbnailCare/(.', $src, ')/', $width, '/', $height, '/void/0/0'))/udata" mode="only-src" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document(concat('udata://system/makeThumbnail/(.', $src, ')/', $width, '/', $height,'////',$quality))/udata" mode="all-thumbnail" >
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
                    <xsl:with-param name="empty_eip_value" select="$empty_eip_value" />
                    <xsl:with-param name="alt" select="$alt" />
                    <xsl:with-param name="title" select="$title" />
                    <xsl:with-param name="rel" select="$rel" />
                    <xsl:with-param name="class" select="$class" />
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="bg" select="$bg" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
      
    <!-- all-thumbnail-path -->
    <xsl:template name="all-thumbnail-path">
        <xsl:param name="path" />
        <xsl:param name="element-id" />
        <xsl:param name="field-name" />
        <xsl:param name="empty_eip_value" select="'фото'"/>
        <xsl:param name="empty_img" select="'&empty-photo;'"/>
        <xsl:param name="width" select="'auto'" />
        <xsl:param name="height" select="'auto'" />
        <xsl:param name="alt" select="''" />
        <xsl:param name="title" select="''" />
        <xsl:param name="rel" select="''" />
        <xsl:param name="class" select="''" />
        <xsl:param name="id" select="''" />
        <xsl:param name="quality" select="80" />
        <xsl:param name="full" select="'full'" />
        <xsl:param name="bg" select="'false'" />
        <xsl:param name="only-src" select="false()" />
        <xsl:param name="data-zoom" select="false()" />
        <xsl:param name="nameItem" select="''" />
        <xsl:param name="gallery-split" select="false()" />
        <xsl:param name="settings_catalog" select="$settings_catalog" />
        <xsl:variable name="src">
            <xsl:choose>
                <xsl:when test="$path">
                    <xsl:value-of select="$path" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$empty_img" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		
		<xsl:variable name="setting_crop">
            <xsl:choose>
				<xsl:when test="$settings_catalog[@name='crop'] = 'full_center' or $settings_catalog[@name='crop'] = 'full_top'">full</xsl:when>
				<xsl:otherwise>care</xsl:otherwise>
			</xsl:choose> 
        </xsl:variable>
		<xsl:variable name="setting_crop_side">
            <xsl:choose>
				<xsl:when test="$settings_catalog[@name='crop'] = 'full_top'">2</xsl:when>
				<xsl:otherwise>5</xsl:otherwise>
			</xsl:choose> 
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$full='full' or ($full='' and $setting_crop='full')">
                <xsl:apply-templates select="document(concat('udata://system/makeThumbnailFull/(.', $src, ')/', $width, '/', $height, '/void/0/1/',$setting_crop_side,'//',$quality))/udata" mode="all-thumbnail">
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
                    <xsl:with-param name="empty_eip_value" select="$empty_eip_value" />
                    <xsl:with-param name="alt" select="$alt" />
                    <xsl:with-param name="title" select="$title" />
                    <xsl:with-param name="rel" select="$rel" />
                    <xsl:with-param name="class" select="$class" />
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="bg" select="$bg" />
                    <xsl:with-param name="data-zoom" select="$data-zoom" />
                    <xsl:with-param name="nameItem" select="$nameItem" />
                    <xsl:with-param name="gallery-split" select="$gallery-split" />
                </xsl:apply-templates>
            </xsl:when>
             <xsl:when test="$only-src = true()">
                <xsl:apply-templates select="document(concat('udata://content/makeThumbnailCare/(.', $src, ')/', $width, '/', $height, '/void/0/1'))/udata" mode="only-src" />
            </xsl:when>
            <xsl:when test="$full='care' or ($full='' and $setting_crop='care')">
                <xsl:apply-templates select="document(concat('udata://content/makeThumbnailCare/(.', $src, ')/', $width, '/', $height, '/void/0/1'))/udata" mode="all-thumbnail">
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
                    <xsl:with-param name="empty_eip_value" select="$empty_eip_value" />
                    <xsl:with-param name="alt" select="$alt" />
                    <xsl:with-param name="title" select="$title" />
                    <xsl:with-param name="rel" select="$rel" />
                    <xsl:with-param name="class" select="$class" />
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="bg" select="$bg" />
                    <xsl:with-param name="data-zoom" select="$data-zoom" />
                    <xsl:with-param name="nameItem" select="$nameItem" />
                    <xsl:with-param name="gallery-split" select="$gallery-split" />
                </xsl:apply-templates>
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:apply-templates select="document(concat('udata://system/makeThumbnail/(.', $src, ')/', $width, '/', $height,'////',$quality))/udata" mode="all-thumbnail" >
                    <xsl:with-param name="element-id" select="$element-id" />
                    <xsl:with-param name="field-name" select="$field-name" />
                    <xsl:with-param name="empty_eip_value" select="$empty_eip_value" />
                    <xsl:with-param name="alt" select="$alt" />
                    <xsl:with-param name="title" select="$title" />
                    <xsl:with-param name="rel" select="$rel" />
                    <xsl:with-param name="class" select="$class" />
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="bg" select="$bg" />
                    <xsl:with-param name="data-zoom" select="$data-zoom" />
                    <xsl:with-param name="nameItem" select="$nameItem" />
                    <xsl:with-param name="gallery-split" select="$gallery-split" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
     
    <xsl:template match="udata[@method = 'makeThumbnail' or @method = 'makeThumbnailFull'or @method = 'makeThumbnailCare']" mode="all-thumbnail">
        <xsl:param name="element-id" />
        <xsl:param name="field-name" />
        <xsl:param name="empty_eip_value" />
        <xsl:param name="alt" select="''" />
        <xsl:param name="title" select="''" />
        <xsl:param name="rel" select="''" />
        <xsl:param name="class" select="''" />
        <xsl:param name="id" select="''" />
        <xsl:param name="bg" select="'false'" />
        <xsl:param name="data-zoom" select="false()" />
        <xsl:param name="nameItem" select="''" />
		<xsl:param name="gallery-split" select="false()" />
		
        <img  src="{src}" width="{width}" height="{height}">
            <xsl:if test="$bg='true'">
                <xsl:attribute name="src">/images/blank.gif</xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:value-of select="width" />
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="height" />
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:value-of select="concat('background:url(',src,') no-repeat center center')" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$alt">
                <xsl:attribute name="alt">
                    <xsl:value-of select="$alt" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$title">
                <xsl:attribute name="title">
                    <xsl:value-of select="$title" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$rel">
                <xsl:attribute name="rel">
                    <xsl:value-of select="$rel" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class">
                    <xsl:value-of select="$class" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$id">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$element-id and $field-name">
                <xsl:attribute name="umi:element-id">
                    <xsl:value-of select="$element-id" />
                </xsl:attribute>
                <xsl:attribute name="umi:field-name">
                    <xsl:value-of select="$field-name" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$empty_eip_value">
                <xsl:attribute name="umi:empty">
                    <xsl:value-of select="$empty_eip_value" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="not($data-zoom = '')">
                <xsl:attribute name="data-zoom-image">
                    <xsl:value-of select="$data-zoom" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$gallery-split = true()">
                <xsl:attribute name="umi:gallery-split">
                    <xsl:value-of select="$gallery-split" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$nameItem"><xsl:attribute name="alt"><xsl:value-of select="$nameItem" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$nameItem" /></xsl:attribute></xsl:if>
        </img>
    </xsl:template>
    
    <xsl:template match="udata[@method = 'makeThumbnail' or @method = 'makeThumbnailFull' or @method = 'makeThumbnailCare']" mode="only-src">
        <xsl:value-of select="src" />
    </xsl:template>
    
</xsl:stylesheet>