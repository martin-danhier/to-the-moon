extends Node2D

@export var moon_y = 100000

@onready var rocket: RigidBody2D = get_node("/root/exploration/Rocket/body_0")
@onready var thrusterL: RigidBody2D = get_node("/root/exploration/Rocket/thruster_left")
@onready var thrusterR: RigidBody2D = get_node("/root/exploration/Rocket/thruster_right")

@onready var camera: Camera2D = get_node("/root/exploration/Rocket/body_0/Camera2D")

var newspaper_loaded = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -moon_y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = rocket.global_position.x
	position.y = -moon_y # + (1-moon_y_scroll) * (rocket.global_position.y - moon_y)

	if rocket.global_position.y - position.y < 50:
		rocket.freeze = true
		if newspaper_loaded < 2.0:
			newspaper_loaded += delta
		elif newspaper_loaded < 100.0:
			newspaper_loaded = 10000.0
			var newspaper = load("res://newspaper.tscn").instantiate()
			newspaper.position = camera.global_position
			get_tree().root.get_node("exploration").add_child(newspaper)

			var hl : Label = get_tree().root.get_node("exploration/newspaper/Offset/WrittenPaperNoBackground/Headline")
			hl.text = "L'impossible a été fait ! Les incrédules disaient \"impossible !\", mais ils ont prouvés le contraire, ils ont marché sur la lune !"

			var infos : Label = get_tree().root.get_node("exploration/newspaper/Offset/WrittenPaperNoBackground/Infos")
			infos.text = ""

			# hide UI because it's useless now
			get_tree().root.get_node("exploration/CanvasLayer").visible = false

	elif rocket.global_position.y - position.y < 700:
		rocket.freeze = true
		if abs(rocket.rotation) < 3.1:
			rocket.rotation += (int(rocket.rotation>0)*2-1) * 0.008
		rocket.global_position.y -= 1
	elif rocket.global_position.y - position.y < 1000:
		rocket.freeze = true
		thrusterL.linear_velocity = Vector2(0,0)
		thrusterR.linear_velocity = Vector2(0,0)
		rocket.global_position.y -= 1
		#slow_down()



func slow_down():
	rocket.apply_central_force(-rocket.linear_velocity * 100)



	#if abs(rocket.linear_velocity.y) > 20:
		#rocket.linear_velocity *= 0.9

	#if rocket.linear_damp < 1:
		#print('slow')
		#rocket.linear_damp += 0.1
