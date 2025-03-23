extends Button

class SomewhatGameState:
	var Coins: int = 0
	var Fame: int = 0
	
	var GunTier: int = 1
	var ThrusterTier: int = 1
	var FuelTier: int = 1
	
var game_state : SomewhatGameState

func _ready() -> void:
	# save config to file
	var file_read = FileAccess.open("./save_file.data", FileAccess.READ)
	if file_read == null:
		print("FIRST TIME PLAYING?")
		var file_write = FileAccess.open("./save_file.data", FileAccess.WRITE)
		game_state = SomewhatGameState.new()
		var dico = inst_to_dict(game_state)
		file_write.store_string(JSON.stringify(dico))
		file_write.close()
	else:
		print("LOADIIINNNGGGG")
		var dico = JSON.new()
		dico.parse(file_read.get_as_text())
		var data = dico.get_data()
		game_state = SomewhatGameState.new()
		game_state.Coins = data["Coins"]
		game_state.Fame = data["Fame"]
		game_state.GunTier = data["GunTier"]
		game_state.ThrusterTier = data["ThrusterTier"]
		game_state.FuelTier = data["FuelTier"]
	
	var coin_value : Label = get_tree().root.get_node("Editor/Missions/CoinValue")
	coin_value.text = str(game_state.Coins)
	
	var path = ""
	match game_state.GunTier:
		1:
			path = "res://sprites/gun/basic.png"
		2:
			path = "res://sprites/gun/standard.png"
		3:
			path = "res://sprites/gun/advanced.png"
	
	print("game_state.GunTier:", game_state.GunTier)
	var gun : Sprite2D = get_tree().root.get_node("Editor/Background/Rocket/body_0/Gun")
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.create_from_image(img)
	gun.texture = tex


func _on_pressed() -> void:
	print("SAVING BEFORE PLAYING?")
	var file_write = FileAccess.open("./save_file.data", FileAccess.WRITE)
	var dico = inst_to_dict(game_state)
	file_write.store_string(JSON.stringify(dico))
	file_write.close()
	
	# then load exploration
	get_tree().change_scene_to_file("res://exploration.tscn")


func _on_fuel_1_pressed() -> void:
	game_state.FuelTier = 1


func _on_fuel_2_pressed() -> void:
	game_state.FuelTier = 2


func _on_fuel_3_pressed() -> void:
	game_state.FuelTier = 3


func _on_battery_1_pressed() -> void:
	game_state.GunTier = 1
	
	var gun : Sprite2D = get_tree().root.get_node("Editor/Background/Rocket/body_0/Gun")
	var img = Image.new()
	img.load("res://sprites/gun/basic.png")
	var tex = ImageTexture.create_from_image(img)
	gun.texture = tex


func _on_battery_2_pressed() -> void:
	game_state.GunTier = 2
	
	var gun : Sprite2D = get_tree().root.get_node("Editor/Background/Rocket/body_0/Gun")
	var img = Image.new()
	img.load("res://sprites/gun/standard.png")
	var tex = ImageTexture.create_from_image(img)
	gun.texture = tex


func _on_battery_3_pressed() -> void:
	game_state.GunTier = 3
	
	var gun : Sprite2D = get_tree().root.get_node("Editor/Background/Rocket/body_0/Gun")
	var img = Image.new()
	img.load("res://sprites/gun/advanced.png")
	var tex = ImageTexture.create_from_image(img)
	gun.texture = tex


func _on_thruster_1_pressed() -> void:
	game_state.ThrusterTier = 1



func _on_thruster_2_pressed() -> void:
	game_state.ThrusterTier = 2


func _on_thruster_3_pressed() -> void:
	game_state.ThrusterTier = 3
