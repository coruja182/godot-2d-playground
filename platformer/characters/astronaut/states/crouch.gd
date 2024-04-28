extends State


class_name PlayerCrouchState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent):
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta):
	if move_component.wants_to_crouch():
		return
		
	if move_component.wants_jump():
		(state_machine as PlayerStateMachine).transition_to("Air", {"action": "on_jump"})
	if move_component.wants_to_move_sideways():
		(state_machine as PlayerStateMachine).transition_to("Run")
	else:
		(state_machine as PlayerStateMachine).transition_to("Idle")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg = {}):
	(parent as Player).on_crouch()


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit():
	(parent as Player).on_leave_crouch()
