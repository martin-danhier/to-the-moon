extends Node2D

@onready var thruster_left : RigidBody2D = get_node("/root/Editor/Rocket/thruster_left")
@onready var thruster_right : RigidBody2D = get_node("/root/exploration/Rocket/thruster_right")
@onready var side_thruster_left : RigidBody2D = get_node("/root/exploration/Rocket/side_thruster_left")
@onready var side_thruster_right : RigidBody2D = get_node("/root/exploration/Rocket/side_thruster_right")
@onready var body: RigidBody2D = get_node("/root/exploration/Rocket/body_0")

@onready var thruster_left_sprite : AnimatedSprite2D = get_node("/root/exploration/Rocket/thruster_left/AnimatedSprite2D")
@onready var thruster_right_sprite : AnimatedSprite2D = get_node("/root/exploration/Rocket/thruster_right/AnimatedSprite2D")
@onready var side_thruster_left_sprite : AnimatedSprite2D = get_node("/root/exploration/Rocket/side_thruster_left/AnimatedSprite2D")
@onready var side_thruster_right_sprite : AnimatedSprite2D = get_node("/root/exploration/Rocket/side_thruster_right/AnimatedSprite2D")

@onready var thruster_sound_left : AudioStreamPlayer = get_node("/root/exploration/Rocket/thruster_sound_left/")
@onready var thruster_sound_right : AudioStreamPlayer = get_node("/root/exploration/Rocket/thruster_sound_right/")
@onready var small_thruster_sound_left : AudioStreamPlayer = get_node("/root/exploration/Rocket/small_thruster_sound_left/")
@onready var small_thruster_sound_right : AudioStreamPlayer = get_node("/root/exploration/Rocket/small_thruster_sound_right/")
@onready var laser_sound : AudioStreamPlayer = get_node("/root/exploration/Rocket/laser_sound/")
@onready var small_explosion_sound: AudioStreamPlayer = get_node("/root/exploration/Rocket/small_explosion_sound/")
@onready var large_explosion_sound: AudioStreamPlayer = get_node("/root/exploration/Rocket/large_explosion_sound/")

#@onready var thruster_side_1 = InputMap.action_get_events("thruster_side_1")[0]
#@onready var thruster_side_0 = InputMap.action_get_events("thruster_side_0")[0]
#@onready var thruster_0 = InputMap.action_get_events("thruster_0")[0]
#@onready var thruster_1 = InputMap.action_get_events("thruster_1")[0]
#@onready var fire = InputMap.action_get_events("fire")[0]
##
##

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("thruster_side_1"):
		side_thruster_left_sprite.play("thrusting")
		if not small_thruster_sound_left.playing:
			small_thruster_sound_left.play()
	else:
		side_thruster_left_sprite.play("idle")
		small_thruster_sound_left.stop()

	if Input.is_action_pressed("thruster_side_0"):
		side_thruster_right_sprite.play("thrusting")
		if not small_thruster_sound_right.playing:
			small_thruster_sound_right.play()
	else:
		side_thruster_right_sprite.play("idle")
		small_thruster_sound_right.stop()

	if Input.is_action_pressed("thruster_0"):
		thruster_left_sprite.play("thrusting")
		if not thruster_sound_left.playing:
			thruster_sound_left.play()
	else:
		thruster_left_sprite.play("idle")
		thruster_sound_left.stop()

	if Input.is_action_pressed("thruster_1"):
		thruster_right_sprite.play("thrusting")
		if not thruster_sound_right.playing:
			thruster_sound_right.play()
	else:
		thruster_right_sprite.play("idle")
		thruster_sound_right.stop()

	if Input.is_action_pressed("fire"):
		laser_sound.play()
