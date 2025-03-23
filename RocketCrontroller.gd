extends Node2D

signal rocket_exploded

@export var bpm = 140.0
@export var music_offset_seconds = 0.35

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
var coin_sound: AudioStreamPlayer

var gun : Sprite2D

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

var music_sound: AudioStreamPlayer

var processed_beat = false

var coin_prefab

var coin_value : Label
var coin_count : int = 0

var laser_fired = false

class SomewhatGameState:
	var Coins: int = 0
	var Fame: int = 0
	
	var GunTier: int = 1
	var ThrusterTier: int = 1
	var FuelTier: int = 1
	
var game_state : SomewhatGameState

# some value to change depending on upgrade !!!!
@export var THRUSTER_IMPULSE = 17_000.0
@export var SIDE_THRUSTER_COMSUMPTION = 0.004
@export var MAIN_THRUSTER_COMSUMPTION = 0.012
@export var LASER_RANGE = 620
@export var LASER_COOLDOWN = 0.22
@export var LASER_CONSUMPTION = 1.9

var visual_thruster_tier1_left : AnimatedSprite2D
var visual_thruster_tier2_left : AnimatedSprite2D
var visual_thruster_tier3_left : AnimatedSprite2D

var visual_thruster_tier1_right : AnimatedSprite2D
var visual_thruster_tier2_right : AnimatedSprite2D
var visual_thruster_tier3_right : AnimatedSprite2D

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

		if child.global_position.y > 0.0 or child.is_in_group("ignored"):
			idx += 1
			continue

		if this_distance < min_distance:
			min_idx = idx
			min_distance = this_distance
		idx += 1

	return children[min_idx]

func _ready() -> void:
	# 
	var file_read = FileAccess.open("./save_file.data", FileAccess.READ)
	if file_read == null:
		print("FIRST TIME PLAYING?")
		var file_write = FileAccess.open("./save_file.data", FileAccess.WRITE)
		game_state = SomewhatGameState.new()
		var dico = inst_to_dict(game_state)
		file_write.store_string(JSON.stringify(dico))
		file_write.close()
	else:
		print("LOADIIINNNGGGG")
		var dico = JSON.new()
		dico.parse(file_read.get_as_text())
		var data = dico.get_data()
		print("loading:", JSON.stringify(data))
		game_state = SomewhatGameState.new()
		game_state.Coins = data["Coins"]
		game_state.Fame = data["Fame"]
		game_state.GunTier = data["GunTier"]
		game_state.ThrusterTier = data["ThrusterTier"]
		game_state.FuelTier = data["FuelTier"]
	
	thruster_left = self.get_node("thruster_left")
	thruster_right = self.get_node("thruster_right")
	side_thruster_left = self.get_node("side_thruster_left")
	side_thruster_right = self.get_node("side_thruster_right")
	body = self.get_node("body_0")

	target = get_tree().root.get_node("exploration/target")

	side_thruster_left_sprite = self.get_node("side_thruster_left/AnimatedSprite2D")
	side_thruster_right_sprite = self.get_node("side_thruster_right/AnimatedSprite2D")

	thruster_sound_left = self.get_node("thruster_sound_left")
	thruster_sound_right = self.get_node("thruster_sound_right")
	small_thruster_sound_left = self.get_node("small_thruster_sound_left")
	small_thruster_sound_right = self.get_node("small_thruster_sound_right")
	laser_sound = self.get_node("laser_sound")
	small_explosion_sound = self.get_node("small_explosion_sound")
	large_explosion_sound = self.get_node("large_explosion_sound")
	music_sound = get_tree().root.get_node("exploration/MusicSound") as AudioStreamPlayer
	coin_sound = self.get_node("coin_sound")
	
	visual_thruster_tier1_left = get_node("thruster_left/AnimatedSprite2D_tier1")
	visual_thruster_tier1_left.visible = false
	visual_thruster_tier2_left = get_node("thruster_left/AnimatedSprite2D_tier2")
	visual_thruster_tier2_left.visible = false
	visual_thruster_tier3_left = get_node("thruster_left/AnimatedSprite2D_tier3")
	visual_thruster_tier3_left.visible = false
	
	visual_thruster_tier1_right = get_node("thruster_right/AnimatedSprite2D_tier1")
	visual_thruster_tier1_right.visible = false
	visual_thruster_tier2_right = get_node("thruster_right/AnimatedSprite2D_tier2")
	visual_thruster_tier2_right.visible = false
	visual_thruster_tier3_right = get_node("thruster_right/AnimatedSprite2D_tier3")
	visual_thruster_tier3_right.visible = false
	
	match game_state.ThrusterTier:
		1:
			visual_thruster_tier1_left.visible = true
			visual_thruster_tier1_right.visible = true
			thruster_left_sprite = visual_thruster_tier1_left
			thruster_right_sprite = visual_thruster_tier1_right
			
			THRUSTER_IMPULSE *= 0.9
			MAIN_THRUSTER_COMSUMPTION *= 1.2
		2:
			visual_thruster_tier2_left.visible = true
			visual_thruster_tier2_right.visible = true
			thruster_left_sprite = visual_thruster_tier2_left
			thruster_right_sprite = visual_thruster_tier2_right
			
			THRUSTER_IMPULSE *= 1.0
			MAIN_THRUSTER_COMSUMPTION *= 1.0
		3:
			visual_thruster_tier3_left.visible = true
			visual_thruster_tier3_right.visible = true
			thruster_left_sprite = visual_thruster_tier3_left
			thruster_right_sprite = visual_thruster_tier3_right
			
			THRUSTER_IMPULSE *= 1.2
			MAIN_THRUSTER_COMSUMPTION *= 0.55

	camera = self.get_node("body_0/Camera2D")

	gun = self.get_node("body_0/Gun")

	coin_value = get_tree().root.get_node("exploration/CanvasLayer/CoinValue")
	
	#################
	# SETUPING GUUUUN
	#################
	var path = ""
	match game_state.GunTier:
		1:
			path = "res://sprites/gun/basic.png"
			LASER_COOLDOWN  *= 2.0
			LASER_CONSUMPTION *= 1.8
		2:
			path = "res://sprites/gun/standard.png"
			LASER_COOLDOWN  *= 1.0
			LASER_CONSUMPTION *= 0.9
		3:
			path = "res://sprites/gun/advanced.png"
			LASER_COOLDOWN  *= 0.5
			LASER_CONSUMPTION *= 0.5
	
	print("game_state.GunTier:", game_state.GunTier)
	
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.create_from_image(img)
	gun.texture = tex

func _physics_process(delta: float) -> void:
	if kaput == true:
		return
		
	# Update gravity based on height
	var height = -self.position.y
	body.gravity_scale = 1.0 - (height / 6000000)

	# Music sync
	var is_on_beat = false
	var playback_position = music_sound.get_playback_position()
	var time_since_last_mix = AudioServer.get_time_since_last_mix()
	var elapsed_beats = (playback_position + time_since_last_mix + music_offset_seconds) * (bpm / 60.0)
	var fraction_of_current_beat = elapsed_beats - int(elapsed_beats)
	if fraction_of_current_beat < 0.5:
		if not processed_beat:
			is_on_beat = true
			processed_beat = true
	elif processed_beat:
		processed_beat = false

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

	var impulse = Vector2.UP * THRUSTER_IMPULSE;

	var angular_velocity = body.angular_velocity

	if abs(angular_velocity) > 3.14 * 3:
		explode_rocket()

	if laser_cooldown > 0.0:
		laser_cooldown -= delta

	if Input.is_action_pressed("thruster_side_1") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(side_thruster_left.transform.get_rotation()) / 10.0
		side_thruster_left.apply_force(local_impulse)
		side_thruster_left_sprite.play("thrusting")
		fuel_level -= SIDE_THRUSTER_COMSUMPTION
		if not small_thruster_sound_left.playing:
			small_thruster_sound_left.play()
	else:
		side_thruster_left_sprite.play("idle")
		small_thruster_sound_left.stop()

	if Input.is_action_pressed("thruster_side_0") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(side_thruster_right.transform.get_rotation()) / 10.0
		side_thruster_right.apply_force(local_impulse)
		side_thruster_right_sprite.play("thrusting")
		fuel_level -= SIDE_THRUSTER_COMSUMPTION
		if not small_thruster_sound_right.playing:
			small_thruster_sound_right.play()
	else:
		side_thruster_right_sprite.play("idle")
		small_thruster_sound_right.stop()

	if Input.is_action_pressed("thruster_0") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(thruster_left.transform.get_rotation())
		thruster_left.apply_force(local_impulse)
		thruster_left_sprite.play("thrusting")
		if not thruster_sound_left.playing:
			thruster_sound_left.play()
		fuel_level -= MAIN_THRUSTER_COMSUMPTION
	else:
		thruster_left_sprite.play("idle")
		thruster_sound_left.stop()

	if Input.is_action_pressed("thruster_1") and fuel_level > 0.0:
		var local_impulse = impulse.rotated(thruster_right.transform.get_rotation())
		thruster_right.apply_force(local_impulse)
		thruster_right_sprite.play("thrusting")
		if not thruster_sound_right.playing:
			thruster_sound_right.play()
		fuel_level -= MAIN_THRUSTER_COMSUMPTION
	else:
		thruster_right_sprite.play("idle")
		thruster_sound_right.stop()

	if Input.is_action_pressed("fire") and battery_level > 0.0 and (is_on_beat or not laser_fired) and laser_cooldown <= 0.0:
		laser_fired = true
		battery_level -= LASER_CONSUMPTION

		laser_cooldown = LASER_COOLDOWN

		var space_state = get_tree().root.world_2d.direct_space_state

		if nearest_obstacle != null and nearest_obstacle.global_position.distance_to(body.global_position) < LASER_RANGE:
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
					var number = randi_range(1, 4)
					var coin_prefab = get_tree().root.get_node("exploration/Coin")
					for i in range(number):
						var coin = coin_prefab.duplicate()
						coin.moving = true
						coin.position = result.collider.global_position
						coin.position += Vector2(randf_range(-60.0, 60.0), randf_range(-60.0, 60.0))
						get_tree().root.add_child(coin)

	else:
		if not Input.is_action_pressed("fire"):
			laser_fired = false

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
			await RenderingServer.frame_post_draw
			crash_texture = get_viewport().get_texture().get_image()
			photo_taken = true
		elif time_elapsed >= 3.6:
			spawned_newspaper = true
			
			# save result to file
			var file_write = FileAccess.open("./save_file.data", FileAccess.WRITE)
			var dico = inst_to_dict(game_state)
			file_write.store_string(JSON.stringify(dico))
			file_write.close()
			print("saving: ", JSON.stringify(dico))

			var newspaper = load("res://newspaper.tscn").instantiate()
			newspaper.position = camera.global_position
			get_tree().root.get_node("exploration").add_child(newspaper)

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
			camera.reparent(get_tree().root.get_node("exploration"))

			# hide UI because it's useless now
			get_tree().root.get_node("exploration/CanvasLayer").visible = false

			# clicking to "Suite" relaunch this scene
			# TODO: should launch editor

			# end "die sound"
			die_sound.stop()

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
	side_thruster_left_sprite.play("idle")
	side_thruster_right_sprite.play("idle")

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

func _on_coin_coin_grabbed() -> void:
	coin_count += 1
	game_state.Coins += 1
	coin_sound.play()
	coin_value.text = str(coin_count)
