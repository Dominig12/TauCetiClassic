/obj/structure/gun_bench
    name = "gun bench"
    icon = 'code/modules/projectiles/gun_modular/modular.dmi'
    icon_state = "bench_open"
    desc = ""
    density = TRUE
    anchored = TRUE
    var/obj/item/weapon/gun_modular/module/frame/frame_parent = null
    var/image/frame_overlay

/obj/structure/gun_bench/attackby(obj/item/weapon/W, mob/user, params)
    ..()
    if(istype(W, /obj/item/weapon/gun_modular/module/frame))
        if(!frame_parent)
            var/obj/item/weapon/gun_modular/module/frame/F = W
            frame_parent = F
            user.drop_item()
            frame_parent.loc = src
            frame_overlay = image(icon, icon_state = "")
            frame_overlay.appearance = frame_parent.frame_overlays["icon"]
            var/matrix/frame_change = matrix()
            frame_change.Scale(0.5)
            animate(frame_overlay, pixel_y = 6, transform = frame_change)
            add_overlay(frame_overlay)
            return
    if(istype(W, /obj/item/weapon/gun_modular/module))
        if(frame_parent)
            var/obj/item/weapon/gun_modular/module/M = W
            M.attach(frame_parent, user)
            icon_state = "bench_work"
            var/image/work_overlay = image(icon = icon, icon_state = "overlay_work", layer = 5)
            add_overlay(work_overlay)
            if(do_after(user, 2 SECOND, needhand = FALSE, target = src, can_move = FALSE, progress = TRUE))
                icon_state = "bench_open"
                cut_overlays()
            frame_overlay.appearance = frame_parent.frame_overlays["icon"]
            var/matrix/frame_change = matrix()
            frame_change.Scale(0.5)
            animate(frame_overlay, pixel_y = 6, transform = frame_change)
            add_overlay(frame_overlay)

/obj/item/weapon/gun_modular/module
    name = "gun module"
    icon = 'code/modules/projectiles/gun_modular/modular.dmi'
    desc = ""
    w_class = ITEM_SIZE_SMALL
    var/icon_overlay_name
    var/caliber
    var/lessdamage = 0
    var/lessdispersion = 0
    var/size_gun = 1
    var/gun_type
    var/prefix = "Module"
    var/obj/item/weapon/gun_modular/module/frame/frame_parent = null
    var/datum/component/point_to_point/point = null

/obj/item/weapon/gun_modular/module/examine(mob/user)
    . = ..()
    to_chat(user, "[bicon(src)] [name]. <span class='info'>[EMBED_TIP("More info.", get_info_module(user))]</span><br>")

/obj/item/weapon/gun_modular/module/Destroy()
    if(frame_parent)
        remove()
    return ..()

/obj/item/weapon/gun_modular/module/update_icon()
    for(var/key in point.complex_image)
        if(point.complex_image[key])
            point.complex_image[key].color = color
    return

/obj/item/weapon/gun_modular/module/proc/update_image()
    var/image/IS = point.get_image()
    var/image/image_change = image(null)
    image_change.plane = plane
    image_change.layer = layer
    appearance = IS.appearance
    plane = image_change.plane
    layer = image_change.layer
    update_icon()

/obj/item/weapon/gun_modular/module/atom_init()
    . = ..()
    AddComponent(/datum/component/point_to_point, src, prefix, CALLBACK(src, .proc/update_image))
    point = GetComponent(/datum/component/point_to_point)
    var/image/overlay_icon = image(icon, icon_overlay_name)
    overlay_icon.appearance_flags |= KEEP_TOGETHER
    point.set_image_to_slot(overlay_icon, "ICON")
    point.set_image_to_slot(image(icon = 'code/modules/projectiles/gun_modular/modular_overlays.dmi', icon_state = "[icon_overlay_name]_l"), "[SPRITE_SHEET_HELD]_l")
    point.set_image_to_slot(image(icon = 'code/modules/projectiles/gun_modular/modular_overlays.dmi', icon_state = "[icon_overlay_name]_r"), "[SPRITE_SHEET_HELD]_r")
    point.set_image_to_slot(image(icon = 'code/modules/projectiles/gun_modular/modular_overlays.dmi', icon_state = "[icon_overlay_name]_belt"), "[SPRITE_SHEET_BELT]")
    point.set_image_to_slot(image(icon = 'code/modules/projectiles/gun_modular/modular_overlays.dmi', icon_state = "[icon_overlay_name]_back"), "[SPRITE_SHEET_BACK]")
    build_points_list()

//Point and point system that creates the ability to connect objects to specific points of parent objects
/obj/item/weapon/gun_modular/module/proc/build_points_list()
    var/image/l_arm = image('icons/mob/human_races/masks/dam_mask_gen.dmi', BP_L_ARM)
    var/image/r_arm = image('icons/mob/human_races/masks/dam_mask_gen.dmi', BP_R_ARM)
    var/image/chest = image('icons/mob/human_races/masks/dam_mask_gen.dmi', BP_CHEST)
    var/image/l_leg = image('icons/mob/human_races/masks/dam_mask_gen.dmi', BP_L_LEG)
    var/image/r_leg = image('icons/mob/human_races/masks/dam_mask_gen.dmi', BP_R_LEG)
    var/image/groin = image('icons/mob/human_races/masks/dam_mask_gen.dmi', BP_GROIN)
    var/image/head = image('icons/mob/human_races/masks/dam_mask_gen.dmi', BP_HEAD)

    point.change_list_mask("[SPRITE_SHEET_HELD]_l", "[SOUTH]", list("BODY" = list(l_arm)))
    point.change_list_mask("[SPRITE_SHEET_HELD]_l", "[NORTH]", list("BODY" = list(chest, groin, l_leg, r_leg, r_arm, head)))
    point.change_list_mask("[SPRITE_SHEET_HELD]_l", "[EAST]", list("BODY" = list(l_arm)))
    point.change_list_mask("[SPRITE_SHEET_HELD]_l", "[WEST]", list("BODY" = list(l_arm)))

    point.change_list_mask("[SPRITE_SHEET_HELD]_r", "[SOUTH]", list("BODY" = list(r_arm)))
    point.change_list_mask("[SPRITE_SHEET_HELD]_r", "[NORTH]", list("BODY" = list(chest, groin, l_leg, r_leg, l_arm, head)))
    point.change_list_mask("[SPRITE_SHEET_HELD]_r", "[EAST]", list("BODY" = list(r_arm)))
    point.change_list_mask("[SPRITE_SHEET_HELD]_r", "[WEST]", list("BODY" = list(r_arm)))

    point.change_list_mask("[SPRITE_SHEET_BELT]", "[SOUTH]", list("BODY" = list(l_arm)))
    point.change_list_mask("[SPRITE_SHEET_BELT]", "[NORTH]", list("BODY" = null))
    point.change_list_mask("[SPRITE_SHEET_BELT]", "[EAST]", list("BODY" = list(chest, groin, l_leg, r_leg, r_arm, head)))
    point.change_list_mask("[SPRITE_SHEET_BELT]", "[WEST]", list("BODY" = list(l_arm)))

    point.change_list_mask("[SPRITE_SHEET_BACK]", "[SOUTH]", list("BODY" = list(chest, groin, l_leg, r_leg, r_arm, head, l_arm)))
    point.change_list_mask("[SPRITE_SHEET_BACK]", "[NORTH]", list("BODY" = null))
    point.change_list_mask("[SPRITE_SHEET_BACK]", "[EAST]", list("BODY" = list(r_arm, chest, head, groin, r_leg)))
    point.change_list_mask("[SPRITE_SHEET_BACK]", "[WEST]", list("BODY" = list(l_arm, chest, head, groin, l_leg)))

    point.change_list_exit("ICON", "[SOUTH]", list(0, 0))

    point.change_list_exit("[SPRITE_SHEET_HELD]_l", "[SOUTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_HELD]_l", "[NORTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_HELD]_l", "[EAST]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_HELD]_l", "[WEST]", list(0, 0))

    point.change_list_exit("[SPRITE_SHEET_HELD]_r", "[SOUTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_HELD]_r", "[NORTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_HELD]_r", "[EAST]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_HELD]_r", "[WEST]", list(0, 0))

    point.change_list_exit("[SPRITE_SHEET_BELT]", "[SOUTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_BELT]", "[NORTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_BELT]", "[EAST]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_BELT]", "[WEST]", list(0, 0))

    point.change_list_exit("[SPRITE_SHEET_BACK]", "[SOUTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_BACK]", "[NORTH]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_BACK]", "[EAST]", list(0, 0))
    point.change_list_exit("[SPRITE_SHEET_BACK]", "[WEST]", list(0, 0))

    point.change_list_entry("ICON", "[SOUTH]", null)

    point.change_list_entry("[SPRITE_SHEET_HELD]_l", "[SOUTH]", null)
    point.change_list_entry("[SPRITE_SHEET_HELD]_l", "[NORTH]", null)
    point.change_list_entry("[SPRITE_SHEET_HELD]_l", "[EAST]", null)
    point.change_list_entry("[SPRITE_SHEET_HELD]_l", "[WEST]", null)

    point.change_list_entry("[SPRITE_SHEET_HELD]_r", "[SOUTH]", null)
    point.change_list_entry("[SPRITE_SHEET_HELD]_r", "[NORTH]", null)
    point.change_list_entry("[SPRITE_SHEET_HELD]_r", "[EAST]", null)
    point.change_list_entry("[SPRITE_SHEET_HELD]_r", "[WEST]", null)

    point.change_list_entry("[SPRITE_SHEET_BELT]", "[SOUTH]", null)
    point.change_list_entry("[SPRITE_SHEET_BELT]", "[NORTH]", null)
    point.change_list_entry("[SPRITE_SHEET_BELT]", "[EAST]", null)
    point.change_list_entry("[SPRITE_SHEET_BELT]", "[WEST]", null)

    point.change_list_entry("[SPRITE_SHEET_BACK]", "[SOUTH]", null)
    point.change_list_entry("[SPRITE_SHEET_BACK]", "[NORTH]", null)
    point.change_list_entry("[SPRITE_SHEET_BACK]", "[EAST]", null)
    point.change_list_entry("[SPRITE_SHEET_BACK]", "[WEST]", null)
    return TRUE

// This gives information in the tooltip, here you can talk about additional weapon stats

/obj/item/weapon/gun_modular/module/proc/get_info_module(mob/user = null)
    var/info_module = ""
    if(desc != "")
        info_module += "[desc]\n"
    if(user)
        if(!hasHUD(user, "science") && !hasHUD(user, "security"))
            info_module += "Nothing interesting..."
            return info_module
    info_module += "Damage reduction - ([lessdamage])\n"
    info_module += "Increased accuracy - ([lessdispersion])\n"
    info_module += "Module size - ([size_gun])\n"
    info_module += "Compatible caliber - ([caliber])\n"
    info_module += "Compatible weapon type - ([gun_type])\n"
    info_module += "Additional module parameters:\n"
    return info_module

/obj/item/weapon/gun_modular/module/attackby(obj/item/weapon/W, mob/user, params)
    ..()
    if(isscrewdriver(W))
        remove_items(user)
        return TRUE
    if(attach_item_in_module(W, user))
        return TRUE

// Activation of the module, configs are sent to this, as well as deactivation of modules, it is activated to return everything to the past state

/obj/item/weapon/gun_modular/module/proc/activate(mob/user, var/argument="")
    return FALSE

/obj/item/weapon/gun_modular/module/proc/deactivate(mob/user, var/argument="")
    return FALSE

// Removing all items that were installed in the weapon

/obj/item/weapon/gun_modular/module/proc/remove_items(mob/user)
    if(!contents.len)
        return FALSE
    if(in_use_action)
        return FALSE
    if(!do_after(user, 2 SECOND, target = src, needhand = TRUE))
        return FALSE
    for(var/obj/item/I in contents)
        remove_item_in_module(I)
        I.loc = get_turf(src)
        I.update_icon()
    return TRUE

/obj/item/weapon/gun_modular/module/proc/remove_item_in_module(var/obj/item/I)
    return FALSE

/obj/item/weapon/gun_modular/module/proc/attach_item_in_module(var/obj/item/I, mob/user = null)
    if(user)
        if(in_use_action)
            return FALSE
    return can_attach(I)

/obj/item/weapon/gun_modular/module/proc/can_attach(var/obj/item/I)
    return FALSE

// Check for the ability to attach the module to the frame

/obj/item/weapon/gun_modular/module/proc/checking_to_attach(var/obj/item/weapon/gun_modular/module/frame/I)
    if(!istype(I, /obj/item/weapon/gun_modular/module/frame))
        return FALSE
    var/obj/item/weapon/gun_modular/module/frame/frame = I
    if(isnull(frame.chamber))
        return FALSE
    if(caliber != frame.caliber && caliber != ALL_CALIBER)
        return FALSE
    if(gun_type != frame.gun_type && gun_type != ALL_GUN_TYPE)
        return FALSE
    return TRUE

// Module attachment procedure

/obj/item/weapon/gun_modular/module/proc/attach(var/obj/item/weapon/gun_modular/module/frame/I, mob/user)
    if(!istype(I))
        return FALSE
    var/obj/item/weapon/gun_modular/module/frame/frame = I
    if(frame.modules[prefix] != null)
        return FALSE
    if(!frame.can_attach(src))
        return FALSE
    if(user)
        if(I.in_use_action)
            return FALSE
        if(!do_after(user, 1 SECOND, target = I, needhand = TRUE))
            return FALSE
        if(!in_range(user, frame))
            return FALSE
        user.drop_item()
        to_chat(user, "Module '[name]' was attached")
    src.loc = frame
    frame_parent = frame
    point.connect_to_point(frame.point)
    LAZYINITLIST(frame.modules)
    frame.modules[prefix] = src
    frame.change_state(src, TRUE)
    return TRUE

// Module removal procedure

/obj/item/weapon/gun_modular/module/proc/remove(mob/user = null)
    point.disconnect_to_point()
    frame_parent.modules[prefix] = null
    src.loc = get_turf(frame_parent)
    if(frame_parent)
        for(var/key in frame_parent.modules)
            var/obj/item/weapon/gun_modular/module/module = frame_parent.modules[key]
            if(!module)
                continue
            module.deactivate(user)
            if(module.check_remove())
                module.remove(user)
    frame_parent.change_state(src, FALSE)
    update_icon()
    frame_parent = null
    if(user)
        to_chat(user, "Module '[name]' has been removed")

// This check is called for each module when a module is removed from a weapon. This is done to avoid conflicts.

/obj/item/weapon/gun_modular/module/proc/check_remove()
    return !checking_to_attach(frame_parent)