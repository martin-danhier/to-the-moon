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

@export var variable := Variable.Y
@export var movement_function := MovementFunction.STATIC

# Used for SINE
@export var amplitude: float = 10.0
@export var period: float = 5.0

# Used for LINEAR
@export var velocity: float = 1.0 # Units per second

@onready var target := self.get_parent()
@onready var base_value : float = get_variable()
@onready var random_phase : float = randf_range(0.0, period)


func _ready() -> void:
	var random_period_modifier : float = randf_range(0.0, period / 10.0)
	var random_amplitude_modifier : float = randf_range(0.0, amplitude / 10.0)
	var random_velocity_modifier: float = randf_range(0.0, velocity / 10.0)
	
	amplitude += random_amplitude_modifier
	period += random_period_modifier
	velocity += random_velocity_modifier

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
			var delta_value = amplitude * sin(2 * PI * (1 / period) * ((Time.get_ticks_usec() / 1000000.0) + random_phase))
			set_variable(base_value + delta_value)
		MovementFunction.LINEAR:
			set_variable(get_variable() + velocity * delta)
