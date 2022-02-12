/datum/interface_command
	var/required_count_arguments = 1
	var/keyword = "DEF_COM"
	var/description = "Default command"
	var/datum/signal_terminal/parent_interface = null

/datum/interface_command/New(datum/signal_terminal/parent, key)
	parent_interface = parent
	parent.commands[key] = src
	keyword = key

/datum/interface_command/proc/execute(list/command_arguments)
	// if(command_arguments.len < required_count_arguments)
	// 	return FALSE
	// return TRUE
	return

/datum/interface_command/help
	keyword = "HELP"

/datum/interface_command/help/execute(list/command_arguments)
	var/data = ""
	for(var/key in parent_interface.commands)
		data += parent_interface.commands[key] + " - " + description

	parent_interface.temp_data[ANSWER][PRINT_TERMINAL] += data

/datum/interface_command/connection_to
	keyword = "CONNECTION_TO"
	required_count_arguments = 2

/datum/interface_command/connection_to/execute(list/command_arguments)
	if(command_arguments.len < 2)
		return

	var/datum/signal_t/request_signal = parent_interface.create_signal()
	request_signal.data[COMMAND] = "[typesof(/datum/interface_command/connection_request)[1].keyword]"
	for(var/arg in command_arguments)
		request_signal.data[COMMAND] += " [arg]"

	parent_interface.radio_broadcast(request_signal)

/datum/interface_command/connection_request
	keyword = "CONNECTION_REQUEST"
