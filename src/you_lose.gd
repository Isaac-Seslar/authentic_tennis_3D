extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
func show_lose_text() -> void:
	position = get_viewport().size / 2

	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
