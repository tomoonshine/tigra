<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="utf-8" method="html" indent="yes" />

	<xsl:template match="subscribe_confirm_subject">
		<xsl:text>Подписка на рассылку</xsl:text>
	</xsl:template>

	<xsl:template match="subscribe_confirm">
    <p><xsl:text>Доброго времени суток! Вы подписались на рассылку.</xsl:text></p>
    <p>
      <xsl:text>Если это сделали не вы или вы решили отменить подписку, просто перейдите по ссылке: </xsl:text>
      <a href="{unsubscribe_link}" style="text-decoration: none; color: #24c299; font-weight: normal;">
        <xsl:value-of select="unsubscribe_link" />
      </a>
    </p>
		
	</xsl:template>

</xsl:stylesheet>