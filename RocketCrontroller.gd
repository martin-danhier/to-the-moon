extends Node2D

var thruster_left : RigidBody2D
var thruster_right : RigidBody2D
var body : RigidBody2D

var joints: Node2D

func _ready() -> void:
	thruster_left = self.get_node("thruster_left")
	thruster_right = self.get_node("thruster_right")
	body = self.get_node("body_0")
	joints = self.get_node("joints")
	

func _process(delta: float) -> void:
	var impulse = Vector2.UP * 100.0;
	print(body.transform.get_rotation())
	impulse = impulse.rotated(body.transform.get_rotation())
	thruster_left.apply_impulse(impulse)
	thruster_right.apply_impulse(impulse)

func _on_rocket_part_body_entered(body: Node) -> void:
	
	for child in joints.get_children():
		if is_instance_of(child, Joint2D):
			var joint = child as Joint2D
			joint.node_a = ""
			
	
	pass # Replace with function body.
	
