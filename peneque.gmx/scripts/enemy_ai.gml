var wall = place_meeting(x+hspd,y,obj_solid);
var piso = place_meeting(x+(sign(hspd)*sprite_width),y+1,obj_solid);
var r = floor(random_range(1,100));

if(piso && !wall) {
    x += hspd;
} else if(wall || !piso) {
    hspd = -hspd;
}

if(r >= 99) {
    if(distance_to_object(obj_player) < argument0) {
        var f =instance_create(x,y,obj_enemy_arrow);
        f.damage = dmg;
    }
}