extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var headline: Label = $Offset/WrittenPaperNoBackground/Headline
@onready var texture_rect: TextureRect = $Offset/WrittenPaperNoBackground/TextureRect
@onready var infos: Label = $Offset/WrittenPaperNoBackground/Infos
@onready var button: Button = $Offset/WrittenPaperNoBackground/Button

var headline_text : String;

func _ready():
	var altitude = 1000
	var time = 720
	
	button.pressed.connect(_button_pressed)
	
	animation_player.play("new_animation")
	
func _set_altitude(altitude_text, time_text):
	infos.text = "Altitude atteinte: " + altitude_text + "m in " + time_text + " s"
	
func _set_headline_text(new_headline_text):
	headline_text = new_headline_text
	headline.text = headline_text

func _button_pressed():
	get_tree().change_scene_to_file("res://editor.tscn") # GODOT is CACA
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
