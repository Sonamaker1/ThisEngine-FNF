package;

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
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;
	public static var globalCreditsAddons:Null<Array<Array<String>>> = null;
	
	//formerly named "pisspoop"
	public static var globalCreditsNames:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
		['This Engine Credits'],
		['Winn',			'winn',			'Programmer for fun.\nMade this engine version for a few mods',	'https://twitter.com/DreadPirateWinn',	'a19aea'],
		['Ne_Eo',			'neo',			'Multiple Engine Fixes, \nHScript Import function and support',		'https://twitter.com/Ne_Eo_Twitch',	'282627'],
		['Lunar', 			'lunar', 		'HScript script file Management Code', 				'https://twitter.com/lunarcleint', 	'6757f3'],
		['Everyone Else I\'ve met', 	'discord', 		'This is for you all!\nNew stuff is added for everyone I meet ^-^', '', 					'A1A1A1'],
		[''],
		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',				'https://twitter.com/Shadow_Mario_',	'444444'],
		['Riveren',			'riveren',		'Main Artist/Animator of Psych Engine',				'https://twitter.com/RiverOaken',	'B42F71'],
		[''],
		['Former Engine Members'],
		['bb-panzu',			'bb',			'Ex-Programmer of Psych Engine',				'https://twitter.com/bbpnz213',		'3E813A'],
		['shubs',			'missing_icon',			'Ex-Programmer of Psych Engine\nI don\'t support them.',	 '',					'A1A1A1'],
		[''],
		['Engine Contributors'],
		['CrowPlexus',			'crowplexus',		'Major Help and Other PRs',				 	'https://twitter.com/crowplexus',	'A1A1A1'],
		['SqirraRNG',			'sqirra',		'Crash Handler and Base code for\nChart Editor\'s Waveform',	'https://twitter.com/sqirradotdev',		'E1843A'],
		['EliteMasterEric',		'mastereric',		'Runtime Shaders support',					'https://twitter.com/EliteMasterEric',	'FFBD40'],
		['PolybiusProxy',		'proxy',		'.MP4 Video Loader Library (hxCodec)',				'https://github.com/polybiusproxy',	'DCD294'],
		['Tahir',			'tahir',		'Other PRs',			 				'https://lib.haxe.org/u/tahirk786',	'A04397'],
		['KadeDev',			'kade',			'Fixed some cool stuff on Chart Editor\nand other PRs',		'https://twitter.com/kade0912',		'64A250'],
		['iFlicky',			'flicky',		'Composer of Psync and Tea Time\nMade the Dialogue Sounds',	'https://twitter.com/flicky_i',		'9E29CF'],
		['Keoiki',			'keoiki',		'Note Splash Animations and Latin Alphabet',			'https://twitter.com/Keoiki_',		'D2D2D2'],
		['KadeDev',			'kade',			'Fixed some issues on Chart Editor and Other PRs',		'https://twitter.com/kade0912',		'64A250'],
		['superpowers04',		'superpowers04',	'LUA JIT Fork',							'https://twitter.com/superpowers04',	'B957ED'],
		['Nebula the Zorua',		'nebula',		'some Lua reworks',						'https://github.com/nebulazorua',	'7D40B2'],
		['CheemsAndFriends',		'face',			'Creator of FlxAnimate',	 				'https://lib.haxe.org/u/MrCheemsAndFriends',	'A1A1A1'],
		['Smokey',			'smokey',		'Sprite Atlas Support',						'https://twitter.com/Smokey_5_',	'483D92'],
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	'CF2D2D'],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",				'https://twitter.com/PhantomArcade3K',	'FADC45'],
		['evilsk8r',			'evilsk8r',		"Artist of Friday Night Funkin'",				'https://twitter.com/evilsk8r',		'5ABD4B'],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",				'https://twitter.com/kawaisprite',	'378FC7']
	];
	
	public static var dummyDataItem = [
		'ErrorItem', 
		'face',
		"",
		'',
		'378FC7'
	];
	
	
	
	public static var functionVariables:Map<String, (Void)->(Void)> = new Map();
	
	public function getCurrentDataItem(index:Int){
		var item = creditsStuff[curSelected];
		if(item!=null && item.length > index){
			return item[index];
		}
		return dummyDataItem[index];
	}
	public function addCreditItem(i:Int):Void {
		if(functionVariables.exists("addCreditItem")){
			var overrideFunc = CoolUtil.tryOverride(
				null, functionVariables, "addCreditItem", [i], "Void"
			); 
			if(overrideFunc[0]!="NOT IMPLEMENTED") 
				return;
		}
		else
			return _addCreditItem(i);
	}
	
	public function addModTextCredits():Void {
		if(functionVariables.exists("addModTextCredits")){
			var overrideFunc = CoolUtil.tryOverride(
				null, functionVariables, "addModTextCredits", [], "Void"
			); 
			if(overrideFunc[0]!="NOT IMPLEMENTED") 
				return;
		}

		return _addModTextCredits();
	}
	
	public function selectionControls(expected:Int):Bool {
		if(functionVariables.exists("selectionControls")){
			var overrideFunc = CoolUtil.tryOverride(
				null, functionVariables, "selectionControls", [expected], "Bool"
			); 
			if(overrideFunc[0]!="NOT IMPLEMENTED") 
				return cast(overrideFunc[1], Bool);
		}

		return _selectionControls(expected);
	}
	
	public function checkSelection(elapsed:Float):Void {
		if(functionVariables.exists("checkSelection")){
			var overrideFunc = CoolUtil.tryOverride(
				null, functionVariables, "checkSelection", [elapsed], "Void"
			); 
			if(overrideFunc[0]!="NOT IMPLEMENTED") 
				return;
		}

		return _checkSelection(elapsed);
	}
	
	public function regenerateDescription():Void {
		if(functionVariables.exists("regenerateDescription")){
			var overrideFunc = CoolUtil.tryOverride(
				null, functionVariables, "regenerateDescription", [], "Void"
			); 
			if(overrideFunc[0]!="NOT IMPLEMENTED") 
				return;
		}

		return _regenerateDescription();
	}
	
	function updateItem(item:Alphabet, elapsed:Float){
		if(functionVariables.exists("updateItem")){
			var overrideFunc = CoolUtil.tryOverride(
				null, functionVariables, "updateItem", [item, elapsed], "Void"
			); 
			if(overrideFunc[0]!="NOT IMPLEMENTED") 
				return;
		}

		return _updateItem(item, elapsed);
	}
	
	function _addCreditItem(i:Int){
		var isSelectable:Bool = !unselectableCheck(i);
		var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
		optionText.isMenuItem = true;
		optionText.targetY = i;
		optionText.changeX = false;
		optionText.snapToPosition();
		grpOptions.add(optionText);

		if(isSelectable) {
			if(creditsStuff[i][5] != null)
			{
				Paths.currentModDirectory = creditsStuff[i][5];
			}

			var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
			icon.xAdd = optionText.width + 10;
			icon.sprTracker = optionText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
			Paths.currentModDirectory = '';

			if(curSelected == -1) curSelected = i;
		}
		else optionText.alignment = CENTERED;
	}
	
	function _addModTextCredits(){
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
	}
	
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		addModTextCredits();
		#end

		if(globalCreditsAddons!= null){
			for(i in globalCreditsAddons){
				creditsStuff.push(i);
			}
		}
				
		for(i in globalCreditsNames){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			addCreditItem(i);
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	
	var advanceSelect = 1;
	var previousSelect = -1;
	
	function _selectionControls(expected:Int){
		switch(expected){
			case -2: return controls.UI_UP;
			case -1: return controls.UI_UP_P;
			case 1:  return controls.UI_DOWN_P;
			case 2:  return controls.UI_DOWN;
			default: return false;
		}
	}
	
	function _checkSelection(elapsed:Float){
		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		var upP = selectionControls(-1);//controls.UI_UP_P;
		var downP = selectionControls(1);//controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-shiftMult);
			holdTime = 0;
		}
		if (downP)
		{
			changeSelection(shiftMult);
			holdTime = 0;
		}
		
		var controlUP = selectionControls(-2);//controls.UI_UP;
		var controlDOWN = selectionControls(2);//controls.UI_DOWN;
		if(controlDOWN || controlUP)
		{
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

			if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			{
				changeSelection((checkNewHold - checkLastHold) * (controlUP ? -shiftMult : shiftMult));
			}
		}
	}
	
	function _updateItem(item:Alphabet, elapsed:Float){
		if(!item.bold)
		{
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
			if(item.targetY == 0)
			{
				var lastX:Float = item.x;
				item.screenCenter(X);
				item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
			}
			else
			{
				item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
			}
		}	
	}
	
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				checkSelection(elapsed);
			}

			if(controls.ACCEPT && (getCurrentDataItem(3) == null || getCurrentDataItem(3).length > 4)) {
				CoolUtil.browserLoad(getCurrentDataItem(3));
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			updateItem(item, elapsed);
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	
	function iterateSelection(change:Int = 0){
		if(creditsStuff.length==0) return;
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));
	}
	
	function selectNewItem(item:Alphabet, memberIndex:Int){
		item.targetY = memberIndex - curSelected;
		
		if(!unselectableCheck(memberIndex)) {
			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
	}
	
	function _regenerateDescription(){
		descText.text = getCurrentDataItem(2);
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}
	
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		iterateSelection(change);

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		//formerly named "bullshit" but that's not descriptive at all -W
		var memberIndex:Int = 0;
		for (item in grpOptions.members)
		{
			selectNewItem(item, memberIndex);
			memberIndex++;
		}

		regenerateDescription();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = getCurrentDataItem(4);
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	public function unselectableCheck(num:Int):Bool {
		return (creditsStuff.length > num)?creditsStuff[num].length <= 1: true;
	}
}
