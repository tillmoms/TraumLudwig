extends StaticBody2D

# Wahrscheinlichkeit, dass es eine Laterne wird
@export var lantern_chance: float = 0.25

var player: Node2D

const MIN_SCALE = 0.0
const MAX_SCALE = 1.5

# NEU: Fluchtpunkt-Variablen
var target_x: float = 0.0   # wo das Hindernis am Spieler landen soll
var spawn_y: float = 0.0    # Y-Position beim Spawn (zum Berechnen des Fortschritts)


func _ready():
	add_to_group("obstacle")
	player = get_tree().get_first_node_in_group("player")
	
	# Erst mal ALLES verstecken
	$Stein1.visible = false
	$Stein2.visible = false
	$Stein3.visible = false
	$Laterne.visible = false
	
	$Stein1_Collision.disabled = true
	$Stein2_Collision.disabled = true
	$Stein3_Collision.disabled = true
	$LaterneCollision.disabled = true
	
	if randf() < lantern_chance:
		# Laterne
		$Laterne.visible = true
		$LaterneCollision.disabled = false
	else:
		# Einer der drei Steine
		var stein_nummer = randi_range(1, 3)
		if stein_nummer == 1:
			$Stein1.visible = true
			$Stein1_Collision.disabled = false
		elif stein_nummer == 2:
			$Stein2.visible = true
			$Stein2_Collision.disabled = false
		else:
			$Stein3.visible = true
			$Stein3_Collision.disabled = false


func _process(delta):
	if player == null:
		return
	
	# Wenn hinter Spieler: löschen
	if global_position.y > player.global_position.y + 600:
		queue_free()
		return

	update_scale()


func update_scale():
	if player == null:
		return
	
	var distance = global_position.y - player.global_position.y
	# t: 0.0 = ganz weit weg (am Fluchtpunkt), 1.0 = beim Spieler
	var t = clamp((distance + 800.0) / 800.0, 0.1, 1.0)
	
	# Skalierung
	var new_scale = lerp(MIN_SCALE, MAX_SCALE, t)
	scale = Vector2(new_scale, new_scale)
	
	# NEU: X-Position vom Fluchtpunkt (0) zur target_x interpolieren
	global_position.x = lerp(0.0, target_x, t)
	
	var distance_from_player = global_position.y - player.global_position.y
	z_index = int(1000 + distance_from_player + new_scale * 100)
