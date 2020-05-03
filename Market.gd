extends Control

class_name Market
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _canvas_item:CanvasItem = null

var _dibujo_default:Texture = load("res://market.png")
var _products:Array = ["chocolate","candy"]
var _prices:Dictionary = {"chocolate": 1.0, "candy": 1.0}

var _acumulated_products:Dictionary = {"chocolate": 1.0, "candy": 1.0}

var _my_combination_item_list:CombinationItemList = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _init(canvas_item_arg:CanvasItem):
	_canvas_item = canvas_item_arg
	var sprite:Sprite = Sprite.new()
	sprite.set_texture(_dibujo_default)
	add_child(sprite)
	
	sprite.set_position(Vector2(600,30))

	var name:String = "Prices: "
	var combi_choc:Dictionary = {"chocolate":1}
	var combi_cand:Dictionary = {"candy":1}
	var combi_prices:Dictionary = {combi_choc:1.0,combi_cand:1.1}	
	_my_combination_item_list = CombinationItemList.new(canvas_item_arg, combi_prices,name)
	_my_combination_item_list.set_position(Vector2(600,80))
	add_child(_my_combination_item_list)
	
	pass
	
	
	