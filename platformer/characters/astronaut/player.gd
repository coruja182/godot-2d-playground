extends CharacterBody2D

class_name Player

var BulletScene = preload("res://models/bullet/bullet.tscn")

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _can_move_sideways = true
var _can_shoot = true
var _can_jump = true

# Positive is RIGHT, Negative is LEFT
var _current_horizontal_direction: float

@onready var _animation_tree = $AnimationTree as AnimationTree
@onready var _playback = _animation_tree["parameters/playback"] as AnimationNodeStateMachinePlayback
@onready var _state_machine: PlayerStateMachine = $StateMachine
@onready var _move_component: MoveComponent = $MoveComponent
@onready var _horizontal_flip_container: Node2D = $HorizontalFlipContainer
@onready var _muzzle: Marker2D = $HorizontalFlipContainer/Muzzle
@onready var _shoot_timer: Timer = $ShootTimer

func _ready():
	_animation_tree.active = true
	_state_machine.init(self, _move_component)
	_current_horizontal_direction = scale.x
	
	
func _physics_process(delta):
	move_and_slide()
	_flip_character_if_needed()

	## handle gravity
	if is_on_floor():
		velocity.y = 0
	else:
		### apply gravity
		velocity.y += gravity * delta

	_animation_tree["parameters/Move/blend_position"] = signf(velocity.y)

# Scaling the whole node horizontally does not work
# https://github.com/godotengine/godot/issues/78613
func _flip_character_if_needed() -> void:
	if _move_component.get_input_direction().x != 0:
		_horizontal_flip_container.scale.x = _move_component.get_input_direction().x
	_current_horizontal_direction = _horizontal_flip_container.scale.x


func is_idle() -> bool:
	return is_on_floor() && velocity.x < .1 && velocity.x > -.1


func can_jump() -> bool:
	return _can_jump


func on_air_or_fall() -> void:
	_playback.travel("Move")


func on_jump() -> void:
	_can_shoot = true
	_can_move_sideways = true
	velocity.y = JUMP_VELOCITY
	_playback.travel("Move")
	

func on_double_jump() -> void:
	_can_shoot = true
	_can_move_sideways = true
	_can_jump = false
	_playback.travel("DoubleJump")
	velocity.y = JUMP_VELOCITY


func on_landing() -> void:
	print_debug("on_landing")


func on_idle():
	_playback.travel("Idle")
	_can_shoot = true
	_can_move_sideways = true
	_can_jump = true
	velocity = Vector2.ZERO


func on_run() -> void:
	_can_jump = true
	_playback.travel("Run")


func on_move_sideways(_delta: float = 0):
	if _can_move_sideways:
		var direction = _move_component.get_input_direction().x
		velocity.x = direction * SPEED


func on_crouch() -> void:
	_playback.travel("Crouch")
	velocity.x = 0
	_can_move_sideways = false
	_can_jump = false


func on_leave_crouch() -> void:
	_can_move_sideways = true
	_can_jump = true


func on_shoot() -> void:
	if _can_shoot:
		_playback.travel("ShootStand")
		var bullet_instance = BulletScene.instantiate() as BulletController
		bullet_instance.global_position = _muzzle.global_position
		bullet_instance.init(_current_horizontal_direction)
		get_parent().add_child(bullet_instance)
		_shoot_timer.start()
		_can_shoot = false


func _on_shoot_timer_timeout():
	_can_shoot = true
