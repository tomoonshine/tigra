<?xml version="1.0" encoding="utf-8"?>
<!--DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file"-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output encoding="utf-8" method="html" indent="yes"/>
	<xsl:decimal-format name="price" decimal-separator="," grouping-separator="&#160;"/>
	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="/udata/object">
		<xsl:variable name="order_info" select="document(concat('uobject://',@id))/udata"/>
		<xsl:variable name="customer_id" select="$order_info//property[@name='customer_id']/value/item/@id"/>
		<xsl:variable name="customer_info" select="document(concat('uobject://',$customer_id))/udata"/>
		
		<html>
			<head>
			<meta name="viewport" content="initial-scale=1.0"/>
			<meta name="format-detection" content="telephone=no"/>
				<style type="text/css">
					/* Resets: see reset.css for details */
					.ReadMsgBody { width: 100%; background-color: #ffffff;}
					.ExternalClass {width: 100%; background-color: #ffffff;}
					.ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height:100%;}
					html{width: 100%; }
					body {-webkit-text-size-adjust:none; -ms-text-size-adjust:none; }
					body {margin:0; padding:0;}
					table {border-spacing:0;}
					img{display:block !important;}
					a {color:#24c299;}

					table td {border-collapse:collapse;}
					.yshortcuts a {border-bottom: none !important;}


					/* 

					main color = #24c299

					other color = #056048

					background color = #ececec


					*/


					img{height:auto !important;}


					@media only screen and (max-width: 640px){
					  body{
					    width:auto!important;
					  }

					  table[class="container"]{
					    width: 100%!important;
					    padding-left: 20px!important; 
					    padding-right: 20px!important; 
					  }

					  img[class="image-100-percent"]{
					    width:100% !important;
					    height:auto !important;
					    max-width:100% !important;
					  }

					  img[class="small-image-100-percent"]{
					    width:100% !important;
					    height:auto !important;
					  }

					  table[class="full-width"]{
					    width:100% !important;
					  }

					  table[class="full-width-text"]{
					    width:100% !important;
					     background-color:#056048;
					     padding-left:20px !important;
					     padding-right:20px !important;
					  }

					  table[class="full-width-text2"]{
					    width:100% !important;
					     background-color:#f3f3f3;
					     padding-left:20px !important;
					     padding-right:20px !important; 
					  }

					  table[class="col-2-3img"]{
					    width:50% !important;
					    margin-right: 20px !important;
					  }
					    table[class="col-2-3img-last"]{
					    width:50% !important;
					  }

					  table[class="col-2"]{
					    width:47% !important;
					    margin-right:20px !important;
					  }

					  table[class="col-2-last"]{
					    width:47% !important;
					  }

					  table[class="col-3"]{
					    width:29% !important;
					    margin-right:20px !important;
					  }

					  table[class="col-3-last"]{
					    width:29% !important;
					  }

					  table[class="row-2"]{
					    width:50% !important;
					  }

					  td[class="text-center"]{
					     text-align: center !important;
					   }

					  /* start clear and remove*/
					  table[class="remove"]{
					    display:none !important;
					  }

					  td[class="remove"]{
					    display:none !important;
					  }
					  /* end clear and remove*/

					  table[class="fix-box"]{
					    padding-left:20px !important;
					    padding-right:20px !important;
					  }
					  td[class="fix-box"]{
					    padding-left:20px !important;
					    padding-right:20px !important;
					  }

					  td[class="font-resize"]{
					    font-size: 18px !important;
					    line-height: 22px !important;
					  }


					}



					@media only screen and (max-width: 479px){
					  body{
					    font-size:10px !important;
					  }

					   table[class="container2"]{
					    width: 100%!important; 
					    float:none !important;
					  }

					  img[class="image-100-percent"]{
					    width:100% !important;
					    height:auto !important;
					    max-width:100% !important;
					    min-width:124px !important;
					  }
					    img[class="small-image-100-percent"]{
					    width:100% !important;
					    height:auto !important;
					    max-width:100% !important;
					    min-width:124px !important;
					  }

					  table[class="full-width"]{
					    width:100% !important;
					  }

					  table[class="full-width-text"]{
					    width:100% !important;
					     background-color:#056048;
					     padding-left:20px !important;
					     padding-right:20px !important;
					  }

					  table[class="full-width-text2"]{
					    width:100% !important;
					     background-color:#f3f3f3;
					     padding-left:20px !important;
					     padding-right:20px !important;
					  }



					  table[class="col-2"]{
					    width:100% !important;
					    margin-right:0px !important;
					  }

					  table[class="col-2-last"]{
					    width:100% !important;
					   
					  }

					  table[class="col-3"]{
					    width:100% !important;
					    margin-right:0px !important;
					  }

					  table[class="col-3-last"]{
					    width:100% !important;
					   
					  }

					    table[class="row-2"]{
					    width:100% !important;
					  }


					  table[id="col-underline"]{
					    float: none !important;
					    width: 100% !important;
					    border-bottom: 1px solid #eee;
					  }

					  td[id="col-underline"]{
					    float: none !important;
					    width: 100% !important;
					    border-bottom: 1px solid #eee;
					  }

					  td[class="col-underline"]{
					    float: none !important;
					    width: 100% !important;
					    border-bottom: 1px solid #eee;
					  }



					   /*start text center*/
					  td[class="text-center"]{
					    text-align: center !important;

					  }

					  div[class="text-center"]{
					    text-align: center !important;
					  }
					   /*end text center*/



					  /* start  clear and remove */

					  table[id="clear-padding"]{
					    padding:0 !important;
					  }
					  td[id="clear-padding"]{
					    padding:0 !important;
					  }
					  td[class="clear-padding"]{
					    padding:0 !important;
					  }
					  table[class="remove-479"]{
					    display:none !important;
					  }
					  td[class="remove-479"]{
					    display:none !important;
					  }
					  table[class="clear-align"]{
					    float:none !important;
					  }
					  /* end  clear and remove */

					  table[class="width-small"]{
					    width:100% !important;
					  }

					  table[class="fix-box"]{
					    padding-left:0px !important;
					    padding-right:0px !important;
					  }
					  td[class="fix-box"]{
					    padding-left:0px !important;
					    padding-right:0px !important;
					  }
					    td[class="font-resize"]{
					    font-size: 14px !important;
					  }

					}
					@media only screen and (max-width: 320px){
					  table[class="width-small"]{
					    width:125px !important;
					  }
					  img[class="image-100-percent"]{
					    width:100% !important;
					    height:auto !important;
					    max-width:100% !important;
					    min-width:124px !important;
					  }

					}
				</style>
			</head>
			<body  style="font-size:12px; background-color:#ececec;">
				<table id="mainStructure" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#ececec;">
					<!-- START TAB TOP -->
		    <tbody><tr>
		      <td valign="top">
		        <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" style="background-color:#ececec;"> 
		          <tbody><tr>
		            <td valign="top" height="6">
		              <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width" style="height:6px;">
		                <!-- start space height -->
		                 <tbody><tr>
		                    <td height="10" valign="top"></td>
		                  </tr>
		                  <!-- end space height -->
		                <tr>
		                   <td style="font-size: 15px; line-height: 22px; font-family: Arial,Tahoma, Helvetica, sans-serif; color:#a3a2a2; font-weight:normal; text-align:center;">
		                      <!--<span style="color: #a3a2a2; font-weight: normal;">
		                        
		                         Не отображается письмо? <span style="color: #24c299; font-weight: normal;"><a href="#" style="text-decoration: none; color: #24c299; font-weight: normal;">Нажмите для просмотра в браузере</a></span>
		                        
		                      </span>-->
		                    </td>
		                </tr>
		                 <!-- start space height -->
		                 <tr>
		                    <td height="5" valign="top"></td>
		                  </tr>
		                  <!-- end space height -->
		              </tbody></table>
		            </td>
		          </tr>
		        </tbody></table>
		      </td>
		    </tr>
		  <!-- END TAB TOP -->
		    </tbody>

		    <!--START TOP NAVIGATION ​LAYOUT-->
  <tbody><tr>
    <td valign="top">
      <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" style="background-color:#ececec;">


      <!-- start space height -->
       <tbody><tr>
          <td height="10" valign="top"></td>
        </tr>
      <!-- end space height -->



      <!-- START TAB TOP -->
        <tr>
          <td valign="top" class="fix-box">
            <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 
              <tbody><tr>
                <td valign="top" height="6">
                  <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width" style="height:6px;">

                    <tbody><tr>
                      <td valign="top" align="center" class="remove-479" style="width:100%; background-color:#24c299;"> 
                        <table align="left" border="0" cellspacing="0" cellpadding="0" class="clear-align" style="height:6px; background-color:#24c299;">
                          <tbody><tr>
                            <td valign="top" height="6"></td>
                          </tr>
                        </tbody></table>
                      </td>
                    </tr>
                  </tbody></table>
                </td>
              </tr>
            </tbody></table>
          </td>
        </tr>
      <!-- END TAB TOP -->



      <!-- START CONTAINER NAVIGATION -->
      <tr>
        <td align="center" valign="top" class="fix-box">
          
          <!-- start top navigation container -->
          <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width" bgcolor="#ffffff" style="background-color:#ffffff;">
          
            <tbody><tr>
              <td valign="top">
                  

                <!-- start top navigaton -->
                <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width">
             
                  <tbody><tr>
                    <td valign="top">
                    
                    <table align="left" border="0" cellspacing="0" cellpadding="0" class="container2">
                     
                      <tbody><tr>
                        <td align="center" valign="top">
                           <a href="http://webvideomarket.ru/"><img src="/images/mail/images/logo.png" width="171" style="max-width:171px;" alt="Logo" border="0" hspace="0" vspace="0"></img></a>
                        </td>                  
                     	</tr>

                    </tbody></table>

                    <!--start content nav -->
                    <table border="0" align="right" cellpadding="0" cellspacing="0" class="container2">
                      
                       <tbody><tr>
                        <td height="12" valign="top" class="remove-479"></td>
                      </tr>
                       <tr>
                        <td height="20" valign="top"></td>
                      </tr>

                       <!--start call us -->
                      <tr>
                         <td valign="mindle" align="center">
                        
                        <table align="right" border="0" cellpadding="0" cellspacing="0" class="clear-align">
                          <tbody><tr>
                            <td style="font-size: 13px;  line-height: 18px; color: #555555;  font-weight:normal; text-align: center; font-family:Arail,Tahoma, Helvetica, Arial, sans-serif;">

                              <span style="color: #24c299;">Контактный телефон</span>
                              +7 921 933-0733
                            </td>
                          </tr>
                        </tbody></table>
                        </td>

                         <!--start  space width -->
                         <td valign="top" align="center" class="remove-479">
                          <table width="20" align="right" border="0" cellpadding="0" cellspacing="0" style="height:5px;">
                            <tbody><tr>
                              <td valign="top">
                              </td>
                            </tr>
                          </tbody></table>
                        </td>
                        <!--start  space width -->
                      </tr>
                      <!--end call us -->

                       <tr>
                        <td height="20" valign="top"></td>
                      </tr>

                       <tr>
                        <td height="11" valign="top" class="remove-479"></td>
                      </tr>
                      
                    </tbody></table>
                    <!--end content nav -->

                   </td>
                 </tr>
               </tbody></table>
               <!-- end top navigaton -->
              </td>
            </tr>
          </tbody></table>
          <!-- end top navigation container -->

        </td>
      </tr>
      
       <!-- start shadow -->  
       <tr>
        <td width="100%" align="center" valign="top">
         
          <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width">
           
            <tbody><tr>
              <td valign="top" align="center">

                  <img class="image-100-percent" src="/images/mail/images/shadow.png" width="596" alt="shadow" valign="top" style="max-width:596px display:block; " border="0" hspace="0" vspace="0"></img>  
              </td>
            </tr>
          </tbody></table>
        </td>
      </tr>
      <!-- end  shadow -->  

       <!-- END CONTAINER NAVIGATION -->
  
      <!-- start space height -->
       <tr>
          <td height="10" valign="top"></td>
        </tr>
      <!-- end space height -->

      </tbody></table>
    </td>
  </tr>
   <!--END TOP NAVIGATION ​LAYOUT-->

</tbody>

<!-- START LAYOUT 1 --> 
 <tbody><tr>
   <td align="center" valign="top" class="fix-box" style="background-color:#ececec;">
     <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

      <!-- start space height -->
       <tbody><tr>
          <td height="10" valign="top"></td>
        </tr>
      <!-- end space height -->


       <tr>
         <td align="center" valign="top">

           <!-- start layout-1 container width 740px --> 
           <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="container" bgcolor="#ffffff" style="background-color: #ffffff;  ">
             <tbody><tr>
               <td valign="top">

                 <!-- start layout-1 container width 700px --> 
                 <table width="700" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width" bgcolor="#ffffff" style="background-color:#ffffff;">

                   <!--start space height --> 
                   <tbody><tr>
                     <td height="20"></td>
                   </tr>
                   <!--end space height --> 


                   <!-- start text content --> 
                   <tr>
                     <td valign="top">
                       <table border="0" cellspacing="0" cellpadding="0" align="center" width="100%">
                         <tbody><tr>
                           <td style="font-size: 18px; line-height: 22px; font-family: Arial,Tahoma, Helvetica, sans-serif; color:#555555; font-weight:bold; text-align:center;">
                             <span style="color: #555555; font-weight:bold;">
                               <a href="#" style="text-decoration: none; color: #555555; font-weight: bold;">
                                <span style="color: #24c299; font-weight:bold;"><xsl:value-of select="header" /></span>
                               </a>
                             </span>
                           </td>
                         </tr>

                         <!--start space height --> 
                         <tr>
                           <td height="15"></td>
                         </tr>
                         <!--end space height --> 

                         <tr>
                           <td style="font-size: 13px; line-height: 22px; font-family:Arial,Tahoma, Helvetica, sans-serif; color:#a3a2a2; font-weight:normal; text-align:center;">
								<!-- <xsl:value-of select="content" disable-output-escaping="yes" /> -->
								<xsl:call-template name="order_common_info">
									<xsl:with-param name="order_id" select="@id"/>
									<xsl:with-param name="order_info" select="$order_info"/>
									<xsl:with-param name="customer_info" select="$customer_info"/>
								</xsl:call-template>
                           </td>
                         </tr>

                        <!--start space height --> 
                         <tr>
                           <td height="20"></td>
                         </tr>
                         <!--end space height --> 

                       </tbody></table>
                     </td>
                   </tr>
                   <!-- end text content --> 

                   <!--start space height --> 
                   <tr>
                     <td height="20"></td>
                   </tr>
                   <!--end space height --> 
                 </tbody></table>
                 <!-- end layout-1 container width 700px --> 
               </td>
             </tr>
           </tbody></table>
           <!-- end layout-1 container width 740px --> 
         </td>
       </tr>

       <!-- start shadow -->  
       <tr>
        <td width="100%" align="center" valign="top">
         
          <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width">
           
            <tbody><tr>
              <td valign="top" align="center">

                  <img class="image-100-percent" src="/images/mail/images/shadow.png" width="596" alt="shadow" valign="top" style="max-width:596px display:block; " border="0" hspace="0" vspace="0"></img>  
              </td>
            </tr>
          </tbody></table>
        </td>
      </tr>
      <!-- end  shadow -->  

        <!-- start space height -->
       <tr>
          <td height="5" valign="top"></td>
        </tr>
      <!-- end space height -->


     </tbody></table>
   </td>
 </tr>
 <!-- END LAYOUT 1 --> 

</tbody>

  <!-- START FOOTER COPY RIGHT  -->
  <tbody><tr>
    <td align="center" valign="top" class="fix-box" style="background-color:#ececec;">

      <!-- start layout-7 container -->  
      <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="full-width">
       <tbody>

        <tr>
          <td align="center" valign="top">
            <table width="740" align="center" border="0" cellspacing="0" cellpadding="0" class="container">
              <tbody><tr>
                <td valign="top">
                  <table width="700" align="center" border="0" cellspacing="0" cellpadding="0" class="container">
                    <tbody>
                    <tr>
                      <!-- start COPY RIGHT content -->  
                      <td valign="top" style="font-size: 13px; line-height: 22px; font-family: Arial,Tahoma, Helvetica, sans-serif; color:#a3a2a2; font-weight:normal; text-align:center; ">
                        tigra21 © 2014. Все права защищены.
                      </td>
                      <!-- end COPY RIGHT content --> 
                    </tr>


                  </tbody></table>
                </td>
              </tr>
            </tbody></table>
          </td>
        </tr>
        <!--  END FOOTER COPY RIGHT -->

        <!-- start space height -->
       <tr>
          <td height="20" valign="top"></td>
        </tr>
      <!-- end space height -->

      </tbody></table>
    </td>
  </tr>
</tbody>
				
				</table>
			</body>
		</html>
	</xsl:template>
	
	
	
	<!-- общий шаблон центральной части письма -->
	<xsl:template name="order_common_info">
		<xsl:param name="receipt" select="0" />
		<xsl:param name="order_id" />
		<xsl:param name="order_info" />
		<xsl:param name="customer_info" />

		<xsl:variable name="basket_info" select="document(concat('udata://emarket/order/', $order_id))/udata"/> 
		<xsl:variable name="payment" select="$order_info//property[@name='payment_id']/value/item/@name" />
		<xsl:variable name="address"  select="document(concat('uobject://',$order_info//property[@name='delivery_address']/value/item[1]/@id))/udata/object" />
		<xsl:variable name="table_style"  select="'clear:both;color:#666666 !important;font-family:arial,helvetica,sans-serif;font-size:11px;'" />
		<xsl:variable name="table_th_style"  select="'border:1px solid #ccc;border-right:none;border-left:none;padding:5px 10px 5px 10px !important;color:#333333 !important;'" />

		<table style="border:0px; text-align:left;" border="0" cellpadding="0" cellspacing="0" >
			<tbody>
				<tr>
					<td><b>Заказ №</b></td>
					<td><xsl:apply-templates select="$order_info//property[@name='number']" /></td>
				</tr>
				<tr>
					<td><b>Дата заказа:</b></td>
					<td>
					
					<xsl:apply-templates select="$order_info//property[@name='order_date']" /></td>
				</tr>
				<tr>
					<td><b>ФИО:</b></td>
					<td><xsl:value-of select="concat($customer_info//property[@name='lname']/value,' ',$customer_info//property[@name='fname']/value,' ',$customer_info//property[@name='father_name']/value)" /></td>
				</tr>
				<tr>
					<td><b>E-mail:</b></td>
					<td><xsl:apply-templates select="$customer_info//property[@name='email']" /><xsl:apply-templates select="$customer_info//property[@name='e-mail']" /></td>
				</tr>
				<tr>
					<td><b>Телефон:</b></td>
					<td><xsl:apply-templates select="$customer_info//property[@name='phone']" /></td>
				</tr>
				<xsl:if test="$address//property/value">
					<tr>
						<td><b>Адрес:</b></td>
						<td><xsl:apply-templates select="$address//property" mode="adress_property"/></td>
					</tr>  
				</xsl:if>                   
				<tr>
					<td><b>Способ доставки:</b></td>
					<td><xsl:apply-templates select="$order_info//property[@name='delivery_id']" /></td>
				</tr>
				<tr>
					<td><b>Способ оплаты:</b></td>
					<td><xsl:apply-templates select="$order_info//property[@name='payment_id']" /></td>
				</tr>
			</tbody>
		</table>
		<br /><br />
		<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0" style="{$table_style}">
			<tbody>
				<tr style="height: 20px;">
					<td style="{$table_th_style}" align="left"><xsl:text>Наименование</xsl:text></td>
					<td style="{$table_th_style}" align="right"><xsl:text>Цена</xsl:text></td>
					<td style="{$table_th_style}" align="right"><xsl:text>Кол-во</xsl:text></td>
					<td style="{$table_th_style}" align="right"><xsl:text>Сумма</xsl:text></td>
				</tr>
				<xsl:apply-templates select="$basket_info/items" mode="order_id"/>
			</tbody>
		</table>
		<xsl:apply-templates select="$basket_info/summary" mode="summary" />
	</xsl:template>

	<!-- наименование в заказе -->
	<xsl:template match="udata//items/item" mode="order_id">
		<xsl:variable name="item_info" select="document(concat('upage://',page/@id,'.artikul'))//property"/>
		<xsl:variable name="item_td_style"  select="'padding:10px;'" />

		<tr>
			<td style="{$item_td_style}" align="left">
				<xsl:value-of select="@name" />
				<xsl:if test="$item_info/value"><div><xsl:value-of select="$item_info/title"/>:&#160;<xsl:value-of select="$item_info/value"/></div></xsl:if>
			</td>
			<td style="{$item_td_style}" align="right">
				<xsl:apply-templates select="price/actual" mode="price" />
			</td>
			<td style="{$item_td_style}" align="right">
				<xsl:apply-templates select="amount" />
			</td>
			<td style="{$item_td_style}" align="right">
				<xsl:apply-templates select="total-price" />
			</td>
		</tr>
	</xsl:template>
	
	<!-- итоговые числа -->
	<xsl:template match="summary" mode="summary">
		<xsl:variable name="summary_general_table_style" select="'border-top:1px solid #ccc;clear:both;color:#666666 !important;font-family:arial,helvetica,sans-serif;font-size:11px;width:100%'"/>
		<xsl:variable name="summary_values_table_style" select="'color:#666666 !important;font-family:arial,helvetica,sans-serif;font-size:11px;margin-top:20px;clear:both;width:100%;'"/>
		<xsl:variable name="summary_values_td_title_style" select="'width:390px;text-align:right;padding:0 10px 0 0;'"/>
		<xsl:variable name="summary_values_td_value_style" select="'width:90px;text-align:right;padding:0 5px 0 0;'"/>
		<xsl:variable name="summary_values_td_value_span_style" select="'color:#333333 !important;font-weight:bold;'"/>
		
		<table align="left" border="0" cellpadding="0" cellspacing="0" style="{$summary_general_table_style}">
			<tr>
				<td>
					<table border="0" cellpadding="0" cellspacing="0" style="{$summary_values_table_style}" align="right">
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Итого:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:choose>
									<xsl:when test="price/original">
										<xsl:apply-templates select="price/original" mode="price" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="price/actual" mode="price" />
									</xsl:otherwise>
								</xsl:choose> 
								
							</td>
						</tr>
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Скидка:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:choose>
									<xsl:when test="price/discount!=''">
										<xsl:apply-templates select="price/discount" mode="price" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="price/@prefix" mode="price" />
										0
										<xsl:apply-templates select="price/@suffix" mode="price" />
									</xsl:otherwise>
								</xsl:choose>										
							</td>
						</tr>
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Доставка:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:choose>
									<xsl:when test="price/delivery!=''">
										<xsl:apply-templates select="price/delivery" mode="price" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="price/@prefix" mode="price" />
										0
										<xsl:apply-templates select="price/@suffix" mode="price" />
									</xsl:otherwise>
								</xsl:choose>	
								
							</td>
						</tr>
						<xsl:if test="price/bonus!=''">
							<tr>
								<td style="{$summary_values_td_title_style}">
									<span style="{$summary_values_td_value_span_style}"><xsl:text>Оплачено бонусами:</xsl:text></span>
								</td>
								<td style="{$summary_values_td_value_style}">
									<xsl:apply-templates select="price/bonus" mode="price" />
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td style="{$summary_values_td_title_style}">
								<span style="{$summary_values_td_value_span_style}"><xsl:text>Итого к оплате:</xsl:text></span>
							</td>
							<td style="{$summary_values_td_value_style}">
								<xsl:apply-templates select="price/actual" mode="price" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!-- шаблоны для полей разных типов -->
	<xsl:template match="property">
		<xsl:value-of select="value" />
	</xsl:template>

	<xsl:template match="property[@type = 'boolean'][value]">
		<xsl:text>Нет</xsl:text>
	</xsl:template>

	<xsl:template match="property[@type = 'boolean'][value = 1]|fields/field[@type = 'boolean']//value[.]">
		<xsl:text>Да</xsl:text>
	</xsl:template>

	<xsl:template match="property[@type = 'relation']">
		<xsl:apply-templates select="value/item" />
	</xsl:template>

	<xsl:template match="property[@type = 'symlink']">
		<xsl:apply-templates select="value/page" />
	</xsl:template>

	<xsl:template match="value/item">
		<xsl:value-of select="concat(@name, ', ')" />
	</xsl:template>

	<xsl:template match="value/item[position() = last()]">
		<xsl:value-of select="@name" />
	</xsl:template>

	<xsl:template match="value/page">
		<a href="{@link}">
			<xsl:value-of select="name" />
		</a>
	</xsl:template>

	<!-- шаблоны для вывода адреса -->
	<xsl:template match="property" mode="adress_property" />
	<xsl:template match="property[value]" mode="adress_property">
		<xsl:choose>
			<xsl:when test="@name='house'">д. </xsl:when>
			<xsl:when test="@name='flat'">кв. </xsl:when>
		</xsl:choose> 
		<xsl:value-of select="value" /><xsl:if test="not(position() = last())">,&#160;</xsl:if>
	</xsl:template>
	<xsl:template match="property[@type='relation' and value]" mode="adress_property" >
		<xsl:value-of select="value/item/@name" /><xsl:if test="not(position() = last())">,&#160;</xsl:if>
	</xsl:template>

	<!-- шаблоны для даты -->
	<xsl:template name="format-date">
		<xsl:param name="date" />
		<xsl:param name="pattern" select="'d.m.Y'" />
		<xsl:variable name="uri" select="concat('udata://system/convertDate/', $date, '/(', $pattern, ')')" />

		<xsl:value-of select="document($uri)/udata" />
	</xsl:template>

	<xsl:template match="property[@type = 'date']">
		<xsl:param name="pattern" select="'d.m.Y'" />
		<xsl:call-template name="format-date">
			<xsl:with-param name="date" select="value/@unix-timestamp" />
			<xsl:with-param name="pattern" select="$pattern" />
		</xsl:call-template>
		&#160;
		<xsl:call-template name="format-date">
			<xsl:with-param name="date" select="value/@unix-timestamp" />
			<xsl:with-param name="pattern" select="'G:i'" />
		</xsl:call-template>
	</xsl:template>

	<!-- шаблоны для поле типа цены -->
	<xsl:template match="total-price">
		<xsl:value-of select="concat(@prefix, ' ', format-number(actual, '#&#160;###,##','price'), ' ', @suffix)" />
	</xsl:template>    

	<xsl:template match="price">
		<xsl:value-of select="concat(@prefix, ' ', format-number(original, '#&#160;###,##','price'), ' ', @suffix)" />
	</xsl:template>

	<xsl:template match="price[not(original) or original = '']">
		<xsl:value-of select="concat(@prefix, ' ', format-number(actual, '#&#160;###,##','price'), ' ', @suffix)" />
	</xsl:template>
	
	<!-- спец шаблон для вывода цены -->
	<xsl:template match="actual|original|discount|delivery|bonus" mode="price">
		<xsl:apply-templates select="../../price/@prefix" mode="price" />
		<xsl:value-of select="format-number(., '#&#160;###,##','price')" />
		<xsl:apply-templates select="../../price/@suffix" mode="price" />
	</xsl:template>
		<xsl:template match="price/@prefix" mode="price">
			<xsl:value-of select="." /><xsl:text> </xsl:text>
		</xsl:template>
		<xsl:template match="price/@suffix" mode="price">
			<xsl:text> </xsl:text><xsl:value-of select="." />
		</xsl:template>

</xsl:stylesheet>