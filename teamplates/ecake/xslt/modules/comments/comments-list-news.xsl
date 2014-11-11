<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:umi="http://www.umi-cms.ru/TR/umi"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:fb="http://www.facebook.com/2008/fbml"
                exclude-result-prefixes="xsl umi xlink fb">

    <xsl:template match="udata[@module = 'comments' and @method = 'insert']" mode="comment-news">
        <section class="post-comments">
            <div class="box">
                <div class="box-header">
                    <h3>Комментарии</h3>
                </div>
                <div class="box-content">
                    <xsl:apply-templates select="items" mode="comment-news-item" />
                </div>
                <div class="box-footer text-center">
                    <!--<xsl:apply-templates select="total" mode="usual_paging" />-->
                    <xsl:apply-templates select="total" />
                </div>
             </div>
        </section>
         <section class="post-comment-form">
            <div class="box">
                <div class="box-header">
                    <h3>Присоединяйтесь к обсуждению</h3>
                    <h5>Пусть ваше мнение услышат, добавьте комментарий!</h5>
                </div>
                <div id="post-comment">
                    <xsl:choose>
                        <xsl:when test="$user-type = 'guest'">
                            <xsl:apply-templates select="add_form" mode="guest" />
                        </xsl:when>
                        <xsl:otherwise>
                             <div class="alert alert-error alert-comment hide">
                                <button class="close" type="button" aria-hidden="false">×</button>
                                <p>Отзыв не может быть отправлен так как он пуст.</p>
                            </div>
                            <div class="alert alert-success alert-comment hide">
                                <button class="close" type="button" aria-hidden="false">×</button>
                                <p>Ваш комментарий успешно добавлен. После модерации он будет показан.</p>
                            </div>
                            <xsl:apply-templates select="add_form" mode="user-news" />
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
             </div>
        </section>
    </xsl:template>
    
    <xsl:template match="udata[@method = 'insert']/add_form" mode="user-news">
        <form method="post" action="{action}" class="comment_post" >
            <div class="row-fluid">
                <div class="control-group">
                    <label for="comment" class="control-label">Отзыв</label>
                    <div class="controls">
                        <textarea class="span12" id="review_text" name="comment"></textarea>
                    </div>
                </div>
                <div class="box-footer">
                    <button class="btn btn-primary btn-small" type="submit">Прокомментировать &nbsp; <i class="fa fa-comment-o"></i></button>
                </div>
            </div>
        </form>
    </xsl:template>
    
    <xsl:template match="items" mode="comment-news-item">
        <p>Комментариев пока нет</p>
    </xsl:template>
    
    <xsl:template match="items[item]" mode="comment-news-item">
        <xsl:apply-templates select="item" mode="comment-news-item" />
    </xsl:template> 

    <xsl:template match="item" mode="comment-news-item">
        <div class="comment-item" umi:element-id="{@id}" umi:region="row">
            <div class="row-fluid">
                <div class="span9" umi:field-name="message" umi:delete="delete" umi:empty="&empty;" itemprop="description">
                    <xsl:value-of select="text()" disable-output-escaping="yes" />
                </div>
                <div class="span3">
                    <xsl:apply-templates select="document(@xlink:author-href)" mode="viewAuthor-news" />
                     <small umi:field-name="publish_time" itemprop="datePublished">
                        <xsl:attribute name="content">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="@publish_time" />
                                <xsl:with-param name="pattern" select="'d/m/Y'" />
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:call-template name="format-date">
                            <xsl:with-param name="date" select="@publish_time" />
                        </xsl:call-template>
                    </small>
                </div>
            </div>
        </div>
    </xsl:template>
    
</xsl:stylesheet>