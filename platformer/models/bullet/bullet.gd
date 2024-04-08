extends AnimatedSprite2D


class_name BulletController


@export var _direction: float
@export var speed: float = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(_direction, "%s direction is not set" % name)


func init(direction: float) -> void:
	_direction = direction


func _physics_process(delta: float):
	move_local_x(_direction * speed * delta)


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body: Node):
	queue_free()
