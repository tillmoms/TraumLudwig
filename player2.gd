extends CharacterBody2D

const BASE_SPEED = 400.0
var current_speed = BASE_SPEED
@onready var sprite = $Schlitten
@onready var spur_links = $SpurLinks
@onready var spur_rechts = $SpurRechts

const SPUR_OFFSET_X = 40.0   # Abstand der Spuren von der Mitte (anpassen!)
const SPUR_OFFSET_Y = 49.0   # wo am Schlitten die Spur entsteht (hinten)
const MAX_SPUR_PUNKTE = 50   # wie lang die Spur ist



var is_crashed = false

func _ready():
	z_index = 3000
	sprite.play("idle")
	spur_links.top_level = true
	spur_rechts.top_level = true
	
func _physics_process(delta):
	if is_crashed:
		return  # während Crash keine Bewegung
	
	velocity.y = -current_speed
	
	var direction = 0
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
	if not is_crashed:
		var links_punkt = global_position + Vector2(-SPUR_OFFSET_X, SPUR_OFFSET_Y)
		var rechts_punkt = global_position + Vector2(SPUR_OFFSET_X, SPUR_OFFSET_Y)
		# In lokalen Koordinaten umrechnen (Line2D-Punkte sind relativ zum Node)
		spur_links.add_point(spur_links.to_local(links_punkt))
		spur_rechts.add_point(spur_rechts.to_local(rechts_punkt))
		
		# Alte Punkte entfernen
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
	get_tree().paused = true
	
	# Nach 1.5 Sekunden automatisch neu starten
	var timer = get_tree().create_timer(1.5, true, false, true)
	timer.timeout.connect(_on_crash_finished)

func _on_crash_finished():
	get_tree().paused = false
	get_tree().reload_current_scene()
