extends Control

class_name CombinationItemList

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _dibujo:Texture = load("res://icon.png")
var _candy:Texture = load("res://candy.png")
var _chocolate:Texture = load("res://chocolate.png")


# Declare member variables here. Examples:
#var _persons = ["Pepe", "Paco"]
var _products = ["chocolate","candy"]
var _combination_1:Dictionary = {"chocolate": 2, "candy": 2}
var _combination_2:Dictionary = {"chocolate": 3, "candy": 4}
var _combinations:Array = [_combination_1,_combination_2]

var _canvas_item:CanvasItem = null
#var _item_list_array = Array()
var _item_list:ItemList = ItemList.new()
var _item_lists:Array = Array()

var _scale:float = 0.5
var _fixed_icon_size:Vector2 = Vector2(50,50)

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.set_size(Vector2(40,40))
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _init(canvas_item_arg:CanvasItem, combinations_arg:Array):
	_canvas_item = canvas_item_arg
	_combinations = combinations_arg
	for dict in _combinations:		
		add_item_list(dict)
	
func add_item_list(dict_arg:Dictionary):
	
	var item_list:ItemList = ItemList.new()
	var num_prod=0
	#var total_height = 0
	for product in dict_arg.keys():
		var num_current_prod = dict_arg[product]
		
		var icon =null
		if(product == "chocolate"):
			icon = _chocolate
		elif (product == "candy"):
			icon = _candy
		for pro in num_current_prod:
			#total_height += icon.get_size().y+6 
			item_list.add_icon_item(icon)
			num_prod = num_prod + 1

	var parent_x_pos = self.get_position().x
	var parent_y_pos = self.get_position().y
	
	#item_list.set_size(_chocolate.get_size())
	item_list.set_size(_fixed_icon_size*_scale)
	item_list.set_fixed_icon_size(_fixed_icon_size)
	var current_position = self.get_position().x+_item_lists.size()*item_list.get_size().x
	item_list.set_position(Vector2(current_position,self.get_position().y))
	item_list.set_auto_height(true)
	#item_list.set_fixed_column_width(_fixed_icon_size.x*0.3)
	
	item_list.set_icon_scale(_scale)

	#item_list.set_icon_scale(0.3)

	self.add_child(item_list)
	
	_item_lists.append(item_list)
	
	pass