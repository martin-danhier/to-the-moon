extends Node2D

signal rocket_exploded

var thruster_left : RigidBody2D
var thruster_right : RigidBody2D
var side_thruster_left : RigidBody2D
var side_thruster_right : RigidBody2D
var body : RigidBody2D

var thruster_left_sprite : AnimatedSprite2D
var thruster_right_sprite : AnimatedSprite2D
var side_thruster_left_sprite : AnimatedSprite2D
var side_thruster_right_sprite : AnimatedSprite2D

var laser_beam : Node2D

var gun : Node2D

var kaput = false

func _ready() -> void:
	thruster_left = self.get_node("thruster_left")
	thruster_right = self.get_node("thruster_right")
	side_thruster_left = self.get_node("side_thruster_left")
	side_thruster_right = self.get_node("side_thruster_right")
	body = self.get_node("body_0")
	
	thruster_left_sprite = self.get_node("thruster_left/AnimatedSprite2D")
	thruster_right_sprite = self.get_node("thruster_right/AnimatedSprite2D")
	
	laser_beam = self.get_node("body_0/LaserBeam")
	
	gun = self.get_node("body_0/Gun")

func _physics_process(delta: float) -> void:
	if kaput == true:
		return

	var impulse = Vector2.UP * 30000.0;

	var angular_velocity = body.angular_velocity

	if abs(angular_velocity) > 3.14 * 3:
		explode_rocket()

	if Input.is_action_pressed("thruster_side_1"):
		var local_impulse = impulse.rotated(side_thruster_left.transform.get_rotation()) / 10.0
		side_thruster_left.apply_force(local_impulse)

	if Input.is_action_pressed("thruster_side_0"):
		var local_impulse = impulse.rotated(side_thruster_right.transform.get_rotation()) / 10.0
		side_thruster_right.apply_force(local_impulse)

	if Input.is_action_pressed("thruster_0"):
		var local_impulse = impulse.rotated(thruster_left.transform.get_rotation())
		thruster_left.apply_force(local_impulse)
		thruster_left_sprite.play("thrusting")
	else:
		thruster_left_sprite.play("idle")

	if Input.is_action_pressed("thruster_1"):
		var local_impulse = impulse.rotated(thruster_right.transform.get_rotation())
		thruster_right.apply_force(local_impulse)
		thruster_right_sprite.play("thrusting")
	else:
		thruster_right_sprite.play("idle")
	
	if Input.is_action_pressed("fire"):
		laser_beam.visible = true
		
		var space_state = gun.get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var to = Vector2(0, -1000).rotated(body.transform.get_rotation())
		var query = PhysicsRayQueryParameters2D.create(gun.position, to)
		var result = space_state.intersect_ray(query)
		
		if result:
			if result.collider.name.contains("obstacle_body"):
				result.collider.get_parent().call_deferred("queue_free")
	else:
		laser_beam.visible = false
		

func explode_rocket():
	# Detach all joints
	for child in get_children():
		if is_instance_of(child, GrooveJoint2D):
			var c : GrooveJoint2D = child;
			c.node_a = ""
			c.node_b = ""
	
	# make it looks like everything went wrong
	thruster_left.apply_torque_impulse(randf_range(-2000.0, 2000.0))
	thruster_right.apply_torque_impulse(randf_range(-2000.0, 2000.0))
	side_thruster_left.apply_torque_impulse(randf_range(-2000.0, 2000.0))
	side_thruster_right.apply_torque_impulse(randf_range(-2000.0, 2000.0))
	
	thruster_right_sprite.play("idle")
	thruster_left_sprite.play("idle")
	laser_beam.visible = false
	
	kaput = true
	rocket_exploded.emit()


func _on_rocket_part_body_entered(body: Node) -> void:
	if body.name.contains("obstacle_body"):
		explode_rocket()
