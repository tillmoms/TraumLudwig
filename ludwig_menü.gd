extends Control


func _ready() -> void:
	$ButtonArea/Buttons/BtnStart.pressed.connect(_on_start_pressed)
	$ButtonArea/Buttons/BtnSettings.pressed.connect(_on_settings_pressed)
	$ButtonArea/Buttons/BtnCredits.pressed.connect(_on_credits_pressed)
	$ButtonArea/Buttons/BtnExit.pressed.connect(_on_exit_pressed)
	$SettingsPanel/Inhalt/BtnSettingsClose.pressed.connect(_on_settings_close_pressed)
	$CreditsPanel/Inhalt/BtnCreditClose.pressed.connect(_on_credits_close_pressed)

func _on_start_pressed() -> void:
	
	# Animation start
	$Portrait/KleinLudwig.play("jump")
	# Wenn Animation fertig - Wechsel
	$Portrait/KleinLudwig.animation_finished.connect(_on_jump_animation_finished)

func _on_jump_animation_finished() -> void:
	get_tree().change_scene_to_file("res://Sled_Game.tscn")


func _on_settings_pressed() -> void:
	$SettingsPanel.visible = true

func _on_settings_close_pressed() -> void:
	$SettingsPanel.visible = false

func _on_credits_pressed() -> void:
	$CreditsPanel.visible = true

func _on_credits_close_pressed()-> void:
	$CreditsPanel.visible = false



func _on_exit_pressed() -> void:
	get_tree().quit()
