extends Node2D

class_name PipePair

signal s_bird_crashed
signal s_point_scored

var speed = 0

func set_speed(new_speed):
	speed = new_speed


func _process(delta):
	position.x += speed * delta


func _on_pipe_hit(body):
	s_bird_crashed.emit()


func _on_scored(body):
	s_point_scored.emit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	print_debug("removing pipe ...", self)
	queue_free()
