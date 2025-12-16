extends AnimatedSprite2D
@onready var win_button: Button = $"../win_button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
func show_win_text() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	position = get_viewport().size / 2
	win_button.position = Vector2(get_viewport().size / 2) + Vector2(-36,100)
	win_button.visible = true
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
