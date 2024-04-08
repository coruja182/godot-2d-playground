extends Node


class_name PlayerStateMachine


# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state = NodePath()

# The current active state. At the start of the game, we get the `initial_state`.
@onready var state: State = get_node(initial_state)


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func init(parent: CharacterBody2D, move_component: MoveComponent) -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
		child.parent = parent
		child.move_component = move_component
	state.enter()


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	assert(has_node(target_state_name), "state machine has no '%s' State" % target_state_name)
	transitioned.emit()
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	#print_debug("transitioned to %s" % state.name, msg)
	emit_signal("transitioned", state.name)


func _on_animation_player_animation_finished(anim_name):
	state.on_animation_player_animation_finished(anim_name)
