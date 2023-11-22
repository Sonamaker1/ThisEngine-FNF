package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var alignTrack:Float = Math.NEGATIVE_INFINITY;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	public var lockIcon:LockIcon;
	public var isFreeplayState:Int = 0;
	       
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?inFState:Int = 0)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		isFreeplayState = inFState;
		if(isFreeplayState > 0){
			lockIcon = new LockIcon("lock-icon");
			lockIcon.changeIcon("lock-icon");
			lockIcon.animation.curAnim.curFrame = isFreeplayState - 1;
			lockIcon.scrollFactor.set();
			// trace("lock activated");
		}
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		/*if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);*/
		if (sprTracker != null){
			if(alignTrack == Math.NEGATIVE_INFINITY){
				setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
				if( lockIcon != null ) {
					lockIcon.setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
				}
			}
			else{
				setPosition(sprTracker.x + alignTrack, sprTracker.y - 30);
				if( lockIcon != null ) {
					lockIcon.setPosition(sprTracker.x + alignTrack, sprTracker.y - 30);
				}
			}
		}
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;
			updateHitbox();

			animation.add(char, [0, 1], 0, false, isPlayer);
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
