extends Node2D

var thruster_left : RigidBody2D
var thruster_right : RigidBody2D
var side_thruster_left : RigidBody2D
var side_thruster_right : RigidBody2D
var body : RigidBody2D

var kaput = false

func _ready() -> void:
	thruster_left = self.get_node("thruster_left")
	thruster_right = self.get_node("thruster_right")
	side_thruster_left = self.get_node("side_thruster_left")
	side_thruster_right = self.get_node("side_thruster_right")
	body = self.get_node("body_0")

func _physics_process(delta: float) -> void:
	if kaput == true:
		return

	var impulse = Vector2.UP * 30000.0;

	var angular_velocity = body.angular_velocity

	if abs(angular_velocity) > 3.14 * 3:
		# dirty way of grabbing all joint
		for child in get_children():
			if is_instance_of(child, GrooveJoint2D):
				var c : GrooveJoint2D = child;
				c.node_a = ""
				c.node_b = ""
		kaput = true

		# make it looks like everything went wrong
		thruster_left.apply_torque_impulse(randf_range(-2000.0, 2000.0))
		thruster_right.apply_torque_impulse(randf_range(-2000.0, 2000.0))
		side_thruster_left.apply_torque_impulse(randf_range(-2000.0, 2000.0))
		side_thruster_right.apply_torque_impulse(randf_range(-2000.0, 2000.0))

	if Input.is_action_pressed("thruster_side_0"):
		var local_impulse = impulse.rotated(side_thruster_left.transform.get_rotation()) / 10.0
		side_thruster_left.apply_force(local_impulse)

	if Input.is_action_pressed("thruster_side_1"):
		var local_impulse = impulse.rotated(side_thruster_right.transform.get_rotation()) / 10.0
		side_thruster_right.apply_force(local_impulse)

	if Input.is_action_pressed("thruster_1"):
		var local_impulse = impulse.rotated(thruster_left.transform.get_rotation())
		thruster_left.apply_force(local_impulse)

	if Input.is_action_pressed("thruster_0"):
		var local_impulse = impulse.rotated(thruster_right.transform.get_rotation())
		thruster_right.apply_force(local_impulse)

func _on_rocket_part_body_entered(body: Node) -> void:
	
	# Detach all joints
	for child in joints.get_children():
		if is_instance_of(child, Joint2D):
			var joint = child as Joint2D
			joint.node_a = ""
			joint.node_b = ""

	rocket_exploded.emit()
