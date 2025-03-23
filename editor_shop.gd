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
	
func gun_shop():
	var p = parts[4]
	basic.text = p + upgrade[0]
	standard.text = p + upgrade[1]
	advanced.text = p + upgrade[2]
	
func head_shop():
	var p = parts[0]
	basic.text = p + upgrade[0]
	standard.text = p + upgrade[1]
	advanced.text = p + upgrade[2] + "e"
	
func minit_shop():
	var p = parts[2]
	basic.text = p + upgrade[0] + "s"
	standard.text = p + upgrade[1] + "s"
	advanced.text = p + upgrade[2] + "s"
	
func body_shop():
	var p = parts[3]
	basic.text = p + upgrade[0]
	standard.text = p + upgrade[1]
	advanced.text = p + upgrade[2]
	
func thruster_shop():
	var p = parts[1]
	basic.text = p + upgrade[0] + "s"
	standard.text = p + upgrade[1] + "s"
	advanced.text = p + upgrade[2] + "s"
	
