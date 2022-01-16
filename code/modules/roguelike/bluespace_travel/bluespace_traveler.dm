/datum/bluespace_traveler
	var/atom/movable/owner
	var/list/visited_objects = list()
	var/list/active_traits = list()
	var/obj/effect/landmark/bluespace_object/active_object
	var/extinction_rate = 100

/datum/bluespace_traveler/proc/GetTypeRoom()

