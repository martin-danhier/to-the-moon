extends Node2D

@export var speed = 3

@onready var anim = $AnimatedSprite2D
@onready var shape = $obstacle_body/CollisionShape2D

var direction = (randf() > 0.5)

func _ready() -> void:
	anim.flip_h = direction
	anim.play("fly")
	

func _process(delta: float) -> void:
	position.x -= (int(direction)*2-1) * speed
	
