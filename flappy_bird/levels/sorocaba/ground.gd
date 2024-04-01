extends Node2D

class_name Ground

signal s_bird_crashed

@export var speed = -150

@onready var sprite1: Sprite2D = $Ground1/Sprite2D
@onready var ground_1: Area2D = $Ground1
@onready var ground_2: Area2D = $Ground2
var _texture_width: int = 0


func _ready():
	_texture_width = sprite1.texture.get_width()
	ground_2.position.x = ground_1.position.x + _texture_width


func _process(delta):
	ground_1.position.x += speed * delta
	ground_2.position.x += speed * delta
	
	if ground_1.position.x < -_texture_width:
		ground_1.position.x = ground_2.position.x + _texture_width
	if ground_2.position.x < -_texture_width:
		ground_2.position.x = ground_1.position.x + _texture_width


func _on_body_entered(body):
	s_bird_crashed.emit()


func stop():
	speed = 0
