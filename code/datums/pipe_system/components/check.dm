/datum/pipe_system/component/check
	var/datum/pipe_system/component/success_component = null
	var/datum/pipe_system/component/fail_component = null

/datum/pipe_system/component/check/New(datum/P, datum/pipe_system/component/success_component = null, datum/pipe_system/component/fail_component = null)
	. = ..()

	src.success_component = success_component
	src.fail_component = fail_component

/datum/pipe_system/component/check/CopyComponent()

	var/datum/pipe_system/component/check/new_component = ..()

	if(success_component)
		new_component.success_component = success_component.CopyComponent()

	if(fail_component)
		new_component.fail_component = fail_component.CopyComponent()

	return new_component

/datum/pipe_system/component/check/ApiChange(href_list)

	if(href_list["get_fail_component"])
		return fail_component

	if(href_list["get_success_component"])
		return success_component

	if(href_list["change_fail_component"])
		return ChangeFailComponent(href_list["change_fail_component"])

	if(href_list["change_success_component"])
		return ChangeSuccessComponent(href_list["change_success_component"])

	return ..()

/datum/pipe_system/component/check/proc/ChangeFailComponent(datum/pipe_system/component/C)
	fail_component = C

/datum/pipe_system/component/check/proc/ChangeSuccessComponent(datum/pipe_system/component/C)
	success_component = C

/datum/pipe_system/component/check/proc/FailCheck(datum/pipe_system/process/process)

	SEND_SIGNAL(src, COMSIG_PIPE_CHECK_FAIL)

	if(!fail_component)
		return FALSE

	return ChangeNextComponent(fail_component.CopyComponent())

/datum/pipe_system/component/check/proc/SuccessCheck(datum/pipe_system/process/process)

	SEND_SIGNAL(src, COMSIG_PIPE_CHECK_SUCCESS)

	if(!success_component)
		return FALSE

	return ChangeNextComponent(success_component.CopyComponent())
