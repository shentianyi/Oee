json.extract! inventory_item, :id, :inventory_list_id, :fix_asset_track_id, :cap_date, :profit_center, :asset_description, :acquis_val, :accum_dep, :book_val, :ts_equipment_nr, :ts_project, :ts_inventory_user, :ts_keeper, :ts_position, :ts_nameplate_track, :ts_type, :ts_equipment_type, :ts_area, :ts_supplier, :status, :remark, :ts_inventory_result, :created_at, :updated_at
json.url inventory_item_url(inventory_item, format: :json)