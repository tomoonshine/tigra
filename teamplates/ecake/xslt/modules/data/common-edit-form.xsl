<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="udata[@method = 'getCreateForm' or @method = 'getEditForm']">
		<xsl:apply-templates select="group" mode="form" />
	</xsl:template>
	
	<xsl:template match="group" mode="form">
		<h4>
			<xsl:value-of select="@title" />
		</h4>
		<xsl:apply-templates select="field" mode="form" />
	</xsl:template>


	<xsl:template match="field" mode="form">
		<div>
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<input type="text" name="{@input_name}" value="{.}" class="textinputs" />
			</label>
		</div>
	</xsl:template>


	<xsl:template match="field[@type = 'relation']" mode="form">
		<div>
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<select name="{@input_name}">
					<xsl:if test="@multiple = 'multiple'">
						<xsl:attribute name="multiple">multiple</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="values/item" mode="form" />
				</select>
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="form">
		<option value="{@id}">
			<xsl:copy-of select="@selected" />
			<xsl:value-of select="." />
		</option>
	</xsl:template>


	<xsl:template match="field[@type = 'boolean']" mode="form">
		<div>
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<input type="hidden" name="{@input_name}" value="0" />
				<input type="checkbox" name="{@input_name}" value="1">
					<xsl:copy-of select="@checked" />
				</input>
			</label>
		</div>
	</xsl:template>


	<xsl:template match="field[@type = 'text' or @type = 'wysiwyg']" mode="form">
		<div>
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<textarea name="{@input_name}" class="textinputs">
					<xsl:value-of select="." />
				</textarea>
			</label>
		</div>
	</xsl:template>


	<xsl:template match="field[@type = 'file' or @type = 'img_file']" mode="form">
		<div>
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<input type="file" name="{@input_name}" class="textinputs" />
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="field" mode="form-address-street">
		<label title="{@tip}">
			<xsl:apply-templates select="@required" mode="form" />
			<span class="span5">
				<xsl:value-of select="concat(@title, ':')" />
			</span>
			<input type="text" name="{@input_name}" class="span10" />
		</label>
	</xsl:template>
	
	<xsl:template match="field" mode="form-address-span2">
		<div class="span2">
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<input type="text" name="{@input_name}" class="span12" />
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="field" mode="form-address-span5">
		<div class="span5">
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<input type="text" name="{@input_name}" class="span12" />
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="field" mode="form-address-span1">
		<div class="span1">
			<label title="{@tip}">
				<xsl:apply-templates select="@required" mode="form" />
				<span>
					<xsl:value-of select="concat(@title, ':')" />
				</span>
				<input type="text" name="{@input_name}" class="span12" />
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="field" mode="form-address-comments">
		<label title="{@tip}">
			<xsl:apply-templates select="@required" mode="form" />
			<span class="span2">
				<xsl:value-of select="concat(@title, ':')" />
			</span>
			<span class="span8">
				<textarea name="{@input_name}" class="span12">
					<xsl:value-of select="." />
				</textarea>
			</span>
		</label>
	</xsl:template>
	
	<xsl:template match="field[@type = 'relation']" mode="form-address-city">
		<xsl:variable name="getCity" select="document('udata://settings_site/getSortedCity')/udata" />
		<label title="{@tip}">
			<xsl:apply-templates select="@required" mode="form" />
			<span class="span2">
				<xsl:value-of select="concat(@title, ':')" />
			</span>
			<select name="{@input_name}" class="span5" id="city">
				<xsl:if test="@multiple = 'multiple'">
					<xsl:attribute name="multiple">multiple</xsl:attribute>
				</xsl:if>
				<option value="">Выберите город</option>
				<xsl:apply-templates select="$getCity/sorted" mode="form">
					<xsl:with-param name="count_item" select="count($getCity/items/item)" />
				</xsl:apply-templates>
				<xsl:apply-templates select="$getCity/items/item" mode="form" />
				<!-- <xsl:apply-templates select="values/item" mode="form" /> -->
			</select>
		</label>
	</xsl:template>
	
	<xsl:template match="sorted" mode="form">
		<xsl:param name="count_item" />
		<xsl:apply-templates select="item" mode="form-sorted">
			<xsl:with-param name="count_item" select="$count_item" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="item" mode="form-sorted">
		<xsl:param name="count_item" />
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="count_item" select="$count_item" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="item[position() = last()]" mode="form-sorted">
		<xsl:param name="count_item" />
		<option value="{@id}" test="{$count_item}">
			<xsl:copy-of select="@selected" />
			<xsl:value-of select="." />
		</option>
		<xsl:if test="$count_item &gt; 0"><option disabled="disabled" class="last-list-sorted" value=""></option></xsl:if>
	</xsl:template>
	
	<xsl:template match="field" mode="registrate">
	    <div class="control-group">
	        <xsl:apply-templates select="@required" mode="registrate" />
            <label class="control-label" for="{@name}"><xsl:value-of select="@title" /> <xsl:apply-templates select="@required" mode="registrate-text" /></label>
            <div class="controls">
                <input class="span12" type="text" id="{@name}" name="{@input_name}" value="" />
            </div>
        </div>
    </xsl:template>
	
	<xsl:template match="field" mode="registrate-fname" />
	<xsl:template match="field" mode="registrate-fname">
		<xsl:param name="required_lname" />
		<xsl:param name="required_father_name" />
	    <div class="control-group">
			<xsl:if test="@required or $required_lname or $required_father_name"><xsl:attribute name="class">control-group required</xsl:attribute></xsl:if>
            <label class="control-label" for="full_name">Фамилия Имя Отчество<xsl:if test="@required or $required_lname or $required_father_name">&#160;<i class="fa fa-asterisk"></i></xsl:if></label>
            <div class="controls">
                <input class="span12" type="text" id="full_name" name="full_name" value="" />
            </div>
        </div>
    </xsl:template>
	
	<xsl:template match="field[@name='email']" mode="registrate">
	    <div class="control-group">
	        <xsl:apply-templates select="@required" mode="registrate" />
            <label class="control-label" for="{@name}"><xsl:value-of select="@title" /> <xsl:apply-templates select="@required" mode="registrate-text" /></label>
            <div class="controls">
                <input class="span12" type="text" id="{@name}" name="{@name}" value="" />
            </div>
        </div>
    </xsl:template>
	
	
	<xsl:template match="field" mode="with-wrapper-registrate">
		<div class="span6">
			<xsl:apply-templates select="." mode="registrate" />
		</div>
    </xsl:template>
	
	<xsl:template match="field[position() mod 2 = 1]" mode="with-wrapper-registrate">
		<div class="span6 reset-margin-left">
			<xsl:apply-templates select="." mode="registrate" />
		</div>
    </xsl:template>	
	
	<xsl:template match="@required" mode="form">
		<xsl:attribute name="class">required</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@required" mode="registrate">
		<xsl:attribute name="class">control-group required</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@required" mode="registrate-text">&#160;<i class="fa fa-asterisk"></i></xsl:template>
</xsl:stylesheet>