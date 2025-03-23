extends Node

var screen = DisplayServer.screen_get_size()

@onready var rocket_body: RigidBody2D = get_node("/root/exploration/Rocket/body_0")
@onready var obstacle_container = get_node("/root/exploration/ObstacleInstantiator/obstacle_container")
@onready var alert_container = get_node("alert_container")
@onready var alert_scene = preload("res://alert.tscn")
@onready var camera = get_viewport().get_camera_2d()

var active_alerts = {}

func _process(delta: float) -> void:
	check_alerts()

func check_alerts():
	var rocket_pos = rocket_body.global_position
	
	for obstacle in obstacle_container.get_children():
		var obstacle_pos = obstacle.position
		
		if obstacle.is_in_group("ignored"):
			continue
		
		var dx = abs(obstacle_pos.x - rocket_pos.x)
		var dy = -(obstacle_pos.y - rocket_pos.y)
		if dx < 1500 and dy < 2500 and dy > 800: # set obstacle detection range
			var alert
			if obstacle not in active_alerts:
				alert = alert_scene.instantiate()
				alert_container.add_child(alert)
				active_alerts[obstacle] = alert
			else:
				alert = active_alerts[obstacle]
			
			var x = obstacle_pos.x
			var y = camera.get_screen_center_position().y - 630 # set alert position
			
			alert.position = Vector2(x, y)
		elif obstacle in active_alerts:
			active_alerts[obstacle].queue_free()
			active_alerts.erase(obstacle)
