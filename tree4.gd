extends StaticBody2D

@export var tree_textures: Array [Texture2D] = []
var player: Node2D
var is_wall_tree: bool = false
var side: int = 1


const MIN_SCALE = 0.1
const MAX_SCALE = 1.0

func _ready():
	# Sofort unsichtbar bis erste Position/Scale berechnet ist
	visible = false
	
	player = get_tree().get_first_node_in_group("player")

	if tree_textures.size() > 0:
		$Sprite2D.texture = tree_textures[randi() % tree_textures.size()]
	
	# Direkt einmal updaten, damit Position/Scale stimmen bevor gezeichnet wird
	_update_tree(0.0)
	visible = true

func _process(delta):
	_update_tree(delta)

func _update_tree(_delta):
	if player == null:
		return
	
	if global_position.y > player.global_position.y + 600:
		queue_free()
		return
	
	var distance = global_position.y - player.global_position.y
	var t = clamp(1.0 + (distance / 740.0), 0.0, 1.0)
	
	# Scale
	var new_scale = lerp(MIN_SCALE, MAX_SCALE, t)
	scale = Vector2(new_scale, new_scale)
	z_index = int(global_position.y + new_scale * 100)
	
	# Fluchtpunkt nur für Wand-Bäume
	if is_wall_tree:
		var target_x = side * lerp(5.0, 850.0, t)
		global_position.x = target_x
