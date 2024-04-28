extends State


class_name PlayerAirState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent):
	if move_component.wants_jump() && (parent as Player).can_jump():
		(parent as Player).on_double_jump()
		return

	if move_component.wants_dash():
		(parent as Player).on_dash()
		return


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta):
	(parent as Player).on_move_sideways()
	if (parent as Player).is_idle():
		(state_machine as PlayerStateMachine).transition_to("Idle")
	elif parent.is_on_floor():
		(state_machine as PlayerStateMachine).transition_to("Run")

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg = {}):
	#print_debug("entered %s" % name)
	var action = msg.get("action") if msg.has("action") else null
	if action:
		assert(parent.has_method(action), "%s does not have method %s" % [parent.name, action])
		parent.call(action)
	else:
		(parent as Player).on_air_or_fall()


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit():
	(parent as Player).on_landing()
