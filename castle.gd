extends Node2D

const TRIGGER_DISTANCE = 800.0  # Abstand bei dem die Tore aufgehen

# Skalierung – gleiche Regeln wie bei den anderen Objekten
const MIN_SCALE = 0.0
const MAX_SCALE = 1.5
const FLUCHTPUNKT_DISTANCE = 775.0  # gleiche Distanz wie obstacles

var ludwig_passed: bool = false
var gates_opened: bool = false

@onready var sprite = $AnimatedSprite2D

func _ready():
	z_index = 3100
	sprite.play("closed")

func _process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	# Skalierung mit Fluchtpunkt-Regel
	update_scale(player)
	
	# Tor-Öffnung triggern
	if not gates_opened:
		var distance = player.global_position.y - global_position.y
		if distance < TRIGGER_DISTANCE:
			gates_opened = true
			sprite.play("open")
	
	# Hat Ludwig das Schloss schon passiert?
	if gates_opened and not ludwig_passed:
		# Player ist drüber, wenn seine Y kleiner ist als die des Schlosses
		if player.global_position.y < global_position.y - 100:
			ludwig_passed = true
			level_complete()
			
func update_scale(player: Node2D):
	var distance = global_position.y - player.global_position.y
	# t: 0.0 = ganz weit weg, 1.0 = beim Spieler – gleiche Formel wie obstacles.gd
	var t = clamp((distance + FLUCHTPUNKT_DISTANCE) / FLUCHTPUNKT_DISTANCE, 0.0, 1.0)
	
	var t_eased = pow(t,1)   # wächst schnell am Anfang, langsam am Ende
	var new_scale = lerp(MIN_SCALE, MAX_SCALE, t_eased)
	scale = Vector2(new_scale, new_scale)
	
	
func level_complete():
	# HUD finden und Screen anzeigen
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_level_complete()
	
	# Komplettes Spiel pausieren - alles friert ein
	get_tree().paused = true
