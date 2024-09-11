////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_FLAGS_BELT

/obj/item/weapon/reagent_containers/hypospray/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/hypospray/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
		return
	if(!istype(M))
		return
	if(reagents.total_volume && M.try_inject(user, TRUE, TRUE, TRUE, TRUE))
		reagents.reaction(M, INGEST)
		if(M.reagents)

			var/list/injected = list()
			for(var/datum/reagent/R in src.reagents.reagent_list)
				injected += R.name
			var/contained = get_english_list(injected)

			M.log_combat(user, "injected with [name], reagents: [contained] (INTENT: [uppertext(user.a_intent)])")

			playsound(src, 'sound/effects/hypospray.ogg', VOL_EFFECTS_MASTER, 25)
			var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in [src].</span>")

	return

/obj/item/weapon/reagent_containers/hypospray/cmo
	list_reagents = list("tricordrazine" = 30)

/obj/item/weapon/reagent_containers/hypospray/cmo/afterattack(atom/target, mob/user, proximity, params)
	if(!proximity)
		return
	if(istype(target, /obj/item/weapon/reagent_containers/glass))
		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, "<span class='warning'>The hypospray is full.</span>")
			return
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='warning'>[target] is empty.</span>")
			return

		if(!target.is_open_container())
			to_chat(user, "<span class='warning'>Container is closed.</span>")
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

		to_chat(user, "<span class='notice'>You fill the syringe with [trans] units of the solution.</span>")

/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "inaprovaline autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	volume = 5
	list_reagents = list("inaprovaline" = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/stimpack //goliath kiting
	name = "stimpack"
	desc = "A rapid way to stimulate healing of minor wounds."
	icon_state = "stimpen"
	item_state = "autoinjector_empty"
	volume = 20
	list_reagents = list("inaprovaline" = 5, "coffee" = 13, "tricordrazine" = 2)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/atom_init()
	flags &= ~OPENCONTAINER
	amount_per_transfer_from_this = volume
	. = ..()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/attack(mob/M, mob/user)
	..()
	update_icon()
	update_inv_mob()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
	else
		icon_state = "autoinjector_empty"
		item_state = "autoinjector_empty"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/metatrombine
	name = "metatrombine autoinjector"
	desc = "Accelerates blood clotting."
	icon_state = "autobrut"
	item_state = "autobrut"
	volume = 5
	list_reagents = list("metatrombine" = 5)
