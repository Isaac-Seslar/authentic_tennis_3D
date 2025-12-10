extends WorldEnvironment

@export var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, true)
	
	#var condition_label = $ConditionLabel
	#condition_label.get_parent().remove_child(condition_label)
	#get_tree().root.add_child(condition_label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_new_ball():
	var new_ball = ball_scene.instantiate()
	var entrance_tween = create_tween()
	#entrance_tween.tween_property(new_ball, "position:y", 5, )
	new_ball.global_position = Vector3(5, 5, 0)
	add_child(new_ball)
	
