extends Node

enum MovementFunction {
	STATIC,
	SINE,
	LINEAR
}

enum Variable {
	X,
	Y,
	ANGLE
}

# Used for SINE
@export var amplitude: float = 10.0
@export var period: float = 5.0

# Used for LINEAR
@export var velocity: float = 1.0 # Units per second

@export var variable := Variable.Y
@export var movement_function := MovementFunction.STATIC

@onready var target := self.get_parent()
@onready var base_value : float = get_variable()

func get_variable() -> float:
	match variable:
		Variable.X:
			return target.position.x
		Variable.Y:
			return target.position.y
		Variable.ANGLE:
			return target.rotation
		_:
			return 0.0

func set_variable(value: float) -> void:
	match variable:
		Variable.X:
			target.position.x = value
		Variable.Y:
			target.position.y = value
		Variable.ANGLE:
			target.rotation = value

func _physics_process(delta: float) -> void:

	match movement_function:
		MovementFunction.SINE:
			var delta_value = amplitude * sin(2 * PI * (1 / period) * (Time.get_ticks_usec() / 1000000.0))
			set_variable(base_value + delta_value)
		MovementFunction.LINEAR:
			set_variable(get_variable() + velocity * delta)
