extends Node


class_name GameManager


@onready var bird = $"../Bird" as Bird
@onready var pipe_spawner = $"../PipeSpawner" as PipeSpawner
@onready var ground = $"../Ground" as Ground
@onready var fade_effect = $"../FadeEffect" as FadeEffect
@onready var ui = $"../UI" as UserInterface


var points = 0


func _ready():
	bird.s_game_started.connect(on_game_started)
	ground.s_bird_crashed.connect(on_crash_floor)
	pipe_spawner.s_bird_crashed.connect(on_end_game)
	pipe_spawner.s_bird_scored.connect(on_point_scored)


func on_game_started():
	pipe_spawner.start_spawning_pipes()


func on_crash_floor():
	if fade_effect:
		fade_effect.play()
	ground.stop()
	bird.stop()
	pipe_spawner.stop()
	ui.on_game_over()


func on_end_game():
	ground.stop()
	bird.kill()
	pipe_spawner.stop()
	ui.on_game_over()


func on_point_scored():
	points += 1
	ui.update_points(points)
