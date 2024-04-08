extends State


class_name PlayerIdleState


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if !parent.is_on_floor():
		(state_machine as PlayerStateMachine).transition_to("Air", { "action": "on_air_or_fall" })
	elif move_component.wants_to_crouch():
		(state_machine as PlayerStateMachine).transition_to("Crouch")
	elif move_component.wants_to_move_sideways():
		(state_machine as PlayerStateMachine).transition_to("Run")


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if move_component.wants_jump():
		(state_machine as PlayerStateMachine).transition_to("Air", { "action": "on_jump" })


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	(parent as Player).on_idle()
