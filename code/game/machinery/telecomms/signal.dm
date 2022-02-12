/datum/signal_t
	var/datum/signal_terminal/source
	var/data = list()

/datum/signal_t/New(datum/interface_command/interface)
	source = interface

/datum/signal_t/proc/response(datum/signal_t/S)
	source.receive_signal(S)
