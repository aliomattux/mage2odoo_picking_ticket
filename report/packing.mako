<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.ddiv class="divtd"">
<html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" type="text/css" href="/usr/local/openerp/community/mage2odoo_picking_ticket/report/packslip.css"></link>
        <script src='/usr/local/openerp/community/mage2odoo_picking_ticket/report/jquery-1.10.2.min.js'></script>
        <script src='/usr/local/openerp/community/mage2odoo_picking_ticket/report/jquery-barcode.min.js'></script>
        <script src='/usr/local/openerp/community/mage2odoo_picking_ticket/report/packslip.js'></script>
        <script>
            $(document).ready(function(){
            onebytwo();
            scalefont();
            barcode();
            subst();
            //pagecount();
            controlno();
            highlightme();
            cleandecimals();
            //workingfooter();
            //jqfooter();
            //totebarcode();
            //showheight();
                });
        </script>
    </head>
<body id="packingslip">

    %for picking in objects:
    <% block heada scoped %>
    <br>
    <div class="headtable">
        <div class="divtr">
            <div class="divtd" style="font-size: 45px; width: 25%;"><img height="115" width="115" src="/usr/local/openerp/community/mage2odoo_picking_ticket/report/BOL-revised.png"/>
	    </div>
            <div class="divtd head top department" style="width: 20%;">
		<br>
                <div>${picking.company_id.partner_id.name}</div>
		<div>${picking.company_id.partner_id.street2 or ''}</div>
		<div>${picking.company_id.partner_id.city}, ${picking.company_id.partner_id.state_id.code} ${picking.company_id.partner_id.zip}</div>
            </div>
            <div class="divtd head top" width: 20%;">
                <div class="onebytwo">${picking.id}</div>
            </div>

            <div class="divtd head top" align="right" style="width: 30%;">
                <div class="divtr">
		    <div class="detailtableheadertop" >
		        <div class="divthhead whiteonblack">
                            <div class="divtd thcell" style="font-size: 15px;">Order</div>
                            <div class="divtd thcell" style="font-size: 15px;">Date</div>
			</div>
			<div class="divtr">
                            <div class="divtd detailline" style="font-size: 12px;">${picking.origin}</div>
                            <div class="divtd detailline" style="font-size: 12px;">${get_date_created(picking)}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
     <% endblock %>

    <% block headb scoped %>
    <div class="detailtableheader">
        <div class="divthhead whiteonblack half">
            <div class="divtd thcell half" style="font-size: 15px;">Bill To</div>
            <div class="divtd thcell half" style="font-size: 15px;">Ship Via</div>
	</div>

	<div class="divtr">
	    <div class="divtd detaillinehead"><strong>
                        <div>${picking.sale.partner_invoice_id.name}</div>
                        <div>${picking.sale.partner_invoice_id.street or ''}</div>
                        <div>${picking.sale.partner_invoice_id.street2 or ''}</div>
                        <div>${picking.sale.partner_invoice_id.city or ''}, ${picking.partner_id.state_id.code or ''} ${picking.partner_id.zip or ''}</div>
                        <div>United States T: ${picking.sale.partner_id.phone or 'no phone'}</div>
	    </strong>
            </div>
	    <div class="divtd detaillinehead style="height: 70px;">
		<div><strong>${picking.carrier_id.name or ''}</strong></div>
            </div>
        </div>
    </div>
    <div class="detailtableheader">
        <div class="divthhead whiteonblack half">
            <div class="divtd thcell half" style="font-size: 15px;">Ship To</div>
            <div class="divtd thcell half" style="font-size: 15px;">Customer Comments</div>
        </div>
        <div class="divtr" style="height: 70px;">
            <div class="divtd detaillinehead"><strong>
                        <div>${picking.partner_id.name}</div>
                        <div>${picking.partner_id.street or ''}</div>
                        <div>${picking.partner_id.street2 or ''}</div>
                        <div>${picking.partner_id.city or ''}, ${picking.partner_id.state_id.code or ''} ${picking.partner_id.zip or ''}</div>
                        <div>United States T: ${picking.partner_id.phone or ' '}</div>
            </strong>
            </div>
            <div class="divtd detailline" style="height: 70px;">
                <div> </div>
            </div>

        </div>
    </div>
     <%endblock%>
    <!-- DEVELOPMENT -->

    ${heada}
    ${headb}

<% set myorderlines = paginate_items(picking.move_lines) %>
<% set count = 0 %>
    %for myset in myorderlines:
	<% set count = count + 1 %>

%if count > 1:
    <div style="page-break-after: always;"></div>
    <div class="headtable">
        <div class="divtr">
            <div class="divtd" style="font-size: 45px; width: 25%;"><img height="115" width="115" src="/usr/local/openerp/community/mage2odoo_picking_ticket/report/BOL-revised.png"/>
            </div>
            <div class="divtd head top department" style="width: 20%;">
                <br>
                <div>${picking.company_id.partner_id.name}</div>
                <div>${picking.company_id.partner_id.street2 or ''}</div>
                <div>${picking.company_id.partner_id.city}, ${picking.company_id.partner_id.state_id.code} ${picking.company_id.partner_id.zip}</div>
            </div>
            <div class="divtd head top" width: 20%;">
                <div class="onebytwo">${12345678}</div>
            </div>

            <div class="divtd head top" align="right" style="width: 30%;">
                <div class="divtr">
                    <div class="detailtableheadertop" >
                        <div class="divthhead whiteonblack">
                            <div class="divtd thcell" style="font-size: 15px;">Order</div>
                            <div class="divtd thcell" style="font-size: 15px;">Date</div>
                        </div>
                        <div class="divtr">
                            <div class="divtd detailline" style="font-size: 12px;">${picking.origin}</div>
                            <div class="divtd detailline" style="font-size: 12px;">${get_date_created(picking)}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
%endif

%if count > 1:
    <br>
    <br>
    <div class="detailtable_extended">
%else:
    <div class="detailtable">
%endif
            <div class="divth whiteonblack">
                <div class="divtd thcell" style="font-size: 14px; width: 30%;">Style Number/Name</div>
	        <div class="divtd thcell" style="font-size: 14px; width: 15%;">Special</div>
                <div class="divtd thcell" style="font-size: 14px; width: 13%">On Order</div>
                <div class="divtd thcell" style="font-size: 14px; width: 13%;">Shipped</div>
	        <div class="divtd thcell" style="font-size: 14px; width: 13%;">Backorder</div>
		<div class="divtd thcell" style="font-size: 14px; width: 15%;">Expected Ship Date</div>
            </div>

            <!--for order in page:-->
            %for line in myset:
                <div class="divtr">
		    <div class="divtd detailline">
			<div><strong>${line['sku']}</strong></div>
			<div>${line['description']}
		    </div></div>
		    <div class="divtd detailline">${line['special_order']}</div>
                    <div class="divtd detailline qty highlightme">${line['qty_order']}</div>
		    <div class="divtd detailline qty highlightme">${line['qty_ship']}</div>
		    <div class="divtd detailline qty highlightme">${line['qty_backorder']}</div>
		    <div class="divtd detailline qty highlightme">${line['expected_ship_date']}</div>
                </div>
            %endfor
	    
        </div>
    </div>
    %endfor
    <br>
    <br>
    <!-- END WRAPPER -->
</div>
    <div class="footer_bottom">
        <div class="detailtableheaderbottom">
            <div class="divth whiteonblack">
                <div class="divtd thcell">Return Policy</div>
	    </div>
	    <div class="divtr">
		<div class="divtd detailline">Returns are accepted within 30 days of shipping, minus a 10% Restocking fee. If more than 30 days has passed a store credit minus a 10% Restocking fee will be issued. For Exchanges no restocking fees will apply.
<BR><STRONG>NO RETURNS</STRONG> or <STRONG>EXCHANGES</STRONG> on Final Sale or Special Order items.
<BR>Merchandise must be returned to Bits of Lace in the precise condition it was received, unworn, unwashed, free of perfumes and markings. All original tags and stickers must be in place upon receipt.
<BR>Please complete Return/Exchange Authorization Form enclosed and return to:<BR><STRONG>Bits of Lace, Attn: Return/Exchanges, 453 West Coleman Blvd, Mt Pleasant, SC 29464.</STRONG>
<BR>For any questions or concerns contact our Support Team via email or phone at support@bitsoflace.com /800-842-3990
<BR>To see our full Return Policy, please visit bitsoflace.com/returns-exchanges 
</div>
</STRONG>
            </div>
        </div>
        <br>
        <br>
    </div>
<!-- END FOR LOOP THREE -->
    <div class="push"></div>
    <div style="page-break-after: always;"></div>

  %endfor
  <% set printed = mark_printed(objects) %>
</body>
</html>
