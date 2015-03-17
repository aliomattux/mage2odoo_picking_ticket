import time
from datetime import datetime
from openerp.report import report_sxw
from pprint import pprint as pp
from openerp.tools.translate import _
from tzlocal import get_localzone

BLANK =  {
          'qty': ' ',
          'description': ' ',
          'sku': ' ',
          'sale_order': ' ',
          'vendor_code': ' ',
}

class ReceiveSlipReport(report_sxw.rml_parse):
    def __init__(self, cr, uid, name, context):
        super(ReceiveSlipReport, self).__init__(cr, uid, name, context=context)
        self.localcontext.update({'paginate_items': self._paginate_items, 
				  'get_date_created': self._get_date_created,
	})


    def _get_date_created(self, picking):
        if picking.create_date and picking.create_date != 'False':
            date_obj = datetime.strptime(picking.create_date, '%Y-%m-%d %H:%M:%S')
            tz = get_localzone()
            dt = tz.localize(date_obj)
            return datetime.strftime(dt, '%m/%d/%Y')

        return ' '



    def prepare_line_val(self, product, move):
	special_order = ' '
	expected_ship_date = ' '
	cr = self.cr
	uid = self.uid

        return {
		'qty': int(move.product_qty),
		'sku': product.default_code or '',
		'description': product.name or '',
		'sale_order': move.procurement_id.mo_sale.name or ' ',
		'vendor_code': ' ',
	}



    def _process_lines(self, cr, uid, lines):
	result = []
        for line in lines:
	    result.append(self.prepare_line_val(line.product_id, line))

	return result
#	return sorted(result, key=lambda id: id['prime_location'])


    def _paginate_items(self, lines):

	cr = self.cr
	uid = self.uid
	processed_lines = self._process_lines(cr, uid, lines)
        items_per_page = 20
        result = []
        linecount = len(processed_lines)
        myrange = range(0,linecount)
        #myarrays = myrange[i:i+items_per_page]

        pages = [ myrange[i:i+items_per_page] for i in range(0,linecount,items_per_page) ]
        for page in pages:
            pagelist = []
            for order in page:
                pagelist.append(processed_lines[order])
	    if len(pagelist) != 20:
		for x in range(20 - len(pagelist)):
		    pagelist.append(BLANK)
            result.append(pagelist)
        return result




report_sxw.report_sxw('report.receive.slip',
                      'stock.picking',
                      'addons/mage2odoo_picking_ticket/report/receive.mako',
                      parser=ReceiveSlipReport)
