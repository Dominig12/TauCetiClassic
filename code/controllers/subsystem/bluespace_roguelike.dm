SUBSYSTEM_DEF(bluespace)
	name = "Bluespace Roguelike"
	flags = SS_NO_FIRE
	var/list/obj/effect/landmark/bluespace_object/bluespace_objects = list()

/datum/controller/subsystem/bluespace/proc/Relaying(mob/M)
	LAZYINITLIST(bluespace_objects)
	if(length(bluespace_objects) <= 0)
		return
	var/travelers_count_min = bluespace_objects[1].travelers_count
	var/list/obj/effect/landmark/bluespace_object/objects = list()
	for(var/obj/effect/landmark/bluespace_object/object in bluespace_objects)
		if(object.travelers_count < travelers_count_min)
			travelers_count_min = object.travelers_count
	for(var/obj/effect/landmark/bluespace_object/object in bluespace_objects)
		if(travelers_count_min == object.travelers_count)
			LAZYADD(objects, object)

	var/obj/effect/landmark/bluespace_object/object_relaying = bluespace_objects[1]
	if(length(objects) > 0)
		object_relaying = pick(objects)

	object_relaying.Relay(M)

/datum/controller/subsystem/bluespace/proc/AddObject(obj/effect/landmark/bluespace_object/O)
	LAZYADD(bluespace_objects, O)
