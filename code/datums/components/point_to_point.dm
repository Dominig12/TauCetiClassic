/datum/component/point_to_point
	var/datum/component/point_to_point/parent_point = null
	var/list/points_of_entry = list() //Attachment points for attached objects
	var/list/exit_point = list() //Points by which these objects are connected to other objects
	var/list/mask_overlays = list()
	var/list/attach_point = list()
	var/list/image/complex_image = list()
	var/atom/parent_atom = null
	var/datum/callback/Update_Callback
	var/prefix

/datum/component/point_to_point/Initialize(var/atom/A, var/prefix, datum/callback/_Update_Callback)
	src.prefix = prefix
	parent_atom = A
	Update_Callback = _Update_Callback

/datum/component/point_to_point/proc/change_list_entry(var/type, var/direct, var/list/points, var/key = null)
	LAZYINITLIST(points_of_entry)
	LAZYINITLIST(points_of_entry[type])
	LAZYINITLIST(points_of_entry[type][direct])
	if(key)
		points_of_entry[type][direct][key] = points
		return TRUE
	for(var/key_tmp in points)
		points_of_entry[type][direct][key_tmp] = points[key_tmp]
	return TRUE

/datum/component/point_to_point/proc/change_list_exit(var/type, var/direct, var/list/points)
	LAZYINITLIST(exit_point)
	LAZYINITLIST(exit_point[type])
	LAZYINITLIST(exit_point[type][direct])
	exit_point[type][direct] = points
	return TRUE

/datum/component/point_to_point/proc/change_list_mask(var/type, var/direct, var/list/points, var/key = null)
	LAZYINITLIST(mask_overlays)
	LAZYINITLIST(mask_overlays[type])
	LAZYINITLIST(mask_overlays[type][direct])
	if(key)
		mask_overlays[type][direct][key] = points
		return TRUE
	for(var/key_tmp in points)
		mask_overlays[type][direct][key_tmp] = points[key_tmp]
	return TRUE

/datum/component/point_to_point/proc/check_list_point(var/list/changed_list, var/type, var/direct, var/point = null)
	if(!changed_list)
		return FALSE
	if(!changed_list[type])
		return FALSE
	if(!changed_list[type][direct])
		return FALSE
	if(point)
		if(!changed_list[type][direct][point])
			return FALSE
	return TRUE

/datum/component/point_to_point/proc/get_delta_offset(var/datum/component/point_to_point/target, var/type = "ICON", var/direct = "[SOUTH]", var/point = prefix)
	var/list/points_modify = list(0, 0, -3)
	if(target.check_list_point(target.points_of_entry, type, direct, point))
		points_modify = target.points_of_entry[type][direct][point]

	var/delta_x = 0
	var/delta_y = 0
	var/layer_overlay = points_modify[3]

	delta_x = points_modify[1] - exit_point[type][direct][1]
	delta_y = points_modify[2] - exit_point[type][direct][2]
	
	if(check_list_point(points_of_entry, type, direct))
		for(var/key in points_of_entry[type][direct])
			if(target.check_list_point(target.points_of_entry, type, direct, key))
				continue
			if(attach_point[key])
				continue
			target.change_list_entry(type, direct, list(points_of_entry[type][direct][key][1] + delta_x, points_of_entry[type][direct][key][2] + delta_y, points_of_entry[type][direct][key][3]), key)

	return list(delta_x, delta_y, layer_overlay)

/datum/component/point_to_point/proc/build_images(var/direct = "[SOUTH]", var/slot = "ICON")
	var/image/overlay = image(null)
	for(var/key in attach_point)
		var/datum/component/point_to_point/point = attach_point[key]
		if(!point)
			continue
		var/image/M_icon = image(null)
		M_icon.appearance = point.complex_image[slot].appearance
		
		M_icon.color = point.complex_image[slot].color

		var/list/delta_offset = point.get_delta_offset(src, slot, direct)

		M_icon.pixel_x = delta_offset[1]
		M_icon.pixel_y = delta_offset[2]
		M_icon.layer = delta_offset[3]

		overlay.add_overlay(M_icon)

	return overlay

/datum/component/point_to_point/proc/update()
	if(Update_Callback)
		return Update_Callback.Invoke(src)

/datum/component/point_to_point/proc/get_image(var/direct = "[SOUTH]", var/slot = "ICON")
	var/image/I = image(null)
	I = build_images(direct, slot)
	I.appearance_flags |= KEEP_TOGETHER

	var/image/mask = image(null)
	if(check_list_point(mask_overlays, slot, direct))
		for(var/key in mask_overlays[slot][direct])
			for(var/image/mask_add_key in mask_overlays[slot][direct][key])
				mask.add_overlay(mask_add_key)
	mask.appearance_flags |= KEEP_TOGETHER
	mask.render_target = "\ref[mask]"
	
	I.filters += filter(type = "alpha", render_source = "\ref[mask]", flags = MASK_INVERSE)
	I.add_overlay(mask)

	return I

/datum/component/point_to_point/proc/check_connect(var/datum/component/point_to_point/point)
	if(point.attach_point[prefix])
		return FALSE
	return TRUE

/datum/component/point_to_point/proc/connect_to_point(var/datum/component/point_to_point/parent_point)
	if(!check_connect(parent_point))
		return FALSE
	parent_point.attach_point[prefix] = src
	src.parent_point = parent_point
	parent_point.update()
	return TRUE

/datum/component/point_to_point/proc/disconnect_to_point()
	parent_point.attach_point[prefix] = null
	parent_point.update()
	parent_point = null
	return TRUE

/datum/component/point_to_point/proc/add_image_to_slot(var/image/I, var/slot)
	if(complex_image[slot])
		var/image/IS = image(null)
		IS.appearance = I.appearance
		complex_image[slot].add_overlay(IS)
		update()

/datum/component/point_to_point/proc/remove_image_to_slot(var/image/I, var/slot)
	if(complex_image[slot])
		var/image/IS = image(null)
		IS.appearance = I.appearance
		complex_image[slot].cut_overlay(IS)
		update()

/datum/component/point_to_point/proc/set_image_to_slot(var/image/I, var/slot)
	var/image/IS = image(null)
	IS.appearance = I.appearance
	complex_image[slot] = IS
	update()

/datum/component/point_to_point/proc/clear_image_to_slot(var/slot)
	complex_image[slot] = null
	update()

/datum/component/point_to_point/proc/get_image_to_slot(var/slot)
	return complex_image[slot]