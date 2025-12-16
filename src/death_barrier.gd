extends Area3D
#
#@onready var you_win: AnimatedSprite2D = $"../ConditionLabel/YouWin"
#@onready var you_lose: AnimatedSprite2D = $"../ConditionLabel/YouLose"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body:Node3D) -> void:
	if body.is_in_group("player"):
		body.queue_free()
		var you_lose = get_node("../LoseScreen/YouLose")
		you_lose.show_lose_text()
		you_lose.play()
		
	if body.is_in_group("npc"):
		body.queue_free()
		var you_win = get_node("../WinScreen/YouWin")
		you_win.show_win_text()
		you_win.play()
		
	#if body.is_in_group("npc"):
		#print("npc ded")
		#body.queue_free()
		#you_win.position = Vector2(get_viewport().size / 2)
		#you_win.visible = true
		#you_win.play()
		#print("YouWin visible: ", you_win.visible)
		#print("YouWin position: ", you_win.position)
	#
	if body.is_in_group("ball"):
	#if body.name =="RigidBody":
		await get_tree().create_timer(1.0).timeout
		get_parent().spawn_new_ball()
		if body:
			body.queue_free()
	
