/atom/movable/distortion_effect
	icon = 'icons/effects/96x96.dmi'
	icon_state = "distortion_b"
	pixel_x = -32
	pixel_y = -32
	plane = BLUESPACE_DISTORION_PLANE
	appearance_flags = PIXEL_SCALE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/landmark/bluespace_object
	var/size_room = 5
	var/offset = 5
	var/travelers_count = 0
	var/list/mob/travelers = list()
	var/turf/entry_points = list()
	var/type_map_template
	var/type_mapGenerator = /datum/map_generator/bluespace_object
	var/datum/map_template/template
	var/datum/map_generator/mapGenerator
	var/atom/movable/distortion_effect/distortion_effect

/obj/effect/landmark/bluespace_object/proc/Relay(mob/M)
	if(travelers_count == 0)
		GenerateRoom()
	M.forceMove(entry_points[dir2text(turn(M.dir, 180))])
	return

/obj/effect/landmark/bluespace_object/proc/GenerateRoom()
	var/height = template.height
	var/width = template.width
	var/radius_x = round(width / 2) + offset
	var/radius_y = round(height / 2) + offset

	//distortion_effect.loc = src

	entry_points[dir2text(WEST)] = locate(x - round(width/2) - offset, y, z)
	entry_points[dir2text(EAST)] = locate(x + round(width/2) + offset, y, z)
	entry_points[dir2text(NORTH)] = locate(x, y + round(height/2) + offset, z)
	entry_points[dir2text(SOUTH)] = locate(x, y - round(height/2) - offset, z)

	mapGenerator.defineRegion(locate(x - round(template.width/2) - offset, y - round(template.height/2) - offset, z), locate(x + round(template.width/2) + offset, y + round(template.height/2) + offset, z))
	mapGenerator.generate()
	template.load(get_turf(src), TRUE)
	distortion_effect = new()
	distortion_effect.loc = src.loc
	distortion_effect.transform = matrix().Scale((((radius_x + 1) + radius_x) * 32) / 96, (((radius_y + 1) + radius_y) * 32) / 96)


/obj/effect/landmark/bluespace_object/New()
	mapGenerator = new type_mapGenerator
	template = new('maps/templates/space_structures/teleporter.dmm')
	SSbluespace.AddObject(src)
	if(!distortion_effect)
		distortion_effect = new()
		distortion_effect.loc = src.loc
	GenerateRoom()

/obj/effect/landmark/bluespace_object/Destroy()
	QDEL_NULL(distortion_effect)
	return ..()

///obj/effect/landmark/map_generator/square/bluespace
///obj/effect/landmark/bluespace_object
///area/bluespace_areas/outside

