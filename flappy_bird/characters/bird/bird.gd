extends CharacterBody2D

class_name Bird


signal s_game_started

@export var jump_force = -300
@export var rotation_speed = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_speed = 400
var is_started = false
var should_process_input = true


func _ready():
	velocity = Vector2.ZERO
	animation_player.play("idle")


func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && should_process_input:
		if !is_started:
			s_game_started.emit()
			animation_player.play("flapping")
			is_started = true
		jump()
		
	if !is_started:
		return

	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_speed)
	move_and_collide(velocity * delta)
	rotate_bird()


func jump():
	velocity.y = jump_force
	rotation = deg_to_rad(-30)


func rotate_bird():
	# rotate downwards when falling
	if velocity.y > 0 && rad_to_deg(rotation) < 90:
		rotation += rotation_speed * deg_to_rad(1)
	elif velocity.y < 0 && rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)


func kill():
	animation_player.play("hit")
	should_process_input = false


func stop():
	animation_player.stop()
	gravity = 0
	velocity = Vector2.ZERO
	should_process_input = false
