extends Control

class_name CombinationItemList

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _dibujo_default:Texture = load("res://icon.png")
var _candy:Texture = load("res://candy.png")
var _chocolate:Texture = load("res://chocolate.png")


# Declare member variables here. Examples:
#var _persons = ["Pepe", "Paco"]
var _products = ["chocolate","candy"]
var _combination_to_highlight = {"chocolate": 2, "candy": 1}
#todo
#var _combination_1:Dictionary = {"chocolate": 2, "candy": 2}
#var _combination_2:Dictionary = {"chocolate": 3, "candy": 4}
#var _combinations:Array = [_combination_1,_combination_2]

var _utils = load("res://Utils.gd")

var _combinations:Array = Array()

var _combination_satisfaction:Dictionary = Dictionary()

var _canvas_item:CanvasItem = null
#var _item_list_array = Array()
#var _item_list:ItemList = ItemList.new()
var _item_lists:Array = Array()
var _combination_item_list:Dictionary = Dictionary()

var _scale:float = 0.5
var _fixed_icon_size:Vector2 = Vector2(50,50)

var _font = load("res://new_dynamicfont.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.set_size(Vector2(40,40))
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _init(canvas_item_arg:CanvasItem, combinations_arg:Array, combination_satisfaction_arg:Dictionary = Dictionary()):
func _init(canvas_item_arg:CanvasItem, combination_satisfaction_arg:Dictionary = Dictionary()):
	_canvas_item = canvas_item_arg
	#_combinations = combinations_arg
	_combination_satisfaction = combination_satisfaction_arg
	
	_combinations = get_ordered_combinations(combination_satisfaction_arg)
	
	for combination in _combinations:
		assert(typeof(combination)==TYPE_DICTIONARY)
		add_item_list(combination)
	
	highlight_combination(_combination_to_highlight)
#	if (satisfaction_combination.size()>0):
#		todo

func highlight_combination(_combination_to_highlight:Dictionary)->void:
	
	for combination in _combination_item_list:
		print ("Ini")
		print (combination)
		print (_combination_to_highlight)
		print ("Fin")
		
		#Lo siguiente no funciona para comparar Dictionaries en gdscript
		#if(combination==_combination_to_highlight):
		#Lo siguiente tampoco:
		#if(combination.hash()==_combination_to_highlight.hash()):
		
		#	_combination_item_list[combination].set_item_custom_bg_color(0,Color(1,0,0))
		
		
		
		if Utils.compare_dictionaries(combination,_combination_to_highlight):
			#print ("print hashes")
			#print (combination.hash())
			#print (_combination_to_highlight.hash())
			var item_list:ItemList = _combination_item_list[combination]
			item_list.set_item_custom_bg_color(0,Color(1,0,0))
			
			print("combination found")
	#_combination_item_list[_combination_to_highlight]
	#var item_list:ItemList = _combination_item_list[_combination_to_highlight]
	#item_list.set_item_custom_bg_color(0,Color(1,0,0))
	pass

func get_ordered_combinations(combination_satisfaction_arg:Dictionary) -> Array:
	#Se ordenano de menor a mayor satisfacción
	
	var satisfactions_ordered:Array = combination_satisfaction_arg.values()
	satisfactions_ordered.sort()
	
	var combinations_ordered:Array = Array()
	for satisfaction in satisfactions_ordered:
		for combination in combination_satisfaction_arg:
			if satisfaction == combination_satisfaction_arg[combination]:
				combinations_ordered.append(combination)
				break	
	assert(combination_satisfaction_arg.size()==combinations_ordered.size())
	
	return combinations_ordered
	
func add_item_list(combination_dict_arg:Dictionary):
	
	var item_list:ItemList = ItemList.new()
	var num_prod=0
	#var total_height = 0
	for product in combination_dict_arg.keys():
		var num_current_prod = combination_dict_arg[product]
		
		var icon =null
		if(product == "chocolate"):
			icon = _chocolate
		elif (product == "candy"):
			icon = _candy
		else:
			icon = _dibujo_default
			assert(false)
		for pro in num_current_prod:
			#total_height += icon.get_size().y+6 
			item_list.add_icon_item(icon)
			num_prod = num_prod + 1

	var parent_x_pos = self.get_position().x
	var parent_y_pos = self.get_position().y
	
	#item_list.set_size(_chocolate.get_size())
	item_list.set_size(_fixed_icon_size*_scale)
	item_list.set_fixed_icon_size(_fixed_icon_size)
	var current_position_x = self.get_position().x+_item_lists.size()*item_list.get_size().x
	var this_item_list_pos=Vector2(current_position_x,self.get_position().y)
	item_list.set_position(this_item_list_pos)
	item_list.set_auto_height(true)
	#item_list.set_fixed_column_width(_fixed_icon_size.x*0.3)
	
	item_list.set_icon_scale(_scale)

	#item_list.set_icon_scale(0.3)

	self.add_child(item_list)
	
	_item_lists.append(item_list)
	_combination_item_list[combination_dict_arg]=item_list
	
	var label_node:Label = Label.new()
	
	
	var satisf:float = 0
	if(_combination_satisfaction.size()>0):
		satisf = _combination_satisfaction[combination_dict_arg]
	
	
	label_node.set_text(String(satisf).pad_decimals(1))
	
	label_node.set_position(this_item_list_pos)
	
	label_node.set_rotation(-PI/2);
	
	self.add_child(label_node)
	
	#self.draw_string(_font, this_item_list_pos,String(52),Color(1,1,1))
	
	pass


#static func compare_dictionaries(dict_1:Dictionary,dict_2:Dictionary)-> bool:
#	#Este método casero es necesario, porque en la versión de gdscript actual
#	#no funciona bien la comparación (operador==) entre objetos Dictionary
#	if(dict_1.size()!=dict_2.size()):
#		return false
#
#	for key in dict_1.keys():
#		if false==dict_2.has(key):
#			return false
#		if dict_1[key] != dict_2[key]:
#			return false
#
#	return true