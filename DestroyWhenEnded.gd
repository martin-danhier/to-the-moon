extends AnimatedSprite2D

var counter = 0

func _on_animation_finished() -> void:
	self.queue_free()


func _on_animation_looped() -> void:
	self.queue_free()
