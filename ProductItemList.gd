extends Control


class_name ProductItemList
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _canvas_item:CanvasItem = null

var _dibujo_default:Texture = load("res://icon.png")
var _candy:Texture = load("res://candy.png")
var _chocolate:Texture = load("res://chocolate.png")


# Declare member variables here. Examples:
#var _persons = ["Pepe", "Paco"]
var _products = ["chocolate","candy"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _init(canvas_item_arg:CanvasItem, product_value_arg:Dictionary = Dictionary(),name_arg:String = "no name"):
	_canvas_item = canvas_item_arg
	#Prueba
	var price_elem_height = 30
	var total_height = 0.0
	var prices_list = ItemList.new()
	for prod in product_value_arg.keys():
		var value_of_prod:float = product_value_arg[prod]
		var price_string:String = String(value_of_prod)
		total_height += price_elem_height
		var icon = null
		if(prod == "chocolate"):
			icon = _chocolate
		elif (prod == "candy"):
			icon = _candy
		else:
			icon = _dibujo_default
			assert(false)

		prices_list.add_item(price_string,icon)
	prices_list.set_fixed_icon_size(Vector2(30,price_elem_height-10))
	prices_list.set_size(Vector2(100,total_height))
	#prices_list.add_item("blablalblallallalalallalal")
	add_child(prices_list)
	prices_list.set_position(Vector2(0,40))
	#fin Prueba

	self.set_label(name_arg)
	
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
	