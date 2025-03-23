extends Button

@onready var rocket: Node2D = $"../../Rocket"
@onready var gun: TextureButton = $"../Gun"
@onready var body: TextureButton = $"../Body"
@onready var thruster: TextureButton = $"../Thruster"
@onready var thruster_2: TextureButton = $"../Thruster2"
@onready var basic: Button = $"../Basic"
@onready var standard: Button = $"../Standard"
@onready var advanced: Button = $"../Advanced"
@onready var b_coin: TextureRect = $"../Basic/Coin"
@onready var b_price: Label = $"../Basic/Price"
@onready var s_coin: TextureRect = $"../Standard/Coin"
@onready var s_price: Label = $"../Standard/Price"
@onready var a_coin: TextureRect = $"../Advanced/Coin"
@onready var a_price: Label = $"../Advanced/Price"
@onready var coin_counter: Label = $"../../Missions/CoinValue"

var parts = ["Coiffe", "Propulseurs", "Propulseurs secondaires", "Corps", "Canon laser"]
var upgrade = [" basique", " standard", " avancé"]
var current
var current_name = ""

class SomewhatGameState:
	var Coins: int = 0
	var Fame: int = 0
	
	var GunTier: int = 1
	var ThrusterTier: int = 1
	var FuelTier: int = 1
	
var game_state : SomewhatGameState

func _ready() -> void:
	gun.pressed.connect(gun_shop)
	body.pressed.connect(body_shop)
	thruster.pressed.connect(thruster_shop)
	thruster_2.pressed.connect(thruster_shop)
	basic.pressed.connect(basic_purchase)
	standard.pressed.connect(standard_purchase)
	advanced.pressed.connect(advanced_purchase)
	if int(coin_counter.text) >= 10:
		b_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
	else:
		b_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))
	
	if int(coin_counter.text) >= 30:
		s_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
	else:
		s_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))
		
	if int(coin_counter.text) >= 100:
		a_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
	else:
		a_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))
	
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
	var gun : Sprite2D = get_tree().root.get_node("Editor/Rocket/body_0/Gun")
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
	
func gun_shop():
	var p = parts[4]
	basic.text = p + upgrade[0]
	standard.text = p + upgrade[1]
	advanced.text = p + upgrade[2]
	b_coin.visible = true
	b_price.visible = true
	s_coin.visible = true
	s_price.visible = true
	a_coin.visible = true
	a_price.visible = true
	current = [rocket.get_node("body_0/Gun")]
	current_name = "gun.png"
	
	
func body_shop():
	var p = parts[3]
	basic.text = p + upgrade[0]
	standard.text = p + upgrade[1]
	advanced.text = p + upgrade[2]
	b_coin.visible = true
	b_price.visible = true
	s_coin.visible = true
	s_price.visible = true
	a_coin.visible = true
	a_price.visible = true
	current = [rocket.get_node("body_0/Sprite2D")]
	current_name = "body.png"
	
func thruster_shop():
	var p = parts[1]
	basic.text = p + upgrade[0] + "s"
	standard.text = p + upgrade[1] + "s"
	advanced.text = p + upgrade[2] + "s"
	b_coin.visible = true
	b_price.visible = true
	s_coin.visible = true
	s_price.visible = true
	a_coin.visible = true
	a_price.visible = true
	current = [rocket.get_node("thruster_left/AnimatedSprite2D"), rocket.get_node("thruster_left/AnimatedSprite2D")]
	current_name = "thruster.png"
	
func basic_purchase():
	if current_name != "" :
		var p = int(b_price.text)
		var c = int(coin_counter.text)
		if c >= p :
			coin_counter.text = str(c - p)
			if current_name == "thruster.png" :
				_on_thruster_1_pressed()
			if current_name == "body.png" :
				_on_fuel_1_pressed()
			if current_name == "gun.png" :
				_on_battery_1_pressed()
		if int(coin_counter.text) >= p:
			b_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
		else:
			b_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))
		
func standard_purchase():
	if current_name != "" :
		var p = int(s_price.text)
		var c = int(coin_counter.text)
		if c >= p :
			coin_counter.text = str(c - p)
			if current_name == "thruster.png" :
				_on_thruster_2_pressed()
			if current_name == "body.png" :
				_on_fuel_2_pressed()
			if current_name == "gun.png" :
				_on_battery_2_pressed()
		if int(coin_counter.text) >= p:
			s_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
		else:
			s_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))

func advanced_purchase():
	if current_name != "" :
		var p = int(a_price.text)
		var c = int(coin_counter.text)
		if c >= p :
			coin_counter.text = str(c - p)
			if current_name == "thruster.png" :
				_on_thruster_3_pressed()
			if current_name == "body.png" :
				_on_fuel_3_pressed()
			if current_name == "gun.png" :
				_on_battery_3_pressed()
		if int(coin_counter.text) >= p:
			a_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
		else:
			a_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))
