extends CharacterBody2D

@export var player: int = 0
@export var steering_force: float = 5
@export var max_speed: float = 400

var steering: float = 0
var speed: float = 0

func _ready() -> void:
	GameManager.player = self

func _physics_process(delta: float) -> void:
	var steering_input = Input.get_joy_axis(player,JOY_AXIS_LEFT_X)
	var acceleration = Input.get_joy_axis(player,JOY_AXIS_LEFT_Y)
	#steering = steering_input * deg_to_rad(steering)
	
	rotate(steering_input * steering_force * delta)
	speed += acceleration
	velocity = transform.y * (speed)
	move_and_slide()
	#smoothstep(speed,max_speed, )
