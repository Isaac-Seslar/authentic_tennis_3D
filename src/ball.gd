extends RigidBody3D

var bounce_count = 0
var has_exploded = false
var can_count_bounce = true
var suspend_tween: Tween
var just_hit_enemy_side: bool
var just_hit_player_side: bool

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

func _ready():
	#position = Vector3(5, 14, 0)
	body_entered.connect(_on_body_entered)
	add_to_group("ball")
	start_floating()
	
func serve() -> void:
	if suspend_tween:
		print("kill tween")
		suspend_tween.kill()
	freeze = false
	
func start_floating() -> void:
	freeze = true
	suspend_tween = create_tween().set_loops()
	suspend_tween.set_trans(Tween.TRANS_SINE)
	#suspend_tween.tween_callback(self.set_modulate.bind(Color.RED)).set_delay(2)
	#suspend_tween.tween_callback(self.set_modulate.bind(Color.BLUE)).set_delay(2)
	suspend_tween.tween_property(self, "position:y", position.y+0.5, 2)
	suspend_tween.tween_property(self, "position:y", position.y-0.5, 2)

func _on_body_entered(body):
	if has_exploded or !can_count_bounce:
		return
		
	if body.is_in_group("enemy_floor"):
		just_hit_enemy_side = true
		if just_hit_player_side:
			bounce_count=0
			just_hit_player_side = false
		bounce_count+=1
		print("enemy floor")
		if bounce_count == 1:
			await get_tree().create_timer(0.3).timeout
			
		can_count_bounce = true
		if bounce_count >= 2:
			explode()
			
	if body.is_in_group("player_floor"):
		just_hit_player_side = true
		if just_hit_enemy_side:
			bounce_count=0
			just_hit_enemy_side = false
		bounce_count+=1
		print("player_floor")
		if bounce_count == 1:
			await get_tree().create_timer(0.3).timeout
			
		can_count_bounce = true
		if bounce_count >= 2:
			explode()
	
		
		#if body.is_in_group("floor"):
		#bounce_count += 1
		#print("Bounce #", bounce_count)
		#can_count_bounce = false
		#
		#if bounce_count == 1:
			#await get_tree().create_timer(0.3).timeout
		#can_count_bounce = true
		#if bounce_count >= 2:
			#explode()

func explode():
	has_exploded = true
	$MeshInstance3D.visible = false
	gpu_particles_3d.emitting = true
	# Destroy nearby floor pieces
	destroy_floor_at_position(global_position)
	$Explosion_Timer.start()

func destroy_floor_at_position(explosion_pos):
	var radius_error = randf_range(1.0, 1.5)
	var explosion_radius = 2.0 * radius_error
	
	# Find all floor tiles in the scene
	var floor_tiles = get_tree().get_nodes_in_group("floor_tile")
	
	for tile in floor_tiles:
		var distance = tile.global_position.distance_to(explosion_pos)
		if distance < explosion_radius:
			tile.queue_free()  

func _respawn_ball() -> void:
	await get_tree().create_timer(1.0).timeout
	get_parent().spawn_new_ball()
	queue_free()

func _on_explosion_timer_timeout() -> void:
	destroy_floor_at_position(global_position)
	_respawn_ball()	
