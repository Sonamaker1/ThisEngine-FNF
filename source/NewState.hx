import llua.Lua.Lua_helper;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;

import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

#if hscript
import hscript.Parser;
import hscript.Interp;
import hscript.Expr;
import FunkinLua.HScript;
import FunkinLua.CustomSubstate;
#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
#end
#end
import flixel.addons.transition.FlxTransitionableState;

import Type.ValueType;
// New Junk Below For HScript usage lol
typedef FunkyFunct = {
    var func:Void->Void;
}

class NewState extends PlayState
{
	public static var gameStages:Map<String,FunkyFunct>;
	public static var hscript:HScript = null;
	public var curMod ="";
	public static var startingVariables:Map<String, Null<Dynamic>> = null;
	public static var lastMod = "";
	
	public function setUpVars(){
		#if (haxe >= "4.0.0")
		boyfriendMap = new Map();
		dadMap = new Map();
		gfMap = new Map();
		variables = new Map();
		modchartTweens = new Map();
		modchartSprites = new Map();
		modchartTimers = new Map();
		modchartSounds = new Map();
		modchartTexts = new Map();
		modchartSaves = new Map();
		#else
		boyfriendMap = new Map<String, Boyfriend>();
		dadMap = new Map<String, Character>();
		gfMap = new Map<String, Character>();
		variables = new Map<String, Dynamic>();
		modchartTweens = new Map<String, FlxTween>();
		modchartSprites = new Map<String, ModchartSprite>();
		modchartTimers = new Map<String, FlxTimer>();
		modchartSounds = new Map<String, FlxSound>();
		modchartTexts = new Map<String, ModchartText>();
		modchartSaves = new Map<String, FlxSave>();
		#end
		isDead = false;
	}

	

	public var name:String = 'unnamed';
	public static var instance:NewState;
	public static var lastState:flixel.FlxState;
	override function create()
	{
		FlxG.mouse.visible=true;
		//curMod = Paths.hscriptModDirectory;
		
		trace("creation");
		instance = this;
		#if hscript
		gameStages = new Map<String,FunkyFunct>();
		//funk = new PlayState.FunkinUtil(instance);
		#end
		PlayState.instance=instance;
		setUpVars();
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		camGame.bgColor = FlxColor.fromRGB(2, 3, 5);

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		CustomFadeTransition.nextCamera = camOther;
		super.bypass_create();
		menuscripts.setAll("Lua_helper", Lua_helper);
		menuscripts.executeAllFunc("create",[]);	
		callOnLuas('onCreatePost', []);
		
	}
	
	public function new(nameInput:String = 'NewState', ?startingVars:Map<String,Dynamic>) {
        super();
		
		lastState = FlxG.state;
		name = nameInput;
		if(startingVars !=null){
			//startingVariables = startingVars; //Doesn't work
			startingVariables = [for( k in startingVars.keys() ) k => startingVars.get(k)]; 
		}
		
		var doPush:Bool = false;
		
		var luaFile:String = 'menus/' + name + '.lua';
		if(FileSystem.exists(luaFile)) {
			//luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush){
			luaArray.push(new FunkinLua(luaFile));
			trace("adding "+ luaFile);
		}
			
    }

	//override function closeSubState(){super.bypass_closeSubState();}
	//override function create(){super.bypass_create();}
	//override function destroy(){super.bypass_destroy();}
	override function onFocus(){
		callOnLuas('onFocus', []);
		super.bypass_onFocus();
		callOnLuas('onFocusPost', []);
	}
	override function onFocusLost(){
		callOnLuas('onFocusLost', []);
		super.bypass_onFocusLost();
		callOnLuas('onFocusLostPost', []);		
	}
	override function openSubState(SubState:FlxSubState){
		super.bypass_openSubState(SubState);
	}
	
	override function stepHit()
	{
		callOnLuas('onStepHit', []);
		super.bypass_stepHit();
		callOnLuas('onStepHitPost', []);
	}
	override function endSong(){
		MusicBeatState.switchState(lastState);
		super.endSong();
	}
	
	override function beatHit()
	{
		callOnLuas('onBeatHit', []);
		super.bypass_beatHit();
		callOnLuas('onBeatHitPost', []);
	}
	
	override function update(elapsed:Float)
	{
		callOnLuas('onUpdate', [elapsed]); 
		super.bypass_update(elapsed);
		callOnLuas('onUpdatePost', [elapsed]); 
	}


	override function destroy() {
		FlxG.mouse.visible=false;
		FlxG.mouse.cursorContainer.alpha = 1;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		menuscripts.executeAllFunc("stateDestroy",[]);
		luaArray = [];
		if(FlxTransitionableState.skipNextTransIn) {
			CustomFadeTransition.nextCamera = null;
		}
		super.bypass_destroy();
	}
	
	
	override function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic {
		for (script in luaArray) {
			script.call(event, args);
		}
		return null;
	}
}
