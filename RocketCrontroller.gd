extends Node2D

var thruster_left : RigidBody2D
var thruster_right : RigidBody2D
var side_thruster_left : RigidBody2D
var side_thruster_right : RigidBody2D
var body : RigidBody2D

func _ready() -> void:
	thruster_left = self.get_node("thruster_left")
	thruster_right = self.get_node("thruster_right")
	side_thruster_left = self.get_node("side_thruster_left")
	side_thruster_right = self.get_node("side_thruster_right")
	body = self.get_node("body_0")

func _physics_process(delta: float) -> void:
	var impulse = Vector2.UP * 30000.0;
	
	if Input.is_action_pressed("thruster_side_0"):
		var local_impulse = impulse.rotated(side_thruster_left.transform.get_rotation()) / 10.0
		side_thruster_left.apply_force(local_impulse)
		print("impulse on side thruster 0")
	
	if Input.is_action_pressed("thruster_side_1"):
		var local_impulse = impulse.rotated(side_thruster_right.transform.get_rotation()) / 10.0
		side_thruster_right.apply_force(local_impulse)
		print("impulse on side thruster 1")
	
	if Input.is_action_pressed("thruster_1"):
		var local_impulse = impulse.rotated(thruster_left.transform.get_rotation())
		thruster_left.apply_force(local_impulse)
		print("impulse on thruster 0")
	
	if Input.is_action_pressed("thruster_0"):
		var local_impulse = impulse.rotated(thruster_right.transform.get_rotation())
		print(thruster_right.transform.get_rotation())
		thruster_right.apply_force(local_impulse)
		print("impulse on thruster 1")
	
