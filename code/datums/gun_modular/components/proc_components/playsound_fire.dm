/datum/gun_modular/component/proc_gun/playsound_fire
	id_component = "playsound_fire"

/datum/gun_modular/component/proc_gun/playsound_fire/RunTimeAction(datum/process_fire/process)

	var/datum/gun_modular/component/data/sound_data/fire_sound_data = process.GetCacheData("fire_sound")
	var/datum/gun_modular/component/data/gun_user/gun_user_data = process.GetCacheData(USER_FIRE)

	if(!fire_sound_data || !gun_user_data)
		return ..()

	if(!fire_sound_data.IsValid() || !gun_user_data.IsValid())
		return ..()

	var/mob/user = gun_user_data.GetData()

	playsound(user, fire_sound_data.sound, VOL_EFFECTS_MASTER, fire_sound_data.volume, fire_sound_data.vary, null, fire_sound_data.extrarange)
	return ..()
