extends Control


var _font = load("res://new_dynamicfont.tres")
var _satisf_plotter = load("res://SatisfPoltter.gd")

# Declare member variables here. Examples:
#var _persons = ["Pepe", "Paco"]
var _products = ["chocolate","candy"]
var _production = {"chocolate": 2, "candy": 2}
#var _productionPepe = {"chocolate": 2, "candy": 2}
#var _productionPaco = {"chocolate": 1, "candy": 3}


var _param_preference_at_0 = {"chocolate": 4.5, "candy": 4.5}

var _maximum_satisf = {"chocolate": 9.0, "candy": 4.0}

var _combo = {"sweets":["chocolate","candy"]}
var _param_combo_preference_at_0 = {"sweets":10.8}
var _param_combo_maximum_quantity_satisf = {"sweets":3.0}

# Called when the node enters the scene tree for the first time.
func _ready():

	_satisf_plotter = SatisfPlotter.new(400, 10, 6,40.0,5.0,100, self, _font)
	_satisf_plotter.draw_background()

	print ("Satisf = "+ String(calculate_satisf()))
	
	print ("calculate_combinations(3):")	
	var combinations = calculate_combinations(3)
	print (combinations)

	print ("calculate_combinations_exact_num_of_elem(3, self._products): ")		
	var combinations_2 = calculate_combinations_exact_num_of_elem(3, self._products)
		
	var combination_3 = {"chocolate": 23, "candy": 52}
	var combo_satisfaction_3:float = calculate_satisfaction_of_prod_combos_in_combination(combination_3)
	print ("combination_3: ")
	print (combination_3)
	print ("combo_satisfaction_3: ")
	print (combo_satisfaction_3)
	
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

	var satisf_of_combi = 0.0
	for combi_name in self._combo.keys():
		var amount_of_product = 0
		for product in _combo[combi_name]:
			amount_of_product += self._production[product]
		satisf_of_combi += self.calculate_satifaction_of_prod_combo(combi_name,amount_of_product)

	satisfaction_return = satisf_of_prod_individually+satisf_of_combi		
		
	return satisfaction_return

func calculate_satisfaction_of_combination(combination:Dictionary) -> float:
	#Satisfaction of individual products
	#{candy:3, chocolate:0}
	var satisfaction:float = 0.0
		
	for prod in combination.keys():
		var num_of_prod:float = combination[prod]
		if num_of_prod > 0.0:
			var satisf_of_prod = calculate_satifaction_of_product(prod,num_of_prod)
			satisfaction += satisf_of_prod

	#Satisfaction of combos
	var satisf_combos:float = calculate_satisfaction_of_prod_combos_in_combination(combination)

	return satisfaction+satisf_combos

func calculate_satisfaction_of_prod_combos_in_combination(combination:Dictionary) -> float:
	#Satisfaction of individual products
	#{candy:3, chocolate:0}
	var satisfaction:float = 0.0

	#var _combo = {"sweets":["chocolate","candy"]}
	for combo in self._combo.keys():
		var dict_prod_of_combo_repetitions:Dictionary = Dictionary()
		var prods_in_combo:Array = _combo[combo]
		for prod in prods_in_combo:
			dict_prod_of_combo_repetitions[prod] = 0.0

		print ("dict_prod_of_combo_repetitions:")
		print (dict_prod_of_combo_repetitions)

		for prod in combination.keys():
			var num_of_prod:float = combination[prod]
			if num_of_prod > 0.0:
				if dict_prod_of_combo_repetitions.has(prod):
					dict_prod_of_combo_repetitions[prod] = num_of_prod

		print ("dict_prod_of_combo_repetitions 2:")
		print (dict_prod_of_combo_repetitions)

			
		var min_of_comb_in_combination:float = 0.0
		if (dict_prod_of_combo_repetitions.size()>0):
			var first_prod:bool = true
			for prod in dict_prod_of_combo_repetitions.keys():
				var num_of_repet = dict_prod_of_combo_repetitions[prod]
				if first_prod:
					min_of_comb_in_combination = num_of_repet
					first_prod = false
				if num_of_repet < min_of_comb_in_combination:
					min_of_comb_in_combination = num_of_repet
		else:
			min_of_comb_in_combination = 0.0

		print ("min_of_comb_in_combination:")
		print (min_of_comb_in_combination)


		if min_of_comb_in_combination > 0.0:
			var satisf_of_combo_in_combination = calculate_satifaction_of_prod_combo(combo, min_of_comb_in_combination)
			satisfaction += satisf_of_combo_in_combination

	return satisfaction

func calculate_satifaction_of_product(product_arg:String, quantity_arg:float) -> float:
	
	if false==_products.has(product_arg):
		return 0.0
	
	var ret_satisf = 0.0
	var pref_at_0 = _param_preference_at_0[product_arg]
	var max_satisf = _maximum_satisf[product_arg]
	
	ret_satisf = max_satisf*get_diminishing_returns_factor(quantity_arg*pref_at_0/max_satisf)
	
	return ret_satisf

func calculate_satifaction_of_prod_combo(combi_arg:String, quantity_arg:float) -> float:
	
	if false==self._combo.has(combi_arg):
		return 0.0
	
	var ret_satisf = 0.0
	var pref_at_0 = self._param_combo_preference_at_0[combi_arg]
	var max_satisf = self._param_combo_maximum_quantity_satisf[combi_arg]
	
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

	_satisf_plotter.draw_background()

	for product in self._products:
		var my_funcref = funcref( self, "calculate_satifaction_of_product")
		_satisf_plotter.draw(my_funcref,product)

	for combi in self._combo:
		var my_funcref = funcref( self, "calculate_satifaction_of_prod_combo")
		_satisf_plotter.draw(my_funcref,combi, Color(1,0,0))
	pass
	

func calculate_combinations(max_num_elements_arg:int)->Dictionary:

	var combination_dict = Dictionary()
	for num_elem in range(1,max_num_elements_arg+1):
		var combination_list_of_exact_number_of_elements = calculate_combinations_exact_num_of_elem(num_elem,self._products)
		combination_dict[num_elem] = combination_list_of_exact_number_of_elements;
	
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