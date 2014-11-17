<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:umi="http://www.umi-cms.ru/TR/umi"
				xmlns:xlink="http://www.w3.org/TR/xlink"
				xmlns:fb="http://www.facebook.com/2008/fbml"
				exclude-result-prefixes="xsl umi xlink fb">

	<xsl:template match="udata[@module = 'comments' and @method = 'insert']">
		<!-- <hr /><a name="comments" />
		<h4>
			<xsl:text>&comments;:</xsl:text>
		</h4>
		<div itemprop="review" itemscope="itemscope" itemtype="http://schema.org/Review" class="comments" umi:module="comments" umi:add-method="none" umi:region="list" umi:sortable="sortable">
			<xsl:apply-templates select="items/item" mode="comment" />
			<xsl:apply-templates select="document(concat('udata://system/numpages/', total, '/', per_page))" />
			<xsl:choose>
				<xsl:when test="$user-type = 'guest'">
					<xsl:apply-templates select="add_form" mode="guest" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="add_form" mode="user" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<xsl:apply-templates select="document('udata://comments/insertVkontakte')" />
		<xsl:apply-templates select="document('udata://comments/insertFacebook')" /> -->
		<div class="ratings-items" index="{$document-page-id}">
			<xsl:apply-templates select="items/item" mode="comment" />
			
			<hr />
			<xsl:apply-templates select="total" mode="usual_paging" />
		</div>
		<div class="alert alert-error alert-comment hide"><button class="close" type="button" aria-hidden="false">×</button>
			<p>Отзыв не может быть отправлен, так как он пуст.</p>
		</div>
		<div class="alert alert-success alert-comment hide"><button class="close" type="button" aria-hidden="false">×</button>
			<p>Ваш комментарий успешно добавлен. После модерации он будет показан.</p>
		</div>
		<div class="well ratingform">
			<xsl:choose>
				<xsl:when test="$user-type = 'guest'">
					<xsl:apply-templates select="add_form" mode="guest" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="add_form" mode="user" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="udata[@module = 'comments' and @method = 'insert' and not(items)]">
		<xsl:apply-templates select="document('udata://comments/insertVkontakte')" />
		<xsl:apply-templates select="document('udata://comments/insertFacebook')" />
	</xsl:template>

	<xsl:template match="udata[@module = 'comments' and @method = 'insertVkontakte' and @type='vkontakte']">
		<script type="text/javascript" src="http://userapi.com/js/api/openapi.js?34"></script>
		<script type="text/javascript"><![CDATA[VK.init({apiId: ]]><xsl:value-of select="api" /><![CDATA[, onlyWidgets: true});]]></script>
		<hr /><a name="comments" />
		<h4>
			<xsl:text>Комментарии ВКонтакте:</xsl:text>
		</h4>
		<div id="vk_comments"></div>
		<script type="text/javascript"><![CDATA[
		VK.Widgets.Comments("vk_comments", {limit: ]]><xsl:value-of select="per_page" /><![CDATA[, width: "]]><xsl:value-of select="width" /><![CDATA[", attach: "]]><xsl:value-of select="extend" /><![CDATA["});
		]]></script>
	</xsl:template>

	<xsl:template match="udata[@module = 'comments' and @method = 'insertVkontakte' and not(@type)]"/>

	<xsl:template match="udata[@module = 'comments' and @method = 'insertFacebook' and @type='facebook']">
		<xsl:variable name="href" select="concat('http://', $domain, $lang-prefix, $request-uri)" />
		<hr /><a name="comments" />
		<h4>
			<xsl:text>Комментарии Facebook:</xsl:text>
		</h4>
		<div id="fb-root"></div>
		<script src="http://connect.facebook.net/ru_RU/all.js#xfbml=1"></script>
		<fb:comments href="{$href}" num_posts="{per_page}" width="{width}" colorscheme="{colorscheme}"></fb:comments>
	</xsl:template>

	<xsl:template match="udata[@module = 'comments' and @method = 'insertFacebook' and not(@type)]" />

	<xsl:template match="udata[@method = 'insert']/add_form" mode="guest">
		<form>
			<h6><i class="fa fa-comment-o"></i> &nbsp; Поделитесь своим мнением</h6>
			<p class="hide0">Вам необходимо <a href="/users/login/" target="_blank">Войти</a> или <a href="/users/registrate/" target="_blank">Зарегистрироваться</a> на сайте, чтобы оставить отзыв. </p>
		</form>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'insert']/add_form" mode="user">
		<form method="post" action="{action}" class="comment_post" >
			<h6><i class="fa fa-comment-o"></i> &nbsp; Поделитесь своим мнением</h6>
			<p class="hide answer">Ваш комментарий успешно добавлен. После модерации он будет показан.</p>
			<p class="hide">Нужно быть зарегистриованным пользователем, чтобы оставить отзыв. </p>
			<div class="row-fluid">

				<div class="control-group">
					<label for="comment" class="control-label">Отзыв</label>
					<div class="controls">
						<textarea class="span12" id="review_text" name="comment"></textarea>
					</div>
				</div>
				<div class="control-group">
					<div class="span8">
						<div class="starrating goodsreview__setrating">
							<a href="#" class="main_rating rating rat4">
								<span data-starrate="0" class="rating_summ ">
									<span class="rating_curr starlight" data-val="0"> </span>
								</span>
							</a>
							<input type="hidden" class="rating_int" name="rating_int"/>
						</div>
						
						
						
					</div>
					<div class="span4">
						<input type="submit" class="btn btn-seconary btn-block" value="Оценить"/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>

	<xsl:template match="item" mode="comment">
		<article class="rating-item" umi:element-id="{@id}" umi:region="row">
			<div class="row-fluid">
				<div class="span9">
					<div class="starrating goodstooltip__starrating">
						<span data-starrate="{round(.//property[@name='rating_int']/value)}"  class="starlight"></span>
					</div>
					<div umi:field-name="message" umi:delete="delete" umi:empty="&empty;" itemprop="description">
						<xsl:value-of select="text()" disable-output-escaping="yes" />
					</div>
				</div>
				<div class="span3">
					<xsl:apply-templates select="document(@xlink:author-href)" />
					
					<small umi:field-name="publish_time" itemprop="datePublished">
						<xsl:attribute name="content">
							<xsl:call-template name="format-date">
								<xsl:with-param name="date" select="@publish_time" />
								<xsl:with-param name="pattern" select="'Y-m-d'" />
							</xsl:call-template>
						</xsl:attribute>
						<xsl:call-template name="format-date">
							<xsl:with-param name="date" select="@publish_time" />
						</xsl:call-template>
					</small>
				</div>
			</div>
		</article>
	</xsl:template>
</xsl:stylesheet>