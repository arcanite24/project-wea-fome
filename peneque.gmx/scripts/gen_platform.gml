///gen_platform(x,y,size,enemies,gen_enemy);
var size = argument2 - 2;
var xmid = argument0 + 32;
var xright = xmid + (size*32);

instance_create(argument0,argument1,obj_left_plat);
var plat = instance_create(xmid,argument1,obj_mid_plat);
plat.image_xscale = abs(size);
plat.gen_enemy = true;
plat.enemies = argument3;

instance_create(xright,argument1,obj_right_plat);

