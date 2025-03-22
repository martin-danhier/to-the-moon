extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var headline: Label = $WrittenPaperNoBackground/Headline
@onready var texture_rect: TextureRect = $WrittenPaperNoBackground/TextureRect
@onready var infos: Label = $WrittenPaperNoBackground/Infos
@onready var button: Button = $WrittenPaperNoBackground/Button

func _ready():
	var altitude = 1000
	var time = 720
	
	button.pressed.connect(_button_pressed)
	
	animation_player.play("new_animation")
	
	var head_to_get = randi() % 5
	var file = FileAccess.open("res://newspaper_headlines/" + str(head_to_get) + ".txt", FileAccess.READ)
	headline.text = file.get_as_text()
	
	infos.text = "Altitude atteinte: " + str(altitude) + "m in " + str(time) + " s"
	
	texture_rect.texture = get_viewport().get_texture()

func _button_pressed():
	get_tree().quit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
