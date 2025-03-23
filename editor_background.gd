extends Sprite2D

@onready var coin_counter: Label = $"../Missions/coin_counter"
@onready var research_counter: Label = $"../Missions/research_counter"

func _ready() -> void:
	# Load the scene
	var rocket = preload("res://rocket.tscn").instantiate()
	
	var gun = rocket.get_node("body_0/Gun")
	var body = rocket.get_node("body_0/Sprite2D")
	var thruster_l = rocket.get_node("thruster_left/AnimatedSprite2D")
	var thruster_r = rocket.get_node("thruster_right/AnimatedSprite2D")
	var side_thruster_l = rocket.get_node("side_thruster_left/Sprite2D")
	var side_thruster_r = rocket.get_node("side_thruster_right/Sprite2D")
	var camera = rocket.get_node("body_0/Camera2D")
	
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
