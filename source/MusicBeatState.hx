package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxBasic;
import script.Script;
import script.ScriptGroup;
import script.ScriptUtil;
import NewState;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
using StringTools;

class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	public static var camBeat:FlxCamera;

	public var menuscripts:ScriptGroup;
	public var menuscriptData:Map<String, String>;
	
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function new()
	{
		super();
		var nameNew = "menus/"+Type.getClassName(Type.getClass(this)).replace('State','Addons.hx');
		trace(nameNew);
		//makeFileDebug();
		makeInterpreterGroup(
			nameNew
		);
		
		if(menuscripts!=null)
			menuscripts.executeAllFunc("super_new", [this]);
	}

		
	override function create() {
		camBeat = FlxG.camera;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();
		
		if(!skip) {
			openSubState(new CustomFadeTransition(0.7, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
	}

	var first_run = 0;
	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
		
		if(menuscripts!=null && first_run == 0){
			menuscripts.executeAllFunc("super_runOnce", []);
			first_run++;
		}
		
		if(menuscripts!=null)
			menuscripts.executeAllFunc("super_update", [elapsed]);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	public function makeInterpreterGroup(file:String):Void
	{
		menuscripts = new script.ScriptGroup();
		
		var hx:Null<String> = null;
		menuscriptData = [];

		if (FileSystem.exists(file))
			hx = File.getContent(file);

		if (hx != null)
		{
			trace("FOUND FILE");
			var scriptName:String = CoolUtil.getFileStringFromPath(file);

			if (!menuscriptData.exists(scriptName))
			{
				menuscriptData.set(scriptName, hx);
			}
		}
		
		for (scriptName => hx in menuscriptData)
		{
			trace(scriptName);
			if (menuscripts.getScriptByTag(scriptName) == null)
				menuscripts.addScript(scriptName).executeString(hx);
			else
			{
				menuscripts.getScriptByTag(scriptName).error("Duplicate Script Error!", '$scriptName: Duplicate Script');
			}
		}
	}
	
	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	public function makeFileDebug():Void
	{
		var name = Type.getClassName(Type.getClass(this)).replace('State','Addons.hx');
		var path = "menus/"+name;
		sys.io.File.saveContent(path, "trace('"+path+" has loaded succesfully')");
	}
	
	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState) {
		// Custom made Trans in
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		if(!FlxTransitionableState.skipNextTransIn) {
			leState.openSubState(new CustomFadeTransition(0.6, false));
			if(nextState == FlxG.state) {
				CustomFadeTransition.finishCallback = function() {
					FlxG.resetState();
				};
				//trace('resetted');
			} else {
				CustomFadeTransition.finishCallback = function() {
					FlxG.switchState(nextState);
				};
				//trace('changed state');
			}
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		FlxG.switchState(nextState);
	}

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
			
		if(menuscripts!=null)
			menuscripts.executeAllFunc("super_stepHit", [curStep]);
	}

	public function beatHit():Void
	{
		if(menuscripts!=null)
			menuscripts.executeAllFunc("super_beatHit", [curBeat]);

		//trace('Beat: ' + curBeat);
	}

	public function sectionHit():Void
	{
		if(menuscripts!=null)
			menuscripts.executeAllFunc("super_sectionHit", [curSection]);
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
	
	//Hi 7oltan lol
	override function draw(){
		menuscripts.executeAllFunc("super_draw", []);
		super.draw();
		menuscripts.executeAllFunc("super_drawPost", []);
	}
}
