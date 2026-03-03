extends RigidBody2D

var speed = 500

var dir = [-1, 1]
var score_p1 = 0
var score_p2 = 0


func _ready() -> void:
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)

	Reset()


func _physics_process(delta: float) -> void:
	Score()
	_prevent_obstacle_tunneling(delta)


func Reset():
	global_position = get_viewport_rect().size /2
	linear_velocity = Vector2.ZERO
	freeze = true

	await get_tree().create_timer(1.5).timeout

	freeze = false
	apply_central_impulse(Vector2(dir.pick_random() * speed, dir.pick_random() * speed))


func Score():
	if global_position.x >= get_viewport_rect().size.x:
		Reset()
		score_p1 += 1
	if global_position.x <= 0:
		Reset()
		score_p2 += 1
	$"../Score".text = str(score_p1) + " : " + str(score_p2)


func _prevent_obstacle_tunneling(delta: float) -> void:
	if freeze or linear_velocity.length_squared() == 0.0:
		return

	var next_position := global_position + linear_velocity * delta
	var query := PhysicsRayQueryParameters2D.create(global_position, next_position)
	query.exclude = [self]

	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return

	var collider = hit.get("collider")
	if collider and collider is StaticBody2D and collider.name == "Obstacle":
		linear_velocity = linear_velocity.bounce(hit.normal)
		global_position = hit.position + hit.normal * 2.0


func _on_body_entered(body: Node) -> void:
	if body.name == "Player" or body.name == "Player2":
		_spawn_sparkles()


func _spawn_sparkles() -> void:
	var sparkles := CPUParticles2D.new()
	sparkles.one_shot = true
	sparkles.emitting = false
	sparkles.amount = 18
	sparkles.lifetime = 0.5
	sparkles.explosiveness = 1.0
	sparkles.randomness = 0.5
	sparkles.direction = Vector2.ZERO
	sparkles.spread = 180.0
	sparkles.initial_velocity_min = 120.0
	sparkles.initial_velocity_max = 220.0
	sparkles.scale_amount_min = 1.0
	sparkles.scale_amount_max = 5.0
	sparkles.color = Color(1.0, 0.454, 0.272, 1.0)
	sparkles.global_position = global_position
	get_tree().current_scene.add_child(sparkles)
	sparkles.emitting = true

	await get_tree().create_timer(0.5).timeout
	sparkles.queue_free()
