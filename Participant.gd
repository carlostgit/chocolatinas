extends Control

class_name Participant 

var _name:String = ""

## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#var _dibujo_default:Texture = load("res://icon.png")
#var _candy:Texture = load("res://candy.png")
#var _chocolate:Texture = load("res://chocolate.png")
#
#
## Declare member variables here. Examples:
##var _persons = ["Pepe", "Paco"]
#var _products = ["chocolate","candy"]
#var _selected_combination = {"chocolate": 1, "candy": 1}
##todo
##var _combination_1:Dictionary = {"chocolate": 2, "candy": 2}
##var _combination_2:Dictionary = {"chocolate": 3, "candy": 4}
##var _combinations:Array = [_combination_1,_combination_2]

var _utils = load("res://Utils.gd")
#var _MyDictionary = load("res://MyDictionary.gd")

#var _combinations:Array = Array()
#var _combination_satisfaction:Dictionary = Dictionary()

var _canvas_item:CanvasItem = null
#var _item_list_array = Array()
#var _item_list:ItemList = ItemList.new()
#var _item_lists:Array = Array()
#var _combination_item_list:Dictionary = Dictionary()

#var _scale:float = 0.5
#var _fixed_icon_size:Vector2 = Vector2(50,50)

var _font = load("res://new_dynamicfont.tres")

var _my_combination_item_list:CombinationItemList = null

var _selected_combination = {"chocolate": 1, "candy": 1}
var _combination_satisfaction:Dictionary = Dictionary()

var _market:Market = null
# Called when the node enters the scene tree for the first time.
func _ready():
	#self.set_size(Vector2(40,40))
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _init(canvas_item_arg:CanvasItem, combinations_arg:Array, combination_satisfaction_arg:Dictionary = Dictionary()):
func _init(canvas_item_arg:CanvasItem, market_arg:Market, combination_satisfaction_arg:Dictionary = Dictionary(),name_arg:String = "no name"):
	
	set_name(name_arg)
	_canvas_item = canvas_item_arg
	
	_combination_satisfaction = combination_satisfaction_arg
	
	_market = market_arg
	
#	var labels:Array = []
#	labels.append("Satisfaction")
#	labels.append("Value")
	var combination_price = Dictionary()
	combination_price = get_combination_price()
	var combinations_ordered:Array = Utils.get_ordered_combinations(combination_satisfaction_arg)
	_my_combination_item_list = CombinationItemList.new(canvas_item_arg, combinations_ordered, combination_satisfaction_arg, combination_price,name_arg)
	_my_combination_item_list.set_position(Vector2(0,90))
	add_child(_my_combination_item_list)
	
	var value:float = 0;
	var value_string:String = String(value).pad_decimals(1)
	var labels_array = Array()
	#labels_array.append(value_string)
	var selected_combi_list = CombinationItem.new( canvas_item_arg, _selected_combination, "selected", labels_array)
	selected_combi_list.set_position(Vector2(120,00))
	add_child(selected_combi_list)

func set_name(name_arg:String)->void:
	
	var label_name:Label = Label.new()
	label_name.set_scale(Vector2(1.5,1.5))
	label_name.set_text(name_arg)
	label_name.set("custom_colors/font_color", Color(1,0,0))

	label_name.set_position(self.get_position()+Vector2(0,0))
	
	self.add_child(label_name)
	
	_name = name_arg

func get_name()->String:
	return _name
#
func get_combinations()->Array:
	return self._combination_satisfaction.keys()

func get_selected_combination()->Dictionary:
	return _selected_combination

func set_selected_combination(selected_combination_arg:Dictionary)->void:
	#_selected_combination = selected_combination_arg
#	_my_combination_item_list.set_selected_combination(selected_combination_arg)
	_selected_combination = selected_combination_arg
	
func get_satisfaction_of_selected_combination()->float:	
	var satisf:float = Utils.find_value_in_dictionary_with_dictionary_key(_combination_satisfaction,_selected_combination)
	return satisf
#	return _my_combination_item_list.get_satisfaction_of_selected_combination()

func highlight_combinations_with_less_satisf(satisfaction_arg:float) -> void:
	var combinations_to_highlight:Array = get_combinations_with_less_satisfaction(satisfaction_arg)	
	for combination in combinations_to_highlight:
		highlight_combination(combination,Color(1,0,0))
	#_my_combination_item_list.highlight_combinations_with_less_satisf(satisfaction_arg)
	
func highlight_combinations_with_more_satisf(satisfaction_arg:float) -> void:
	var combinations_to_highlight:Array = get_combinations_with_more_satisfaction(satisfaction_arg)	
	for combination in combinations_to_highlight:
		highlight_combination(combination,Color(0,1,0))
#	_my_combination_item_list.highlight_combinations_with_more_satisf(satisfaction_arg)

func highlight_combination(combination_arg:Dictionary, color_arg:Color) -> void:
	for combination in self._combination_satisfaction.keys():		
		if Utils.compare_dictionaries(combination,combination_arg):
			self._my_combination_item_list.highlight_combination_with_color(combination, color_arg)


func highlight_selected_combination() -> void:
#	highlight_combination_with_color(_selected_combination,Color(0,0,1))
	#_my_combination_item_list.highlight_selected_combination()
	highlight_combination(self._selected_combination, Color(0,0,1))
	
func get_combinations_with_less_satisfaction(satisfaction_arg:float) -> Array:
	var combinations_with_less:Array = Array()
	for combination in self._combination_satisfaction.keys():
		var satisf:float = _combination_satisfaction[combination]
		if satisf>=satisfaction_arg:
			continue
		print("satisf "+ String(satisf) + " < " + String(satisfaction_arg))
		combinations_with_less.append(combination)

	return combinations_with_less

func get_combinations_with_more_satisfaction(satisfaction_arg:float) -> Array:
	var combinations_with_more:Array = Array()
	for combination in self._combination_satisfaction.keys():
		var satisf:float = _combination_satisfaction[combination]
		if satisf<=satisfaction_arg:
			continue
		print("satisf "+ String(satisf) + " > " + String(satisfaction_arg))
		combinations_with_more.append(combination)

	return combinations_with_more

##static func compare_dictionaries(dict_1:Dictionary,dict_2:Dictionary)-> bool:
##	#Este método casero es necesario, porque en la versión de gdscript actual
##	#no funciona bien la comparación (operador==) entre objetos Dictionary
##	if(dict_1.size()!=dict_2.size()):
##		return false
##
##	for key in dict_1.keys():
##		if false==dict_2.has(key):
##			return false
##		if dict_1[key] != dict_2[key]:
##			return false
##
##	return true

#func set_market(market_arg:Market) ->void:
#	_market = market_arg
#	todo. tengo q pasar esto en el constructor. si no es demasiado tarde
	
func get_combination_price() -> Dictionary:
	if _market:
		var combination_price:Dictionary = Dictionary()
		for combination in self._combination_satisfaction.keys():
			var price:float = _market.get_price_of_combi(combination)
			combination_price[combination] = price
		return combination_price
	else:
		return Dictionary()
		
		
