/proc/changeColorTurf(list/map)
	for(var/turf/T in map)
		T.set_light(1, 0.5, "#00ffff")
		T.color = "#0de2f1"


/datum/map_generator_module/bottom_layer/bluespace_turfs
	spawnableTurfs = list(/turf/unsimulated/floor/fakealien = 100)
	//spawnableAtoms = list(/obj/effect/effect/smoke/infinity = 100)

/datum/map_generator_module/bottom_layer/bluespace_turfs/generate()
	. = ..()
	var/list/map = mother.map
	for(var/turf/T in map)
		T.opacity = TRUE

/datum/map_generator_module/bluespace_area_outside
	spawnableAtoms = list(/area/bluespace_areas/outside = 100)

/datum/map_generator_module/bottom_layer/bluespace_object_turf
	spawnableTurfs = list(
		/turf/unsimulated/floor/fakealien = 100,
		/turf/unsimulated/floor/abductor = 10,
		/turf/unsimulated/floor/fakespace = 20,
		/turf/unsimulated/floor/cult = 10
	)

/datum/map_generator_module/bottom_layer/bluespace_object_turf/generate()
	. = ..()
	changeColorTurf(mother.map)

/datum/map_generator_module/bluespace_area_inside
	spawnableAtoms = list(/area/bluespace_areas/inside = 100)



