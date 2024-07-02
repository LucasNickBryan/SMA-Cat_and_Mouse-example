/**
* Name: CatAndMouse
* Based on the internal empty template. 
* Author: lucas
* Tags: 
*/


model CatAndMouse

/* Insert your model definition here */

global{
	
	image_file cheese_img <- image_file("../includes/icons/cheese.png");
	image_file mouse_alive_img <- image_file("../includes/icons/mouse_alive.png");
	image_file blue_cat_img <- image_file("../includes/icons/blue_cat.png");
	image_file mouse_dead_img <- image_file("../includes/icons/emoji_dead.png");


	init{
		create Cheese number:30;
		create Mouse number:16;
		create Cat number:8;
	}

}

species Cat{
	float cat_size <- 5.0;
	float cat_zone <- 5.0;
	
	aspect base{
		draw blue_cat_img size:cat_size;
	}
	
	reflex hunt{
		list <Mouse> mouse_list <- Mouse where ((each distance_to self)< cat_zone and each.is_alive);
		
		if(!empty(mouse_list)){
			Mouse mouse_item <- first(mouse_list);
			ask mouse_item{
				is_alive <- false;
			}
		}
		location <- point(location.x+rnd(-2,2), location.y+rnd(-2,2));
	}
}

species Mouse{
	float mouse_size <- 3.0;
	float mouse_zone <- 3.0;
	bool is_alive <- true;
	list <Mouse> former_partner;
	
	aspect base{
		if(is_alive){
			draw mouse_alive_img size:mouse_size;
		}
		else{
			draw mouse_dead_img size:2.5;
		}
	}
	
	reflex grow{
		float max_mouse_size <- 3.8;
		list <Cheese> cheese_list <- Cheese where ((each distance_to self) < mouse_zone);
		
		if(!empty(cheese_list)){
			Cheese cheese_item <- first(cheese_list);
			ask cheese_item{
				if(myself.mouse_size < max_mouse_size){
					myself.mouse_size <- myself.mouse_size + 0.15;
				}
				myself.location <- location;
				do die;
			}
		}
		else{
			if(is_alive){				
				location <- point(location.x+rnd(-1,1), location.y+rnd(-1,1));
			}
		}
	}
	
	reflex reproduce{
		list <Mouse> mouse_list <- Mouse where ((each distance_to self) < mouse_zone);
		
		if(length(mouse_list) = 2){
			bool can_reproduce <- true;
			
			loop mouse over:mouse_list{
				if(mouse in former_partner){
					can_reproduce <- false;
				}
				else{
					if(mouse.is_alive){						
						add item:mouse to:former_partner;
					}
					else{
						can_reproduce <- false;
					}
				}
			}
			
			if(can_reproduce){
				create Mouse number:1;
				write "reproduced MOUSE";
			}
		}
	}
}

species Cheese{
	float cheese_size <- 2.5;
	
	aspect base{
		draw cheese_img size:cheese_size;
	}
}

experiment cat_and_mouse type:gui{
	output{
		display main{
			species Cheese aspect:base;
			species Mouse aspect:base;
			species Cat aspect:base;
		}
	}
}