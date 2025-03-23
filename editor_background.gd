extends Sprite2D

@onready var coin_counter: Label = $"../Missions/coin_counter"
@onready var research_counter: Label = $"../Missions/research_counter"
@onready var rocket: Node2D = $"../Rocket"

func _ready() -> void:
	
	var gun = rocket.get_node("body_0/Gun")
	var body = rocket.get_node("body_0/Sprite2D")
	var thruster_l = rocket.get_node("thruster_left/AnimatedSprite2D")
	var thruster_r = rocket.get_node("thruster_right/AnimatedSprite2D")
	var side_thruster_l = rocket.get_node("side_thruster_left/Sprite2D")
	var side_thruster_r = rocket.get_node("side_thruster_right/Sprite2D")
	var camera = rocket.get_node("body_0/Camera2D")
	var laser = rocket.get_node("LaserBeam")
	
	for child in rocket.get_children():
		if is_instance_of(child, RigidBody2D):
			var c : RigidBody2D = child;
			c.freeze = true
	camera.enabled = false
	laser.visible = false
	
	# Temporarily disable the script
	rocket.set_script(null)

# Au changement de scene, remettre les paramètres de base pour rocket
