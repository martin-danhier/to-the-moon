extends CollisionShape2D

var rocket : RigidBody2D

func _ready() -> void:
	rocket = get_node("/root/exploration/Rocket/body_0")

func _process(delta: float) -> void:
	position.x = rocket.position.x
	
