///gen_world(y,ymax);
randomize();
var yy = argument0;
var ymax = argument1;

while(yy <= ymax) {

    var xx = floor(random_range(0,992));
    var yy1 = choose(96,128,128+32);
    gen_platform(xx,yy+yy1,choose(5,6,7,8,9),choose(0,0,1,1,1,2,2,3,3,4,5,6));
    
    yy += yy1;
    
}
