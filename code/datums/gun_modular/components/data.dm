/datum/gun_modular/component/data
	var/value
	var/id_data = "DEFAULT"

/datum/gun_modular/component/data/New(obj/item/gun_modular/module/P, value_data = null)

	value = value_data
	. = ..()

/datum/gun_modular/component/data/Action(datum/process_fire/process)

	var/datum/gun_modular/component/data/cache_data = process.GetCacheData(id_data)

	if(!cache_data)
		process.AddCacheData(src)
		return ..()

	cache_data.ChangeData(value)
	return ..()

/datum/gun_modular/component/data/proc/ChangeData(new_value)

	value = new_value

	return TRUE

/datum/gun_modular/component/data/proc/GetData()

	if(!value)
		return FALSE

	return value

/datum/gun_modular/component/data/CopyComponentGun()

	var/datum/gun_modular/component/data/new_component = ..()

	new_component.value = value

	return new_component
