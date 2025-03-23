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

var thruster_sound_left : AudioStreamPlayer
var thruster_sound_right : AudioStreamPlayer
var small_thruster_sound_left : AudioStreamPlayer
var small_thruster_sound_right : AudioStreamPlayer
var laser_sound : AudioStreamPlayer
var small_explosion_sound: AudioStreamPlayer
var large_explosion_sound: AudioStreamPlayer

var laser_beam : Node2D

var gun : Node2D

var kaput = false

var fuel_level = 100.0
var battery_level = 100.0

# only used when rocket dies
var time_elapsed : float
var spawned_newspaper = false
var photo_taken = false
var die_sound_played = false
var crash_texture : Image
var crash_max_altitude : float
var crash_max_speed : float

var camera : Camera2D

var laser_cooldown = 0.3

var target : Node2D

func get_nearest_obstacle() -> Node2D:
	var children = get_tree().root.get_node("exploration/ObstacleInstantiator/obstacle_container").get_children()

	if children.size() == 0:
		return null

	var min_idx = 0
	var min_distance = 99999.0

	var local_pos = gun.global_position

	var idx = 0
	for child in children:
		var this_distance = local_pos.distance_to(child.global_position)

		if child.global_position.y > 0.0:
			idx += 1
			continue

		if this_distance < min_distance:
			min_idx = idx
			min_distance = this_distance
		idx += 1

	return children[min_idx]

func _ready() -> void:
	thruster_left = self.get_node("thruster_left")
	thruster_right = self.get_node("thruster_right")
	side_thruster_left = self.get_node("side_thruster_left")
	side_thruster_right = self.get_node("side_thruster_right")
	body = self.get_node("body_0")

	target = get_tree().root.get_node("exploration/target")

	thruster_left_sprite = self.get_node("thruster_left/AnimatedSprite2D")
	thruster_right_sprite = self.get_node("thruster_right/AnimatedSprite2D")

	thruster_sound_left = self.get_node("thruster_sound_left")
	thruster_sound_right = self.get_node("thruster_sound_right")
	small_thruster_sound_left = self.get_node("small_thruster_sound_left")
	small_thruster_sound_right = self.get_node("small_thruster_sound_right")
	laser_sound = self.get_node("laser_sound")
	small_explosion_sound = self.get_node("small_explosion_sound")
	large_explosion_sound = self.get_node("large_explosion_sound")

	laser_beam = self.get_node("LaserBeam")

	camera = self.get_node("body_0/Camera2D")

	gun = self.get_node("body_0/Gun")

func _physics_process(delta: float) -> void:
	if kaput == true:
		return

	var nearest_obstacle = get_nearest_obstacle()
	if nearest_obstacle != null:
		var too_close = get_tree().root.get_node("exploration/TooCloseSound") as AudioStreamPlayer
		if nearest_obstacle.global_position.distance_to(body.global_position) < 350:
			if !too_close.playing:
				too_close.play()
		else:
			too_close.stop()

	crash_max_speed = max(crash_max_speed, int(body.linear_velocity.length() / 200.0))
	var curr_altitude = (-int(body.position.y)) / 20
	crash_max_altitude = max(crash_max_altitude, curr_altitude)

	var altitude_sound = get_tree().root.get_node("exploration/AltitudeSound") as AudioStreamPlayer
	if crash_max_altitude > curr_altitude + 45:
		if !altitude_sound.playing:
			altitude_sound.play()

	var impulse = Vector2.UP * 17000.0;

	var angular_velocity = body.angular_velocity

	if abs(angular_velocity) > 3.14 * 3:
		explode_rocket()

	if laser_cooldown > 0.0:
		laser_cooldown -= delta

	if Input.is_action_pressed("thruster_side_1") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(side_thruster_left.transform.get_rotation()) / 10.0
		side_thruster_left.apply_force(local_impulse)
		fuel_level -= 0.006
		if not small_thruster_sound_left.playing:
			small_thruster_sound_left.play()
	else:
		small_thruster_sound_left.stop()

	if Input.is_action_pressed("thruster_side_0") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(side_thruster_right.transform.get_rotation()) / 10.0
		side_thruster_right.apply_force(local_impulse)
		fuel_level -= 0.006
		if not small_thruster_sound_right.playing:
			small_thruster_sound_right.play()
	else:
		small_thruster_sound_right.stop()

	if Input.is_action_pressed("thruster_0") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(thruster_left.transform.get_rotation())
		thruster_left.apply_force(local_impulse)
		thruster_left_sprite.play("thrusting")
		if not thruster_sound_left.playing:
			thruster_sound_left.play()
		fuel_level -= 0.018
	else:
		thruster_left_sprite.play("idle")
		thruster_sound_left.stop()

	if Input.is_action_pressed("thruster_1") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(thruster_right.transform.get_rotation())
		thruster_right.apply_force(local_impulse)
		thruster_right_sprite.play("thrusting")
		if not thruster_sound_right.playing:
			thruster_sound_right.play()
		fuel_level -= 0.018
	else:
		thruster_right_sprite.play("idle")
		thruster_sound_right.stop()

	if Input.is_action_pressed("fire") and battery_level > 0.0 and laser_cooldown <= 0.0:
		battery_level -= 2.3

		laser_cooldown = 0.3

		var space_state = get_tree().root.world_2d.direct_space_state

		if nearest_obstacle != null and nearest_obstacle.global_position.distance_to(body.global_position) < 850:
			var to = nearest_obstacle.global_position
			var query = PhysicsRayQueryParameters2D.create(gun.global_position, to)
			var result = space_state.intersect_ray(query)

			target.global_position = to

			if result:
				if result.collider.name.contains("obstacle_body"):
					# delete obstacles
					result.collider.get_parent().call_deferred("queue_free")

					# spawn explosion
					var explosion = load("res://explosion.tscn")
					var local_explosion = explosion.instantiate()
					local_explosion.position = to
					local_explosion.scale *= 0.5
					get_tree().root.add_child(local_explosion)
					laser_sound.play()
					small_explosion_sound.play()
					# laser_beam.visible = true

					# spawn coins


	else:
		laser_beam.visible = false

	(get_tree().root.get_node("exploration/CanvasLayer/Fuel") as ProgressBar).value = fuel_level
	(get_tree().root.get_node("exploration/CanvasLayer/Battery") as ProgressBar).value = battery_level

func _process(delta: float) -> void:
	if !kaput:
		var rot = rad_to_deg(body.global_rotation)
		if rot > 30.0 or rot < -30.0:
			var pull_up = get_tree().root.get_node("exploration/PullUpSound") as AudioStreamPlayer
			if !pull_up.playing and !die_sound_played:
				pull_up.play()
				die_sound_played = true
		else:
			var pull_up = get_tree().root.get_node("exploration/PullUpSound") as AudioStreamPlayer
			pull_up.stop()
	elif kaput and !spawned_newspaper:
		var die_sound = get_tree().root.get_node("exploration/DieSound") as AudioStreamPlayer
		if !die_sound.playing:
			die_sound.play()
		time_elapsed += delta

		if time_elapsed < 3.6 and time_elapsed > 0.2 and !photo_taken:
			crash_texture = get_viewport().get_texture().get_image()
			photo_taken = true
		elif time_elapsed >= 3.6:
			var newspaper = load("res://newspaper.tscn").instantiate()
			newspaper.position = camera.global_position
			get_tree().root.add_child(newspaper)

			var head_to_get = randi() % 2
			var headline_text : String

			if fuel_level <= 0.0:
				var file = FileAccess.open("res://newspaper_headlines/fuel/" + str(head_to_get) + ".txt", FileAccess.READ)
				headline_text = file.get_as_text()
			elif crash_max_altitude < 1000.0:
				var file = FileAccess.open("res://newspaper_headlines/bad/" + str(head_to_get) + ".txt", FileAccess.READ)
				headline_text = file.get_as_text()
			elif crash_max_altitude < 2000.0 and crash_max_altitude > 1000.0:
				var file = FileAccess.open("res://newspaper_headlines/semi_good/" + str(head_to_get) + ".txt", FileAccess.READ)
				headline_text = file.get_as_text()
			else:
				var file = FileAccess.open("res://newspaper_headlines/good/" + str(head_to_get) + ".txt", FileAccess.READ)
				headline_text = file.get_as_text()

			var hl : Label = newspaper.get_node("Offset/WrittenPaperNoBackground/Headline")
			hl.text = headline_text

			var infos : Label = newspaper.get_node("Offset/WrittenPaperNoBackground/Infos")
			infos.text = "Altitude atteinte : " + str(crash_max_altitude) + " m\nVitesse maximale : " + str(crash_max_speed) + " m/s\n"

			var screenshot : TextureRect = newspaper.get_node("Offset/WrittenPaperNoBackground/TextureRect")
			var final =  Image.create(1920 / 2, 1080 / 2, false, Image.FORMAT_RGB8)
			final.blit_rect(crash_texture, Rect2i(1920 / 4, 1080 / 4 + 200, 1920 / 2, 1080 / 2 + 200), Vector2i(0, 0))
			screenshot.texture = ImageTexture.create_from_image(final)

			# prevent the camera from moving again
			camera.reparent(get_tree().root)

			# hide UI because it's useless now
			get_tree().root.get_node("exploration/CanvasLayer").visible = false

			# clicking to "Suite" relaunch this scene
			# TODO: should launch editor

			# end "die sound"
			die_sound.stop()

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
	large_explosion_sound.play()
	get_tree().root.add_child(local_explosion)

	# make it looks like everything went wrong
	thruster_left.apply_torque_impulse(randf_range(-2000.0, 2000.0))
	thruster_right.apply_torque_impulse(randf_range(-2000.0, 2000.0))
	side_thruster_left.apply_torque_impulse(randf_range(-2000.0, 2000.0))
	side_thruster_right.apply_torque_impulse(randf_range(-2000.0, 2000.0))

	thruster_right_sprite.play("idle")
	thruster_left_sprite.play("idle")
	laser_beam.visible = false

	thruster_sound_left.stop()
	thruster_sound_right.stop()
	small_thruster_sound_left.stop()
	small_thruster_sound_right.stop()

	kaput = true
	rocket_exploded.emit()

func _on_rocket_part_body_entered(target: Node) -> void:
	if target.name.contains("obstacle_body"):
		explode_rocket()
	elif body.linear_velocity.length() > 120.0:
		explode_rocket()
