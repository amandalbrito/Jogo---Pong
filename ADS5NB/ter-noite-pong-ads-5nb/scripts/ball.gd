extends RigidBody2D

var speed = 500

var dir = [-1, 1]
var score_p1 = 0
var score_p2 = 0


func _ready() -> void:
	
	Reset()
	
	pass



func _physics_process(delta: float) -> void: 
	Score()
	
	pass


func Reset():
	global_position = get_viewport_rect().size /2
	freeze = true
	
	await get_tree().create_timer(1.5).timeout
	
	freeze = false
	apply_central_impulse( Vector2( dir.pick_random() * speed , dir.pick_random() * speed ))
	
	
	pass


func Score():
	
	if global_position.x >= get_viewport_rect().size.x:
		Reset()
		score_p1 += 1
	if global_position.x <= 0:
		Reset()
		score_p2 += 1
	$"../Score".text = str(score_p1) + " : " + str(score_p2)
	
	pass
