extends StaticBody2D

var player: Node2D
var is_wall_tree: bool = false
var side: int = 1

const MIN_SCALE = 0.1
const MAX_SCALE = 1.0

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player == null:
		return
	
	if global_position.y > player.global_position.y + 600:
		queue_free()
		return
	
	# Einblenden basierend auf Distanz
	
	
	var distance = global_position.y - player.global_position.y
	var t = clamp(1.0 + (distance / 700.0), 0.0, 1.0)
	
	# Scale
	var new_scale = lerp(MIN_SCALE, MAX_SCALE, t)
	scale = Vector2(new_scale, new_scale)
	
	# Einblenden basierend auf Distanz
	modulate.a = clamp(1.0 - (-distance / 880.0), 0.5, 1.0)
	
	# Fluchtpunkt nur für Wand-Bäume
	if is_wall_tree:
		var target_x = side * lerp(5.0, 850.0, t)
		global_position.x = target_x
