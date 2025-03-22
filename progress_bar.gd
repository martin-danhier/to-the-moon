extends ProgressBar

@export var rocket: RigidBody2D

func _ready():
	update()
	
func _process(delta: float) -> void:
	update()

func update():
	value = -rocket.position.y/10000
	print("aaa", rocket.position)
	
