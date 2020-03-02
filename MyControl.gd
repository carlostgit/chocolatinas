extends Control


var font = load("res://new_dynamicfont.tres")
# Declare member variables here. Examples:
#var _persons = ["Pepe", "Paco"]
var _products = ["chocolate","candy"]
var _production = {"chocolate": 2, "candy": 2}
#var _productionPepe = {"chocolate": 2, "candy": 2}
#var _productionPaco = {"chocolate": 1, "candy": 3}


var _param_preference_at_0 = {"chocolate": 4.5, "candy": 4.5}
#param_preference_at_0["chocolate"] = 0.080
#param_preference_at_0["candy"] = 0.0305

var _maximum_satisf = {"chocolate": 9.0, "candy": 4.0}
#maximum_satisf["chocolate"] = 6.0;
#maximum_satisf["candy"] = 8.0;

#var _param_quantity_preference_at_0_food = 0.350
#var _param_maximum_quantity_satisf = 3.0
var _combies = {"sweets":["chocolate","candy"]}
var _param_combi_preference_at_0 = {"sweets":10.8}
var _param_combi_maximum_quantity_satisf = {"sweets":3.0}

var satisf_plotter = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#var arr = [1, 2, 3]
#	var dict = {"a": 0, "b": 1, "c": 2}
#	for i in dict:
#		print(i)
#		print(dict[i])
		
#	for i in range(0,100):
#		print(i)
#		print(get_diminishing_returns_factor(i))
#
#		var y_bottom:float = 500
#	var x_left:float = 10
#
#	var x_zoom:float = 6
#	var y_zoom:float = 40.0
#
#	var max_quantity = 5
#
##	var x_scale:float = 200
##	var y_scale:float = 200

#
#	var num_of_calculated_points = 100
	satisf_plotter = SatisfPlotter.new(400, 10, 6,40.0,5.0,100, self, font)
	satisf_plotter.draw_background()
	#calculate_satisf(_productionPepe)
	print ("Satisf = "+ String(calculate_satisf()))
	
	print ("calculate_combinations(3):")	
	var combinations = calculate_combinations(3)
	print (combinations)

	print ("calculate_combinations_exact_num_of_elem(3, self._products): ")		
	var combinations_2 = calculate_combinations_exact_num_of_elem(3, self._products)

#	print(combinations_2)
#	for combination in combinations_2:
#		print ("combination")
#		print (combination)
#		for elem in combination:
#			print ("elem")
#			print (elem)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("_process called")
	self.update()
	#pass

func calculate_satisf() -> float:
	var satisfaction_return = 0.0
	
	var satisf_of_prod_individually = 0.0
	for product in self._products:
		var amount_of_product = _production[product]
		satisf_of_prod_individually += self.calculate_satifaction_of_product(product,amount_of_product)
		#draw_satisf_graph_of_product(product)

	var satisf_of_combi = 0.0
	for combi_name in self._combies.keys():
		var amount_of_product = 0
		for product in _combies[combi_name]:
			amount_of_product += self._production[product]
		satisf_of_combi += self.calculate_satifaction_of_combi(combi_name,amount_of_product)
			
	
	satisfaction_return = satisf_of_prod_individually+satisf_of_combi		
		
	return satisfaction_return
	
func calculate_satifaction_of_product(product_arg:String, quantity_arg:float) -> float:
	
	if false==_products.has(product_arg):
		return 0.0
	
	var ret_satisf = 0.0
	var pref_at_0 = _param_preference_at_0[product_arg]
	var max_satisf = _maximum_satisf[product_arg]
	
	ret_satisf = max_satisf*get_diminishing_returns_factor(quantity_arg*pref_at_0/max_satisf)
	
	return ret_satisf

func calculate_satifaction_of_combi(combi_arg:String, quantity_arg:float) -> float:
	
	if false==self._combies.has(combi_arg):
		return 0.0
	
	var ret_satisf = 0.0
	var pref_at_0 = self._param_combi_preference_at_0[combi_arg]
	var max_satisf = self._param_combi_maximum_quantity_satisf[combi_arg]
	
	ret_satisf = max_satisf*get_diminishing_returns_factor(quantity_arg*pref_at_0/max_satisf)
	
	return ret_satisf

func get_diminishing_returns_factor(quantity_arg:float) -> float:
	#Voy a llamar al termino "1-(1/(0.25*x+1)^2)" Diminishing Returns Factor
	#Esta ecuación tendría un máximo en 1, y tendría pendiente 1 en 0
    #Es como una ecuación y = x, pero que se va haciendo más y más horizontal hasta q ya no crece la y
	var result = 0.0
	var denominator_square_root = 0.25*quantity_arg + 1.0;
	var denominator = denominator_square_root*denominator_square_root
	result = 1.0 - (1.0/denominator)
	if result < 0:
		result = 0
	return result

func _draw():

	satisf_plotter.draw_background()
	
	for product in self._products:
		var my_funcref = funcref( self, "calculate_satifaction_of_product")
		satisf_plotter.draw(my_funcref,product)

	for combi in self._combies:
		var my_funcref = funcref( self, "calculate_satifaction_of_combi")
		satisf_plotter.draw(my_funcref,combi, Color(1,0,0))
	pass
	#calculate_satisf(_productionPepe)
	
	
	
################################################
################################################
#Clase SatisfPlotter. Sacar mejor a otro fichero
class SatisfPlotter:
	var y_bottom:float = 500
	var x_left:float = 10
	
	var x_zoom:float = 6
	var y_zoom:float = 40.0
	
	var max_quantity:float = 5

	var num_of_calculated_points:int = 100
	
	var canvas_item:CanvasItem = null
	
	var font:Font = null
	var quantity_per_point:float = 0.0

	func _init(y_bottom_arg:float, x_left_arg:float, x_zoom_arg:float,y_zoom_arg:float,max_quantity_arg:float,num_of_calculated_points_arg:int, canvas_item_arg:CanvasItem, font_arg:Font):
		y_bottom=y_bottom_arg
		x_left=x_left_arg
		
		x_zoom=x_zoom_arg
		y_zoom=y_zoom_arg
		
		max_quantity = max_quantity_arg
	
		num_of_calculated_points=num_of_calculated_points_arg
		canvas_item = canvas_item_arg
		font = font_arg	
		
		quantity_per_point = float(max_quantity)/float(num_of_calculated_points)
	
	func draw_background():
		
		
		canvas_item.draw_line(Vector2(x_left,y_bottom),Vector2(800+x_left,y_bottom), Color(1,1,1))
	
		canvas_item.draw_line(Vector2(x_left,y_bottom-1*y_zoom),Vector2(800+x_left,y_bottom-1*y_zoom), Color(1,1,1)) #Value of 1 line
		canvas_item.draw_line(Vector2(num_of_calculated_points*x_zoom+x_left,y_bottom),Vector2(num_of_calculated_points*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 100 line
		
		for line in range(1,10):
			canvas_item.draw_line(Vector2((line*num_of_calculated_points/10)*x_zoom+x_left,y_bottom),Vector2((line*num_of_calculated_points/10)*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 50 line
		
		canvas_item.draw_string(font,Vector2(num_of_calculated_points*x_zoom+x_left,y_bottom+10),String(max_quantity),Color(1,1,1))
		canvas_item.draw_string(font,Vector2(0,y_bottom-1*y_zoom),"1",Color(1,1,1))
			
	func draw(var myfunc, var func_arg, color_arg:Color = Color(0,1,0)):
		
		for i in range(0,num_of_calculated_points):	
				
			var x1:float = x_zoom*float(i)
			var x2:float = x_zoom*float(i+1)
			var y1:float = y_zoom*myfunc.call_func(func_arg,i*quantity_per_point)
			var y2:float = y_zoom*myfunc.call_func(func_arg,(i+1)*quantity_per_point)
			canvas_item.draw_line(Vector2((x_left+x1),y_bottom-y1), Vector2((x_left+x2), y_bottom-y2), color_arg, 1)


#func calculate_combinations(max_num_elements_arg:int)->Array:
func calculate_combinations(max_num_elements_arg:int)->Dictionary:
	#var combination_list = Array()
	var combination_dict = Dictionary()
	for num_elem in range(1,max_num_elements_arg+1):
		var combination_list_of_exact_number_of_elements = calculate_combinations_exact_num_of_elem(num_elem,self._products)
		#combination_list.push_back(combination_list_of_exact_number_of_elements)
		combination_dict[num_elem] = combination_list_of_exact_number_of_elements;
	#return combination_list
	return combination_dict

func calculate_combinations_exact_num_of_elem(exact_num_elements_arg:int, list_of_prod:Array)->Array:
	#[{candy:3, chocolate:0}, {candy:2, chocolate:1}, {candy:1, chocolate:2}, {candy:0, chocolate:3}]

	var combination_list = Array()
	var used_products = Array()
	
	if list_of_prod.size()>0:
		var prod = list_of_prod.front()

		var rest_of_products = list_of_prod.duplicate(true) #copia del array
		used_products.append(prod)
		for used_prod in used_products:
			rest_of_products.erase(used_prod)

		for num in range(0,exact_num_elements_arg+1):
			
			var subcombination_list = Array()
			if rest_of_products.size() > 0:

				subcombination_list = calculate_combinations_exact_num_of_elem(exact_num_elements_arg-num,rest_of_products)

				for dict in subcombination_list:
					dict[prod] = num

				for elem in subcombination_list:
					combination_list.append(elem)
				
			else:
				if (num==exact_num_elements_arg):
					var dict_prod_num = { prod:num}
					
					subcombination_list.append(dict_prod_num)

					for elem in subcombination_list:
						combination_list.append(elem)

					break
					
	return combination_list