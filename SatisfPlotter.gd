extends Node

class_name SatisfPlotter

var _y_bottom:float = 500
var _x_left:float = 10

var _x_zoom:float = 6
var _y_zoom:float = 40.0

var _max_quantity:float = 5

var _num_of_calculated_points:int = 100

var _canvas_item:CanvasItem = null

var _font = load("res://new_dynamicfont.tres")
#var font:Font = null
var _quantity_per_point:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(y_bottom_arg:float, x_left_arg:float, x_zoom_arg:float,y_zoom_arg:float,max_quantity_arg:float,num_of_calculated_points_arg:int, canvas_item_arg:CanvasItem):
	_y_bottom=y_bottom_arg
	_x_left=x_left_arg
	
	_x_zoom=x_zoom_arg
	_y_zoom=y_zoom_arg
	
	_max_quantity = max_quantity_arg

	_num_of_calculated_points=num_of_calculated_points_arg
	_canvas_item = canvas_item_arg
	#_font = font_arg	
	
	_quantity_per_point = float(_max_quantity)/float(_num_of_calculated_points)

func draw_background():
	
	
	_canvas_item.draw_line(Vector2(_x_left,_y_bottom),Vector2(800+_x_left,_y_bottom), Color(1,1,1))

	_canvas_item.draw_line(Vector2(_x_left,_y_bottom-1*_y_zoom),Vector2(800+_x_left,_y_bottom-1*_y_zoom), Color(1,1,1)) #Value of 1 line
	_canvas_item.draw_line(Vector2(_num_of_calculated_points*_x_zoom+_x_left,_y_bottom),Vector2(_num_of_calculated_points*_x_zoom+_x_left,0), Color(1,1,1)) #Cuantity of 100 line
	
	for line in range(1,10):
		_canvas_item.draw_line(Vector2((line*_num_of_calculated_points/10)*_x_zoom+_x_left,_y_bottom),Vector2((line*_num_of_calculated_points/10)*_x_zoom+_x_left,0), Color(1,1,1)) #Cuantity of 50 line
	
	_canvas_item.draw_string(_font,Vector2(_num_of_calculated_points*_x_zoom+_x_left,_y_bottom+10),String(_max_quantity),Color(1,1,1))
	_canvas_item.draw_string(_font,Vector2(0,_y_bottom-1*_y_zoom),"1",Color(1,1,1))
		
func draw(var myfunc, var func_arg, color_arg:Color = Color(0,1,0)):
	
	for i in range(0,_num_of_calculated_points):	
			
		var x1:float = _x_zoom*float(i)
		var x2:float = _x_zoom*float(i+1)
		var y1:float = _y_zoom*myfunc.call_func(func_arg,i*_quantity_per_point)
		var y2:float = _y_zoom*myfunc.call_func(func_arg,(i+1)*_quantity_per_point)
		_canvas_item.draw_line(Vector2((_x_left+x1),_y_bottom-y1), Vector2((_x_left+x2), _y_bottom-y2), color_arg, 1)
