extends Label

var rocket : RigidBody2D

func _ready() -> void:
	rocket = get_node("/root/exploration/Rocket/body_0")

func _process(delta: float) -> void:
	var altitude = (-int(rocket.position.y) + 95) / 20
	
	var suffix = " m"
	
	if altitude > 1000.0:
		altitude /= 100
		altitude /= 10.0
		suffix = " km"
		
	self.text = str(altitude) + suffix
