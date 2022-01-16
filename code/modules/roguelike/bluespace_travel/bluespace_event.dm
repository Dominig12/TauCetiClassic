/datum/bluespace_event
	name = "event"

/datum/bluespace_event/proc/StartEvent()
	return
/datum/bluespace_event/proc/CheckEvent()
	return
/datum/bluespace_event/proc/EndEvent()
	return

/datum/bluespace_event/random_item

/datum/bluespace_event/random_item/StartEvent()
	var/obj/random/random_item = pick(typesof(/obj/random))
