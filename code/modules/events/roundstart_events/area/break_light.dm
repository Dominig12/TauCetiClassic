/datum/event/roundstart/area/break_light/start()
	for(var/area/target_area in targeted_areas)
		message_admins("RoundStart Event: All light break in [target_area]")
		for(var/obj/machinery/light/L in target_area)
			L.broken(TRUE)
