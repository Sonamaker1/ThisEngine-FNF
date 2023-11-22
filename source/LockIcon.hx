package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class LockIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var alignTrack:Float = Math.NEGATIVE_INFINITY;
	public var isFreeplayState:Int = 0;
	
	private var char:String = '';
	private var charSprite:FlxSprite;

	public function new(char:String = 'bf', inFreeplayState:Int = 0)
	{
		super();
		changeIcon(char);
		scrollFactor.set();
	}


	private var iconOffsets:Array<Float> = [0, 0];
	
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/lock-' + char; //
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/lock-icon'; //Prevents crash from missing icon
			//trace(name + " [lock]")
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;
			updateHitbox();

			animation.add(char, [0, 1], 0, false, false);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}
