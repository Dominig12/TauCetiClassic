/datum/gun_modular/component/check/user_isLiving
	id_component = "user_isLiving"

/datum/gun_modular/component/check/user_isLiving/Action(datum/process_fire/process)

	var/datum/gun_modular/component/data/cache_data = process.GetCacheData(USER_FIRE)

	if(!cache_data)
		FailCheck(process)
		return ..()

	var/mob/user = cache_data.GetData()

	if(isnull(user))
		FailCheck(process)
		return ..()

	if(!istype(user))
		FailCheck(process)
		return ..()

	if(!isliving(user))
		FailCheck(process)
		return ..()

	SuccessCheck(process)
	return ..()
