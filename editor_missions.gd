extends Sprite2D

@onready var coin_counter: Label = $"../Missions/coin_counter"
@onready var research_counter: Label = $"../Missions/research_counter"
@onready var fame_bar: ProgressBar = $fame_bar
@onready var label: Label = $Missions/Label
@onready var project_1: Label = $"Research_projects/Purchase_1/Project 1"
@onready var project_2: Label = $"Research_projects/Purchase_2/Project 2"
@onready var price_1: Label = $"Research_projects/Purchase_1/Project 1/Price1"
@onready var price_2: Label = $"Research_projects/Purchase_2/Project 2/Price2"
@onready var purchase_1: Button = $Research_projects/Purchase_1
@onready var purchase_2: Button = $Research_projects/Purchase_2

func _ready() -> void:
	purchase_1.pressed.connect(pay_research1)
	purchase_2.pressed.connect(pay_research2)
	
	label.text = FileAccess.open("res://Missions/" + str(randi()%3+1) + ".txt", FileAccess.READ).get_as_text()
	
	var parts = ["Coiffe", "Propulseurs", "Propulseurs secondaires", "Corps", "Canon laser"]
	var part1 = parts[randi()%5]
	var part2 = parts[randi()%5]
	
	var upgrade = [" basique", " standard", " avancé"]
	var price = [10, 30, 100]
	
	var rand1 = randi()%3
	var up1 = upgrade[rand1]
	price_1.text = str(price[rand1])
	
	if (part1 == "Coiffe") && (up1 == " avancé") : up1 = " avancée"
	
	if (part1 == "Propulseurs") || (part1 == "Propulseurs secondaires") : up1 = up1 + "s"
	
	var rand2 = randi()%3
	var up2 = upgrade[rand2]
	price_2.text = str(price[rand2])
	
	if (part2 == "Coiffe" && up2 == " avancé") : up2 = " avancée"
	
	if (part2 == "Propulseurs" || part2 == "Propulseurs secondaires") : up2 = up2 + "s"
	
	project_1.text = part1 + up1
	project_2.text = part2 + up2
	

func pay_research1() -> void:
	var p = int(price_1.text)
	var c = int(research_counter.text)
	if c >= p :
		research_counter.text = str(c - p)
	
func pay_research2() -> void:
	var p = int(price_2.text)
	var c = int(research_counter.text)
	if c >= p :
		research_counter.text = str(c - p)
