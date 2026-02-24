extends StaticBody2D



var dir = Vector2(0 ,0)

var speed = 400

@export var up = KEY_W
@export var down = KEY_S

func _ready() -> void:
	
	
	
	pass




func _physics_process(delta: float) -> void:
	
	Move(delta)
	
	pass


func Move(delta):
	
	dir = Vector2(0 ,0)
	
	if Input.is_key_pressed(up) and global_position.y > 40:
		dir = Vector2(0, -1)
		
	if Input.is_key_pressed(down) and global_position.y < get_viewport_rect().size.y - 40:
		dir = Vector2(0, 1)
	
	
	
	
	global_position += dir * speed * delta
	pass
