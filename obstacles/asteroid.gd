extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var shape = $obstacle_body/CollisionShape2D

func _ready() -> void:
	anim.play("roll")
	var scale = randf_range(0.2, 1)
	anim.scale = Vector2(scale, scale)
	shape.scale *= scale
	anim.speed_scale = randf_range(1, 2) * (2*int(randf() > .5)-1)
	
