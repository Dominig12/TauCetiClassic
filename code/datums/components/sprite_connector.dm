/datum/component/sprite_connector
	var/datum/component/sprite_connector/parent_point = null
	var/list/datum/component/sprite_connector/attached_sprites = list()
	var/image/image_self = null
	var/list/entry_points = list()
	var/list/exit_point = list()
	var/list/end_point = list()
	var/datum/callback/update_function = null
	var/name = ""

/datum/component/sprite_connector/Initialize(var/image/parent_image, var/name, datum/callback/update_function)

	name = name
	update_function = update_function
	image_self = parent_image

	RegisterSignal(parent, list(COMSIG_ATOM_CHANGE_DIR), .proc/update)

/datum/component/sprite_connector/proc/ChangeEndPoint(var/type, var/direct, var/list/points)
	LAZYINITLIST(end_point)
	LAZYINITLIST(end_point[type])
	LAZYINITLIST(end_point[type][direct])
	end_point[type][direct] = points
	return TRUE

/datum/component/sprite_connector/proc/ChangeExitPoint(var/type, var/direct, var/list/points)
	LAZYINITLIST(exit_point)
	LAZYINITLIST(exit_point[type])
	LAZYINITLIST(exit_point[type][direct])
	exit_point[type][direct] = points
	return TRUE

/datum/component/sprite_connector/proc/ChangeEntryPoint(var/type, var/direct, var/list/points, var/key = null)
	LAZYINITLIST(entry_points)
	LAZYINITLIST(entry_points[type])
	LAZYINITLIST(entry_points[type][direct])
	if(key)
		entry_points[type][direct][key] = points
		return TRUE
	for(var/key_tmp in points)
		entry_points[type][direct][key_tmp] = points[key_tmp]
	return TRUE

/datum/component/sprite_connector/proc/CalculateOffset(var/type, var/direct)
	var/pixel_x = end_point[0]
	var/pixel_y = end_point[1]
	if(parent_point)
		pixel_x = parent_point.entry_points[type][direct][name][0]
		pixel_y = parent_point.entry_points[type][direct][name][1]

	LAZYINITLIST(exit_point)
	LAZYINITLIST(exit_point[type])
	LAZYINITLIST(exit_point[type][direct])
	if(exit_point[type][direct].len == 0)
		exit_point[type][direct] = list(0, 0)

	var/offset_x = pixel_x - exit_point[type][direct][0]
	var/offset_y = pixel_y - exit_point[type][direct][1]

	return list(offset_x, offset_y)

/datum/component/sprite_connector/proc/CalculateAbsoluteOffset(var/type, var/direct)
	var/list/offset = CalculateOffset(type, direct)
	var/pixel_x = offset[0]
	var/pixel_y = offset[1]

	if(parent_point)
		var/list/parent_offset = parent_point.CalculateAbsoluteOffset(type, direct)
		pixel_x += parent_offset[0]
		pixel_y += parent_offset[1]

	return list(pixel_x, pixel_y)

/datum/component/sprite_connector/proc/ConnectPoint(var/datum/component/sprite_connector/point)
	attached_sprites[point.name] = point
	update()

/datum/component/sprite_connector/proc/DisconnectPoint(var/datum/component/sprite_connector/point)
	attached_sprites[point.name] = null
	update()

/datum/component/sprite_connector/proc/update()
	update_function.Invoke()

/datum/component/sprite_connector/proc/build_image(var/type, var/direct)
	var/image/result = image(icon = image_self.icon, icon_state = image_self.icon_state)
	result.appearance = image_self.appearance
	result.appearance_flags |= KEEP_TOGETHER

	var/list/offset = CalculateOffset(type, direct)
	result.pixel_x = offset[0]
	result.pixel_y = offset[1]

	LAZYINITLIST(attached_sprites)

	for(var/child_name in attached_sprites)
		if(!attached_sprites[child_name])
			continue
		var/image/child_image = attached_sprites[child_name].build_image(type, direct)
		result.add_overlay(child_image)
		child_image.color = result.color

	return result.appearance








