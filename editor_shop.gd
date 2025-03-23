extends Sprite2D

@onready var gun: TextureButton = $Gun
@onready var head: TextureButton = $Head
@onready var mini_thruster: TextureButton = $Mini_thruster
@onready var mini_thruster_2: TextureButton = $Mini_thruster2
@onready var body: TextureButton = $Body
@onready var thruster: TextureButton = $Thruster
@onready var thruster_2: TextureButton = $Thruster2
@onready var basic: Button = $Basic
@onready var standard: Button = $Standard
@onready var advanced: Button = $Advanced
@onready var b_coin: TextureRect = $Basic/Coin
@onready var b_price: Label = $Basic/Price
@onready var s_coin: TextureRect = $Standard/Coin
@onready var s_price: Label = $Standard/Price
@onready var a_coin: TextureRect = $Advanced/Coin
@onready var a_price: Label = $Advanced/Price
@onready var coin_counter: Label = $"../Missions/coin_counter"

var parts = ["Coiffe", "Propulseurs", "Propulseurs secondaires", "Corps", "Canon laser"]
var upgrade = [" basique", " standard", " avancé"]

func _ready() -> void:
	gun.pressed.connect(gun_shop)
	head.pressed.connect(head_shop)
	mini_thruster.pressed.connect(minit_shop)
	mini_thruster_2.pressed.connect(minit_shop)
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
	
func head_shop():
	var p = parts[0]
	basic.text = p + upgrade[0]
	standard.text = p + upgrade[1]
	advanced.text = p + upgrade[2] + "e"
	b_coin.visible = true
	b_price.visible = true
	s_coin.visible = true
	s_price.visible = true
	a_coin.visible = true
	a_price.visible = true
	
func minit_shop():
	var p = parts[2]
	basic.text = p + upgrade[0] + "s"
	standard.text = p + upgrade[1] + "s"
	advanced.text = p + upgrade[2] + "s"
	b_coin.visible = true
	b_price.visible = true
	s_coin.visible = true
	s_price.visible = true
	a_coin.visible = true
	a_price.visible = true
	
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
	
func basic_purchase():
	var p = int(b_price.text)
	var c = int(coin_counter.text)
	if c >= p :
		coin_counter.text = str(c - p)
	if int(coin_counter.text) >= p:
		b_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
	else:
		b_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))
		
func standard_purchase():
	var p = int(s_price.text)
	var c = int(coin_counter.text)
	if c >= p :
		coin_counter.text = str(c - p)
	if int(coin_counter.text) >= p:
		s_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
	else:
		s_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))

func advanced_purchase():
	var p = int(a_price.text)
	var c = int(coin_counter.text)
	if c >= p :
		coin_counter.text = str(c - p)
	if int(coin_counter.text) >= p:
		a_price.add_theme_color_override("font_color", Color(0.1, 0.75, 0.1))
	else:
		a_price.add_theme_color_override("font_color", Color(0.75, 0.1, 0.1))
