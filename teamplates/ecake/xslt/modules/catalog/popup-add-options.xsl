<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet	version="1.0"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:umi="http://www.umi-cms.ru/TR/umi"
				xmlns:date="http://exslt.org/dates-and-times"
				xmlns:udt="http://umi-cms.ru/2007/UData/templates"
				xmlns:xlink="http://www.w3.org/TR/xlink"
				exclude-result-prefixes="xsl date udt xlink">
 
	<xsl:output encoding="utf-8" method="html" indent="no" />
 
	<xsl:template match="/">
	    <div id="add_options_{udata/page/@id}" class="modal hide fade" tabindex="-1">
	        <form class="options" action="/emarket/basket/put/element/{udata/page/@id}/">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <div class="hgroup title">
                        <h3>Опции товара</h3>                        
                        <h5>Выберите нужные опции</h5>
                    </div>
                </div>
                <div class="modal-body">
                     <xsl:apply-templates select="//group[@name = 'catalog_option_props']" mode="radio-option" />
                   <!-- <xsl:apply-templates select="//group[@name = 'catalog_option_props']/property" />
                    <input type="submit" class="button" value="Добавить" /> -->
                </div>
                <div class="modal-footer">  
                    <div class="pull-right">
                        <button class="btn btn-primary button" type="submit">
                           <i class="fa fa-plus"></i> &#160; Добавить в корзину
                        </button>
                    </div>
                </div>
              </form>
        </div>
	</xsl:template>
	
	<xsl:template match="group" mode="radio-option">
        <xsl:if test="count(//option) &gt; 0">
            <div class="options">
                <xsl:apply-templates select="property" mode="radio-option" />
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="option" mode="radio-option">
        <!-- <button type="button" class="btn btn-primary small"><xsl:if test="position() = 1"><xsl:attribute name="class">btn btn-primary active</xsl:attribute></xsl:if> -->
        <label class="btn btn-primary small"><xsl:if test="position() = 1"><xsl:attribute name="class">btn btn-primary active</xsl:attribute></xsl:if>
            <input name="options[{../../@name}]" type="radio" value="{object/@id}" data-float="{@float}" class="not-styler">
                <xsl:if test="position() = 1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
             <xsl:value-of select="object/@name" />
        </label>
        <!-- </button> -->
    </xsl:template>
    
    <xsl:template match="property" mode="radio-option" />
    <xsl:template match="property[value/option]" mode="radio-option">
        <div class="options-row">
            <span class=""><xsl:value-of select="concat(title, ':')" /></span>
            <div class="btn-group" data-toggle="buttons-radio">
                 <xsl:apply-templates select="value/option" mode="radio-option" />
            </div>
        </div>
    </xsl:template>

	<xsl:template match="property">
		<table>
			<thead>
				<tr>
					<th colspan="3" align="left">
						<xsl:value-of select="concat(title, ':')" />
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="value/option" />
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="option">
		<tr>
			<td style="width:20px;">
				<input type="radio" name="options[{../../@name}]" value="{object/@id}" id="{generate-id()}">
					<xsl:if test="position() = 1">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
			</td>
			<td>
				<label for="{generate-id()}">
					<xsl:value-of select="object/@name" />
				</label>
			</td>
			<td align="right">
				<label for="{generate-id()}">
					<xsl:value-of select="@float" />
				</label>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>