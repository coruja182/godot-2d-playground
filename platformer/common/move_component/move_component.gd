extends Node


class_name MoveComponent


var _input_direction: Vector2


func get_input_direction() -> Vector2:
	return _input_direction


func _input(event):
	_input_direction = Input.get_vector("Left", "Right", "Up", "Down")


func _unhandled_input(event: InputEvent):
	_input_direction = Input.get_vector("Left", "Right", "Up", "Down")


func wants_jump() -> bool:
	return Input.is_action_just_pressed("Jump")	


func wants_to_move_sideways() -> bool:
	return _input_direction.x != 0


func wants_to_crouch() -> bool:
	return _input_direction.y > 0


func wants_shoot() -> bool:
	return Input.is_action_just_pressed("Shoot")
