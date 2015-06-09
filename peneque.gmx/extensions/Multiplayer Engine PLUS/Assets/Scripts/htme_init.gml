///htme_init()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This will load all variables and settings required by GMnet CORE/ENGINE.
**      You will find the whole configuration here.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/

/***
 *** ENUMS - CONFIGURATION CAN BE FOUND BELOW! 
 ***/

enum htme_debug {NONE=-1,DEBUG=0,TRAFFIC=1,CHATDEBUG=2,INFO=3,WARNING=4,ERROR=5};

//first part of buffer: htme packets start at 100, they are signed 8bit
enum htme_packet {
    PING=100,
    CLIENT_REQUESTCONNECT=101,
    SERVER_CONREQACCEPT=102,
    SERVER_GREETINGS=103,
    SERVER_PLAYERCONNECTED=104,
    INSTANCE_VARGROUP=105,
    CLIENT_INSTANCEREMOVED=106,
    SERVER_INSTANCEREMOVED=107,
    CLIENT_ROOMCHANGE=108,
    SERVER_PLAYERDISCONNECTED=109,
    GLOBALSYNC=110,
    SERVER_KICKREQ=111,
    CLIENT_BYE=113,
    SERVER_BROADCAST=114,
    CHAT_API=115,
    SIGNEDPACKET=126,
    SIGNEDPACKET_ACCEPTED=127,
}

enum mp_type {
    FAST, /*Syncs by simply sending a packet to client or servers
            when sent to the server, the server will send it back to
            the clients when the timeout for that group on the server is over*/
    /*FASTPLUS,*/ /*Like fast, but when the server gets updated information from the clients,
                the server instantly syncs back the group to all clients [NOT IMPLEMENTED]*/ 
    IMPORTANT, /*Uses signed packets to ensure that all servers and clients recieve the
                information, like TCP would do. This is quite slow! When messages arrive at
                the server, the packets will be relayed to all clients*/
    SMART, /* Same as important, but only sync if a variable has changed.
              If a tolerance is set, it will also only sync if it passed the
              tolerance for reals*/
}

/**
 * Extends the buffer_ constants and is used for the mp_add* functions to threat builtin
 * variable groups synced between instances differently and allows multiple datatypes in one
 * variable group of an instance. The names correspond to the mp_add* functions with the same
 * name
 **/
enum mp_buffer_type {
    BUILTINBASIC=100,BUILTINPHYSICS=101,BUILTINPOSITION=102
}

/***
 *** CONFIGURATION
 ***/

/** 
 * This will randomize the random functions. If you need a certain hash change this.
*/
randomize();

/** 
 * Set the level of debug. The debug messages of this level and higher
 * will be shown. NONE disables debug messages. TRAFFIC ONLY shows traffic!
 * When GMnet PUNCH is enabled (use_udphp = true), it's debug level will be adjusted accordingly.
*/
self.debuglevel = htme_debug.WARNING;

/** 
 * Enable or disable the debug overlay. Provides you with useful debugging tools.
 * Use htme_debugOverlayEnabled() to check if the overlay is on, to draw your own
 * debug information. 
 * Make sure you updated obj_htme to at least V. 1.2.0
*/
self.debugoverlay = true;

/** 
 * ID of the Object that controls the engine. You normally don't have to change this.
 * @type real
 */
global.htme_object = self.id;

htme_debugger("htme_init",htme_debug.INFO,"SETTING UP GMnet CORE");

/** 
 * Use GMnet PUNCH? Set to true if GMnet PUNCH is installed and should be used to make the conection.
 * GMnet PUNCH is installed if you use GMnet ENGINE and needs to be installed manually
 * when using GMnet CORE.
 * More Information can be found in the manual.
 */

self.use_udphp = true;

/** 
 * WHEN USING GMnet PUNCH:
 * IP of the master/mediation server 
 * THERE CAN BE NO GAME SERVER RUNNING ON THIS IP!!
 * Use 95.85.63.183 if you have no server. It is only for debugging!
 * @type string
 */
self.udphp_master_ip = "95.85.63.183";

/** 
 * WHEN USING GMnet PUNCH:
 * Port of the master/mediation server 
 * @type real
 */
self.udphp_master_port = 6510;

/** 
 * WHEN USING GMnet PUNCH:
 * The server should reconnect to the master server every x steps.
 * The server will only reconnect if it's no longer connected.
 * @type real
 */
self.udphp_rctintv = 3*60*room_speed;

/** 
 * The timeout after which the client gives up to connect.
 * This will also specify when server and client should timeout when the are not responding
 * to each others requests (ping timeout)
 * When using udphp:
 * The timeout after which the server and client give up to connect to each other.
 * @type real
 */
self.global_timeout = 5*room_speed;

/** 
 * Interval the servers broadcast data to the LAN, for the LAN lobby
 * @type real
 */
self.lan_interval = 15*room_speed;

/**
 *  Shortname of this game
 *  + version
 *  Example: htme_demo120
 **/
self.gamename = "htme_demo121"

/*** 
 *** BELOW: INIT INTERNAL VARIABLES - DO NOT CHANGE 
 ***/
 
if (self.use_udphp) {
    htme_debugger("htme_init",htme_debug.INFO,"Starting GMnet PUNCH...");
    var u_debug = false, u_silent = true;
    if (self.debuglevel <= htme_debug.INFO) {u_debug=false;u_silent=false;}
    if (self.debuglevel <= htme_debug.DEBUG) {u_debug=true;u_silent=false;}
    if (self.debuglevel == htme_debug.TRAFFIC) {u_debug=false;u_silent=true;}
    script_execute(asset_get_index("udphp_config"),self.udphp_master_ip, self.udphp_master_port,self.udphp_rctintv,self.global_timeout,u_debug,u_silent);
}

//Is the engine started by creating a server or client?
self.started = false;
//true -> Server, false -> Client
self.isServer = false;
//ONLY CLIENTS: Is the client connected? [when used with server always true]
self.isConnected = false;
//The client id used for udphp.
self.udphp_client_id = 0;
//The UDP server or socket created by the client/server creation scripts
self.socketOrServer = -1;
//Server ip [ONLY FOR CLIENT]
self.server_ip = "";
//Server port [ONLY FOR CLIENT]
self.server_port = 0;
//Buffer used for everything
self.buffer = buffer_create(256, buffer_grow, 1);
//Player list for GMnet PUNCH ONLY [we use a different type of player map;see below] [Only for server with udphp]
self.udphp_playerlist = -1;
//Playermap. Contains entry with the format <ip:port> -> <playerhash> [Only server!]
self.playermap = -1;
//Kickmap - When clients will be forced to be kicked <ip:port> -> <time till kicked in steps> [Only server!]
self.kickmap = -1;
//Local playerhash.
self.playerhash = "";
//Timeout counter for client
self.client_timeout = 0;
//True if a client was running but stooped
self.clientStopped = false;
//Client timeout check
self.clientTimeoutSend = 0;
self.clientTimeoutRecv = 0;
//Server timeout check (ds_map) -> <ip:port> -> real
self.serverTimeoutSend = -1;
self.serverTimeoutRecv = -1;
//Signed packets list <map containing ["cmd_list"->cmd_list,"target"->ip:port],"timeout"->real>
self.signedPackets = -1;
//Map of all signed packets <category> -> <packet> ; Only one packet per category will always exist
self.signedPacketsCategories = -1;
//Cache for recieved signedPackets
self.signedPacketsInCache = ds_list_create();
//List of locally controlled instances <hash> -> <instance_id> 
self.localInstances = ds_map_create();
//List of all controlled instances <hash> -> <instance_id> 
self.globalInstances = ds_map_create();
//
self.tmp_creatingNetworkInstance = false;
//Playermap for romms. Contains entry with the format <ip:port> -> <room> [Only server!]
self.playerrooms = -1;
//Server backup map for instance data
self.serverBackup = -1;
//Force the sync of mp_type.SMART packets
self.syncForce = false;
//A list used to store playerhashes used in htme_iteratePlayers
self.playerlist = -1;
//
self.tmp_instanceForceCreated = false;
//Link stores a link to all vargroups for looping over them, since this is more
//efficient than looping over instance maps and then var group maps.
self.grouplist = -1;
//
self.tmp_creatingNetworkInstanceHash = "";
//the 7 data strings (2-8)
self.server_data2 = "";
self.server_data3 = "";
self.server_data4 = "";
self.server_data5 = "";
self.server_data6 = "";
self.server_data7 = "";
self.server_data8 = "";
//global sync map
self.globalsync = noone;
self.globalsync_datatypes = noone;
//
self.dbgstate = vk_f12;
self.dbgpage = 0;
self.dbgcntx = "";
self.dbgcntx2 = "";
self.port = -1;
self.lanlobby = ds_list_create();
self.lanlobbysearch = false;
self.lanlobbyfilter = "";
self.lanlobbyport = 0;
self.lanlobbysearchserver = -1;
self.lan_intervalpnt = self.lan_interval;
self.serverEventHandlerConnect = htme_defaultEventHandler;
self.serverEventHandlerDisconnect = htme_defaultEventHandler;
self.chatQueues = -1;