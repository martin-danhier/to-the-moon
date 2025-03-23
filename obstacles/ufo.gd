extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var shape = $obstacle_body/CollisionShape2D

func _ready() -> void:
	anim.play("spin")
	
