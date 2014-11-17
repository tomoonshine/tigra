<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">
<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="search-form-left-column">
		<form class="search" action="/search/search_do/" method="get">
			<input type="text" value="&search-default-text;" name="search_string" class="textinputs" onblur="javascript: if(this.value == '') this.value = '&search-default-text;';" onfocus="javascript: if(this.value == '&search-default-text;') this.value = '';"  x-webkit-speech="" speech="" />
		</form>
	</xsl:template>
	
	<xsl:template name="search-form-new">
		<div class="search">
			<div class="qs_s">
				<form action="/search/search_doN/" method="get" id="form-search">
						<input type="text" class="span12" name="search_string" id="query" placeholder="Поиск&hellip;" autocomplete="off" value="" />
						<button class="btn-search" type="submit"><i class="fa fa-search"></i></button>
				</form>
				<!-- Autocomplete results -->
				<div id="autocomplete-results" style="display: none;">	

				</div>
				<!-- End id="autocomplete-results" -->
			</div>
		</div>
		<!-- End class="search"-->
	</xsl:template>
	
</xsl:stylesheet>