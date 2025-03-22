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

# only used when rocket dies
var time_elapsed : float
var spawned_newspaper = false
var photo_taken = false
var crash_texture : Image
var crash_max_altitude : float
var crash_max_speed : float

var camera : Camera2D

func _ready() -> void:
	thruster_left = self.get_node("thruster_left")
	thruster_right = self.get_node("thruster_right")
	side_thruster_left = self.get_node("side_thruster_left")
	side_thruster_right = self.get_node("side_thruster_right")
	body = self.get_node("body_0")
	
	thruster_left_sprite = self.get_node("thruster_left/AnimatedSprite2D")
	thruster_right_sprite = self.get_node("thruster_right/AnimatedSprite2D")
	
	laser_beam = self.get_node("body_0/LaserBeam")
	
	camera = self.get_node("body_0/Camera2D")
	
	gun = self.get_node("body_0/Gun")

func _physics_process(delta: float) -> void:
	if kaput == true:
		return
		
	crash_max_speed = max(crash_max_speed, int(body.linear_velocity.length() / 200.0))
	crash_max_altitude = max(crash_max_altitude, (-int(body.position.y)) / 20)

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

func _process(delta: float) -> void:
	if kaput and !spawned_newspaper:
		time_elapsed += delta
		
		if time_elapsed < 3.0 and time_elapsed > 0.2 and !photo_taken:
			crash_texture = get_viewport().get_texture().get_image()
			photo_taken = true
		elif time_elapsed >= 3.0:
			var newspaper = load("res://newspaper.tscn").instantiate()
			newspaper.position = camera.global_position
			get_tree().root.add_child(newspaper)
			
			var head_to_get = randi() % 5
			var file = FileAccess.open("res://newspaper_headlines/" + str(head_to_get) + ".txt", FileAccess.READ)
			var headline_text = file.get_as_text()
			
			var hl : Label = newspaper.get_node("Offset/WrittenPaperNoBackground/Headline")
			hl.text = headline_text
			
			var infos : Label = newspaper.get_node("Offset/WrittenPaperNoBackground/Infos")
			infos.text = "Altitude atteinte : " + str(crash_max_altitude) + " m\nVitesse maximale : " + str(crash_max_speed) + " m/s\n"
			
			var screenshot : TextureRect = newspaper.get_node("Offset/WrittenPaperNoBackground/TextureRect")
			var final =  Image.create(1920 / 2, 1080 / 2, false, Image.FORMAT_RGB8)
			final.blit_rect(crash_texture, Rect2i(1920/4, 1080/4, 1920/2, 1080/2), Vector2i(0, 0))
			screenshot.texture = ImageTexture.create_from_image(final)
			
			# prevent the camera from moving again
			camera.reparent(get_tree().root)
			
			# hide UI because it's useless now
			get_tree().root.get_node("exploration/CanvasLayer").visible = false
			
			# clicking to "Suite" relaunch this scene
			# TODO: should launch editor
			
			spawned_newspaper = true

func explode_rocket():
	# Detach all joints
	var explosion = load("res://explosion.tscn")
	for child in get_children():
		if is_instance_of(child, GrooveJoint2D):
			var c : GrooveJoint2D = child;
			c.node_a = ""
			c.node_b = ""
			
	var local_explosion = explosion.instantiate()
	local_explosion.position = body.global_position
	get_tree().root.add_child(local_explosion)
	
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


func _on_rocket_part_body_entered(target: Node) -> void:
	if target.name.contains("obstacle_body"):
		explode_rocket()
	elif body.linear_velocity.length() > 100.0:
		explode_rocket()
