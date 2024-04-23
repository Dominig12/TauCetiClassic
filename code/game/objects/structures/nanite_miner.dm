/obj/structure/nanite_miner
	name = "Nanite Cluster"
	var/datum/pipe_system/component
	var/obj/structure/nanite_miner/previous_module
	var/obj/structure/nanite_miner/next_module

/obj/structure/nanite_miner/atom_init()
	. = ..()
	init_program()
	START_PROCESSING(SSfastprocess, src)

/obj/structure/nanite_miner/process()

	var/datum/pipe_system/process/cluster_process = new()

	cluster_process.AddComponentPipe(component)

	cluster_process.RunComponents()

/obj/structure/nanite_miner/proc/init_program()
