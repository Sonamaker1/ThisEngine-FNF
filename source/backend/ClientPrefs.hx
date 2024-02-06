package backend;
import ClientPrefs as OG_ClientPrefs;
import flixel.FlxG;
class ClientPrefs {
	//backporting 0.7.1 scripts to 0.6.3 with a singleton lol
	public static final data:ClientPrefs = new ClientPrefs();
	
	@:isVar public var downScroll(get, set):Bool;
	@:isVar public var middleScroll(get, set):Bool;
	@:isVar public var opponentStrums(get, set):Bool;
	@:isVar public var showFPS(get, set):Bool;
	@:isVar public var flashing(get, set):Bool;
	@:isVar public var autoPause(get, set):Bool;
	@:isVar public var antialiasing(get, set):Bool;
	@:isVar public var noteSkin(get, set):String;
	@:isVar public var splashSkin(get, set):String;
	@:isVar public var splashAlpha(get, set):Float;
	@:isVar public var lowQuality(get, set):Bool;// = false;
	@:isVar public var shaders(get, set):Bool;// = true;
	@:isVar public var cacheOnGPU(get, set):Bool = #if !switch false #else true #end; //From Stilic
	@:isVar public var framerate(get, set):Int;// = 60;
	@:isVar public var camZooms(get, set):Bool;// = true;
	@:isVar public var hideHud(get, set):Bool;// = false;
	@:isVar public var noteOffset(get, set):Int;// = 0;
	@:isVar public var ghostTapping(get, set):Bool;// = true;
	@:isVar public var timeBarType(get, set):String;// = 'Time Left';
	@:isVar public var scoreZoom(get, set):Bool;// = true;
	@:isVar public var noReset(get, set):Bool;// = false;
	@:isVar public var healthBarAlpha(get, set):Float;// = 1;
	@:isVar public var hitsoundVolume(get, set):Float;// = 0;
	@:isVar public var pauseMusic(get, set):String;// = 'Tea Time';
	@:isVar public var checkForUpdates(get, set):Bool;// = true;
	@:isVar public var comboStacking(get, set):Bool;// = true;
	/*@:isVar public var gameplaySettings(get, set):Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		// -kade
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];*/

	@:isVar public var comboOffset(get, set):Array<Int>;// = [0, 0, 0, 0];
	@:isVar public var ratingOffset(get, set):Int;// = 0;
	@:isVar public var sickWindow(get, set):Float;// = 45;
	@:isVar public var goodWindow(get, set):Float;// = 90;
	@:isVar public var badWindow(get, set):Float;// = 135;
	@:isVar public var safeFrames(get, set):Float;// = 10;
	@:isVar public var discordRPC(get, set):Bool;// = true;

	//These are not yet supported
	function get_splashSkin() { return "";/*OG_ClientPrefs.splashSkin;*/}
	function set_splashSkin(input:String) {  return "";/*OG_ClientPrefs.splashSkin = input;*/}
		
	function get_splashAlpha() { return 0.6; /*OG_ClientPrefs.splashAlpha;*/}
	function set_splashAlpha(input:Float) {return 0.6; /*OG_ClientPrefs.splashAlpha = input;*/}

	function get_cacheOnGPU() { return false; /*OG_ClientPrefs.cacheOnGPU*/}
	function set_cacheOnGPU(input:Bool) {return false;/* OG_ClientPrefs.cacheOnGPU = input;*/}

	function get_noteSkin() { return "Default"; /*OG_ClientPrefs.noteSkin;*/}
	function set_noteSkin(input:String) { return "Default"; /*OG_ClientPrefs.noteSkin = input*/}

	function get_discordRPC() { return true;} //OG_ClientPrefs.discordRPC;}
	function set_discordRPC(input:Bool) {return true; }//OG_ClientPrefs.discordRPC = input;}

	//These are work-arounds
	function get_autoPause() { return FlxG.autoPause;}
	function set_autoPause(input:Bool) { FlxG.autoPause = input; return FlxG.autoPause;}
	
	function get_antialiasing() { return OG_ClientPrefs.globalAntialiasing;}
	function set_antialiasing(input:Bool) { OG_ClientPrefs.globalAntialiasing = input; return OG_ClientPrefs.globalAntialiasing;}

	function get_downScroll() { return OG_ClientPrefs.downScroll;}
	function set_downScroll(input:Bool) { OG_ClientPrefs.downScroll = input; return OG_ClientPrefs.downScroll;}
	function get_middleScroll() { return OG_ClientPrefs.middleScroll;}
	function set_middleScroll(input:Bool) { OG_ClientPrefs.middleScroll = input; return OG_ClientPrefs.middleScroll;}
	function get_opponentStrums() { return OG_ClientPrefs.opponentStrums;}
	function set_opponentStrums(input:Bool) { OG_ClientPrefs.opponentStrums = input; return OG_ClientPrefs.opponentStrums;}
	function get_showFPS() { return OG_ClientPrefs.showFPS;}
	function set_showFPS(input:Bool) { OG_ClientPrefs.showFPS = input; return OG_ClientPrefs.showFPS;}
	function get_flashing() { return OG_ClientPrefs.flashing;}
	function set_flashing(input:Bool) { OG_ClientPrefs.flashing = input; return OG_ClientPrefs.flashing;}

	function get_lowQuality() { return OG_ClientPrefs.lowQuality;}
	function set_lowQuality(input:Bool) { OG_ClientPrefs.lowQuality = input; return OG_ClientPrefs.lowQuality;}
	function get_shaders() { return OG_ClientPrefs.shaders;}
	function set_shaders(input:Bool) { OG_ClientPrefs.shaders = input; return OG_ClientPrefs.shaders;}

	function get_framerate() { return OG_ClientPrefs.framerate;}
	function set_framerate(input:Int) { OG_ClientPrefs.framerate = input; return OG_ClientPrefs.framerate;}
	function get_camZooms() { return OG_ClientPrefs.camZooms;}
	function set_camZooms(input:Bool) { OG_ClientPrefs.camZooms = input; return OG_ClientPrefs.camZooms;}
	function get_hideHud() { return OG_ClientPrefs.hideHud;}
	function set_hideHud(input:Bool) { OG_ClientPrefs.hideHud = input; return OG_ClientPrefs.hideHud;}
	function get_noteOffset() { return OG_ClientPrefs.noteOffset;}
	function set_noteOffset(input:Int) { OG_ClientPrefs.noteOffset = input; return OG_ClientPrefs.noteOffset;}
	function get_ghostTapping() { return OG_ClientPrefs.ghostTapping;}
	function set_ghostTapping(input:Bool) { OG_ClientPrefs.ghostTapping = input; return OG_ClientPrefs.ghostTapping;}
	function get_timeBarType() { return OG_ClientPrefs.timeBarType;}
	function set_timeBarType(input:String) { OG_ClientPrefs.timeBarType = input; return OG_ClientPrefs.timeBarType;}
	function get_scoreZoom() { return OG_ClientPrefs.scoreZoom;}
	function set_scoreZoom(input:Bool) { OG_ClientPrefs.scoreZoom = input; return OG_ClientPrefs.scoreZoom;}
	function get_noReset() { return OG_ClientPrefs.noReset;}
	function set_noReset(input:Bool) { OG_ClientPrefs.noReset = input; return OG_ClientPrefs.noReset;}
	function get_healthBarAlpha() { return OG_ClientPrefs.healthBarAlpha;}
	function set_healthBarAlpha(input:Float) { OG_ClientPrefs.healthBarAlpha = input; return OG_ClientPrefs.healthBarAlpha;}
	function get_hitsoundVolume() { return OG_ClientPrefs.hitsoundVolume;}
	function set_hitsoundVolume(input:Float) { OG_ClientPrefs.hitsoundVolume = input; return OG_ClientPrefs.hitsoundVolume;}
	function get_pauseMusic() { return OG_ClientPrefs.pauseMusic;}
	function set_pauseMusic(input:String) { OG_ClientPrefs.pauseMusic = input; return OG_ClientPrefs.pauseMusic;}
	function get_checkForUpdates() { return OG_ClientPrefs.checkForUpdates;}
	function set_checkForUpdates(input:Bool) { OG_ClientPrefs.checkForUpdates = input; return OG_ClientPrefs.checkForUpdates;}
	function get_comboStacking() { return OG_ClientPrefs.comboStacking;}
	function set_comboStacking(input:Bool) { OG_ClientPrefs.comboStacking = input; return OG_ClientPrefs.comboStacking;}
	function get_comboOffset() { return OG_ClientPrefs.comboOffset;}
	function set_comboOffset(input:Array<Int>) { OG_ClientPrefs.comboOffset = input; return OG_ClientPrefs.comboOffset;}
	function get_ratingOffset():Int { return Std.int(OG_ClientPrefs.ratingOffset);}
	function set_ratingOffset(input:Int) { OG_ClientPrefs.ratingOffset = Std.int(input); return Std.int(OG_ClientPrefs.ratingOffset);}
	function get_sickWindow():Float { return OG_ClientPrefs.sickWindow;}
	function set_sickWindow(input:Float) { OG_ClientPrefs.sickWindow = input; return OG_ClientPrefs.sickWindow;}
	function get_goodWindow():Float { return OG_ClientPrefs.goodWindow;}
	function set_goodWindow(input:Float) { OG_ClientPrefs.goodWindow = input; return OG_ClientPrefs.goodWindow;}
	function get_badWindow():Float { return OG_ClientPrefs.badWindow;}
	function set_badWindow(input:Float) { OG_ClientPrefs.badWindow = input; return OG_ClientPrefs.badWindow;}
	function get_safeFrames():Float { return OG_ClientPrefs.safeFrames;}
	function set_safeFrames(input:Float) { OG_ClientPrefs.safeFrames = input; return OG_ClientPrefs.safeFrames;}


	private function new(){}
}
