/datum/component/image_holder
	var/id
	var/image/main_image
	var/list/exit_points = list(0, 0);
	var/list/entry_points = list();

/datum/component/image_holder/Initialize(var/id, image/img)
	src.id = id
	src.main_image = img
	if(istype(parent, /atom))
		RegisterSignal(parent, list(COMSIG_FORCEFIELD_PROTECT), .proc/add_protected)
