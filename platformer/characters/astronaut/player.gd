extends CharacterBody2D

class_name Player


@export var SPEED = 300.0

const JUMP_VELOCITY = -300.0

const _EVENTS: Dictionary = { 
	"GROUNDED": &"grounded",
	"IDLE": &"idle",
	"MOVING": &"moving",
	"AIRBORNE": &"airborne",
	"JUMP": &"jump",
	"DOUBLE_JUMP": &"double_jump",
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _sprite = $Sprite2D
@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")


func _ready():
	_animation_tree.active = true


func _physics_process(delta):

	# handle left/right movement
	var direction = Input.get_axis(Controls.LEFT, Controls.RIGHT)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# flip the sprite. we do this before moving, so it flips
	# even if we stand at a wall
	if signf(velocity.x) != 0:
		_sprite.flip_h = velocity.x < 0

	move_and_slide()

	# handle gravity
	if is_on_floor():
		_state_chart.send_event(_EVENTS.GROUNDED)
		velocity.y = 0
	else:
		## apply gravity
		velocity.y += gravity * delta
		_state_chart.send_event(_EVENTS.AIRBORNE)

	# let the state machine know if we are moving or not
	if velocity.length_squared() <= 0.005:
		_state_chart.send_event(_EVENTS.IDLE)
	else:
		_state_chart.send_event(_EVENTS.MOVING)

	# set the velocity to the animation tree, so it can blend between animations
	_animation_tree["parameters/Move/blend_position"] = signf(velocity.y)


func _on_grounded_state_physics_processing(delta):
	if Input.is_action_just_pressed(Controls.JUMP):
		velocity.y = JUMP_VELOCITY
		_state_chart.send_event(_EVENTS.JUMP)


func _on_can_double_jump_state_physics_processing(delta):
	if Input.is_action_just_pressed(Controls.JUMP):
		velocity.y = JUMP_VELOCITY
		_state_chart.send_event(_EVENTS.JUMP)


func _on_double_jump_taken():
	_state_chart.send_event(_EVENTS.DOUBLE_JUMP)
