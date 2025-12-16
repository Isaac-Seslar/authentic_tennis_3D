extends AnimatedSprite2D
@onready var lose_button: Button = $"../lose_Button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
func show_lose_text() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	position = get_viewport().size / 4
	lose_button.visible = true
	lose_button.position = Vector2(get_viewport().size / 4) + Vector2(-36,100)
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
