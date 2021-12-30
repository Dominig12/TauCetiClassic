/obj/effect/landmark/map_generator
	var/startTurfZ = -1
	var/endTurfZ = -1
	var/start_locate
	var/end_locate
	var/mapGeneratorType = /datum/map_generator/nature
	var/datum/map_generator/mapGenerator

/obj/effect/landmark/map_generator/New()
	..()
	if(startTurfZ < 0)
		startTurfZ = z
	if(endTurfZ < 0)
		endTurfZ = z

	mapGenerator = new mapGeneratorType()

/obj/effect/landmark/map_generator/square
	var/offset_left = 0
	var/offset_bottom = 0
	var/offset_right = 0
	var/offset_top = 0

/obj/effect/landmark/map_generator/square/New()
	..()
	mapGenerator.defineRegion(locate(x - offset_left, y - offset_bottom, startTurfZ), locate(x + offset_right, y + offset_top, endTurfZ))
	mapGenerator.generate()

/obj/effect/landmark/map_generator/circle
	var/radius = 5

/obj/effect/landmark/map_generator/circle/New()
	..()
	mapGenerator.defineCircularRegion(locate(1 , 1, 1), locate(5, 5, 5))
	mapGenerator.generate()

/obj/effect/landmark/map_generator/circle/bluespace
	radius = 10
	mapGeneratorType = /datum/map_generator/bluespace

/obj/effect/landmark/map_generator/square/bluespace
	offset_left = 5
	offset_bottom = 5
	offset_right = 5
	offset_top = 5
	mapGeneratorType = /datum/map_generator/bluespace

/obj/effect/landmark/map_generator/square/bluespace/New()
	mapGenerator = new mapGeneratorType()
	mapGenerator.defineRegion(locate(1, 1, z), locate(254, 254, z))
	mapGenerator.generate()

