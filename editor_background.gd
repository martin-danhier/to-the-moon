extends Sprite2D

@onready var coin_counter: Label = $"../Missions/coin_counter"
@onready var research_counter: Label = $"../Missions/research_counter"

var laser_beam : Node2D

func _ready() -> void:
	# Load the scene
	var rocket = preload("res://rocket.tscn").instantiate()
	
	var gun = rocket.get_node("body_0/Gun")
	var body = rocket.get_node("body_0/Sprite2D")
	var camera = rocket.get_node("body_0/Camera2D")
	laser_beam = rocket.get_node("LaserBeam")
	
	for child in rocket.get_children():
		if is_instance_of(child, RigidBody2D):
			var c : RigidBody2D = child;
			c.freeze = true
	camera.enabled = false
	
	# Temporarily disable the script
	rocket.set_script(null)

	# Add the node to the current scene
	add_child(rocket)
	
	rocket.apply_scale(Vector2(1.5,1.5))
	rocket.set_position(Vector2(0.0, 135.0))

func _process(delta: float) -> void:
	laser_beam.visible = false
