<?xml version="1.0"?>

<queryset>

  <fullquery name="select_orders">
    <querytext> 
      SELECT DISTINCT cio.order_id, cio.parent_id, cio.cnimp_number, cp.pretty_name AS provider_pretty, cio.fabricant_id, cp1.pretty_name AS fabricant_pretty, cio.cnimp_date, cio.di_status, cio.order_cost, cio.transport_type, cio.li_need_p 
      FROM cn_import_orders cio 
      LEFT JOIN cn_import_orders cio2 ON (cio2.parent_id = cio.order_id)
      LEFT OUTER JOIN cn_persons cp ON (cp.person_id = cio.provider_id)
      LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = cio.fabricant_id)
      $where_clause
      [template::list::filter_where_clauses -and -name "orders"]
      [template::list::orderby_clause -orderby -name "orders"]
    </querytext>
  </fullquery>

  <fullquery name="select_comment">
    <querytext> 
	SELECT r.title
	FROM general_comments g,
	cr_items i,
	cr_revisions r,
	acs_objects o,
	persons p
	WHERE g.object_id = :order_id AND
	i.item_id = g.comment_id AND
	r.revision_id = i.live_revision AND
	o.object_id = g.comment_id AND
	p.person_id = o.creation_user
	ORDER BY creation_date DESC
	LIMIT 1

    </querytext>
  </fullquery>

</queryset>
