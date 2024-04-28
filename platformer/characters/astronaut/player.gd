extends CharacterBody2D

class_name Player


@export var SPEED = 300
@export var DASH_SPEED = 800
@export var JUMP_VELOCITY = -300
@export var dash_speed = 1200
@export var BulletScene: PackedScene


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _can_move_sideways = true
var _can_shoot = true
var _can_jump = true
var _can_dash = true
var _is_dashing = false
var _is_dashing_cooling_down = false

# Positive is RIGHT, Negative is LEFT
var _current_horizontal_direction: float

@onready var _animation_tree = $AnimationTree as AnimationTree
@onready var _playback = _animation_tree["parameters/playback"] as AnimationNodeStateMachinePlayback
@onready var _state_machine: PlayerStateMachine = $StateMachine
@onready var _move_component: MoveComponent = $MoveComponent
@onready var _horizontal_flip_container: Node2D = $HorizontalFlipContainer
@onready var _muzzle: Marker2D = $HorizontalFlipContainer/Muzzle
@onready var _shoot_timer: Timer = $ShootTimer
@onready var _dash_timer: Timer = $DashTimer
@onready var _dash_cooldown_timer: Timer = $DashCooldown


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
		velocity.y += (gravity * delta) if should_apply_gravity() else 0

	_animation_tree["parameters/Move/blend_position"] = signf(velocity.y)


func should_apply_gravity():
	return not _is_dashing


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
	pass


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
	if _can_move_sideways and not _is_dashing:
		var direction = _move_component.get_input_direction().x
		velocity.x = direction * SPEED


func on_crouch() -> void:
	_playback.travel("Crouch")
	velocity.x = 0
	_can_move_sideways = false
	_can_jump = false
	_can_dash = true


func on_leave_crouch() -> void:
	_can_move_sideways = true
	_can_jump = true


func on_shoot() -> void:
	if not _can_shoot: return
	
	_playback.travel("ShootStand")
	var bullet_instance = BulletScene.instantiate() as BulletController
	bullet_instance.global_position = _muzzle.global_position
	bullet_instance.init(_current_horizontal_direction)
	get_parent().add_child(bullet_instance)
	_shoot_timer.start()
	_can_shoot = false


func get_can_dash() -> bool:
	return _can_dash and not _is_dashing_cooling_down


func on_dash() -> void:
	if not get_can_dash(): return

	_is_dashing = true
	_dash_timer.start()
	_can_jump = false
	velocity.y = 0
	velocity.x = _current_horizontal_direction * DASH_SPEED


func _on_shoot_timer_timeout():
	_can_shoot = true


func _on_dash_timer_timeout():
	_is_dashing = false
	_is_dashing_cooling_down = true
	_dash_cooldown_timer.start()


func _on_dash_cooldown_timeout():
	_is_dashing_cooling_down = false
	_can_dash = true
