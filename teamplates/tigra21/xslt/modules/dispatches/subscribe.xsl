<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:date="http://exslt.org/dates-and-times"
				xmlns:udt="http://umi-cms.ru/2007/UData/templates"
				xmlns:xlink="http://www.w3.org/1999/xlink"
				exclude-result-prefixes="xsl date udt xlink">

	<xsl:template match="udata[@module = 'dispatches'][@method = 'subscribe']" mode="right">
		<div class="infoblock">
			<div class="title"><h2><xsl:text>&newsletters;</xsl:text></h2></div>
			<div class="body">
				<div class="in">
					<form action="/dispatches/subscribe_do/" name="sbs_frm" method="post">
						<ul>
							<li><input	type="text"
									onblur="if(this.value == '') this.value = '&e-mail;';"
									onfocus="if(this.value == '&e-mail;') this.value = '';"
									value="&e-mail;"
									class="input"
									id="subscribe"
									name="sbs_mail" /></li>
						</ul>
						<input type="submit" class="button" value="&subscribe;" />
					</form>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="udata[@module = 'dispatches'][@method = 'subscribe'][subscriber_dispatches]" mode="right">
		<xsl:apply-templates select="subscriber_dispatches" mode="right" />
	</xsl:template>

	<xsl:template match="subscriber_dispatches" mode="right" />

	<xsl:template match="subscriber_dispatches[items]" mode="right">
		<div class="infoblock">
			<div class="title"><h2><xsl:text>&newsletters;</xsl:text></h2></div>
			<div class="body">
				<div class="in">
					<form action="/dispatches/subscribe_do/" name="sbs_frm" method="post">
						<ul><xsl:apply-templates select="items" mode="dispatches" /></ul>
						<input type="submit" class="button" value="&subscribe;" />
					</form>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="result[@module = 'dispatches'][@method = 'subscribe']">
		<p class="lead">Подписки</p>                                               
		<form action="/dispatches/subscribe_do/" enctype="multipart/form-data" method="post" id="subscribe-form">
		<table class="table table-lk">
			<tbody>
				<xsl:apply-templates select="document('udata://dispatches/subscribe/?extProps=disp_description')/udata" />
				<tr>
					<th colspan="3"><div class="btn_line"><input type="submit" class="btn btn-turquoise btn-small" value="сохранить" /><i class="fa fa-spinner fa-spin"></i>
						<span class="text-spinner">Подождите...</span></div></th>
				</tr>
			</tbody>
		</table>
		</form>
		
		
		<!-- <form action="/dispatches/subscribe_do/" enctype="multipart/form-data" name="sbs_frm" method="post">
			<xsl:apply-templates select="document('udata://dispatches/subscribe/')/udata" />
			<input type="submit" class="button" value="&subscribe;" />
		</form> -->
	</xsl:template>

	<xsl:template match="udata[@module = 'dispatches'][@method = 'subscribe']">
		<tr>
			<th>Пока нет ни одной подписки</th>
			<td></td>
			<td></td>   
		</tr>
		<!-- <div>
			<input	type="text"
					onblur="javascript: if(this.value == '') this.value = '&e-mail;';"
					onfocus="javascript: if(this.value == '&e-mail;') this.value = '';"
					value="&e-mail;"
					class="input"
					id="subscribe"
					name="sbs_mail" />
		</div> -->
	</xsl:template>

	<xsl:template match="udata[@module = 'dispatches'][@method = 'subscribe'][subscriber_dispatches]">
		<xsl:apply-templates select="subscriber_dispatches" />
	</xsl:template>

	<xsl:template match="subscriber_dispatches" />
	<xsl:template match="subscriber_dispatches[items]">
		<xsl:apply-templates select="items" mode="dispatches" />
	</xsl:template>

	<xsl:template match="items" mode="dispatches">
		<tr>
			<th><xsl:value-of select="text()" /></th>
			<td>
				<input type="checkbox" name="subscriber_dispatches[{@id}]" value="{@id}">
					<xsl:if test="@is_checked = '1'">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
			</td>
			<td>
				<xsl:value-of select=".//property[@name='disp_description']/value" disable-output-escaping="yes"/>
			</td>   
		</tr>
		<!-- <li>
			<label>
				<input type="checkbox" name="subscriber_dispatches[{@id}]" value="{@id}">
					<xsl:if test="@is_checked = '1'">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<xsl:value-of select="." />
			</label>
		</li> -->
	</xsl:template>
	
	
	<xsl:template match="udata[@module = 'dispatches'][@method = 'subscribe']" mode="subscribe-footer">
	    <div class="newsletter">
            <h6>Подписаться</h6>
            <form action="/dispatches/subscribe_do/" name="sbs_frm" method="post">
				<div class="btn_line">
					<div class="input-append">
						<input type="text" class="span3" name="sbs_mail" /><button class="btn" type="submit">Да!</button>
					</div>
					<i class="fa fa-spinner fa-spin"></i>
					<span class="text-spinner">Подождите...</span>
				</div>
            </form>
            <p>Подпишитесь на свежие новости о магазине и акциях</p>
        </div>
        
        <hr />
    </xsl:template>

    <xsl:template match="udata[@module = 'dispatches'][@method = 'subscribe'][subscriber_dispatches]" mode="subscribe-footer">
        <xsl:apply-templates select="subscriber_dispatches" mode="subscribe-footer" />
    </xsl:template>

    <xsl:template match="subscriber_dispatches" mode="subscribe-footer" />

    <xsl:template match="subscriber_dispatches[items]" mode="subscribe-footer" />

</xsl:stylesheet>