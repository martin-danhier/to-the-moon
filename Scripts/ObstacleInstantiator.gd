extends Node

@export var min_distance = 17500.0
@export var max_distance = 50000.0
@export var spawn_box_size = 1000.0
@export var base_probability = 0.04

@onready var rocket_body: RigidBody2D = get_node("/root/exploration/Rocket/body_0")
@onready var obstacle_container = get_node("obstacle_container")

class ObstacleDefinition:
	var mean: float
	var std: float
	var scene: Resource

	func _init(mean: float, std: float, scene: Resource):
		self.mean = mean
		self.std = std
		self.scene = scene

	func prob(height: float) -> float:
		var coefficient = 1.0 / (std * sqrt(2 * PI))
		var exponent = exp(-((height - mean) * (height - mean)) / (2 * std * std))
		return coefficient * exponent

	func instantiate() -> Node2D:
		return scene.instantiate()

var obstacle_defs = []

func _ready():
	# Define object types here
	obstacle_defs.push_back(ObstacleDefinition.new(1500.0, 500.0, preload("res://obstacles/obstacle.tscn")))

func _process(delta: float) -> void:
	var obstacle_count = obstacle_container.get_child_count()

	var spawn_probability = 0.0
	if obstacle_count == 0.0:
		spawn_probability = 1.0
	else:
		spawn_probability = (-rocket_body.global_position.y * base_probability)  / (obstacle_count * obstacle_count)

	var sampled = randf()
	if sampled < spawn_probability:
		spawn_obstacle()

func sum(x, acc):
	return x + acc


func spawn_obstacle():
	# Find where the rocket is pointing at
	var direction = rocket_body.linear_velocity.normalized()
	# Determine a position for the new object
	var distance = randf_range(min_distance, max_distance)

	var target: Vector2 = rocket_body.global_position + distance * direction

	if target.y > 0.0:
		return

	# Choose a point around the target
	target.x += randf_range(-spawn_box_size, spawn_box_size)
	target.y += randf_range(-spawn_box_size, spawn_box_size)

	var height = -target.y

	var probs = []
	for obstacle_def in obstacle_defs:
		probs.push_back(obstacle_def.prob(height))
	var total = probs.reduce(sum, 0.0)

	var sample = randf_range(0.0, total)

	for i in range(0, probs.size()):
		if sample < probs[i]:
			# Spawn this one
			var obstacle = obstacle_defs[i].instantiate()
			obstacle.global_position = target;
			obstacle_container.add_child(obstacle)
			break
		else:
			# Not this one, try the next one
			sample -= probs[i]


func _on_area_2d_body_exited(body: Node2D) -> void:
	# Cleanup obstacles that are too far
	body.get_parent().call_deferred("queue_free")
