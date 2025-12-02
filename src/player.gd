extends CharacterBody3D


#const SPEED = 5.0
#const DASH_SPEED = 5.0
const JUMP_VELOCITY = 5.0
const SWING_ROTATION = 65
const SWING_SPEED = 0.2
#cost SWING_RETURN = -

@onready var arm_pivot: CharacterBody3D = $ArmPivot
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $Camera3D

@export var tilt_limit = deg_to_rad(75)

var is_swinging = false
var mouse_sensitivity: float = 0.002
var camera_x_rotation: float = 0.0
var jumps: int = 0
var normal_speed := 5.0
var boost_speed := 20.0
var max_speed := normal_speed

func _ready() -> void:
	arm_pivot.rotation_degrees.x = 45
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing") and not is_swinging:
		swing_racket()
		
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_x_rotation -= event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation, -PI/2, PI/2)
		camera_pivot.rotation.x = camera_x_rotation


		
func swing_racket() -> void:
	var tween = create_tween()
	
	tween.tween_property(arm_pivot, "rotation_degrees:x", -SWING_ROTATION, SWING_SPEED)
	tween.tween_interval(0.1)
	tween.tween_property(arm_pivot, "rotation_degrees:x", SWING_ROTATION, SWING_SPEED)
	
	tween.finished.connect(func(): is_swinging = false)
	

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumps=0
	else:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumps+=1
		print("SINGLE JUMP")
	elif Input.is_action_just_pressed("jump") and jumps<2 and not is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumps+=1
	elif Input.is_action_just_pressed("jump") and jumps>=2:
		pass
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if Input.is_action_just_pressed("dash"):
			max_speed = boost_speed
			$DashTimer.start()
		#else:
			#dash = 0.0
			
		velocity.z = direction.z * max_speed
		velocity.x = direction.x * max_speed
		#print(velocity.x)
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)
		velocity.z = move_toward(velocity.z, 0, max_speed)

	move_and_slide()

func _on_dash_timer_timeout() -> void:
	max_speed = normal_speed
	print("cooldown")
	
	
