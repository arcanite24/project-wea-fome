///htme_serverNetworking()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      server counterpart of htme_clientNetworking
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

if (!self.isConnected) {exit;}

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");
var dbg_contents = "";

var player = ds_map_find_value(self.playermap,in_ip+":"+string(in_port));

//Check that the packet is from a valid client
if (!is_undefined(player)) {
    //Read command
    code = buffer_read(in_buff, buffer_s8 );
    switch code {
        case htme_packet.INSTANCE_VARGROUP:
            htme_debugger("htme_serverNetworking",htme_debug.DEBUG,"Got a update packet");
            htme_recieveVarGroup(dbg_contents);
        break;
        case htme_packet.GLOBALSYNC:
            htme_debugger("htme_serverNetworking",htme_debug.TRAFFIC,"Got packet htme_packet.GLOBALSYNC. Contents not logged.");
            htme_debugger("htme_serverNetworking",htme_debug.DEBUG,"Got a update globalsync update");
            htme_recieveGS();
        break;
        case htme_packet.CLIENT_INSTANCEREMOVED:
             var hash = buffer_read(in_buff,buffer_string);
             dbg_contents += "hash: "+hash+",";
             htme_debugger("htme_serverNetworking",htme_debug.DEBUG,"Player "+in_ip+":"+string(in_port)+" removed instance "+hash+"! Remove local and then broadcast!");
             var inst = ds_map_find_value(self.globalInstances,hash);
             if (!is_undefined(inst) && instance_exists(inst)) {
                htme_cleanUpInstance(inst);
                {with (inst) {instance_destroy();}}
             }
             htme_serverRemoveBackup(hash);
             ds_map_delete(self.globalInstances,hash);
             htme_serverBroadcastUnsync(hash);
             htme_debugger("htme_serverNetworking",htme_debug.TRAFFIC,"Recieved htme_packet.CLIENT_INSTANCEREMOVED from "+in_ip+":"+string(in_port)+" with content {"+dbg_contents+"}");
        break;
        case htme_packet.CLIENT_ROOMCHANGE:
             var _room = buffer_read(in_buff,buffer_u16);
             dbg_contents += "room: "+string(_room)+",";
             htme_debugger("htme_serverNetworking",htme_debug.INFO,"Player "+in_ip+":"+string(in_port)+" moved to room "+string(_room)+"!");
             ds_map_replace(self.playerrooms,in_ip+":"+string(in_port),_room);
             //Send all instances of this room to this player
             htme_serverSendAllInstances(in_ip+":"+string(in_port));
             //Tell all other players not in the room to delete their instances of this player
             htme_serverBroadcastRoomChange(ds_map_find_value(self.playermap,in_ip+":"+string(in_port)));
             htme_debugger("htme_serverNetworking",htme_debug.TRAFFIC,"Recieved htme_packet.CLIENT_ROOMCHANGE from "+in_ip+":"+string(in_port)+" with content {"+dbg_contents+"}");
        break;
        case htme_packet.CLIENT_BYE:
             htme_debugger("htme_serverNetworking",htme_debug.TRAFFIC,"Recieved htme_packet.CLIENT_BYE from "+in_ip+":"+string(in_port));
             htme_serverKickClient(in_ip+":"+string(in_port));
        break;
        case htme_packet.CHAT_API:
             htme_debugger("htme_serverNetworking",htme_debug.TRAFFIC,"Recieved htme_packet.CHAT_API from "+in_ip+":"+string(in_port));
             var channel = buffer_read(in_buff,buffer_string);
             var to = buffer_read(in_buff,buffer_string);
             var message = buffer_read(in_buff,buffer_string);
             htme_debugger("htme_serverNetworking",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Recieved "+message+" to "+to+".");
             //Add to local queues
             if (to == "" or to == self.playerhash) {
                 htme_debugger("htme_serverNetworking",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Relaying message "+message+" to myself.");
                 htme_chatAddToQueue(channel, message, to);
             }
             htme_chatSendServer(channel,message,to);
        break;
    }
}