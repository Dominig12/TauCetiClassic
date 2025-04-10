// signal
#define SIGNAL_TARGET "signal_target"
#define SIGNAL_INFO "signal_info"

//signals
#define SIGNAL_PING "ping"
#define GET_AMMO "get_ammo"

//modules id
#define GRIP_MODULE "grip"
#define CHAMBER_MODULE "chamber"
#define MAGAZINE_HOLDER "magazine_holder"
#define BARREL "barrel"

// process fire
#define ACTIVE_FIRE "active"
#define GUN_FIRE "gun_fire"
#define TARGET_FIRE "target"
#define USER_FIRE "user"
#define PROXIMITY_FIRE "proximity"
#define PARAMS_FIRE "params"
#define AMMO_FIRE "ammo"
#define BULLET_FIRE "bullet"
#define FIRE_SOUND "fire_sound"
#define SILENSED "silensed"
#define START_FIRE_LOC "start_fire_loc"
#define GUN_LOC "gun_loc"
#define FIRE_RESULT "fire_result"
#define AMMO_BOX "ammo_box"
#define AMMO_RETURN "ammo_return"
#define ALLOW_CALIBER "allow_caliber"

#define RECOIL "recoil"

#define CREATE_ADD_COMPONENT(type, parent_component, params...) _gun_modular_create_component(type, parent_component, list(##params))

/proc/_gun_modular_create_component(type, datum/pipe_system/component/parent, list/arguments)

	if(!ispath(type, /datum/pipe_system/component))
		CRASH("Attempted to create a component with wrong type: [type]")

	var/datum/pipe_system/component/new_component = new type(arglist(arguments))
	var/datum/pipe_system/component/parent_component = parent

	if(parent_component)
		parent_component.AddLastComponent(new_component)

	return new_component
