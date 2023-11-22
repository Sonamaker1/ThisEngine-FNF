package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxBasic;
import flixel.FlxSprite;
import script.Script;
import script.ScriptGroup;
import script.ScriptUtil;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
using StringTools;

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
		
		var name = Type.getClassName(Type.getClass(this));
		if(name == "GameOverSubstate"){
			name = "GameOverSubState"; //This is dumb lol but lua script compatibility demands it
		}
		var path = "menus/substates/"+name.replace('SubState','Addons')+".hx";
		//var nameNew = "menus/"+Type.getClassName(Type.getClass(this)).replace('State','Addons.hx');
		//makeFileDebug();
		makeInterpreterGroup(
			path
		);
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;
	public var menuscripts:ScriptGroup;
	public var menuscriptData:Map<String, String>;
	
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;



	
	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();


		super.update(elapsed);
		
		if(menuscripts!=null)
			menuscripts.executeAllFunc("super_update", [elapsed]);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}
	
	public function makeFileDebug():Void
	{
		var name = Type.getClassName(Type.getClass(this));
		if(name == "GameOverSubstate"){
			name = "GameOverSubState"; //This is dumb lol but lua script compatibility demands it
		}
		var path = "menus/substates/"+name.replace('SubState','Addons')+".hx";
		sys.io.File.saveContent(path, "trace('"+path+" has loaded succesfully')");
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
		
	}
}
