extends Node2D

@export var moon_y = 40000

@onready var rocket: RigidBody2D = get_node("/root/exploration/Rocket/body_0")
@onready var thrusterL: RigidBody2D = get_node("/root/exploration/Rocket/thruster_left")
@onready var thrusterR: RigidBody2D = get_node("/root/exploration/Rocket/thruster_right")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = rocket.global_position.x
	position.y = -moon_y # + (1-moon_y_scroll) * (rocket.global_position.y - moon_y)
	
	print(rocket.global_position.y - position.y)
	if rocket.global_position.y - position.y < 120:
		#rocket.freeze = true
		pass # transition to newspaper scene
	
	elif rocket.global_position.y - position.y < 700:
		#rocket.freeze = true
		if abs(rocket.rotation) < 3.1:
			rocket.rotation += sign(rocket.rotation) * 0.008
		rocket.global_position.y -= 1
	elif rocket.global_position.y - position.y < 1000:
		rocket.freeze = true
		thrusterL.linear_velocity = Vector2(0,0)
		thrusterR.linear_velocity = Vector2(0,0)
		rocket.global_position.y -= 1
		#slow_down()
	
	

func slow_down():
	print(rocket.linear_velocity)
	rocket.apply_central_force(-rocket.linear_velocity * 100)
	
	
	
	#if abs(rocket.linear_velocity.y) > 20:
		#rocket.linear_velocity *= 0.9
		
	#if rocket.linear_damp < 1:
		#print('slow')
		#rocket.linear_damp += 0.1
