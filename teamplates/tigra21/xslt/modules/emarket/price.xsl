<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="udata[@method = 'price']">
		<xsl:apply-templates select="price" />
	</xsl:template>
	
	<xsl:template match="total-price">
		<xsl:value-of select="concat(@prefix, ' ', format-number(actual, '### ###', 'price'), ' ', @suffix)" />
	</xsl:template>
	
	<xsl:template match="property[@name='total_original_price' or @name='total_price']">
		<xsl:value-of select="concat(@prefix, ' ', format-number(value, '### ###', 'price'), ' ', @suffix)" />
	</xsl:template>

	<xsl:template match="price" mode="discounted-price">
		<span class="old">
			<xsl:value-of select="@prefix" /><xsl:text> </xsl:text><span class="price"><xsl:value-of select="format-number(original, '### ###', 'price')" /></span><xsl:text> </xsl:text><xsl:value-of select="@suffix" />
		</span>
		<span>
			<xsl:value-of select="@prefix" /><xsl:text> </xsl:text><span class="price"><xsl:value-of select="format-number(actual, '### ###', 'price')" /></span><xsl:text> </xsl:text><xsl:value-of select="@suffix" />
		</span>
	</xsl:template>
	
	<xsl:template match="price[not(original) or original = '']" mode="discounted-price">
		<xsl:value-of select="@prefix" /><xsl:text> </xsl:text><span class="price"><xsl:value-of select="format-number(actual, '### ###', 'price')" /></span><xsl:text> </xsl:text><xsl:value-of select="@suffix" />
	</xsl:template>
	

	<xsl:template match="price">
		<xsl:value-of select="concat(@prefix, ' ', format-number(original, '### ###', 'price'), ' ', @suffix)" />
	</xsl:template>

	<xsl:template match="price[not(original) or original = '']">
		<xsl:value-of select="concat(@prefix, ' ', format-number(actual, '### ###', 'price'), ' ', @suffix)" />
	</xsl:template>
	
	<xsl:template match="original" priority="1">
        <xsl:value-of select="format-number(., '### ###', 'price')" />
    </xsl:template>
    
	<xsl:template match="actual" priority="1">
        <xsl:value-of select="format-number(., '### ###', 'price')" />
    </xsl:template>
    
	<xsl:template match="price" mode="discounted-price-object">
	    <span class="price">
		  <span class="old"><xsl:value-of select="concat(@prefix, ' ', format-number(original, '### ###', 'price'), ' ', @suffix)" /></span>
		  <span class="new"><xsl:value-of select="concat(@prefix, ' ', format-number(actual, '### ###', 'price'), ' ', @suffix)" /></span>
		</span>
	</xsl:template>
    
	<xsl:template match="price" mode="discounted-price-object">
	    <span class="price" id="price" data-suffix="{@suffix}" data-prefix="{@prefix}"  data-original="{original}" data-actual="{actual}">
		  <span class="old"><xsl:value-of select="concat(@prefix, ' ', format-number(original, '### ###', 'price'), ' ', @suffix)" /></span>
		  <span class="new"><xsl:value-of select="concat(@prefix, ' ', format-number(actual, '### ###', 'price'), ' ', @suffix)" /></span>
		</span>
	</xsl:template>

	<xsl:template match="price[not(original) or original = '']" mode="discounted-price-object">
	    <span class="price" id="price" data-suffix="{@suffix}" data-prefix="{@prefix}" data-original="" data-actual="{actual}">
	        <span class="new"><xsl:value-of select="concat(@prefix, ' ', format-number(actual, '### ###', 'price'), ' ', @suffix)" /></span>
        </span>
	</xsl:template>
	

</xsl:stylesheet>
