/mob/living/carbon/monkey/gib()
	var/atom/movable/overlay/animation = new(loc)
	flick(icon('icons/mob/mob.dmi', "gibbed-m"), animation)
	..()
	QDEL_IN(animation, 2 SECOND)

/mob/living/carbon/monkey/dust()
	new /obj/effect/decal/cleanable/ash(loc)
	dust_process()

/mob/living/carbon/monkey/death(gibbed)
	if(stat == DEAD)
		return
<<<<<<< HEAD
	
=======

>>>>>>> ee76559633a855f85b6ae3666a190bbdca4d9c8d
	stat = DEAD

	if(!gibbed)
		visible_message("<b>The [name]</b> lets out a faint chimper as it collapses and stops moving...")

	update_canmove()

	return ..(gibbed)
