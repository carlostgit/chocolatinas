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
	
	
	var combinations = calculate_combinations(3)
	print ("calculate_combinations:")
	print (combinations)
	
	var combinations_2 = calculate_combinations_exact_num_of_elem(3, self._products)
	print ("calculate_combinations_exact_num_of_elem: ")	
	print(combinations_2)
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
	
#	draw_satisf(param_preference_at_0["chocolate"],maximum_satisf["chocolate"],Color(1,0,0))
#	draw_satisf(param_preference_at_0["candy"],maximum_satisf["candy"],Color(0,1,0))
#	draw_satisf(param_quantity_preference_at_0_food,param_maximum_quantity_satisf,Color(0,0,1))
#
#	var amount_food = 0
#	var types_of_food = dic_prod_amount.keys()
#	for food in types_of_food:
#		amount_food += dic_prod_amount[food] 
#
#
#	var num_of_chocolate = 3.0
#	var chocolate_satisfaction = maximum_satisf["chocolate"]*get_diminishing_returns_factor(3/param_preference_at_0["chocolate"])
#
#	var keys = dic_prod_amount.keys()
#	for i in dic_prod_amount:
#		print(i, dic_prod_amount[i])
#		pass
#
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
#	print ("gdrf")
#	print (quantity_arg)
	var denominator_square_root = 0.25*quantity_arg + 1.0;
#	print (denominator_square_root)
	var denominator = denominator_square_root*denominator_square_root
#	print (denominator)
	result = 1.0 - (1.0/denominator)
#	print (result)
#	print ("gdrf end")
	if result < 0:
		result = 0
	return result



#double CParticipant::GetDiminishingReturnsFactor(double dQuantity)
#{
#    //Este método es candidato a meterse en una clase aparte
#    //Voy a llamar al termino "1-(1/(0.25*x+1)^2)" Diminishing Returns Factor
#    double dDenominatorSquareRoot = (0.25*dQuantity+1.0);
#    double dDenominator = dDenominatorSquareRoot*dDenominatorSquareRoot;
#    double dResult = 1.0 - (1.0/dDenominator);
#    return dResult;
#}


func _draw():
#	for product in self._products:
#		draw_satisf_graph_of_product(product)
#
#	for combi in self._combies:
#		draw_satisf_graph_of_combi(combi)

	satisf_plotter.draw_background()
	
	for product in self._products:
		var my_funcref = funcref( self, "calculate_satifaction_of_product")
		satisf_plotter.draw(my_funcref,product)

	for combi in self._combies:
		var my_funcref = funcref( self, "calculate_satifaction_of_combi")
		satisf_plotter.draw(my_funcref,combi, Color(1,0,0))
	pass
	#calculate_satisf(_productionPepe)
	
	#print ("_draw() called")
#	var color = Color(1,1,0,1)
#	draw_line(Vector2(0,100), Vector2(100, 0), color ,1)
##	draw_satisf(5.0,2,Color(1,0,0))
#	draw_satisf(10.0,1.5,Color(0,1,0))
	#draw_drf(0.1,1,Color(255,0,0))
	#draw_drf(0.4,2,Color(255,255,0))

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

	
		
#
#func draw_satisf_graph_of_combi(combi_arg:String, color_arg:Color = Color(0,1,0)):
#	var y_bottom:float = 500
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
#	var quantity_per_point:float = float(max_quantity)/float(num_of_calculated_points)
#
#	draw_line(Vector2(x_left,y_bottom),Vector2(800+x_left,y_bottom), Color(1,1,1))
#
#	draw_line(Vector2(x_left,y_bottom-1*y_zoom),Vector2(800+x_left,y_bottom-1*y_zoom), Color(1,1,1)) #Value of 1 line
#	draw_line(Vector2(num_of_calculated_points*x_zoom+x_left,y_bottom),Vector2(num_of_calculated_points*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 100 line
#
#	for line in range(1,10):
#		draw_line(Vector2((line*num_of_calculated_points/10)*x_zoom+x_left,y_bottom),Vector2((line*num_of_calculated_points/10)*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 50 line
#
#	draw_string(font,Vector2(num_of_calculated_points*x_zoom+x_left,y_bottom+10),String(max_quantity),Color(1,1,1))
#	draw_string(font,Vector2(0,y_bottom-1*y_zoom),"1",Color(1,1,1))
#
#
#	for i in range(0,num_of_calculated_points):	
#
#
#		var x1:float = x_zoom*float(i)
#		var x2:float = x_zoom*float(i+1)
#		var y1:float = y_zoom*calculate_satifaction_of_combi(combi_arg,i*quantity_per_point)
#		var y2:float = y_zoom*calculate_satifaction_of_combi(combi_arg,(i+1)*quantity_per_point)
#		draw_line(Vector2((x_left+x1),y_bottom-y1), Vector2((x_left+x2), y_bottom-y2), color_arg, 1)
#
#
#func draw_satisf_graph_of_product(product_arg:String, color_arg:Color = Color(1,0,0)):
#	var y_bottom:float = 500
#	var x_left:float = 10
#
#	var x_zoom:float = 6
#	var y_zoom:float = 40.0
#	var max_quantity = 5
#
##	var x_scale:float = 200
##	var y_scale:float = 200
#
#	var num_of_calculated_points = 100
#	var quantity_per_point:float = float(max_quantity)/float(num_of_calculated_points)
#
#	draw_line(Vector2(x_left,y_bottom),Vector2(800+x_left,y_bottom), Color(1,1,1))
#
#	draw_line(Vector2(x_left,y_bottom-1*y_zoom),Vector2(800+x_left,y_bottom-1*y_zoom), Color(1,1,1)) #Value of 1 line
#	draw_line(Vector2(num_of_calculated_points*x_zoom+x_left,y_bottom),Vector2(num_of_calculated_points*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 100 line
#	draw_line(Vector2((num_of_calculated_points/2)*x_zoom+x_left,y_bottom),Vector2((num_of_calculated_points/2)*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 50 line
#
#	draw_string(font,Vector2(num_of_calculated_points*x_zoom+x_left,y_bottom+10),String(max_quantity),Color(1,1,1))
#	draw_string(font,Vector2(0,y_bottom-1*y_zoom),"1",Color(1,1,1))
#
#
#	for i in range(0,num_of_calculated_points):	
#
#
#
#		var x1:float = x_zoom*float(i)
#		var x2:float = x_zoom*float(i+1)
#		var y1:float = y_zoom*calculate_satifaction_of_product(product_arg,i*quantity_per_point)
#		var y2:float = y_zoom*calculate_satifaction_of_product(product_arg,(i+1)*quantity_per_point)
#		draw_line(Vector2((x_left+x1),y_bottom-y1), Vector2((x_left+x2), y_bottom-y2), color_arg, 1)


#func draw_satisf(x_preference_at_start:float, y_max_satisf,color_arg:Color = Color(255,255,0)):
#	draw_drf(1.0/x_preference_at_start,y_max_satisf, color_arg)
#
#func draw_drf(x_scale_arg:float, y_scale_arg:float, color_arg:Color = Color(255,255,0)):
#	var y_bottom:float = 500
#	var x_left:float = 10
#
#	var x_zoom:float = 6
#	var y_zoom:float = 40.0
#
#	var x_scale:float = x_scale_arg
#	var y_scale:float = y_scale_arg
#
#	draw_line(Vector2(x_left,y_bottom),Vector2(800+x_left,y_bottom), Color(1,1,1))
#	draw_line(Vector2(x_left,y_bottom-y_scale_arg*y_zoom),Vector2(800+x_left,y_bottom-y_scale_arg*y_zoom), color_arg.lightened(0.8))#Max value line
#	draw_line(Vector2(x_left,y_bottom-1*y_zoom),Vector2(800+x_left,y_bottom-1*y_zoom), Color(1,1,1)) #Value of 1 line
#	draw_line(Vector2(100*x_zoom+x_left,y_bottom),Vector2(100*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 100 line
#	draw_line(Vector2(50*x_zoom+x_left,y_bottom),Vector2(50*x_zoom+x_left,0), Color(1,1,1)) #Cuantity of 50 line
#
#	draw_string(font,Vector2(100*x_zoom+x_left,y_bottom+10),"100",Color(1,1,1))
#	draw_string(font,Vector2(0,y_bottom-1*y_zoom),"1",Color(1,1,1))
#
#
#	for i in range(0,100):	
#
#		var x1:float = x_zoom*float(i)
#		var x2:float = x_zoom*float(i+1)
#		var y1:float = y_zoom*y_scale*get_diminishing_returns_factor(float(i)/x_scale)
#		var y2:float = y_zoom*y_scale*get_diminishing_returns_factor(float(i+1)/x_scale)
#		draw_line(Vector2((x_left+x1),y_bottom-y1), Vector2((x_left+x2), y_bottom-y2), color_arg, 1)
#
#func draw(x_arg:float,y_arg:float,max_x:float,max_y:float) -> Vector2:
#	var ret_vect:Vector2 = Vector2(x_arg,y_arg)
#
#
#	return ret_vect
	

func calculate_combinations(max_num_elements_arg:int)->Array:
	var combination_list = Array()
	for num_elem in range(1,max_num_elements_arg):
		var combination_list_of_exact_number_of_elements = calculate_combinations_exact_num_of_elem(num_elem,self._products)
		combination_list += combination_list_of_exact_number_of_elements		
	return combination_list

func calculate_combinations_exact_num_of_elem(exact_num_elements_arg:int, list_of_prod:Array)->Array:
	var combination_products_number_dict = Dictionary()
	var combination_list = Array()
	var used_products = Array()
	for prod in list_of_prod:
		for num in range(0,exact_num_elements_arg):
			var rest_of_products = list_of_prod.duplicate(true) #copia del array
			used_products.append(prod)
			for used_prod in used_products:				
				rest_of_products.erase(used_prod)
			
			var subcombination_list = Array()
			if rest_of_products.size() > 0:
				subcombination_list = calculate_combinations_exact_num_of_elem(exact_num_elements_arg-num,rest_of_products)
		
				var dict_prod_num = { prod:num}
				for subcombination in subcombination_list:
					subcombination.append(dict_prod_num)
				
				var count_of_prod_in_subcombi = 0
				for subcombination in subcombination_list:
					for diction in subcombination:
						for prod_2 in diction:
							if(diction.has(prod_2)):
								var num_of_prod_2 = diction[prod_2]
								count_of_prod_in_subcombi += num_of_prod_2
						
				if(count_of_prod_in_subcombi==exact_num_elements_arg):
					combination_list.append(subcombination_list)
			else:
				var dict_prod_num = { prod:exact_num_elements_arg}
				subcombination_list.append(dict_prod_num)
				#combination_list += subcombination_list
				combination_list.append(subcombination_list)
				break
				
	return combination_list