extends Node2D

var target : Node2D
var rocket : Node2D

@export var moving = true

var created_time = 0.0

signal coin_grabbed

func _ready() -> void:
	target = get_tree().root.get_node("exploration/Rocket/body_0")
	rocket = get_tree().root.get_node("exploration/Rocket")
	created_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if moving:
		var distance = target.global_position.distance_to(self.global_position)
		
		var age_msec = Time.get_ticks_msec() - created_time
		
		if distance < 120.0:
			self.queue_free()
			coin_grabbed.emit()
			return

		var direction = (target.global_position - self.global_position).normalized()
		self.position += direction * (1.0 + (age_msec / 30.0))
		
