extends Sprite2D

@onready var coin_counter: Label = $"../Missions/CoinValue"
@onready var research_counter: Label = $"../Missions/ScienceValue"
@onready var rocket: Node2D = $"../Rocket"

var laser_beam : Node2D

func _ready() -> void:
	var camera = rocket.get_node("body_0/Camera2D")
	laser_beam = rocket.get_node("LaserBeam")
	
	for child in rocket.get_children():
		if is_instance_of(child, RigidBody2D):
			var c : RigidBody2D = child;
			c.freeze = true
	camera.enabled = false
	
	# Temporarily disable the script
	rocket.set_script(null)

func _process(delta: float) -> void:
	laser_beam.visible = false
