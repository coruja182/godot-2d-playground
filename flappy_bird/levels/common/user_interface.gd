extends CanvasLayer


class_name UserInterface


@onready var points_label = $MarginContainer/PointsLabel as Label
@onready var game_over_box = $MarginContainer/GameOverBox as BoxContainer


func _ready():
	points_label.text = "0"
	game_over_box.visible = false
	

func update_points(points: int):
	points_label.text = "%d" % points


func on_game_over():
	game_over_box.visible = true


func _on_restart_button_pressed():
	get_tree().reload_current_scene()
