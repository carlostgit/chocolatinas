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
var _combination_1 = {"chocolate": 2, "candy": 2}
var _combination_2 = {"chocolate": 3, "candy": 4}
var _combinations = [_combination_1,_combination_2]

var _canvas_item:CanvasItem = null
#var _item_list_array = Array()
var _item_list:ItemList = ItemList.new()
var _item_lists:Array = Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	#self.set_size(Vector2(40,40))
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _init(canvas_item_arg:CanvasItem):
	_canvas_item = canvas_item_arg
#	_item_list.set_position(Vector2(30,30))
#	_item_list.set_size(Vector2(40,40))
#	var elem_height = _candy.get_size().y
#	var elem_width = _candy.get_size().x
#
#	var total_width = _combinations.size()*elem_width
#	var total_height=10;
	for dict in _combinations:	
		Add_item_list(dict)
#		var this_height = dict.size()*elem_height
#		if (this_height > total_height):
#			total_height = this_height
#
#	_item_list.set_size(Vector2(total_width,total_height))
#
#	for combination_dict in _combinations:
#		for product in combination_dict.keys():
#			if(product == "chocolate"):
#				_item_list.add_icon_item(_chocolate)
#			elif (product == "candy"):
#				_item_list.add_icon_item(_candy)
#
#	self.add_child(_item_list)
	#o mejor ? _canvas_item.add_child(_item_list)
	
func Add_item_list(dict:Dictionary):
	
	var item_list:ItemList = ItemList.new()
	var num_prod=0
	for product in dict.keys():
		var num_current_prod = dict[product]
		
		var icon =null
		if(product == "chocolate"):
			icon = _chocolate
		elif (product == "candy"):
			icon = _candy
		for pro in num_current_prod:
			item_list.add_icon_item(icon)
			num_prod = num_prod + 1

	var elem_height = _candy.get_size().y
	var elem_width = _candy.get_size().x
	var total_width = elem_width
	var total_height = elem_height*num_prod

	var parent_x_pos = self.get_position().x
	var current_list_x_pos = parent_x_pos + elem_width*_item_lists.size()
	
	item_list.set_position(Vector2(current_list_x_pos,30))
	item_list.set_size(Vector2(40,40))
	item_list.set_size(Vector2(total_width,total_height))
	
	self.add_child(item_list)
	
	_item_lists.append(item_list)
	
	pass