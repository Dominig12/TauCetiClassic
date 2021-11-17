/datum/component/point_and_point
	var/id = "DEFAULT"
	var/list/image/images = null
	var/list/enter_points = null
	var/list/exit_points = null
	var/list/datum/component/point_and_point/parent = null
	var/list/datum/component/point_and_point/childs = list()

/datum/component/point_and_point/Initialize(id_point, datum/component/point_and_point/parent_point = null)
	id = id_point
	if(parent_point)
		parent = parent_point

/datum/component/point_and_point/check_enter_points_list(type, id, dir)
	LAZYINITLIST(enter_points)
