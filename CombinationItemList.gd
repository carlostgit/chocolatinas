extends ItemList

class_name CombinationItemList

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dibujo:Texture = load("res://icon.png")
var candy:Texture = load("res://candy.png")
var chocolate:Texture = load("res://chocolate.png")


# Declare member variables here. Examples:
#var _persons = ["Pepe", "Paco"]
var _products = ["chocolate","candy"]
var _combination_1 = {"chocolate": 2, "candy": 2}
var _combination_2 = {"chocolate": 3, "candy": 4}
var _combinations = [_combination_1,_combination_2]


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_size(Vector2(40,40))
	var elem_height = candy.get_size().y
	var elem_width = candy.get_size().x
	
	var total_width = _combinations.size()*elem_width
	var total_height=10;
	for dict in _combinations:
		var this_height = dict.size()*elem_height
		if (this_height > total_height):
			total_height = this_height
		
	self.set_size(Vector2(total_width,total_height))
	
	for combination_dict in _combinations:
		for product in combination_dict.keys():
			if(product == "chocolate"):
				self.add_icon_item(chocolate)
			elif (product == "candy"):
				self.add_icon_item(candy)
	
	
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
