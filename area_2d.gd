extends Area2D

@export var popup: Control  # gleich im Inspector zuweisen

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	popup.hide()

func _on_body_entered(body):
	if body.name == "Ludwig":
		popup.show()

func _on_body_exited(body):
	if body.name == "Ludwig":
		popup.hide()
