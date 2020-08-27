/obj/item/weapon/gun_modular/module/frame
    name = "gun frame"
    desc = "The frame, the base of the weapon, all parts of the weapon are attached to it, and configuration and interaction of the parts also take place through it. For normal assembly, use the installation order: Chamber, Magazine Holder, Handle, Barrel, Accessories"
    icon_state = "frame_icon"
    icon_overlay_layer = LAYER_FRAME
    lessdamage = 0
    lessdispersion = -2
    size_gun = 1
    prefix = FRAME
    points_of_entry = list(
        "ICON" = list(
            SOUTH_DIR = list(CHAMBER = list(16, 16),
                            HANDLE = list(0, 0),
                            MAGAZINE = list(0, 0),
                            BARREL = list(0, 0),
                            "DNA Crypter" = list(13, 14)),
            NORTH_DIR = list(CHAMBER = list(16, 16),
                            HANDLE = list(0, 0),
                            MAGAZINE = list(0, 0),
                            BARREL = list(0, 0),
                            "DNA Crypter" = list(13, 14)),
            WEST_DIR = list(CHAMBER = list(16, 16),
                            HANDLE = list(0, 0),
                            MAGAZINE = list(0, 0),
                            BARREL = list(0, 0),
                            "DNA Crypter" = list(13, 14)),
            EAST_DIR = list(CHAMBER = list(16, 16),
                            HANDLE = list(0, 0),
                            MAGAZINE = list(0, 0),
                            BARREL = list(0, 0),
                            "DNA Crypter" = list(13, 14))
        ),
        "hand_l" = list(
            SOUTH_DIR = null,
            NORTH_DIR = null,
            WEST_DIR = null,
            EAST_DIR = null
        ),
        "hand_r" = list(
            SOUTH_DIR = null,
            NORTH_DIR = null,
            WEST_DIR = null,
            EAST_DIR = null
        ),
        "belt"  = list(
            SOUTH_DIR = null,
            NORTH_DIR = null,
            WEST_DIR = null,
            EAST_DIR = null
        ),
        "back"  = list(
            SOUTH_DIR = null,
            NORTH_DIR = null,
            WEST_DIR = null,
            EAST_DIR = null
        )
    )
    exit_point = list(
        "ICON" = list(
            SOUTH_DIR = list(16, 16),
            NORTH_DIR = list(16, 16),
            WEST_DIR = list(16, 16),
            EAST_DIR = list(16, 16)
        ),
        "hand_l" = list(
            SOUTH_DIR = list(0, 0),
            NORTH_DIR = list(0, 0),
            WEST_DIR = list(0, 0),
            EAST_DIR = list(0, 0)
        ),
        "hand_r" = list(
            SOUTH_DIR = list(0, 0),
            NORTH_DIR = list(0, 0),
            WEST_DIR = list(0, 0),
            EAST_DIR = list(0, 0)
        ),
        "belt"  = list(
            SOUTH_DIR = list(0, 0),
            NORTH_DIR = list(0, 0),
            WEST_DIR = list(0, 0),
            EAST_DIR = list(0, 0)
        ),
        "back"  = list(
            SOUTH_DIR = list(0, 0),
            NORTH_DIR = list(0, 0),
            WEST_DIR = list(0, 0),
            EAST_DIR = list(0, 0)
        )
    )
    var/custom_name = ""
    var/max_accessory = 3
    var/obj/item/weapon/gun_modular/module/chamber/chamber = null
    var/obj/item/weapon/gun_modular/module/handle/handle = null
    var/obj/item/weapon/gun_modular/module/barrel/barrel = null
    var/obj/item/weapon/gun_modular/module/magazine/magazine = null
    var/list/obj/item/weapon/gun_modular/module/modules = list()
    var/list/obj/item/weapon/gun_modular/module/accessories = list()
    var/obj/item/weapon/gun_modular/module/accessory/active_accessory = null
    var/list/config_user = list()
    var/list/icon/radial_icons = list()
    var/list/image/frame_overlays = list()

// When changing weapons, icons are rebuilt to display on a person

/obj/item/weapon/gun_modular/module/frame/proc/build_images(var/direct = SOUTH, var/slot = "hand_l")
    var/image/overlay = image(icon = icon, icon_state = "")
    for(var/key in modules)
        var/obj/item/weapon/gun_modular/module/M = modules[key]
        if(!M)
            continue
        var/image/M_icon = M.icon_overlay[slot]
        
        M_icon.color = M.color

        var/dir_t = direct != SOUTH ? direct != NORTH ? direct != WEST ? EAST_DIR : WEST_DIR : NORTH_DIR : SOUTH_DIR

        M_icon.pixel_x = M.get_delta_offset(slot, dir_t)[1]
        M_icon.pixel_y = M.get_delta_offset(slot, dir_t)[2]

        overlay.add_overlay(M_icon)

    frame_overlays[slot] = overlay

    // var/matrix/frame_change = matrix()
    // frame_change.Scale(0.7 + (0.9 / size_gun))
    // if(size_gun > MEDIUM_GUN)
    //     frame_change.Turn(315)
    // animate(icon_s, transform = frame_change)

/obj/item/weapon/gun_modular/module/frame/proc/update_images(var/mob/user)
    user.update_inv_item(src)

/obj/item/weapon/gun_modular/module/frame/get_standing_overlay(mob/living/carbon/human/H, def_icon_path, sprite_sheet_slot, layer, bloodied_icon_state = null, icon_state_appendix = null)
    var/image/I = ..()
    var/slot = ""
    if(sprite_sheet_slot == SPRITE_SHEET_HELD)
        if(icon_state_appendix == "_l")
            slot = "hand_l"
        else
            slot = "hand_r"
    else if(sprite_sheet_slot == SPRITE_SHEET_BELT)
        slot = "belt"
    else if(sprite_sheet_slot == SPRITE_SHEET_BACK)
        slot = "back"
    I.icon_state = ""
    if(frame_overlays[slot])
        I.add_overlay(frame_overlays[slot])
    return I

/obj/item/weapon/gun_modular/module/frame/examine(mob/user)
    ..()
    if(!in_range(user, src))
        return
    var/dit = "The weapon consists of:\n"
    for(var/key in modules)
        var/obj/item/weapon/gun_modular/module/M = modules[key]
        if(!M)
            continue
        dit += "[bicon(M)] [M.name]. <span class='info'>[EMBED_TIP("More info.", M.get_info_module(user))]</span>\n"
    dit += "<br>"
    dit += "Weapon size - [size_gun > SMALL_GUN ? size_gun < LARGE_GUN ? "Medium size" : "Large size" : "Small size"]\n"
    dit += "Reduced spread - [lessdispersion >= CRITICAL_LOW_REDUCED ? lessdispersion < GOOD_REDUCED ? "Low Reduced" : "Good Reduced" : "CRITICAL LOW REDUCED"]\n"
    dit += "<br>"
    dit += "Configs:\n"
    for(var/key in config_user)
        var/config_text = ""
        if(!modules[config_user[key]])
            config_text = "[key] - module not detected\n"
        else
            config_text = "[key] - [modules[config_user[key]].name]\n"
        dit += config_text
    to_chat(user, dit)

/obj/item/weapon/gun_modular/module/frame/atom_init()
    . = ..()
    appearance_flags |= KEEP_TOGETHER
    appearance_flags |= PIXEL_SCALE
    build_images()
    update_icon()
    
/obj/item/weapon/gun_modular/module/frame/Destroy()
    for(var/key in modules)
        if(modules[key])
            modules[key].Destroy()
    return ..()

// Generation of icons for the radial menu, generated when creating a configuration for a weapon

/obj/item/weapon/gun_modular/module/frame/proc/generate_radial_icon()
    radial_icons = list()
    for(var/key in modules)
        if(modules[key])
            radial_icons[key] = image(modules[key].icon, modules[key].icon_state)

// Weapon configuration by index, you can configure which module to activate during actions. Now done by clicking on the weapon and by CTRL clicking

/obj/item/weapon/gun_modular/module/frame/proc/config_user(mob/user, var/index)
    if(!modules[config_user[index]])
        config_user[index] = null
    if(!config_user[index])
        generate_radial_icon()
        var/rezult = show_radial_menu(user, src, radial_icons, tooltips = TRUE)
        if(!in_range(user, src))
            return
        config_user[index] = rezult
    else
        modules[config_user[index]].activate(user)

/obj/item/weapon/gun_modular/module/frame/verb/reset_config()
    set src in usr
    set name = "Reset Config"
    set category = "Gun"

    config_user = list()

/obj/item/weapon/gun_modular/module/frame/verb/select_fire_chamber()
    set src in usr
    set name = "Select fire"
    set category = "Gun"

    if(chamber)
        chamber.activate(usr)

/obj/item/weapon/gun_modular/module/frame/verb/eject_magazine()
    set src in usr
    set name = "Eject magazine/ammo"
    set category = "Gun"

    if(magazine)
        magazine.activate(usr)

/obj/item/weapon/gun_modular/module/frame/dropped(mob/user)
    . = ..()
    UnregisterSignal(user, COSMIG_ATOM_SETDIR)
    appearance_flags |= KEEP_TOGETHER
    appearance_flags |= PIXEL_SCALE
    if(accessories)
        for(var/obj/item/weapon/gun_modular/module/accessory/A in accessories)
            A.loc = src
            A.deactivate(user)

/obj/item/weapon/gun_modular/module/frame/attack_hand(mob/user)
    . = ..()
    RegisterSignal(user, COSMIG_ATOM_SETDIR, .proc/update_images)
    appearance_flags |= KEEP_TOGETHER
    appearance_flags |= PIXEL_SCALE
    if(accessories)
        for(var/obj/item/weapon/gun_modular/module/accessory/A in accessories)
            A.loc = user

/obj/item/weapon/gun_modular/module/frame/attack_self(mob/user)
    . = ..()
    config_user(user, "AttackSelf")

/obj/item/weapon/gun_modular/module/frame/AltClick(mob/user)
    . = ..()
    config_user(user, "AltClick")

// Pulling objects out of the frame is done according to a different principle, since this is a common use for all modules, it is activated with a screwdriver. Here, when you click with a screwdriver, a module for pulling out is given

/obj/item/weapon/gun_modular/module/frame/remove_items(mob/user)
    if(in_use_action)
        return FALSE
    if(!modules)
        return FALSE
    generate_radial_icon()
    var/remove = show_radial_menu(user, src, radial_icons, tooltips = TRUE)
    if(!remove)
        return FALSE
    if(!do_after(user, 2 SECOND, target = src, needhand = TRUE))
        return FALSE
    if(!in_range(user, src))
        return FALSE
    if(!modules[remove])
        return FALSE
    modules[remove].remove(user)
    return TRUE

/obj/item/weapon/gun_modular/module/frame/attackby(obj/item/weapon/W, mob/user, params)
    ..()
    if(istype(W, /obj/item/weapon/pen))
        change_name(user)
        return TRUE
    else if(istype(W, /obj/item/weapon/gun_modular/module))
        var/obj/item/weapon/gun_modular/module/module = W
        module.attach(src, user)
        return TRUE
    else if(active_accessory && active_accessory.attackby(W, user))
        return TRUE
    else if(!isscrewdriver(W))
        for(var/key in modules)
            if(modules[key])
                var/obj/item/weapon/gun_modular/module/M = modules[key]
                if(M.attackby(W, user))
                    break
        return TRUE

/obj/item/weapon/gun_modular/module/frame/afterattack(atom/A, mob/living/user, proximity, params)
    if(proximity)
        return FALSE
    if(istype(A, /obj/structure/gun_bench))
        return FALSE
    if(!handle)
        return FALSE
    if(!handle.Special_Check(user))
        return FALSE
    if(active_accessory)
        if(!active_accessory.target_activate(A, user))
            return FALSE
    if(chamber)
        chamber.Fire(A, user, params)

/obj/item/weapon/gun_modular/module/frame/attack(mob/living/M, mob/living/user, def_zone)
    if(!handle)
        return FALSE
    if(!handle.Special_Check(user))
        return ..()
    if(user.a_intent == INTENT_HARM)
        if(chamber)
            chamber.Fire(M, user, TRUE)
        return
    return ..()

/obj/item/weapon/gun_modular/module/frame/can_attach(var/obj/item/weapon/gun_modular/module/M)
    if(!istype(M, /obj/item/weapon/gun_modular/module))
        return FALSE
    var/obj/item/weapon/gun_modular/module/module = M
    return module.checking_to_attach(src)

// Changing the stats of weapons, called when the module is attached, as well as when it is pulled

/obj/item/weapon/gun_modular/module/frame/proc/change_name(mob/user = null)
    var/custom = "modular "
    if(user)
        custom_name = sanitize_safe(input(usr,"What would you like to name this gun?","Input a name", "") as text|null, MAX_NAME_LEN)
    custom += "[caliber] gun"
    if(custom_name)
        custom += " '[custom_name]'"
    name = custom

/obj/item/weapon/gun_modular/module/frame/proc/change_state(var/obj/item/weapon/gun_modular/module/M, var/attach = TRUE)
    if(!istype(M, /obj/item/weapon/gun_modular/module))
        return FALSE
    var/obj/item/weapon/gun_modular/module/module = M
    if(attach)
        lessdamage += module.lessdamage
        lessdispersion += module.lessdispersion
        size_gun += module.size_gun
    else
        lessdamage -= module.lessdamage
        lessdispersion -= module.lessdispersion
        size_gun -= module.size_gun
        if(size_gun >= SMALL_GUN)
            w_class = ITEM_SIZE_SMALL
        if(size_gun >= MEDIUM_GUN)
            w_class = ITEM_SIZE_NORMAL
        if(size_gun >= LARGE_GUN)
            w_class = ITEM_SIZE_LARGE
    slowdown = 5 - (25/size_gun)
    for(var/key_type in points_of_entry)
        for(var/key_dir in points_of_entry[key_type])
            build_images(key_dir, key_type)
    change_name()
    return TRUE

// These are weapon presets for testing, and can be used to create station or spawn weapon presets. The main thing is to observe the order as when assembling

/obj/item/weapon/gun_modular/module/frame/ptr_heavyrifle/atom_init()
    . = ..()
    var/obj/item/weapon/gun_modular/module/chamber/heavyrifle/new_chamber = new(src)
    var/obj/item/weapon/gun_modular/module/magazine/bullet/heavyrifle/new_magazine = new(src)
    var/obj/item/weapon/gun_modular/module/handle/rifle/new_handle = new(src)
    var/obj/item/weapon/gun_modular/module/barrel/large/new_barrel = new(src)
    var/obj/item/weapon/gun_modular/module/accessory/optical/large/new_optical = new(src)
    new_chamber.attach(src)
    new_magazine.attach(src)
    new_handle.attach(src)
    new_barrel.attach(src)
    new_optical.attach(src)

/obj/item/weapon/gun_modular/module/frame/energy_shotgun/atom_init()
    . = ..()
    var/obj/item/weapon/gun_modular/module/chamber/energy/shotgun/new_chamber = new(src)
    var/obj/item/weapon/gun_modular/module/magazine/energy/new_magazine = new(src)
    var/obj/item/weapon/stock_parts/cell/bluespace/internal_magazine = new(src)
    var/obj/item/weapon/gun_modular/module/handle/rifle/new_handle = new(src)
    var/obj/item/weapon/gun_modular/module/barrel/rifle_laser/new_barrel = new(src)
    var/obj/item/weapon/gun_modular/module/accessory/optical/large/new_optical = new(src)
    var/obj/item/weapon/gun_modular/module/accessory/additional_battery/new_additional = new(src)
    var/obj/item/weapon/stock_parts/cell/bluespace/internal_magazine2 = new(src)
    var/obj/item/ammo_casing/energy/laser/ammo_case1 = new(src)
    var/obj/item/ammo_casing/energy/xray/ammo_case2 = new(src)
    var/obj/item/weapon/gun_modular/module/accessory/core_charger/core_charger = new(src)
    var/obj/item/device/assembly/signaler/anomaly/core = new(src)
    new_chamber.attach_item_in_module(ammo_case1)
    new_chamber.attach_item_in_module(ammo_case2)
    new_chamber.attach(src)
    new_magazine.attach_item_in_module(internal_magazine)
    new_magazine.attach(src)
    new_handle.attach(src)
    new_barrel.attach(src)
    new_optical.attach(src)
    new_additional.attach_item_in_module(internal_magazine2)
    new_additional.attach(src)
    core_charger.attach_item_in_module(core)
    core_charger.attach(src)

/obj/item/weapon/gun_modular/module/frame/pistol_9mm/atom_init()
    . = ..()
    var/obj/item/weapon/gun_modular/module/chamber/new_chamber = new(src)
    var/obj/item/weapon/gun_modular/module/magazine/bullet/new_magazine = new(src)
    var/obj/item/ammo_box/magazine/m9mm/internal_magazine = new(src)
    var/obj/item/weapon/gun_modular/module/handle/new_handle = new(src)
    var/obj/item/weapon/gun_modular/module/barrel/medium/new_barrel = new(src)
    new_chamber.attach(src)
    new_magazine.attach_item_in_module(internal_magazine)
    new_magazine.attach(src)
    new_handle.attach(src)
    new_barrel.attach(src)
