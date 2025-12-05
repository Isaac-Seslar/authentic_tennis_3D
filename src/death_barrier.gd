extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body:Node3D) -> void:
	if body.is_in_group("ball"):
	#if body.name =="RigidBody":
		await get_tree().create_timer(1.0).timeout
		get_parent().spawn_new_ball()
		body.queue_free()
		
		print("new ball!")
		
	print(body.name)
	print(body.is_in_group("ball"))
