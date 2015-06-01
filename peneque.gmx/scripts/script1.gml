///Platform physics
left = keyboard_check(ord("A"));
right = keyboard_check(ord("D"));
jump = keyboard_check_pressed(vk_space);

if(place_meeting(x,y+1,obj_solid)) {
    vspd = 0;
    if(jump) {
        vspd = -jump_spd;
    }
} else {
    if(vspd < 5) {
        vspd += grav;
    }
}

if(!left && !right) {
    hspd = 0;
}

if(left) {
    hspd = -spd;
}
if(right) {
    hspd = spd;
}

if(place_meeting(x+hspd,y,obj_solid)) {
    while(!place_meeting(x+sign(hspd),y,obj_solid)) {
        x += sign(hspd);
    }
    hspd = 0;
}

x += hspd * global.delta;

if(place_meeting(x,y+vspd,obj_solid)) {
    while(!place_meeting(x,y+sign(vspd),obj_solid)) {
        y += sign(vspd);
    }
    vspd = 0;
}

y += vspd * global.delta;
