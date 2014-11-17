<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template match="udata[@module = 'core' and @method = 'navibar']" />
	<xsl:template match="udata[@module = 'core' and @method = 'navibar'][items/item]">
		<ul class="breadcrumb pull-left">
			<xsl:apply-templates select="items/item" mode="navibar" />
		</ul>
	</xsl:template>
	
	<xsl:template match="udata[@module = 'core' and @method = 'navibar']" mode="object-view" />
	<xsl:template match="udata[@module = 'core' and @method = 'navibar'][items/item]" mode="object-view">
		<div>
			<ul class="breadcrumb">
				<li>
					<a href="{$lang-prefix}">Главная</a>
				</li>
				<xsl:apply-templates select="items/item" mode="navibar" />
			</ul>
		</div>
	</xsl:template>
	
	
	<xsl:template match="item" mode="navibar">
		<li>
			<a href="{@link}"><xsl:value-of select="text()" /></a>
		</li>
	</xsl:template>
	
	<xsl:template match="item[position() = last() - 1 ]" mode="navibar">
		<li class="active">
			<a href="{@link}"><xsl:value-of select="text()" /></a>
		</li>
	</xsl:template>
	
	<xsl:template match="item[position() = last() ]" mode="navibar" />
	
	<xsl:template match="item[@id = '36']" mode="navibar" />
	
</xsl:stylesheet>