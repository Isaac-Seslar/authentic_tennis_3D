extends WorldEnvironment

@export var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_new_ball():
	var new_ball = ball_scene.instantiate()
	add_child(new_ball)
	new_ball.global_position = Vector3(5, 14, 0)
