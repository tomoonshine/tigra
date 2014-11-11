<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:date="http://exslt.org/dates-and-times"
				xmlns:udt="http://umi-cms.ru/2007/UData/templates"
				xmlns:xlink="http://www.w3.org/1999/xlink"
				exclude-result-prefixes="xsl date udt xlink">

	<xsl:template match="udata[@module = 'webforms'][@method = 'add']">
		<form method="post" action="{$lang-prefix}/webforms/send/" onsubmit="site.forms.data.save(this); return site.forms.data.check(this);" enctype="multipart/form-data">
			<xsl:apply-templates select="items" mode="address" />
			<xsl:apply-templates select="groups/group" mode="webforms" />
			<input type="hidden" name="system_form_id" value="{/udata/@form_id}" />
			<input type="hidden" name="ref_onsuccess" value="{$lang-prefix}/webforms/posted/{/udata/@form_id}/" />
			<div class="form_element">
				<xsl:apply-templates select="document('udata://system/captcha/')/udata" />
			</div>
			<div class="row-fluid">
			    <div class="span12">
			        <input class="btn btn-primary" type="submit" value="Отправить" />
				</div>
			</div>
		</form>
	</xsl:template>
	
	<xsl:template match="udata[@module = 'webforms'][@method = 'add']" mode="callback">
		<div id="callback" class="modal hide fade" tabindex="-1" role="dialog">
			<form method="post" action="{$lang-prefix}/webforms/send/" onsubmit="site.forms.data.save(this); return site.forms.data.check(this);" enctype="multipart/form-data">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<div class="hgroup title">
						<h3>Заказать обратный звонок</h3>
					</div>
				</div>
				<div class="modal-body">
					<xsl:apply-templates select="items" mode="address" />
					<xsl:apply-templates select="groups/group" mode="webforms" />
					<input type="hidden" name="system_form_id" value="{/udata/@form_id}" />
					<input type="hidden" name="ref_onsuccess" value="{$lang-prefix}/webforms/posted/{/udata/@form_id}/" />
					<div class="form_element">
						<xsl:apply-templates select="document('udata://system/captcha/')/udata" />
					</div>
				</div>
				<div class="modal-footer">	
					<div class="pull-right">
						<div class="btn_line">
							<button class="btn btn-primary btn-small">
								Отправить &#160; <i class="fa fa-check"></i>
							</button>
							<i class="fa fa-spinner fa-spin"></i>
							<span class="text-spinner">Подождите...</span>
						</div>
					</div>
				</div>
			</form>
		</div>
	</xsl:template>

	<xsl:template match="group" mode="webforms">
	    <xsl:choose>
	        <xsl:when test="count(field) mod 2 = 0">
	            <xsl:apply-templates select="field" mode="webforms-even" />
	        </xsl:when>
	        <xsl:otherwise>
	            <xsl:apply-templates select="field" mode="webforms-odd" />
	        </xsl:otherwise>
	    </xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="field[position() mod 2 = 1]" mode="webforms-even" />
	<xsl:template match="field[position() mod 2 = 0]" mode="webforms-even">
	    <xsl:variable name="i" select="position()" />
	    <div class="row-fluid">
	        <xsl:apply-templates select="../field[$i - 1]" mode="webforms" />
	        <xsl:apply-templates select="../field[$i]" mode="webforms" />
        </div>
	</xsl:template>
	
	<xsl:template match="field[position() mod 2 = 0]" mode="webforms-odd" />
    <xsl:template match="field[position() mod 2 = 1]" mode="webforms-odd">
        <xsl:variable name="i" select="position()" />
        <div class="row-fluid">
            <xsl:apply-templates select="../field[$i]" mode="webforms" />
            <xsl:apply-templates select="../field[$i + 1]" mode="webforms" />
        </div>
    </xsl:template>

	<xsl:template match="field" mode="webforms">
	    <div class="span6">
            <div class="control-group">
                <xsl:apply-templates select="." mode="webforms_required" />
                <label for="{@name}" class="control-label"><xsl:value-of select="@title" /></label>
                <div class="controls">
                    <xsl:apply-templates select="." mode="webforms_input_type" />
                </div>
            </div>
        </div>
	</xsl:template>
	
	<xsl:template match="field[@type = 'text' or @type='wysiwyg']" mode="webforms">
        <div class="span12">
            <div class="control-group">
                <xsl:apply-templates select="." mode="webforms_required" />
                <label for="{@name}" class="control-label"><xsl:value-of select="@title" /></label>
                <div class="controls">
                    <xsl:apply-templates select="." mode="webforms_input_type" />
                </div>
            </div>
        </div>
    </xsl:template>

	<xsl:template match="field" mode="webforms_input_type">
		<input type="text" name="{@input_name}" id="{@name}" class="span12" />
	</xsl:template>
	
	<xsl:template match="field[contains(@name,'phone_')]" mode="webforms_input_type">
		<input type="text" name="{@input_name}" id="{@name}" class="span12 phone-valid" />
	</xsl:template>

	<xsl:template match="field[@type = 'text' or @type='wysiwyg']" mode="webforms_input_type">
		<textarea name="{@input_name}" id="{@name}" class="span12" style="height: 110px"></textarea>
	</xsl:template>

	<xsl:template match="field[@type = 'password']" mode="webforms_input_type">
		<input type="password" name="{@input_name}" id="{@name}" class="span12"/>
	</xsl:template>

	<xsl:template match="field[@type = 'boolean']" mode="webforms_input_type">
		<input type="hidden" id="{@input_name}" name="{@input_name}" value="" />
		<input onclick="javascript:document.getElementById('{@input_name}').value = this.checked;" type="checkbox" value="1" />
	</xsl:template>

	<xsl:template match="field[@type = 'relation']" mode="webforms_input_type">
		<select name="{@input_name}">
			<xsl:if test="@multiple">
				<xsl:attribute name="multiple">
					<xsl:text>multiple</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<option value=""></option>
			<xsl:apply-templates select="values/item" mode="webforms_input_type" />
		</select>
	</xsl:template>

	<xsl:template match="field[@type = 'file' or @type = 'img_file' or @type = 'swf_file' or @type = 'video_file']" mode="webforms_input_type">
		<xsl:text> &max-file-size; </xsl:text><xsl:value-of select="@maxsize" />Mb
		<input type="file" name="{@input_name}" class="textinputs"/>
	</xsl:template>

	<xsl:template match="item" mode="webforms_input_type">
		<option value="{@id}"><xsl:apply-templates /></option>
	</xsl:template>

	<xsl:template match="field" mode="webforms_required" />

	<xsl:template match="field[@required = 'required']" mode="webforms_required">
		<xsl:attribute name="class">
			<xsl:text>control-group required</xsl:text>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="items" mode="address">
		<xsl:apply-templates select="item" mode="address" />
	</xsl:template>

	<xsl:template match="item" mode="address">
		<input type="hidden" name="system_email_to" value="{@id}" />
	</xsl:template>

	<xsl:template match="items[count(item) &gt; 1]" mode="address">
		<xsl:choose>
			<xsl:when test="count(item[@selected='selected']) != 1">
				<div class="form_element">
					<label class="required">
						<span><xsl:text>Кому отправить:</xsl:text></span>
						<select name="system_email_to">
							<option value=""></option>
							<xsl:apply-templates select="item" mode="address_select" />
						</select>
					</label>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="item[@selected='selected']" mode="address" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="item" mode="address_select">
		<option value="{@id}"><xsl:apply-templates /></option>
	</xsl:template>

</xsl:stylesheet>
