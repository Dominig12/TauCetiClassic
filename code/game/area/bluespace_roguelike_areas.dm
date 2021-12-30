/area/bluespace_areas
	name = "Bluespace Area"

/area/bluespace_areas/atom_init()
	. = ..()

/area/bluespace_areas/outside/Entered(atom/movable/A, atom/OldLoc)
	SSbluespace.Relaying(A)
	. = ..()

/area/bluespace_areas/inside/Entered(atom/movable/A, atom/OldLoc)
	. = ..()


