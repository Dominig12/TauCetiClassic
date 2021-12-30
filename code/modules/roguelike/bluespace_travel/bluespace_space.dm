/obj/effect/landmark/bluespace_object
	var/size_room = 5
	var/offset = 5
	var/travelers_count = 0
	var/turf/entry_points = list()
	var/type_map_template
	var/type_mapGenerator = /datum/map_generator/bluespace_object
	var/datum/map_template/template
	var/datum/map_generator/mapGenerator

/obj/effect/landmark/bluespace_object/proc/Relay(mob/M)
	if(travelers_count == 0)
		GenerateRoom()
	M.forceMove(entry_points[dir2text(turn(M.dir, 180))])
	return

/obj/effect/landmark/bluespace_object/proc/GenerateRoom()
	var/height = template.height
	var/width = template.width

	entry_points[dir2text(WEST)] = locate(x - round(width/2) - offset, y, z)
	entry_points[dir2text(EAST)] = locate(x + round(width/2) + offset, y, z)
	entry_points[dir2text(NORTH)] = locate(x, y + round(height/2) + offset, z)
	entry_points[dir2text(SOUTH)] = locate(x, y - round(height/2) - offset, z)

	mapGenerator.defineRegion(locate(x - round(template.width/2) - offset, y - round(template.height/2) - offset, z), locate(x + round(template.width/2) + offset, y + round(template.height/2) + offset, z))
	mapGenerator.generate()
	template.load(get_turf(src), TRUE)

/obj/effect/landmark/bluespace_object/New()
	mapGenerator = new type_mapGenerator
	template = new('maps/templates/space_structures/teleporter.dmm')
	SSbluespace.AddObject(src)
	GenerateRoom()
///obj/effect/landmark/map_generator/square/bluespace
///obj/effect/landmark/bluespace_object
///area/bluespace_areas/outside

