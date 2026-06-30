extends CharacterBody2D

@export var speed: float = 200.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	move_and_slide()
	_update_animation(dir)

func _update_animation(dir: Vector2):
	if dir == Vector2.ZERO:
		anim.stop()  # steht still -> Animation pausiert
		return

	# Stärkere Achse entscheidet, welche Richtung gezeigt wird
	if abs(dir.x) > abs(dir.y):
		anim.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		anim.play("walk_down" if dir.y > 0 else "walk_up")
