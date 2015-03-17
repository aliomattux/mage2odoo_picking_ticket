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
            <div class="divtd" style="font-size: 25px; width: 30%;">Vendor Receipt</div>
            <div class="divtd head top department" style="width: 20%;">
		<br>
            </div>
            <div class="divtd head top" width: 20%;">
                <div class="onebytwo">${picking.id}</div>
            </div>

            <div class="divtd head top" align="right" style="width: 40%;">
                <div class="divtr">
		    <div class="detailtableheadertop" >
		        <div class="divthhead whiteonblack">
                            <div class="divtd thcell" style="font-size: 15px;">PO #</div>
                            <div class="divtd thcell" style="font-size: 15px;">Vendor Ref #</div>
			</div>
			<div class="divtr">
                            <div class="divtd detailline" style="font-size: 12px;">${picking.purchase.name or ' '}</div>
                            <div class="divtd detailline" style="font-size: 12px;">${picking.purchase.partner_ref or ' '}</div>
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
            <div class="divtd thcell half" style="font-size: 15px;">Vendor</div>
            <div class="divtd thcell half" style="font-size: 15px;">PO Notes</div>
	</div>

	<div class="divtr">
	    <div class="divtd detaillinehead"><strong>
                        <div>${picking.partner_id.name or ' '}</div>
	    </strong>
            </div>
	    <div class="divtd detaillinehead style="height: 70px;">
		<div style="font-size: 12px;">${picking.purchase.notes or ''}</div>
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
                <div class="divtd thcell" style="font-size: 14px; width: 30%;">Style Number</div>
	        <div class="divtd thcell" style="font-size: 14px; width: 15%;">Product Name</div>
                <div class="divtd thcell" style="font-size: 14px; width: 13%">Vendor Code</div>
                <div class="divtd thcell" style="font-size: 14px; width: 13%;">Quantity</div>
                <div class="divtd thcell" style="font-size: 14px; width: 13%;">Sales Order</div>

            </div>

            <!--for order in page:-->
            %for line in myset:
                <div class="divtr">
		    <div class="divtd detailline">${line['sku']}</div>
		    <div class="divtd detailline">${line['description']}</div>
                    <div class="divtd detailline qty highlightme">${line['vendor_code']}</div>
		    <div class="divtd detailline qty highlightme">${line['qty']}</div>
		    <div class="divtd detailline qty highlightme">${line['sale_order']}</div>
                </div>
            %endfor
	    
        </div>
    </div>
    %endfor
    <br>
    <br>
    <!-- END WRAPPER -->
</div>
<!-- END FOR LOOP THREE -->
    <div class="push"></div>
    <div style="page-break-after: always;"></div>

  %endfor
</body>
</html>
