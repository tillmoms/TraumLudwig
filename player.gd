extends CharacterBody2D

const BASE_SPEED = 400.0
var current_speed = BASE_SPEED

func _physics_process(delta):
	velocity.y = -current_speed
	
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	
	velocity.x = direction * BASE_SPEED
	
	move_and_slide()
