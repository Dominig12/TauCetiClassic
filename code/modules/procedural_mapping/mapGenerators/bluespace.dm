/datum/map_generator/bluespace
	modules = list(
	/datum/map_generator_module/bottom_layer/bluespace_turfs,
	/datum/map_generator_module/bluespace_area_outside)
	buildmode_name = "Pattern: Bluespace"

/datum/map_generator/bluespace_object
	modules = list(
	/datum/map_generator_module/bottom_layer/massdelete,
	/datum/map_generator_module/bottom_layer/bluespace_object_turf,
	/datum/map_generator_module/bluespace_area_inside)
	buildmode_name = "Pattern: Bluespace Object"

///datum/map_generator_module/bottom_layer/bluespace_turfs
///datum/map_generator_module/bottom_layer/massdelete
