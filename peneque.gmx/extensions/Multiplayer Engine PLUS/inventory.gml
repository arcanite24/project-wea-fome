#define inv_cube_create
var i;
yslots=argument1;
xslots=argument0;
inventoryx=argument2;
inventoryy=argument3;
celldim=argument4;
open=0;

for (i=0; i<=xslots; i+=1)
    {
    for (c=0; c<=yslots; c+=1)
        {
        slot[i,c]=0;
        }
    }
#define inv_cube_make
with (argument3){
    if (incube=1){
      for (i=floor((x-argument0.cube.inventoryx)/argument0.cube.celldim); i<floor((x-argument0.cube.inventoryx)/argument0.cube.celldim+itemslotsw); i+=1){
           for (c=floor((y-argument0.cube.inventoryy)/argument0.cube.celldim); c<floor((y-argument0.cube.inventoryy)/argument0.cube.celldim+itemslotsh); c+=1){
               if (i<argument0.cube.xslots && c<argument0.cube.yslots)
               {
                   argument0.cube.slot[i,c]=0;
               }
           }
      }
	argument0.depthobject.itemobject=-1;
	instance_destroy();
    }
}
with (argument4){
var xi,xc;
incube=1;
x=argument0.cube.inventoryx+argument1*argument0.cube.celldim;
y=argument0.cube.inventoryy+argument2*argument0.cube.celldim;
xat=x-argument0.cube.inventoryx;
yat=y-argument0.cube.inventoryy;
inventoryobject=argument0;
instance_change(argument3,true);
selected=0;
for (xi=argument1; xi<argument1+width; xi+=1){
    for (xc=argument2; xc<argument2+height; xc+=1){
        argument0.cube.slot[xi,xc]=1;
    }
}
}
#define inv_cube_putin
with (argument1){
var ix,iy;
    for (ix=0; ix<argument3.xslots; ix+=1){
        for (iy=0; iy<argument3.yslots; iy+=1){
            if (argument3.slot[ix,iy]=0){
                var scriptix, scriptiy, scriptimposible;
                scriptimposible=-1
                if (ix+itemslotsw>argument3.xslots or iy+itemslotsh>argument3.yslots){scriptimposible=1;}
                for (scriptix=ix; scriptix<ix+itemslotsw; scriptix+=1){
                    for (scriptiy=iy; scriptiy<iy+itemslotsh; scriptiy+=1){
                        if (scriptix<argument3.xslots && scriptiy<argument3.yslots){
                            if (argument3.slot[scriptix,scriptiy]=1){
                                scriptimposible=1;
                                break;
                            }
                        }
                    }
                }
                if (scriptimposible!=1){scriptimposible=0;}
                if (scriptimposible=0){returnn = true;}else
			{
			returnn = false;
			}
                if (returnn=true){
			  x=argument3.inventoryx+ix*argument3.celldim;
			  y=argument3.inventoryy+iy*argument3.celldim;
			  xat=x-argument3.inventoryx;
			  yat=y-argument3.inventoryy;
		    	  if (sound_exists(argument0.pickup_sound) && argument0.pickup_sound!=0){sound_play(argument0.pickup_sound);}
			  selected=0;
			  argument0.selecteditem=0;
			  incube=1;
                        for (xi=ix; xi<ix+itemslotsw; xi+=1){
                            for (xc=iy; xc<iy+itemslotsh; xc+=1){
                                argument3.slot[xi,xc]=1;
                            }
                        }
			  exit;
                }
            }
        }
	}
if (sound_exists(argument2) && !sound_isplaying(argument2)){sound_play(argument2);}
if (frame=sprite_get_number(ongroundsprite)-1){frame=0;}
}
#define inv_cube_draw
if (open=1){
var i,c;
if (argument2>0){
for (i=0; i<xslots; i+=1){
    for (c=0; c<yslots; c+=1){
        if (slot[i,c]=0){
        draw_sprite_ext(argument0,-1,argument3+i*celldim,argument4+c*celldim,1,1,0,c_white,argument2)}
        else{draw_sprite_ext(argument1,-1,argument3+i*celldim,argument4+c*celldim,1,1,0,c_white,argument2)}
    }
}
}
if (inventoryx!=argument3 or inventoryy!=argument4){
inventoryx=argument3;
inventoryy=argument4;
with (argument5){
	if (xat!=-1 && incube=1){
	x=argument3+xat;
	y=argument4+yat;
	}
}
}
}
#define inv_cube_true
var found;
found = false;
for (i=0; i<items; i+=1){
  if (item[i,0]=argument0 && item[i,1]=argument1){
      found = true;
      break;
  }
}
return found
#define inv_cube_itemlist
items=string_count("|",argument0);
var text;
text=argument0;

for (i=0; i<items; i+=1){
    item[i,0]=string_copy(text,1,string_pos("|",text)-1);
    item[i,1]=0;
    text=string_delete(text,1,string_pos("|",text));
}

for (i=0; i<items; i+=1){
    for (c=0; c<items; c+=1){
        if (item[i,0]=item[c,0]){
            item[i,1]+=1;
        }
    }
}
return items;
#define inv_create
var i;
yslots=argument1;
xslots=argument0;
inventoryx=argument2;
inventoryy=argument3;
selecteditem=0;
celldim=argument4;
pickup_sound=argument5;
cube=argument6;
open=0;

for (i=0; i<=xslots; i+=1)
    {
    for (c=0; c<=yslots; c+=1)
    {
        slot[i,c]=0;
    }
}
#define inv_draw
if (open=1){
var i,c;
if (argument2>0){
for (i=0; i<xslots; i+=1){
    for (c=0; c<yslots; c+=1){
        if (slot[i,c]=0){
        draw_sprite_ext(argument0,-1,argument3+i*celldim,argument4+c*celldim,1,1,0,c_white,argument2)}
        else{draw_sprite_ext(argument1,-1,argument3+i*celldim,argument4+c*celldim,1,1,0,c_white,argument2)}
    }
}
}
if (inventoryx!=argument3 or inventoryy!=argument4){
inventoryx=argument3;
inventoryy=argument4;
with (argument5){
	if (xat!=-1 && incube=0){
	x=argument3+xat;
	y=argument4+yat;
	}
}
}
}
if (selecteditem!=0){
	argument6.object=selecteditem;
	argument6.sprite=selecteditem.sprite;
}else{
	argument6.sprite=-1;
	argument6.object=-1;
}
depthobject=argument6;
with (argument6){
if (!variable_local_exists("inventory_object")){inventory_object=other.id;}
}
#define inv_change_size
var i,c;
for (i=0; i<=argument0; i+=1)
{
    for (c=0; c<=argument1; c+=1)
    {
        if (i>xslots or c>yslots){slot[i,c]=0;}
    }
}
xslots=argument0;
yslots=argument1;
#define inv_open
open=argument0;
#define inv_action
var i,c,xc,xi,xq,xw,justpicked;
justpicked=0;
justdropped=0;
if (selecteditem=0){
        with (argument1){
    if (undermouse=1){
	  if ((argument0.open=1 && incube=0) or (argument0.cube.open=1 && incube=1)){
		if (incube=0){
                for (i=floor((x-argument0.inventoryx)/argument0.celldim); i<floor((x-argument0.inventoryx)/argument0.celldim+itemslotsw); i+=1){
                    for (c=floor((y-argument0.inventoryy)/argument0.celldim); c<floor((y-argument0.inventoryy)/argument0.celldim+itemslotsh); c+=1){
                        if (i<argument0.xslots && c<argument0.yslots && i>=0 && c>=0){
                                            argument0.slot[i,c]=0;
		            }
	               }
	          }
		}else if (incube=1){
	           for (i=floor((x-argument0.cube.inventoryx)/argument0.cube.celldim); i<floor((x-argument0.cube.inventoryx)/argument0.cube.celldim+itemslotsw); i+=1){
                    for (c=floor((y-argument0.cube.inventoryy)/argument0.cube.celldim); c<floor((y-argument0.cube.inventoryy)/argument0.cube.celldim+itemslotsh); c+=1){
                        if (i<argument0.cube.xslots && c<argument0.cube.yslots && i>=0 && c>=0){
                                            argument0.cube.slot[i,c]=0;
		            }
	               }
	          }
            incube=0;
		}
	   if (equiped!=-1){
	     equiped.item=-1;
	     equiped=-1;
	    }
                argument0.selecteditem=self.id;  
                selected=1;
                justpicked=1;
		    if (sound_exists(other.pickup_sound) && other.pickup_sound!=0){sound_play(other.pickup_sound);}
            }
        }
    }
}
else if (selecteditem!=0){
if (mouse_x>inventoryx && mouse_y>inventoryy && mouse_x<inventoryx+(xslots*argument0.celldim) && mouse_y<inventoryy+(yslots*celldim) && open=1) {
        impossible=0;
                for (xi=floor((selecteditem.x-inventoryx)/celldim); xi<floor((selecteditem.x-inventoryx)/celldim+selecteditem.itemslotsw); xi+=1){
                        for (xc=floor((selecteditem.y-inventoryy)/celldim); xc<floor((selecteditem.y-inventoryy)/celldim+selecteditem.itemslotsh); xc+=1){
                                if (xi>=xslots or xc>=yslots){
                                    impossible=1;
                                }
		                    if (xi<0 or xc<0){
                                    impossible=1;
		                    }                  
		                    if (xi<xslots && xc<yslots && xi>-1 && xc>-1){
                                    if (slot[xi,xc]=1){
                                        impossible=1;
                                    }
                                }
                       }
                }
        if (impossible=0){
                var scriptix, scriptiy, scriptimposible;
                for (scriptix=floor((selecteditem.x-inventoryx)/celldim); scriptix<floor((selecteditem.x-inventoryx)/celldim+selecteditem.itemslotsw); scriptix+=1){
                    for (scriptiy=floor((selecteditem.y-inventoryy)/celldim); scriptiy<floor((selecteditem.y-inventoryy)/celldim+selecteditem.itemslotsh); scriptiy+=1){
                        if (scriptix>-1 && scriptiy>-1 && scriptix<xslots && scriptiy<yslots){
                            if (slot[scriptix,scriptiy]=1){
                                scriptimposible=1;
                                break;
                            }
                        }
                    }
                }
                selecteditem.x=inventoryx+(scriptix-selecteditem.itemslotsw)*celldim;
                selecteditem.y=inventoryy+(scriptiy-selecteditem.itemslotsh)*celldim;
	          selecteditem.xat=selecteditem.x-inventoryx;
	          selecteditem.yat=selecteditem.y-inventoryy;
	          if (sound_exists(selecteditem.dropped_sound)){sound_play(selecteditem.dropped_sound);}
                	for (xq=floor((selecteditem.x-inventoryx)/celldim); xq<floor((selecteditem.x-inventoryx)/celldim+selecteditem.itemslotsw); xq+=1){
                  	for (xw=floor((selecteditem.y-inventoryy)/celldim); xw<floor((selecteditem.y-inventoryy)/celldim+selecteditem.itemslotsh); xw+=1){
		     			if (xq>-1 && xw>-1 && xq<xslots && xw<yslots){
                        	 	slot[xq,xw]=1;
		     			}
                    	}
                	}
                selecteditem.selected=0;
                selecteditem=0;
	  }
}else if (mouse_x<inventoryx or mouse_y<inventoryy or mouse_x>inventoryx+(xslots*celldim) or mouse_y>inventoryy+(yslots*celldim)){
	with (cube){
		if (mouse_x>inventoryx && mouse_y>inventoryy && mouse_x<inventoryx+xslots*celldim && mouse_y<inventoryy+yslots*celldim && open=1){
            impossible=0
                for (xi=floor((other.selecteditem.x-inventoryx)/celldim); xi<floor((other.selecteditem.x-inventoryx)/celldim+other.selecteditem.itemslotsw); xi+=1){
                        for (xc=floor((other.selecteditem.y-inventoryy)/celldim); xc<floor((other.selecteditem.y-inventoryy)/celldim+other.selecteditem.itemslotsh); xc+=1){
                                if (xi>=xslots or xc>=yslots){
                                    impossible=1;
                                }
		                    if (xi<0 or xc<0){
                                    impossible=1;
		                    }                  
		                    if (xi<xslots && xc<yslots && xi>-1 && xc>-1){
                                    if (slot[xi,xc]=1){
                                        impossible=1;
                                    }
                                }
                       }
                }
        if (impossible=0){
                var scriptix, scriptiy, scriptimposible;
                for (scriptix=floor((other.selecteditem.x-inventoryx)/celldim); scriptix<floor((other.selecteditem.x-inventoryx)/celldim+other.selecteditem.itemslotsw); scriptix+=1){
                    for (scriptiy=floor((other.selecteditem.y-inventoryy)/celldim); scriptiy<floor((other.selecteditem.y-inventoryy)/celldim+other.selecteditem.itemslotsh); scriptiy+=1){
                        if (scriptix>-1 && scriptiy>-1 && scriptix<xslots && scriptiy<yslots){
                            if (slot[scriptix,scriptiy]=1){
                                scriptimposible=1;
                                break;
                            }
                        }
                    }
                }
                other.selecteditem.x=inventoryx+(scriptix-other.selecteditem.itemslotsw)*celldim;
                other.selecteditem.y=inventoryy+(scriptiy-other.selecteditem.itemslotsh)*celldim;
	          other.selecteditem.xat=other.selecteditem.x-inventoryx;
	          other.selecteditem.yat=other.selecteditem.y-inventoryy;
                other.selecteditem.incube=1;
	          if (sound_exists(other.selecteditem.dropped_sound)){sound_play(other.selecteditem.dropped_sound);}
                for (xq=floor((other.selecteditem.x-inventoryx)/celldim); xq<floor((other.selecteditem.x-inventoryx)/celldim+other.selecteditem.itemslotsw); xq+=1){
                  	for (xw=floor((other.selecteditem.y-inventoryy)/celldim); xw<floor((other.selecteditem.y-inventoryy)/celldim+other.selecteditem.itemslotsh); xw+=1){
		     if (xq>-1 && xw>-1 && xq<xslots && xw<yslots){
                        	 slot[xq,xw]=1;
		     }
                    	}
                }
                other.selecteditem.selected=0;
                other.selecteditem=0;
	  }
}
}
	with (argument5){
		if (mouse_x>eqx && mouse_y>eqy && mouse_x<eqx+width && mouse_y<eqy+height){
			if (argument0.selecteditem.type=type && argument0.selecteditem.returns2=1){
			    var tmp;
			    tmp=item;
			    argument0.selecteditem.selected=0;
			    argument0.selecteditem.x=eqx+(width/2)-(sprite_get_width(argument0.selecteditem.sprite)/2);
			    argument0.selecteditem.y=eqy+(height/2)-(sprite_get_height(argument0.selecteditem.sprite)/2);
		    	    argument0.selecteditem.xat=-1;
                	    argument0.selecteditem.yat=-1;
			    if (sound_exists(argument0.selecteditem.dropped_sound)){sound_play(argument0.selecteditem.dropped_sound);}
		    	    item=argument0.selecteditem;
		    	    argument0.selecteditem.equiped=self.id;
                	    if (tmp!=-1){argument0.selecteditem=tmp; argument0.selecteditem.selected=1; argument0.selecteditem.equiped=-1;}else{argument0.selecteditem=0;}
			}else if (argument0.selecteditem.returns2=0 && !sound_isplaying(cant_use_sound)){sound_play(cant_use_sound);}
		exit;
		}
	}
}
if (variable_local_exists("zones") && open=1){
	for (i=0; i<ds_grid_height(zones); i+=1;){
		if (ds_grid_get(zones,5,i)=1){
			if (mouse_x>ds_grid_get(zones,0,i) && mouse_y>ds_grid_get(zones,1,i) && mouse_x<ds_grid_get(zones,0,i)+ds_grid_get(zones,2,i) && mouse_y<ds_grid_get(zones,1,i)+ds_grid_get(zones,3,i)){
				exit;
			}
		}
	}
}
}
if (selecteditem!=0 && justpicked=0){
		    selecteditem.selected=0;
		    selecteditem.x=argument3;
		    selecteditem.y=argument4;
		    depthobject.itemobject=-1;
		    selecteditem.frame=0;
		    if (selecteditem.drop_code!=""){execute_string(selecteditem.drop_code);}
		    with (selecteditem){
		         	instance_change(argument2,false);
				justdropped=1;
		    }
                selecteditem=0;
}
#define inv_fit_draw
if (argument0.open=1){
if (variable_local_exists("object")=false){
	if (selecteditem!=0){
	if (selecteditem.alpha>0){
	draw_set_alpha(argument1);
        if (mouse_x>inventoryx && mouse_x<inventoryx+xslots*celldim && mouse_y>inventoryy && mouse_y<inventoryy+yslots*celldim){
                for (i=floor((mouse_x-inventoryx)/celldim); i<floor((mouse_x-inventoryx)/celldim+selecteditem.itemslotsw); i+=1){
                    for (c=floor((mouse_y-inventoryy)/celldim); c<floor((mouse_y-inventoryy)/celldim+selecteditem.itemslotsh); c+=1){
                        if (i<xslots && c<yslots && c>0 && i>0 && selecteditem.fittype=0){
                            if (slot[i,c]=0)
                            {
                            draw_set_color(argument2);
                            }else
                            {
                            draw_set_color(argument3);
                            }
					draw_rectangle(inventoryx+i*celldim,inventoryy+c*celldim,inventoryx+i*celldim+celldim,inventoryy+c*celldim+celldim,0);
                        }else if (i<xslots && c<yslots  && selecteditem.fittype=1){
                            if (slot[i,c]=0)
                            {
                            draw_sprite_ext(argument4,-1,inventoryx+i*celldim,inventoryy+c*celldim,1,1,0,c_white,argument1);
                            }else
                            {
                            draw_sprite_ext(argument5,-1,inventoryx+i*celldim,inventoryy+c*celldim,1,1,0,c_white,argument1);
                            }
				}
                    }
		    }
        }
      }
}
}else if (variable_local_exists("object")){
	if (object!=-1){
		if (object.alpha>0){
	draw_set_alpha(argument1);
        if (mouse_x>argument0.inventoryx && mouse_x<argument0.inventoryx+argument0.xslots*argument0.celldim && mouse_y>argument0.inventoryy && mouse_y<argument0.inventoryy+argument0.yslots*argument0.celldim){
                for (i=floor((mouse_x-argument0.inventoryx)/argument0.celldim); i<floor((mouse_x-argument0.inventoryx)/argument0.celldim+object.itemslotsw); i+=1){
                    for (c=floor((mouse_y-argument0.inventoryy)/argument0.celldim); c<floor((mouse_y-argument0.inventoryy)/argument0.celldim+object.itemslotsh); c+=1){
                        if (i<argument0.xslots && c<argument0.yslots && i>-1 && c>-1 && object.fittype=0){
                            if (argument0.slot[i,c]=0)
                            {
					draw_set_color(argument2);
                            }
                            else
                            {
                            draw_set_color(argument3);
                            }
                            draw_rectangle(argument0.inventoryx+i*argument0.celldim,argument0.inventoryy+c*argument0.celldim,argument0.inventoryx+i*argument0.celldim+argument0.celldim,argument0.inventoryy+c*argument0.celldim+argument0.celldim,0);
                        }else if (i<argument0.xslots && c<argument0.yslots  && object.fittype=1){
                            if (argument0.slot[i,c]=0)
                            {
                            draw_sprite_ext(argument4,-1,argument0.inventoryx+i*argument0.celldim,argument0.inventoryy+c*argument0.celldim,1,1,0,c_white,argument1);
                            }else
                            {
                            draw_sprite_ext(argument5,-1,argument0.inventoryx+i*argument0.celldim,argument0.inventoryy+c*argument0.celldim,1,1,0,c_white,argument1);
                            }
				}
			   }
		    }
        }
      }
}
}
}
//cube
var cube;
if (instance_exists(argument0.cube) && argument0.cube!=argument0){
cube=argument0.cube
if (cube.open=1){
if (!variable_local_exists("object")){
	if (argument0.selecteditem!=0){
	if (argument0.selecteditem.alpha>0){
	draw_set_alpha(argument1);
        if (mouse_x>cube.inventoryx && mouse_x<cube.inventoryx+cube.xslots*cube.celldim && mouse_y>cube.inventoryy && mouse_y<cube.inventoryy+cube.yslots*cube.celldim){
                for (i=floor((mouse_x-cube.inventoryx)/cube.celldim); i<floor((mouse_x-cube.inventoryx)/cube.celldim+argument0.selecteditem.itemslotsw); i+=1){
                    for (c=floor((mouse_y-cube.inventoryy)/cube.celldim); c<floor((mouse_y-cube.inventoryy)/cube.celldim+argument0.selecteditem.itemslotsh); c+=1){
                        if (i<cube.xslots && c<cube.yslots && c>0 && i>0 && argument0.selecteditem.fittype=0){
                            if (cube.slot[i,c]=0)
                            {
                            draw_set_color(argument2);
                            }else
                            {
                            draw_set_color(argument3);
                            }
					draw_rectangle(cube.inventoryx+i*cube.celldim,cube.inventoryy+c*cube.celldim,cube.inventoryx+i*cube.celldim+cube.celldim,cube.inventoryy+c*cube.celldim+cube.celldim,0);
                        }else if (i<cube.xslots && c<cube.yslots  && argument0.selecteditem.fittype=1){
                            if (cube.slot[i,c]=0)
                            {
                            draw_sprite_ext(argument4,-1,cube.inventoryx+i*cube.celldim,cube.inventoryy+c*cube.celldim,1,1,0,c_white,argument1);
                            }else
                            {
                            draw_sprite_ext(argument5,-1,cube.inventoryx+i*cube.celldim,cube.inventoryy+c*cube.celldim,1,1,0,c_white,argument1);
                            }
				}
                    }
		    }
        }
      }
}
}else if (variable_local_exists("object")){
	if (object!=-1){
	if (object.alpha>0){
	draw_set_alpha(argument1);
        if (mouse_x>cube.inventoryx && mouse_x<cube.inventoryx+cube.xslots*cube.celldim && mouse_y>cube.inventoryy && mouse_y<cube.inventoryy+cube.yslots*cube.celldim){
                for (i=floor((mouse_x-cube.inventoryx)/cube.celldim); i<floor((mouse_x-cube.inventoryx)/cube.celldim+object.itemslotsw); i+=1){
                    for (c=floor((mouse_y-cube.inventoryy)/cube.celldim); c<floor((mouse_y-cube.inventoryy)/cube.celldim+object.itemslotsh); c+=1){
                        if (i<cube.xslots && c<cube.yslots && i>-1 && c>-1 && object.fittype=0){
                            if (cube.slot[i,c]=0)
                            {
					draw_set_color(argument2);
                            }
                            else
                            {
                            	draw_set_color(argument3);
                            }
                            draw_rectangle(cube.inventoryx+i*cube.celldim,cube.inventoryy+c*cube.celldim,cube.inventoryx+i*cube.celldim+cube.celldim,cube.inventoryy+c*cube.celldim+cube.celldim,0);
                        }else if (i<cube.xslots && c<cube.yslots  && object.fittype=1){
                            if (cube.slot[i,c]=0)
                            {
                            draw_sprite_ext(argument4,-1,cube.inventoryx+i*cube.celldim,cube.inventoryy+c*cube.celldim,1,1,0,c_white,argument1);
                            }else
                            {
                            draw_sprite_ext(argument5,-1,cube.inventoryx+i*cube.celldim,cube.inventoryy+c*cube.celldim,1,1,0,c_white,argument1);
                            }
				}
			   }
		    }
        }
      }
}
}
}
}
#define inv_info_draw
if (variable_local_exists("itemobject")){
if (itemobject!=-1){
if (itemobject.undermouse && (argument3.open=1 && itemobject.incube=0) or (argument3.cube.open=1 && itemobject.incube=1)){
reqnum=0;
req_longestline=0;
with (itemobject){
var var01, var02, var03;
	for (i=0; i<ds_grid_height(reqs)-1; i+=1){
		var01=ds_grid_get(reqs,0,i);
		var02=ds_grid_get(reqs,1,i);
		var03=ds_grid_get(reqs,2,i);
		if (var03=0){
			if (var01<var02)
				{
				other.reqnum+=1;
				if (string_width(ds_grid_get(reqs,4,i))>other.req_longestline){other.req_longestline=string_width(ds_grid_get(reqs,4,i));}
				}
		}
		if (var03=1){
			if (var01>var02)
				{
				other.reqnum+=1;
				if (string_width(ds_grid_get(reqs,4,i))>other.req_longestline){other.req_longestline=string_width(ds_grid_get(reqs,4,i));}
				}
		}
		if (var03=2){
			if (var01!=var02)
				{
				other.reqnum+=1;
				if (string_width(ds_grid_get(reqs,4,i))>other.req_longestline){other.req_longestline=string_width(ds_grid_get(reqs,4,i));}
				}
		}
	}
}
var linetouse;
if (req_longestline>itemobject.longestline){linetouse=req_longestline;}else{linetouse=itemobject.longestline;}
iy=iy-(reqnum*16);
if (ix+linetouse+10>view_xview[0]+view_wview[0]){ix=(view_xview[0]+view_wview[0])-(linetouse+10);}
if (ix<view_xview[0]){ix=view_xview[0];}
if ((ds_grid_height(itemobject.lines)-1)*16>view_yview[0]+view_hview[0]){iy=(view_yview[0]+view_hview[0])-(ds_grid_height(itemobject.lines)-1)*16;}
if (iy<view_yview[0]-16){iy=view_yview[0]-16;}
var i;
if (itemobject.undermouse && inventoryobject.selecteditem=0 && ds_grid_height(itemobject.lines)-1>0){
draw_set_color(backcolor);
draw_set_alpha(backalpha);
draw_rectangle(ix,iy+16,ix+linetouse+10,iy+16+((reqnum+ds_grid_height(itemobject.lines)-1)*16)+2,0);
if (argument0){
draw_set_alpha(argument2);
draw_set_color(argument1);
draw_rectangle(ix,iy+16,ix+linetouse+10,iy+16+((reqnum+ds_grid_height(itemobject.lines)-1)*16)+2,1);
}
var const;
const=0;
draw_set_alpha(textalpha);
for (i=0; i<ds_grid_height(itemobject.lines)-1; i+=1){
    draw_set_color(ds_grid_get(itemobject.lines,1,i));
    draw_set_font(ds_grid_get(itemobject.lines,2,i));
    draw_text(ix+5,iy+16+(i*16),ds_grid_get(itemobject.lines,0,i));
    const+=16;
}
with (itemobject){
var var01, var02, var03;
	for (i=0; i<ds_grid_height(reqs)-1; i+=1){
		var01=ds_grid_get(reqs,0,i);
		var02=ds_grid_get(reqs,1,i);
		var03=ds_grid_get(reqs,2,i);
		if (var03=0){
			if (var01<var02)
				{
				draw_set_color(ds_grid_get(reqs,5,i));
				with (other){
				draw_text(ix+5,iy+16+const,ds_grid_get(other.reqs,4,i));
				const+=16;
				}
				}
		}
		if (var03=1){
			if (var01>var02)
				{
				draw_set_color(ds_grid_get(reqs,5,i));
				with (other){
				draw_text(ix+5,iy+16+const,ds_grid_get(other.reqs,4,i));
				const+=16;
				}
				}
		}
		if (var03=2){
			if (var01!=var02)
				{
				draw_set_color(ds_grid_get(reqs,5,i));
				with (other){
				draw_text(ix+5,iy+16+const,ds_grid_get(other.reqs,4,i));
				const+=16;
				}
				}
		}
	}
}
draw_set_color(c_black);
}
}
}
}
#define inv_pick_up
var i;
if (argument0.selecteditem=0){
with (argument0){
	if (variable_local_exists("zones")){ 
		for (i=0; i<ds_grid_height(zones); i+=1;){
			if (ds_grid_get(zones,5,i)=1){
				if (mouse_x>ds_grid_get(zones,0,i) && mouse_y>ds_grid_get(zones,1,i) && mouse_x<ds_grid_get(zones,0,i)+ds_grid_get(zones,2,i) && mouse_y<ds_grid_get(zones,1,i)+ds_grid_get(zones,3,i)){
					exit;
				}
			}
		}
	}
}
var ix,iy, lb;
    for (ix=0; ix<argument0.xslots; ix+=1){
        for (iy=0; iy<argument0.yslots; iy+=1){
            if (argument0.slot[ix,iy]=0){
                var scriptix, scriptiy, scriptimposible;
                scriptimposible=-1
                if (ix+itemslotsw>argument0.xslots or iy+itemslotsh>argument0.yslots){scriptimposible=1;}
                for (scriptix=ix; scriptix<ix+itemslotsw; scriptix+=1){
                    for (scriptiy=iy; scriptiy<iy+itemslotsh; scriptiy+=1){
                        if (scriptix<argument0.xslots && scriptiy<argument0.yslots){
                            if (argument0.slot[scriptix,scriptiy]=1){
                                scriptimposible=1;
                                break;
                            }
                        }
                    }
                }
                if (scriptimposible!=1){scriptimposible=0;}
                if (scriptimposible=0){returnn = true;}else
			{
			returnn = false;
			}
                if (returnn=true){
			  if (argument0.open=0){
                       if (variable_local_exists("stock")){
                          var test;
                          for (lb=0; lb<inv_count_item(argument1,name); lb+=1){
                            test=inv_get_item(argument1,name,lb);
                            if (test!=-1 && test!=self.id){
                                if (test.stock[1]+stock[1]<=test.stock[0])
                                {
                                test.stock[1]+=stock[1];
                                on_ground_selected=0;
                                fittype=0;
                                selected=0;
                                if (sound_exists(argument0.pickup_sound) && argument0.pickup_sound!=0){sound_play(argument0.pickup_sound);}
                                instance_destroy();
                                if (pick_up_code!=""){execute_string(pick_up_code);}
                                exit;
                                }else{
                                stock[1]+=test.stock[1]-test.stock[0];
                                test.stock[1]=test.stock[0];
                                }
                            }
                          }
                       }
			     x=argument0.inventoryx+ix*argument0.celldim;
			     y=argument0.inventoryy+iy*argument0.celldim;
			     xat=x-argument0.inventoryx;
			     yat=y-argument0.inventoryy;
                       inventoryobject=argument0;
			     on_ground_selected=0;
			     fittype=0;
		    	     if (sound_exists(argument0.pickup_sound) && argument0.pickup_sound!=0){sound_play(argument0.pickup_sound);}
			     instance_change(argument1,true);
			     if (pick_up_code!=""){execute_string(pick_up_code);}
			     selected=0;
                       for (xi=ix; xi<ix+itemslotsw; xi+=1){
                            for (xc=iy; xc<iy+itemslotsh; xc+=1){
                                argument0.slot[xi,xc]=1;
                            }
                       }
    			  exit;
                    }
                }
            }
        }
	}
if (argument0.open=1){
        inventoryobject=argument0;
	  xat=argument0.inventoryx;
	  yat=argument0.inventoryy;
	  selected=1;
	  fittype=0;
	  on_ground_selected=0;
	  argument0.selecteditem=self.id;
	  instance_change(argument1,true);
	  if (pick_up_code!=""){execute_string(pick_up_code);}
        if (sound_exists(argument0.pickup_sound) && argument0.pickup_sound!=0){sound_play(argument0.pickup_sound);}
        exit;
}
if (sound_exists(argument2) && !sound_isplaying(argument2)){sound_play(argument2);}
if (frame=sprite_get_number(ongroundsprite)-1){frame=0;}
}
#define inv_dropped_draw
if (frame<sprite_get_number(ongroundsprite)-1){frame+=1;}
if (frame=sprite_get_number(ongroundsprite)-3 && sound_exists(dropped_sound)){sound_play(dropped_sound);}
if (frame=1 && sound_exists(drop_sound)){sound_play(drop_sound);}
draw_sprite_ext(ongroundsprite,frame,x,y,1,1,0,argument1,argument0);
#define inv_dropped_select
if (argument0=1 && on_ground_selected=0){
with (argument1){
    on_ground_selected=0;
}
}
on_ground_selected=argument0;
#define inv_dropped_create
selected=0;
itemslotsw=argument1;
itemslotsh=argument2;
name=argument0;
sprite=argument4;
ongroundsprite=argument3;
type=argument5;
equiped=-1;
returns2=0;
undermouse=0;
frame=0;
on_ground_selected=0;
incube=0;

drop_sound=argument6;
dropped_sound=argument7;
drop_code=argument9;
pick_up_code=argument8;
#define inv_item_stock
if (argument2=0){
    if (variable_local_exists("stock[0]")=false && variable_local_exists("stock[1]")=false)
    {
        if (argument0<1){stock[0]=1;}else{stock[0]=argument0;}
        stock[1]=argument1;
    }
}
else if (argument2=1){
    stock[1]+=argument1;
    if (stock[1]<0){stock[1]=0;}
}else if (argument2=2){
    return stock[1];
}
#define inv_picked_draw
if ((inventoryobject.open=1 && incube=0) or (inventoryobject.cube.open=1 && incube=1)){
if (mouse_x>x && mouse_x<x+itemslotsw*inventoryobject.celldim && mouse_y>y && mouse_y<y+itemslotsh*inventoryobject.celldim && inventoryobject.selecteditem=0){
undermouse=1;
if (variable_local_exists("stock")){inv_info_change("stock",argument5+string(stock[1]));}
}
else if (mouse_x>x && mouse_x<x+itemslotsw*inventoryobject.celldim && mouse_y>y && mouse_y<y+itemslotsh*inventoryobject.celldim && inventoryobject.selecteditem!=0){undermouse=2;}
else{undermouse=0;}
fittype=argument2;
if (equiped=-1){
returns2=1;
var var01, var02, var03;
	for (i=0; i<ds_grid_height(reqs)-1; i+=1){
		var01=ds_grid_get(reqs,0,i);
		var02=ds_grid_get(reqs,1,i);
		var03=ds_grid_get(reqs,2,i);
		if (var03=0){
			if (var01<var02){returns2=0;}
		}
		if (var03=1){
			if (var01>var02){returns2=0;}
		}
		if (var03=2){
			if (var01!=var02){returns2=0;}
		}
	}
if (returns2=0 && selected=0){
if (undermouse=0 or undermouse=2){
draw_set_color(argument3);
draw_set_alpha(argument4);
draw_rectangle(x,y,x+itemslotsw*argument0.celldim,y+itemslotsh*argument0.celldim,0);
}
}
}
if (variable_local_exists("sprite") && selected=0){draw_sprite_ext(sprite,-1,x+argument8,y+argument9,1,1,argument6,argument7,argument1);}
}
if (selected=1){
x=mouse_x;
y=mouse_y;
}
#define inv_selected_draw
if ((inventoryobject.open=1 && incube=0) or (inventoryobject.cube.open=1 && incube=1)){
    if (undermouse=1 && argument1!=0){
        if (inventoryobject.selecteditem=0){draw_set_color(argument0);}
        draw_set_alpha(argument1);
        if (equiped=-1){draw_rectangle(x,y,x+itemslotsw*inventoryobject.celldim,y+itemslotsh*inventoryobject.celldim,0);}
        else {draw_rectangle(equiped.eqx,equiped.eqy,equiped.eqx+equiped.width,equiped.eqy+equiped.height,0);}
    }else if (argument3!=0 && equiped=-1)
    {
	   if ((undermouse=0 or undermouse=2) && returns2=1 && inventoryobject.selecteditem!=self.id)
	   {
	   draw_set_alpha(argument3);
	   draw_set_color(argument2);
	   draw_rectangle(x,y,x+itemslotsw*inventoryobject.celldim,y+itemslotsh*inventoryobject.celldim,0);
	   }
    }
}
#define inv_item_remove
with (argument1){
    for (i=floor((x-argument0.inventoryx)/argument0.celldim); i<floor((x-argument0.inventoryx)/argument0.celldim+itemslotsw); i+=1){
        for (c=floor((y-argument0.inventoryy)/argument0.celldim); c<floor((y-argument0.inventoryy)/argument0.celldim+itemslotsh); c+=1){
            if (i<argument0.xslots && c<argument0.yslots && i>=0 && c>=0){
                   argument0.slot[i,c]=0;
            }
        }
    }
}
inventoryobject.depthobject.itemobject=-1;
#define inv_place_item_in_inv
if (argument4=1){
var xi,xc;
x=argument0.inventoryx+argument1*argument0.celldim;
y=argument0.inventoryy+argument2*argument0.celldim;
xat=x-argument0.inventoryx;
yat=y-argument0.inventoryy;
inventoryobject=argument0;
instance_change(argument3,true);
selected=0;
for (xi=argument1; xi<argument1+itemslotsw; xi+=1){
    for (xc=argument2; xc<argument2+itemslotsh; xc+=1){
        argument0.slot[xi,xc]=1;
    }
}
}
if (argument4=2){
var ix,iy;
    for (ix=0; ix<argument0.xslots; ix+=1){
        for (iy=0; iy<argument0.yslots; iy+=1){
            if (argument0.slot[ix,iy]=0){
                var scriptix, scriptiy, scriptimposible;
                scriptimposible=-1
                if (ix+itemslotsw>argument0.xslots or iy+itemslotsh>argument0.yslots){scriptimposible=1;}
                for (scriptix=ix; scriptix<ix+itemslotsw; scriptix+=1){
                    for (scriptiy=iy; scriptiy<iy+itemslotsh; scriptiy+=1){
                        if (scriptix<argument0.xslots && scriptiy<argument0.yslots){
                            if (argument0.slot[scriptix,scriptiy]=1){
                                scriptimposible=1;
                                break;
                            }
                        }
                    }
                }
                if (scriptimposible!=1){scriptimposible=0;}
                if (scriptimposible=0){returnn = true;}else
			{
			returnn = false;
			}
               if (returnn=true){
			x=argument0.inventoryx+ix*argument0.celldim;
			y=argument0.inventoryy+iy*argument0.celldim;
			xat=x-argument0.inventoryx;
			yat=y-argument0.inventoryy;
            	  	inventoryobject=argument0;
			instance_change(argument3,true);
			selected=0;
                        for (xi=ix; xi<ix+itemslotsw; xi+=1){
                            for (xc=iy; xc<iy+itemslotsh; xc+=1){
                                argument0.slot[xi,xc]=1;
                            }
                        }
		exit;
                }
            }
    }
    }
}
#define inv_equipment_draw
if (argument6=1){
if (item=-1 && argument3>0){draw_sprite_ext(argument0,0,argument1,argument2,1,1,0,c_white,argument3);}else{draw_sprite_ext(argument0,1,argument1,argument2,1,1,0,c_white,argument3);}
if (!variable_local_exists("height")){
height=argument5;
width=argument4;
}
if (argument1!=eqx or argument2!=eqy){
eqx=argument1;
eqy=argument2;
if (item!=-1){
	item.x=eqx+(width/2)-(sprite_get_width(item.sprite)/2);
	item.y=eqy+(height/2)-(sprite_get_height(item.sprite)/2);
}
}
}
#define inv_equipment_create
eqx=argument0;
eqy=argument1;
type=argument2;
cant_use_sound=argument3;
inventory_object=argument4;
item=-1;
#define inv_requirement_update
for (i=0; i<ds_grid_height(reqs); i+=1){
if (string(ds_grid_get(reqs,3,i))=string(argument0)){
ds_grid_set(reqs,0,i,argument1);
}
}
#define inv_requirement_add
if (!variable_local_exists("reqs")){reqs=ds_grid_create(6,1);}
if (reqs=0){reqs=ds_grid_create(6,1);}
ds_grid_set(reqs,0,ds_grid_height(reqs)-1,argument0);
ds_grid_set(reqs,1,ds_grid_height(reqs)-1,argument1);
ds_grid_set(reqs,2,ds_grid_height(reqs)-1,argument2); 
ds_grid_set(reqs,3,ds_grid_height(reqs)-1,string(argument3));
ds_grid_set(reqs,4,ds_grid_height(reqs)-1,argument4);
ds_grid_set(reqs,5,ds_grid_height(reqs)-1,argument5);
ds_grid_resize(reqs,6,ds_grid_height(reqs)+1);
#define inv_nodropzone_add
if (!variable_local_exists("zones")){zones=ds_grid_create(6,1);}
if (zones=0){zones=ds_grid_create(6,1);}
ds_grid_set(zones,0,ds_grid_height(zones)-1,argument0);
ds_grid_set(zones,1,ds_grid_height(zones)-1,argument1);
ds_grid_set(zones,2,ds_grid_height(zones)-1,argument2);
ds_grid_set(zones,3,ds_grid_height(zones)-1,argument3);
ds_grid_set(zones,4,ds_grid_height(zones)-1,argument4);
ds_grid_set(zones,5,ds_grid_height(zones)-1,argument5);
ds_grid_resize(zones,6,ds_grid_height(zones)+1);
#define inv_nodropzone_update
ds_grid_set(zones,0,argument4,argument0);
ds_grid_set(zones,1,argument4,argument1);
ds_grid_set(zones,2,argument4,argument2);
ds_grid_set(zones,3,argument4,argument3);
ds_grid_set(zones,5,argument4,argument5);
#define inv_info_set
if (undermouse=1 && argument5.selecteditem=0 && lines>0){
if ((argument5.open=1 && incube=0) or (argument5.cube.open=1 && incube=1)){
argument5.depthobject.ix=argument0;
argument5.depthobject.iy=argument1;
argument5.depthobject.backalpha=argument2;
argument5.depthobject.backcolor=argument3;
argument5.depthobject.textalpha=argument4;
argument5.depthobject.inventoryobject=argument5;
argument5.depthobject.itemobject=self.id;
}
}
#define inv_info_add_line
if (!variable_local_exists("lines")){lines=ds_grid_create(4,1);}
if (lines=0){lines=ds_grid_create(4,1);}
ds_grid_set(lines,0,ds_grid_height(lines)-1,argument0);
ds_grid_set(lines,1,ds_grid_height(lines)-1,argument1);
ds_grid_set(lines,2,ds_grid_height(lines)-1,argument2);
ds_grid_set(lines,3,ds_grid_height(lines)-1,argument3);
ds_grid_resize(lines,4,ds_grid_height(lines)+1);
draw_set_font(argument2);
if (!variable_local_exists("longestline")){longestline=0;}
if (string_width(argument0)>longestline){longestline=string_width(argument0);}
#define inv_info_change
for (i=0; i<ds_grid_height(lines); i+=1){
    if (string(ds_grid_get(lines,3,i))=string(argument0)){
        ds_grid_set(lines,0,i,argument1);
        if (string_width(argument1)>longestline){longestline=string_width(argument1);}
    }
}
#define inv_name_create
surf=surface_create(string_width(argument0)+10,string_height("M"));
surface_set_target(surf);
draw_clear_alpha(c_white,0);
draw_set_alpha(argument5);
draw_set_color(argument3);
draw_rectangle(0,0,string_width(argument0)+10,string_height("M"),0);
draw_rectangle(0,0,string_width(argument0)+10,string_height("M"),0);
draw_set_alpha(argument6);
draw_set_color(argument4);
draw_rectangle(0,0,string_width(argument0)+10,string_height("M"),1);
draw_rectangle(0,0,string_width(argument0)+10,string_height("M"),1);
if (argument2>0){
draw_set_color(argument1);
draw_set_alpha(argument2);
draw_text(5,2,argument0);
}
surface_reset_target();
#define inv_name_draw
if (on_ground_selected>0){
draw_surface_ext(surf,argument0,argument1,1,1,0,c_white,argument2);
}
#define inv_get_item
var count;
count=0;
with (argument0){
    if (name=argument1){
        if (count=argument2){return self.id;}
        count+=1;
    }
}
return -1;
#define inv_item_under
with (argument0){
        if (undermouse=2){return self.id;}
}
return -1;
#define inv_info_remove_line
var found;
found=false;
for (k=0; k<ds_grid_height(lines); k+=1){
    if (string(ds_grid_get(lines,3,k))=string(argument0)){
        found=true;
        for (i=k; i<ds_grid_height(lines); i+=1){
            for (c=0; c<ds_grid_width(lines); c+=1){
                ds_grid_set(lines,c,i,ds_grid_get(lines,c,i+1)); 
            }
        }
    }
    if (found=true){ 
    ds_grid_resize(lines,ds_grid_width(lines),ds_grid_height(lines)-1);
    break;
    }
}
#define inv_count_item
var count;
count=0;
with (argument0){
    if (name=argument1){
        count+=1;
    }
}
return count;
#define inv_item_change
if (argument1!=-1){itemslotsw=argument1;}
if (argument2!=-1){itemslotsh=argument2;}
if (argument0!=-1){name=argument0;}
if (argument4!=-1){sprite=argument4;}
if (argument3!=-1){ongroundsprite=argument3;}
if (argument5!=-1){type=argument5;}
if (argument6!=-1){drop_sound=argument6;}
if (argument7!=-1){dropped_sound=argument7;}
if (argument9!=-1){drop_code=argument9;}
if (argument8!=-1){pick_up_code=argument8;}
