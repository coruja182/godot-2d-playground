extends Node2D


class_name PipeSpawner

signal s_bird_crashed
signal s_bird_scored

const _GROUP_PIPES = "group_pipes"

var pipe_pair_scene = preload("res://models/pipe/pipe_pair.tscn")

@export var pipe_speed = -150

@onready var spawn_timer: Timer = $SpawnTimer


func _ready():
	spawn_timer.timeout.connect(spawn_pipe)


func start_spawning_pipes():
	spawn_timer.start()


func spawn_pipe():
	var pipes = pipe_pair_scene.instantiate() as PipePair
	pipes.add_to_group(_GROUP_PIPES)
	add_child(pipes)
	
	var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
	pipes.position.x = viewport_rect.end.x
	
	var half_height = viewport_rect.size.y / 2
	pipes.position.y = randf_range(viewport_rect.size.y * 0.15 - half_height, viewport_rect.size.y * 0.65 - half_height)
	pipes.s_bird_crashed.connect(on_bird_crashed)
	pipes.s_point_scored.connect(on_bird_scored)
	pipes.set_speed(pipe_speed)


func stop():
	spawn_timer.stop()
	for pipe_it in get_tree().get_nodes_in_group(_GROUP_PIPES):
		(pipe_it as PipePair).speed = 0


func on_bird_crashed():
	s_bird_crashed.emit()


func on_bird_scored():
	s_bird_scored.emit()
