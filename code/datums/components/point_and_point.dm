/datum/component/image_holder
	var/id
	var/list/main_images = list()
	var/list/exit_points = list();
	var/list/entry_points = list();
	var/list/datum/component/image_holder/childs = list()
	var/datum/component/image_holder/parent_image_holder = null
	var/atom/parent_obj = null

/datum/component/image_holder/Initialize(var/id)
	src.id = id
	if(istype(parent, /atom))
		parent_obj = parent
	else
		parent_image_holder = parent

/datum/component/image_holder/proc/CreateChild(var/id_child)
	LAZYINITLIST(childs)
	childs[id_child] = AddComponent(/datum/component/image_holder, id_child)
	return childs[id_child]

/datum/component/image_holder/proc/SetChild(var/datum/component/image_holder/child)
	LAZYINITLIST(childs)
	childs[child.id] = child

/datum/component/image_holder/proc/DeleteChild(var/id_child)
	LAZYINITLIST(childs)
	if(childs[id_child])
		childs[id_child].Destroy()

/datum/component/image_holder/proc/GetStringDir(var/dir = SOUTH)
	return "[dir]"

/datum/component/image_holder/proc/GetParentObj()
	if(parent_obj)
		return parent_obj
	return parent_image_holder.GetParentObj()

/datum/component/image_holder/proc/SetImage(var/image/img, var/dir = SOUTH, var/type = "ICON")
	preparing_main_images(dir, type)
	img.appearance_flags |= KEEP_TOGETHER
	main_images[GetStringDir(dir)][type] = img

/datum/component/image_holder/proc/GetImage(var/dir, var/type)
	preparing_main_images(dir, type)
	if(!main_images[GetStringDir(dir)][type])
		return FALSE
	return main_images[GetStringDir(dir)][type]

/datum/component/image_holder/proc/Calculate_Offset(var/dir = SOUTH, var/type = "ICON")
	var/offset_x = 0
	var/offset_y = 0
	if(parent_image_holder)
		offset_x += parent_image_holder.GetEntryPoints(dir, type, id)[1]
		offset_y += parent_image_holder.GetEntryPoints(dir, type, id)[2]
	offset_x -= GetExitPoint(dir, type)[1]
	offset_y -= GetExitPoint(dir, type)[2]
	return list(offset_x, offset_y)

/datum/component/image_holder/proc/GetGlobalOffset(var/dir = SOUTH, var/type = "ICON")
	var/offset = Calculate_Offset(dir, type)
	if(parent_image_holder)
		offset[1] += parent_image_holder.GetGlobalOffset(dir, type)[1]
		offset[2] += parent_image_holder.GetGlobalOffset(dir, type)[2]
	return offset

/datum/component/image_holder/proc/AddMask(var/image/img, var/dir = SOUTH, var/type = "ICON", var/entry_offset = list(0, 0))
	img.render_target = "\ref[img]"
	var/list/offset = GetGlobalOffset(dir, type)
	offset[1] -= entry_offset[1]
	offset[2] -= entry_offset[2]
	img.pixel_x = -offset[1]
	img.pixel_y = -offset[2]

	if(GetImage(dir, type))
		GetImage(dir, type).filters += filter(type = "alpha", render_source = "\ref[img]", flags = MASK_INVERSE, x = -offset[1], y = -offset[2])
		GetImage(dir, type).add_overlay(img)

/datum/component/image_holder/proc/preparing_entry_points(var/dir = SOUTH, var/type = "ICON", var/id = "null")
	LAZYINITLIST(entry_points)
	LAZYINITLIST(entry_points[GetStringDir(dir)])
	LAZYINITLIST(entry_points[GetStringDir(dir)][type])
	return TRUE

/datum/component/image_holder/proc/preparing_exit_point(var/dir = SOUTH, var/type = "ICON")
	LAZYINITLIST(exit_points)
	LAZYINITLIST(exit_points[GetStringDir(dir)])
	return TRUE

/datum/component/image_holder/proc/preparing_main_images(var/dir = SOUTH, var/type = "ICON")
	LAZYINITLIST(main_images)
	LAZYINITLIST(main_images[GetStringDir(dir)])
	return TRUE

/datum/component/image_holder/proc/GetEntryPoints(var/dir = SOUTH, var/type = "ICON", var/id = "null")
	preparing_entry_points(dir, type, id)
	if(entry_points[GetStringDir(dir)][type][id] == list())
		entry_points[GetStringDir(dir)][type][id] = list(0, 0)
	return entry_points[GetStringDir(dir)][type][id]

/datum/component/image_holder/proc/GetExitPoint(var/dir = SOUTH, var/type = "ICON")
	preparing_exit_point(dir, type)
	if(exit_points[GetStringDir(dir)][type] == list())
		exit_points[GetStringDir(dir)][type] = list(0, 0)
	return exit_points[GetStringDir(dir)][type]

/datum/component/image_holder/proc/ChangeEntryPoints(var/dir = SOUTH, var/type = "ICON", var/id = null, var/list/points = list("null" = list(0, 0)))
	if(!id)
		for(var/id_point in points)
			preparing_entry_points(dir, type, id_point)
			entry_points[GetStringDir(dir)][type][id_point] = points[id_point]
	else
		preparing_entry_points(dir, type, id)
		entry_points[GetStringDir(dir)][type][id] = points

/datum/component/image_holder/proc/ChangeExitPoint(var/dir = SOUTH, var/type = "ICON", var/list/points = list(0, 0))
	preparing_exit_point(dir, type)
	exit_points[GetStringDir(dir)][type] = points

/datum/component/image_holder/proc/build_images(var/entry_point_x = 0, var/entry_point_y = 0)
	for(var/child in childs)
		if(childs[child])
			childs[child].build_images()
	for(var/dir in main_images)
		for(var/type in main_images[dir])
			var/offset = Calculate_Offset(dir, type)
			var/image/M = main_images[GetStringDir(dir)][type]
			M.pixel_x = offset[1] + entry_point_x
			M.pixel_y = offset[2] + entry_point_y
			if(parent_image_holder)
				parent_image_holder.main_images[GetStringDir(dir)][type].add_overlay(M)
	return main_images
