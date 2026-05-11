extends CharacterBody2D

const BASE_SPEED = 400.0
var current_speed = BASE_SPEED
@onready var sprite = $Schlitten
@onready var spur_links = $SpurLinks
@onready var spur_rechts = $SpurRechts

const SPUR_OFFSET_X = 30.0
const SPUR_OFFSET_Y = 27.0
const MAX_SPUR_PUNKTE = 50

const AUTO_CENTER_DISTANCE = 1500.0

var is_crashed = false


func _ready():
	z_index = 3000
	sprite.play("idle")
	spur_links.top_level = true
	spur_rechts.top_level = true


func _physics_process(delta):
	if is_crashed:
		return
	
	velocity.y = -current_speed
	
	# Prüfen ob ein Schloss in der Nähe ist
	var auto_center = false
	var castle = get_tree().get_first_node_in_group("castle")
	if castle != null:
		var distance_to_castle = global_position.y - castle.global_position.y
		if distance_to_castle < AUTO_CENTER_DISTANCE:
			auto_center = true
	
	var target_speed = BASE_SPEED
	if auto_center:
		target_speed = 200.0   # halbe Geschwindigkeit beim Anflug
	current_speed = lerp(current_speed, target_speed, 0.02)
	
	var direction = 0
	if auto_center:
		# Sanft zur Mitte (X = 0) ziehen
		var x_diff = 0.0 - global_position.x
		velocity.x = clamp(x_diff * 3.0, -BASE_SPEED, BASE_SPEED)
	else:
		# Normale Steuerung
		if Input.is_action_pressed("ui_left"):
			direction = -1
		if Input.is_action_pressed("ui_right"):
			direction = 1
		velocity.x = direction * BASE_SPEED
	
	# Animation je nach Richtung
	if direction == -1:
		if sprite.animation != "left":
			sprite.play("left")
	elif direction == 1:
		if sprite.animation != "right":
			sprite.play("right")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
	
	# Schnee-Spuren updaten
	var links_punkt = global_position + Vector2(-SPUR_OFFSET_X, SPUR_OFFSET_Y)
	var rechts_punkt = global_position + Vector2(SPUR_OFFSET_X, SPUR_OFFSET_Y)
	spur_links.add_point(spur_links.to_local(links_punkt))
	spur_rechts.add_point(spur_rechts.to_local(rechts_punkt))
	if spur_links.get_point_count() > MAX_SPUR_PUNKTE:
		spur_links.remove_point(0)
	if spur_rechts.get_point_count() > MAX_SPUR_PUNKTE:
		spur_rechts.remove_point(0)
	
	move_and_slide()
	
	# Kollisions-Check
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("obstacle"):
			crash()
			break


func crash():
	if is_crashed:
		return
	is_crashed = true
	sprite.play("crash")
	
	# 1.5 Sekunden warten
	await get_tree().create_timer(1.5).timeout
	
	# Hindernisse aufm Bildschirm wegräumen
	for obs in get_tree().get_nodes_in_group("obstacle"):
		obs.queue_free()
	
	is_crashed = false
	sprite.play("idle")
