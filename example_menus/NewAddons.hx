trace('menus/newState.hx has loaded successfully');

function super_new(state){
	trace("uhhh");
}

import("MusicBeatState");
import("TitleState");
import("FileSystem");
import("FunkinLua");
import("llua.Lua.Lua_helper");


function super_runOnce(){
	var G = FlxG.state;
	if(G.luaArray.length == 0 && FileSystem.exists("menus/NewState.lua")){
		G.luaArray.push(new FunkinLua("menus/NewState.lua"));
	}
	
	//G.camGame.zoom = 0.5;
	if(G.luaArray.length != 0){
		Lua_helper.add_callback(G.luaArray[0].lua, "doAFlip", function(obj:Dynamic) {
			trace(obj);
		});
		
		G.callOnLuas("onCreate", []);
		G.callOnLuas("onStartCountdown", []);
	}
}
