extends RigidBody3D

var bounce_count = 0
var has_exploded = false

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

func _ready():
	position = Vector3(5, 14, 0)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if has_exploded:
		return
	
	# Check if we hit the floor
	if body.is_in_group("floor"):
		print("floor")
		bounce_count += 1
		print("Bounce #", bounce_count)
		
		if bounce_count >= 2:
			explode()

func explode():
	has_exploded = true
	$MeshInstance3D.visible = false
	gpu_particles_3d.emitting = true
	# Destroy nearby floor pieces
	destroy_floor_at_position(global_position)
	$Explosion_Timer.start()

func destroy_floor_at_position(explosion_pos):
	var radius_error = randf_range(0.5, 1)
	var explosion_radius = 2.0 * radius_error
	
	# Find all floor tiles in the scene
	var floor_tiles = get_tree().get_nodes_in_group("floor_tile")
	
	for tile in floor_tiles:
		var distance = tile.global_position.distance_to(explosion_pos)
		if distance < explosion_radius:
			tile.queue_free()  
			
func _on_explosion_timer_timeout() -> void:
	destroy_floor_at_position(global_position)
	
	# Tell the main scene to spawn a new ball
	await get_tree().create_timer(1.0).timeout
	get_parent().spawn_new_ball()
	
	queue_free()  # Now safe to delete

#func _on_respawn_timer_timeout() -> void:
	#reset_ball()
	#print("respawn")
