
class_name Utils


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

static func compare_dictionaries(dict_1:Dictionary,dict_2:Dictionary)-> bool:
	#Este método casero es necesario, porque en la versión de gdscript actual
	#no funciona bien la comparación (operador==) entre objetos Dictionary
	if(dict_1.size()!=dict_2.size()):
		return false
		
	for key in dict_1.keys():
		if false==dict_2.has(key):
			return false
		if dict_1[key] != dict_2[key]:
			return false
		
	return true