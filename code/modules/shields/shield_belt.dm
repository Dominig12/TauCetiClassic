/obj/item/weapon/storage/belt/shield_belt
    name = "personal forcefield belt"
    icon = 'icons/obj/clothing/belts.dmi'
    desc = "Protective energy belt for personal use"
    item_state = "shieldbelt_active"
    icon_state = "shieldbelt_active"
    slot_flags = SLOT_FLAGS_BELT
    max_w_class = ITEM_SIZE_NORMAL
    w_class = ITEM_SIZE_LARGE
    storage_slots = 1
    can_hold = list(/obj/item/weapon/stock_parts/cell)

/obj/item/weapon/storage/belt/shield_belt/atom_init()
    . = ..()
    var/obj/item/weapon/stock_parts/cell/cell = new /obj/item/weapon/stock_parts/cell/high(src)
    var/datum/callback/on_reactivation = CALLBACK(src, .proc/on_reactivation)
    var/datum/callback/on_deactivation = CALLBACK(src, .proc/on_deactivation)
    var/obj/effect/effect/forcefield/energy_field/F = new
    AddComponent(/datum/component/forcefield/techno/cell, "energy field", 10, 8 SECONDS, 8 SECONDS, F, FALSE, TRUE, on_reactivation, on_deactivation, cell)

/obj/item/weapon/storage/belt/shield_belt/proc/on_reactivation(datum/component/forcefield/F)
    icon_state = "shieldbelt_active"
    item_state = "shieldbelt_active"
    update_icon()

/obj/item/weapon/storage/belt/shield_belt/proc/on_deactivation(datum/component/forcefield/F)
    icon_state = "shieldbelt_notactive"
    item_state = "shieldbelt_notactive"
    update_icon()

/obj/item/weapon/storage/belt/shield_belt/equipped(mob/user, slot)
    if(slot == SLOT_BELT)
        SEND_SIGNAL(src, COMSIG_FORCEFIELD_PROTECT, user)
    else if(slot_equipped == SLOT_BELT)
        SEND_SIGNAL(src, COMSIG_FORCEFIELD_UNPROTECT, user)

/obj/item/weapon/storage/belt/shield_belt/dropped(mob/user)
    if(slot_equipped == SLOT_BELT)
        SEND_SIGNAL(src, COMSIG_FORCEFIELD_UNPROTECT, user)