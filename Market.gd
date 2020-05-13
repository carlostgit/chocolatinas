extends Control

class_name Market
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _canvas_item:CanvasItem = null

#var _dibujo_default:Texture = load("res://icon.png")

var _dibujo_default:Texture = load("res://market.png")
var _products:Array = ["chocolate","candy"]
var _currency:String = "candy"
var _prices:Dictionary = {"chocolate": 1.0, "candy": 1.0}
var _acumulated_products:Dictionary = {"chocolate": 1.0, "candy": 1.0}

var _my_combination_item_list:CombinationItemList = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _init(canvas_item_arg:CanvasItem, combinations_arg:Array):
	_canvas_item = canvas_item_arg

	#Label
	set_label("Market")
	
	#Imagen
	var sprite:Sprite = Sprite.new()
	sprite.set_texture(_dibujo_default)
	sprite.set_position(Vector2(0,50))
	add_child(sprite)

	#Imagen de cada producto y su precio
	var prices_item_list = ProductItemList.new(canvas_item_arg, _prices, "Prices")
	prices_item_list.set_position(Vector2(100,0))
	add_child(prices_item_list)

#	var combiunit_prices:Dictionary = Dictionary()
#	for prod in _products:
#		var combi_prod:Dictionary = Dictionary()
#		combi_prod[prod] = 1
#		combiunit_prices[combi_prod] = _prices[prod]	
#	var name:String = "Prices: "
#	_my_combination_item_list = CombinationItemList.new(canvas_item_arg, combiunit_prices,name)
#	_my_combination_item_list.set_position(Vector2(0,80))
#	add_child(_my_combination_item_list)
	
	#Imagen de las combinaciones y sus precios:
	var combi_prices:Dictionary = Dictionary()
	for combination in combinations_arg:
		combi_prices[combination] = get_price_of_combi(combination)
	var name_combi:String = "Prices of combis: "
	var comb_it_list = CombinationItemList.new(canvas_item_arg, combi_prices,name_combi)
	comb_it_list.set_position(Vector2(0,180))
	add_child(comb_it_list)
		
	
func get_price_of_combi(combination_arg:Dictionary) -> float:
	var price_of_combi:float = 0.0
	for prod in combination_arg.keys():
		#print (prod)
		var number_of_prod = combination_arg[prod]
		#print ("number_of_prod")
		#print (number_of_prod)
		var prod_price = _prices[prod]
		price_of_combi += number_of_prod*prod_price
	
#	print ("price of combi")
#	print (combination_arg)
#	print (price_of_combi)
	return price_of_combi
	
	
func set_label(label_name_arg:String)->void:
	print("label_name is")
	var label_name:Label = Label.new()
	label_name.set_scale(Vector2(1.5,1.5))
	label_name.set_text(label_name_arg)
	label_name.set("custom_colors/font_color", Color(1,0,0))
	#label_name.set_text("Pruebita")
	#print(self.get_name())
	label_name.set_position(self.get_position()+Vector2(0,0))

	self.add_child(label_name)
