import time
from datetime import datetime
from openerp.report import report_sxw
from pprint import pprint as pp
from openerp.tools.translate import _
from tzlocal import get_localzone

BLANK =  {
          'qty_order': ' ',
          'qty_ship': ' ',
          'qty_backorder': ' ',
          'sku': ' ',
          'description': ' ',
          'special_order': ' ',
}

class PackSlipReport(report_sxw.rml_parse):
    def __init__(self, cr, uid, name, context):
        super(PackSlipReport, self).__init__(cr, uid, name, context=context)
        self.localcontext.update({'paginate_items': self._paginate_items, 
				  'get_date_created': self._get_date_created,
				  'mark_printed': self._mark_printed
	})


    def _get_date_created(self, picking):
        if picking.create_date and picking.create_date != 'False':
            date_obj = datetime.strptime(picking.create_date, '%Y-%m-%d %H:%M:%S')
            tz = get_localzone()
            dt = tz.localize(date_obj)
            return datetime.strftime(dt, '%m/%d/%Y')

        return ' '


    def get_backorder_qty(self, move):
	cr = self.cr
	query = """SELECT SUM(product_qty) AS "qty" FROM stock_move WHERE split_from = %s AND state != 'done'""" % move.id
	cr.execute(query)
	results = cr.fetchone()
	if results and results[0]:
	    return int(results[0])
	else:
	    return 0


    def prepare_line_val(self, product, move):
	special_order = ' '
	expected_ship_date = ' '
	cr = self.cr
	uid = self.uid

	for route in product.route_ids:
	    if route.name == 'Make To Order' and product.season.name != 'Stayer':
	        special_order = 'Yes'
		break

	qty_backorder = self.get_backorder_qty(move) if move.picking_id.state == 'done' else int(move.product_qty)
	if qty_backorder > 0:
	    if move.picking_id.anticipated_ship_date:
		expected_ship_date = move.picking_id.anticipated_ship_date
	    if move.procure_method == 'make_to_order':
		if move.picking_id.anticipated_ship_date:
		    expected_ship_date = move.picking_id.anticipated_ship_date
		else:
		    query = "SELECT id FROM stock_move WHERE purchase_line_id IS NOT NULL AND move_dest_id = %s" % move.id
		    cr.execute(query)
		    result = cr.fetchone()
		    if result and result[0]:
		        po_move = self.pool.get('stock.move').browse(cr, uid, result[0])
		        expected_ship_date = po_move.purchase_line_id.order_id.anticipated_receive_date or ' '

        return {
		'qty_order': int(move.procurement_id.product_qty),
		'qty_ship': int(move.product_qty) if move.picking_id.state == 'done' else 0,
		'qty_backorder': qty_backorder,
		'sku': product.default_code or '',
		'description': product.name or '',
		'special_order': special_order,
		'expected_ship_date': expected_ship_date,
	}


    def _get_components_list(self, line):
	result = []
	for component in line.item.components:
	    result.append(self.prepare_line_val(component.item, component.qty * line.qty))

	return result


    def show_backorder_lines(self, cr, uid, move):
	result = []
        move_obj = self.pool.get('stock.move')
	move_ids = move_obj.search(cr, uid, [('backorder_id', '=', move.picking_id.id)])
	if move_ids:
	   for backorder_move in move_obj.browse(cr, uid, move_ids):
	       result.append(self.prepare_line_val(backorder_move.product_id, backorder_move))

	return result


    def _process_lines(self, cr, uid, lines):
	result = []
        for line in lines:
	    result.append(self.prepare_line_val(line.product_id, line))

	result.extend(self.show_backorder_lines(cr, uid, line))
	return result
#	return sorted(result, key=lambda id: id['prime_location'])


    def _paginate_items(self, lines):

	cr = self.cr
	uid = self.uid
	processed_lines = self._process_lines(cr, uid, lines)
        items_per_page = 7
        result = []
        linecount = len(processed_lines)
        myrange = range(0,linecount)
        #myarrays = myrange[i:i+items_per_page]

        pages = [ myrange[i:i+items_per_page] for i in range(0,linecount,items_per_page) ]
        for page in pages:
            pagelist = []
            for order in page:
                pagelist.append(processed_lines[order])
	    if len(pagelist) != 5:
		for x in range(5 - len(pagelist)):
		    pagelist.append(BLANK)
            result.append(pagelist)
        return result


    def _mark_printed(self, pickings):
        cr = self.cr
        uid = self.uid

        picking_obj = self.pool.get('stock.picking')
	print_obj = self.pool.get('print.history')

        for picking in pickings:
 #           print_obj.create(cr, uid, {'picking': picking.id, 'status': 'success', 'user_id': uid, 'date': datetime.utcnow()})
	    picking_obj.write(cr, 1, picking.id, {'printed': True, 'printed_date': datetime.utcnow()})
		
        return True


report_sxw.report_sxw('report.pack.slip',
                      'stock.picking',
                      'addons/mage2odoo_picking_ticket/report/packing.mako',
                      parser=PackSlipReport)
