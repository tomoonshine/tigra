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
		<xsl:apply-templates select="document('udata://users/settings')" />
	</xsl:template>
	
	<xsl:template match="udata[@method = 'settings']" mode="seller">
	</xsl:template>
	
	<!-- Шаблон на вывод настроек магазина -->
	<xsl:template match="result[page/@id='745']">
		<xsl:variable name="user" select="document(concat('uobject://',user/@id))" />
		<xsl:choose>
			<xsl:when test="$user//property[@name = 'shopid']">
				<form action="http://tigra21.ru/data/changeShopName"  method="post" enctype="multipart/form-data" id="settings-form">
					<table class="table" id="acc_info">
						<tbody>
							<tr>
								<th>Название магазина</th>
								<td>
									<input type="text" name="shop_name"  readonly="" value="{$user-info//property[@name = 'magazin']/value}"/>
								</td>
							</tr> 
							<tr>
								<th>Домен</th>
								<td>
									<xsl:value-of select="$user-info//property[@name = 'imya_hosta']/value" />
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
			</xsl:when>
			<xsl:otherwise>
				<p class="lead">Добавьте магазин</p>
				<!-- <form action="http://tigra21.ru/data/addNewShop" method="post" enctype="multipart/form-data" > -->
				<form action="http://tigra21.ru/data/addNewShop" method="post" enctype="multipart/form-data" onsubmit="site.forms.data.save(this); return site.forms.data.check(this);">
					<table class="table" id="acc_info">
					<tbody>
						<tr>
							<th>Название магазина</th>
							<td>
								<div class="control-group required">
									<input type="text" name="shopName" value=""/>
								</div>
							</td>
							<td>
								Задайте имя магазина
							</td>
						</tr> 
						<tr>
							<th>Домен магазина</th>
							<td>
								<div class="control-group required">	
									<input type="text" name="shopDomain" value=""/>
								</div>
							</td>
							<td>
								Задайте имя поддомена который вам нравиться, например <strong>myshoop</strong><br/>
								Название может содержать быквы латинского алфавита и цифры другие символы не допускаются.
								Адрес вашего магазина будет <strong>myshoop.tigra21.ru</strong>
							</td>
						</tr> 
						<tr>
							<th></th>
							<td>
								<input type="submit" class="btn btn-turquoise btn-small" value="Добавить" />
							</td>
							<td>
								
							</td>
						</tr>						
					</tbody>
					</table>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Шаблон на вывод во вкладке товары -->
	<xsl:template match="result[page/@id='866']">
		<xsl:variable name="user" select="document(concat('uobject://',user/@id))" />
		<!-- Вывод всех товаров -->
		<!-- <xsl:value-of select="$user//property[@name='shopid']/value" /> -->
		<xsl:apply-templates select="document(concat('udata://data/getShopProducts/',$user//property[@name='shopid']/value))"/>
		<!-- Добавить товар -->
		<p class="lead">Добавьте товар</p>
		<form action="http://tigra21.ru/data/addNewProduct" method="post" enctype="multipart/form-data" onsubmit="site.forms.data.save(this); return site.forms.data.check(this);">
			<table class="table" >
			<tbody>
				<tr>
					<th>Название продукта</th>
					<td>
						<div class="control-group required">
							<input type="text" name="product_name" value=""/>
						</div>
					</td>
					<td>
						
					</td>
				</tr> 
				<tr>
					<th>Категория</th>
					<td>
						<input id="category_id" type="hidden" name="categoryId" value="0" />
						<xsl:apply-templates select="document('udata://data/getSubCategory/240')" mode="seller_setting"/>
					</td>
					<td></td>
				</tr>
				<tr>
					<th>Фотографии</th>
					<td>
						<input type="file" name="image[]" accept="image/jpeg,image/png,image/gif"/>
						<input type="file" name="image[]" accept="image/jpeg,image/png,image/gif"/>
					</td>
					<td></td>
				</tr>
				<tr>
					<th>Цена</th>
					<td>
						<input type="text" name="price" value=""/>
					</td>
					<td></td>
				</tr>
				<tr>
					<th>Описание</th>
					<td>
						<textarea name="description">
						</textarea>
					</td>
					<td></td>
				</tr>
				<tr>
					<th></th>
					<td>
						<input type="submit" class="btn btn-turquoise btn-small" value="Добавить" />
					</td>
					<td>
					</td>
				</tr>						
			</tbody>
			</table>
		</form>
	</xsl:template>
	
	<xsl:template match="udata[@module='data'][@method='getShopProducts']">
		<xsl:apply-templates select="items/item" />
	</xsl:template>
	
	<xsl:template match="udata[@method='getShopProducts']//item">
		<xsl:variable name="imageItems" select="document(concat('udata://content/parseFileContent/', @pageId,'/tigra21_image_gallery'))/udata" />
		<a href="{@link}"><xsl:value-of select="@name" /> </a>
		Цена: <xsl:value-of select="@price" /> руб.
		<br/>
		Фотографии:
		<br/>
		<xsl:apply-templates select="$imageItems" mode="parseImagePrivate" />		
<!-- 	<xsl:apply-templates select="images/items/item" mode="foto"/> -->
		<br/>
	</xsl:template>
	
	<xsl:template match="udata" mode="parseImage" />
	<xsl:template match="udata[items/item]" mode="parseImagePrivate">
		<div>
		<ul>
			<xsl:apply-templates select="items/item" mode="parseImagePrivate" />
		</ul>
		</div>
	</xsl:template>
	<xsl:template match="item" mode="parseImagePrivate">
		<xsl:variable name="path" select="@src" />
		<li>
			<xsl:call-template name="all-thumbnail-path">
					<xsl:with-param name="width" select="'68'" />
					<xsl:with-param name="height" select="'65'" />
					<xsl:with-param name="path" select="$path" />
					<xsl:with-param name="quality" select="'100'" />
					<xsl:with-param name="full" select="'care'" />
					<xsl:with-param name="gallery-split" select="true()" />
					<xsl:with-param name="settings_catalog" select="$settings_catalog" />
				</xsl:call-template>
		</li>
	</xsl:template>
	
	
	<xsl:template match="udata[@method='getShopProducts']//item" mode="foto">

	</xsl:template>
	
	<xsl:template match="udata[@module='data'][@method='getSubCategory']" mode="seller_setting">
		<select id="select1" onChange="categoryChange(this)">
			<option value="0"> </option>
			<xsl:apply-templates select="items/item" mode="seller_setting"/>
		</select>
		<div id="subcategory1">
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@method='getSubCategory']//item" mode="seller_setting">
		<option value="{@id}"><xsl:value-of select="@name" /></option>
	</xsl:template>
	
	
</xsl:stylesheet>
