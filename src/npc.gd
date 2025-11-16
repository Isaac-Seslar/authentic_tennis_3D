extends CharacterBody3D


const SPEED = 7.0
const AI_SKILL = 1.0
const JUMP_VELOCITY = 6.5
const SWING_ROTATION = 65
const SWING_SPEED = 0.2
const ARRIVAL_THRESH: = 1.0
const SWING_DISTANCE = 3.0
#cost SWING_RETURN = -

@onready var arm_pivot: CharacterBody3D = $ArmPivot

var is_swinging = false

func _ready() -> void:
	arm_pivot.rotation_degrees.x = 45
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	_character_movement()
	move_and_slide()
		
func _predict_ball_landing(ball: RigidBody3D) -> Vector3:
	var ball_velocity = ball.linear_velocity
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(
		ball.global_position,
		ball.global_position + ball_velocity.normalized() * 1000
	)
	var result = space_state.intersect_ray(query)
	var predic_pos
	if result:
		predic_pos = result.position
	else:
		predic_pos = ball.global_position + velocity.normalized() * 1000
		
	var max_error = 100.0 * (1.0 - AI_SKILL)
	var error = Vector3(
		randf_range(-max_error, max_error),
		randf_range(-max_error,max_error),
		randf_range(-max_error,max_error)
	)
	return predic_pos + error
	
func _character_movement() -> void:
	var ball = get_node("../ball")
	var x_landing_position = _predict_ball_landing(ball).x
	var z_landing_postion = _predict_ball_landing(ball).z
	#var linear_distance = sqrt(x_landing_position*x_landing_position + z_landing_postion*z_landing_postion)
	var distance_to_ball = global_position.distance_to(ball.global_position)
	
	print(distance_to_ball)
	
	if distance_to_ball > ARRIVAL_THRESH:
		if position.x < x_landing_position:
			velocity.x = SPEED
		else:
			velocity.x = -SPEED
		if position.z < z_landing_postion:
			velocity.z = SPEED
		else:
			velocity.z = -SPEED	
			
	if distance_to_ball <= SWING_DISTANCE:
		print("swing")
		swing_racket()
	
func swing_racket() -> void:
	var tween = create_tween()
	
	tween.tween_property(arm_pivot, "rotation_degrees:x", -SWING_ROTATION, SWING_SPEED)
	tween.tween_interval(0.1)
	tween.tween_property(arm_pivot, "rotation_degrees:x", SWING_ROTATION, SWING_SPEED)
	tween.tween_interval(0.1)
	
	tween.finished.connect(func(): is_swinging = false)
