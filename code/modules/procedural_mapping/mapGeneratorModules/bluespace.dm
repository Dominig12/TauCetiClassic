proc/changeColorTurf(list/map)
	for(var/turf/T in map)
		T.set_light(1, 0.5, "#00ffff")
		T.color = "#0de2f1"
		var/icon/alpha_mask = new('icons/effects/effects.dmi', "wave4")//Scanline effect.
		T.filters += filter(type="wave", x=rand()*10-20, y=rand()*10-20, offset=rand())


/datum/map_generator_module/bottom_layer/bluespace_turfs
	spawnableTurfs = list(/turf/unsimulated/floor/fakealien = 100)

/datum/map_generator_module/bottom_layer/bluespace_turfs/generate()
	..()

/datum/map_generator_module/dense_layer/bluespace_turfs
	clusterCheckFlags = CLUSTER_CHECK_NONE

/datum/map_generator_module/dense_layer/bluespace_turfs/New()
	..()
	spawnableTurfs[/turf/unsimulated/floor/abductor] = 30

/datum/map_generator_module/dense_layer/bluespace_turfs/generate()
	..()
	changeColorTurf(mother.map)

/datum/map_generator_module/dense_layer/bluespace_filling
	spawnableAtoms = list(/obj/structure/cellular_biomass/grass/bluespace = 30, /obj/item/bluespace_crystal = 1, /obj/machinery/artifact/bluespace_crystal = 10, /mob/living/simple_animal/hostile/cellular/bluespace/meelee = 0.1, /mob/living/simple_animal/hostile/cellular/bluespace/ranged = 0.1)

/datum/map_generator_module/dense_layer/bluespace_filling/generate()
	..()



