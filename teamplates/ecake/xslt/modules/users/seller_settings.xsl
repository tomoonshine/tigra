<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink">
	
	
	<!-- User settings -->
	<!--
		Модифицированный шаблон подключенна проверка прав пользователей 
		Оригинальный закоментирован в файле registration.xml
	-->
	<xsl:template match="result[@method = 'settings']">
		<xsl:choose>
		
			<!-- Если пользователь состоит в группе "Продавцы" -->
			<xsl:when test="document(concat('uobject://',user/@id,'.groups'))//value/item/@id = 10196">
				<xsl:apply-templates select="document('udata://users/settings')" mode="seller"/>
			</xsl:when>

			<!-- В другом случае -->
			<xsl:otherwise>
				<xsl:apply-templates select="document('udata://users/settings')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'settings']" mode="seller">
		<form action="{$lang-prefix}/data/addNewShop" method="post" enctype="multipart/form-data" >
			<table class="table" id="acc_info">
			<tbody>
				<tr>
					<th>Название магазина</th>
					<td>
						<input type="text" name="shopName"  readonly="" value=""/>
					</td>
				</tr> 
				<tr>
					<th></th>
					<td>
						<a href="#" class="btn btn-turquoise btn-small" id="lk-edit-btn">Редактировать</a>    
						<input type="button" class="hide btn btn-small" id="lk-cancel-btn" value="Отменить" />
						<input type="submit" class="hide btn btn-turquoise btn-small" value="Cохранить" />
					</td>
				</tr>						
			</tbody>
			</table>
			
		</form>
	</xsl:template>
	
</xsl:stylesheet>