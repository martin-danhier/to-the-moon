extends Label

var rocket : RigidBody2D

func _ready() -> void:
	rocket = get_node("/root/exploration/Rocket/body_0")

func _process(delta: float) -> void:
	self.text = str(int(rocket.linear_velocity.length() / 200.0)) + " m/s"
