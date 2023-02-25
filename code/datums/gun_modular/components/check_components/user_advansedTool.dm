/datum/gun_modular/component/check/user_advansedTool
	id_component = "user_advansedTool"

/datum/gun_modular/component/check/user_advansedTool/Action(datum/process_fire/process)

	var/mob/living/user = process.GetCacheData(USER_FIRE)

	if(isnull(user))
		FailCheck(process)
		return ..()

	if(!istype(user))
		FailCheck(process)
		return ..()

	if(!user.IsAdvancedToolUser())
		FailCheck(process)
		return ..()

	SuccessCheck(process)
	return ..()
