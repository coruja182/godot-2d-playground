extends State


class_name PlayerShootStandState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent):
	if move_component.wants_shoot():
		(parent as Player).on_shoot()


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta):
	if move_component.wants_to_move_sideways():
		(state_machine as PlayerStateMachine).transition_to("Run")
	elif move_component.wants_to_crouch():
		(state_machine as PlayerStateMachine).transition_to("Crouch")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg = {}):
	(parent as Player).on_shoot()


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit():
	pass


func on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name.replace("_", "").to_upper()  == name.to_upper():
		(state_machine as PlayerStateMachine).transition_to("Idle")
