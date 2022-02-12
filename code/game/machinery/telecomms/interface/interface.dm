/datum/signal_terminal
	var/name = "Терминал"
	var/atom/parent = null
	var/unicue_id = 0
	var/list/datum/interface_command/commands = list()
	var/list/temp_data = list()
	var/datum/callback/answer_callback = null
	var/datum/browser/panel
	var/list/history = list()
	var/list/history_max_length = 50

/datum/signal_terminal/New(atom/A, datum/callback/callback)
	parent = A
	answer_callback = callback
	commands_initialization()

/datum/signal_terminal/proc/commands_initialization()
	commands["HELP"] = new /datum/interface_command(src, "HELP")
	return

/datum/signal_terminal/proc/show_terminal(mob/user)
	panel = new(user, "terminal-\ref[src]", name, 800, 600, src)
	update_content()
	panel.open()

/datum/signal_terminal/Topic(href, href_list)
	if(..())
		return FALSE
	if(href_list["close"])
		qdel(src)
		return FALSE
	if(href_list["input"])
		var/input = sanitize(href_list["input"])
		history += "> [input]"
		if(length(history) > history_max_length)
			history.Cut(1, length(history) - history_max_length + 1)
		execute_command(input)
		update_content()
		return FALSE

/datum/signal_terminal/proc/update_content()
	var/list/content = history.Copy()
	content += "<form action='byond://'><input type='hidden' name='src' value='\ref[src]'> <input type='text' size='40' name='input' autofocus><input type='submit' value='Enter'></form>"
	content += "<i>type `man` for a list of available commands.</i>"
	panel.set_content(jointext(content, "<br>"))

/datum/signal_terminal/proc/execute_command(command)
	var/list/data = splittext(command, " ")
	if(!commands[data[1]])
		return FALSE
	commands[data[1]].execute(data)
	receive_answer(temp_data[ANSWER])

/datum/signal_terminal/proc/receive_answer(list/data)
	answer_callback.Invoke(data)
	return

/datum/signal_terminal/proc/create_signal()
	var/datum/signal_t/S = new(src)
	S.data[DATA_VARIABLES] = list()
	S.data[INTERFACE_INFO] = list()
	S.data[ANSWER] = null
	S.data[COMMAND] = null
	S.data[INTERFACE_INFO][INTERFACE_NAME] = parent.name
	S.data[INTERFACE_INFO][UNICUE_ID] = unicue_id
	S.data[INTERFACE_INFO][ACCESS_KEYS] = temp_data[ACCESS_KEYS]
	return S

/datum/signal_terminal/proc/receive_signal(datum/signal_t/S)
	var/datum/signal_t/answer_signal = create_signal()
	if(S.data[ANSWER])
		receive_answer(S.data[ANSWER])
	if(S.data[COMMAND])
		execute_command(S.data[COMMAND])
		answer_signal.data[ANSWER] = temp_data[ANSWER]
		S.response(answer_signal)
	return

/datum/signal_terminal/proc/radio_broadcast(datum/signal_t/S)
	SEND_SIGNAL(S, COMSIG_SEND_RADIO_SIGNAL)
	return

/datum/signal_terminal/proc/wire_broadcast(datum/signal_t/S, datum/signal_terminal/target)
	target.receive_signal(S)
	return
