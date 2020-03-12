extends Node

class_name SatisfPlotter


var y_bottom:float = 500
var x_left:float = 10

var x_zoom:float = 6
var y_zoom:float = 40.0

var max_quantity:float = 5

var num_of_calculated_points:int = 100

var canvas_item:CanvasItem = null

var font:Font = null
var quantity_per_point:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
