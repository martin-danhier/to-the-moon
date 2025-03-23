extends ProgressBar

var rocket : RigidBody2D

func _ready() -> void:
	rocket = get_node("/root/exploration/Rocket/body_0")
	
func _process(delta: float) -> void:
	update()

func update():
	value = -rocket.position.y / 1000
	
