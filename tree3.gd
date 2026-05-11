extends StaticBody2D

@export var tree_textures: Array [Texture2D] = []
var player: Node2D
var is_wall_tree: bool = false
var side: int = 1


const MIN_SCALE = 0.00
const MAX_SCALE = 1.0

func init_tree():
	if player == null:
		player = get_tree().get_first_node_in_group("player")

	var distance = global_position.y - player.global_position.y
	var t = clamp(1.0 + (distance / 740.0), 0.0, 1.0)

	var new_scale = lerp(MIN_SCALE, MAX_SCALE, t)
	scale = Vector2(new_scale, new_scale)
	z_index = int(t*1000)
	
	if is_wall_tree:
		var target_x = side * lerp(10.0, 850.0, t)
		global_position.x = target_x

func _ready():
	player = get_tree().get_first_node_in_group("player")

	if tree_textures.size() > 0:
		$Sprite2D.texture = tree_textures[randi() % tree_textures.size()]
		
func _process(delta):
	if player == null:
		return
	
	if global_position.y > player.global_position.y + 300:
		queue_free()
		return
	
	# Einblenden basierend auf Distanz
	
	var distance = global_position.y - player.global_position.y
	var t = clamp(1.0 + (distance / 740.0), 0.0, 2.0)
	
	# Scale
	var new_scale = lerp(MIN_SCALE, MAX_SCALE, t)
	scale = Vector2(new_scale, new_scale)
	z_index = int(t*1000)
	# Einblenden basierend auf Distanz
	#modulate.a = clamp(1.0 - (-distance / 200.0), 0.7, 1.0)
	
	# Fluchtpunkt nur für Wand-Bäume
	if is_wall_tree:
		var target_x = side * lerp(10.0, 850.0, t)
		global_position.x = target_x
