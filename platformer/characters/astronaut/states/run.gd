extends State

@onready var _coyote_timer: Timer = $CoyoteTime
var _coyote_timer_running = false


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if move_component.wants_jump():
		(state_machine as PlayerStateMachine).transition_to("Air", { "action": "on_jump"})
	

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta):
	(parent as Player).on_move_sideways(delta)

	if !parent.is_on_floor(): 
		if not _coyote_timer_running:
			_coyote_timer.start()
			_coyote_timer_running = true

	elif (parent.is_on_floor() and move_component.wants_to_crouch()):
		(state_machine as PlayerStateMachine).transition_to("Crouch")

	elif (parent as Player).is_idle():
		(state_machine as PlayerStateMachine).transition_to("Idle")


func reset_coyote_timer() -> void:
	_coyote_timer.stop()
	_coyote_timer_running = false


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg = {}):
	reset_coyote_timer()
	(parent as Player).on_run()


func _on_coyote_time_timeout():
	if not parent.is_on_floor(): 
		(state_machine as PlayerStateMachine).transition_to("Air")
	else:
		reset_coyote_timer()
