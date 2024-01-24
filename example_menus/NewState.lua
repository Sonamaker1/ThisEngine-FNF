--Omg I am so sorry I legit didn't mean to add this to the source code but it's sorta in every build now so forgive me
--Go check out the author's gamebanana link!:
--https://gamebanana.com/tools/11157

--By UpDown LeftRight

--Remaster by Kriptel Pro

--Edited by Whatify for ThisEngine as an example lua state to use NewStateAddons.hx with (then accidentally pushed to github)

--												<-- UPDATE 1 -->
--Additions:
--	Added photo mode
--	Added smooth appearance of the interface
--	Added more settings in Lua
--Bugfix:
--	Fixed the text when entering the gallery

--												<-- UPDATE 2 -->
--Additions:
--	added 'bgVolume' option
--	added 'Font' option, so you can easy change it
--Improvement:
--	sprite now not store like getRandomInt(0, 99999)
--Bugfix:
--	Music now playing on repeat

-- art shit
length = 0;
images = {
	-- do not touch this
}
local id = 0





-- 									<-- SETTINGS, CHANGE SOME OF THE THINGS HERE-->

local bgSettings = {
	['bgSong'] = "offsetSong", -- Bg Music
	['bgVolume'] = 1, -- Bg Music Volume
	['Scroll Value'] = 0.25, -- Background scroll speed
	['Bg Alpha Value'] = 0.75, -- Background alpha value (From 1 to 0)
}
local gallerySettings = {
	['EnablePhotoMode'] = true, -- Will enable Photo Mode to inspect images
	['Shift View Speed'] = 2, -- Default image moving speed while in Photo Mode
	['Font'] = 'Strawberry Blossom.ttf', -- Description Font
}
local inputs = { -- 			<< CHANGE PHOTO MODE INPUTS HERE >>
	['ZoomOutKey'] = "Z",
	['ZoomInKey'] = "X",
	['PhotoModeKey'] = "C", -- Default Photo Mode Keybinding
}






-- 						<-- OTHER THINGS, SO DON'T TOUCH THIS -->

local inPhoto = false -- Don't change it to true, i warning you
local scrollSpeed = gallerySettings['Shift View Speed']

function onCreate()
	--<		  Add art functions       >--
	--tutorial:
	-- addArt('name','description','color(HEX)','sizeSelected','sizeNotSelected')
	-- example:	addArt('pizdec','vanya','FFA500',5,3)

	addArt('Kot','Meow','A9A9A9',5,3)
	addArt('Oxygen','Oxygen','FFA500',5,3)
	addArt('She','hihihiha','2F4F4F',5,3)

	length = length - 1;

	-- preload stuff
	makeLuaSprite('fon', 'menuDesat', 0, 0)
	makeLuaSprite('fon2', 'menuDesat', 1286, 0)
	makeLuaSprite('bglogo', 'gallery/onCreate/downPart', 0, 500)
	makeLuaSprite('bglogo2', 'gallery/onCreate/upPart', 0, -500)
	makeLuaSprite('bglogo3', 'gallery/onCreate/upPart', 1280, -500)
	makeLuaSprite('logo', 'gallery/onCreate/logo', 0, 500)
	makeLuaSprite('RightArrow', 'eventArrow', 1100, 1200)
	makeLuaSprite('LeftArrow', 'eventArrow', 1000, 1200)

	precacheSound('scrollMenu')
	precacheSound('cancelMenu')
	for i = 0,length do
		precacheImage('gallery/'..images[i].name) 
		--debugPrint('New path preloaded: gallery/'..images[i].name)
	end
	
	
	
end

function addArt(name,description,color,sizeSelected,sizeNotSelected)
	images[length] = {
		name = name,
		description = description,
		color = color,
		sizeSelected = sizeSelected,
		sizeNotSelected = sizeNotSelected
	}
	length = length + 1;
end
function onStartCountdown()

	--for _ in pairs(images) do length = length + 1 end  --Get length of Images
	--playMusic(bgSettings['bgSong'], bgSettings['bgVolume'], true)
	--fuckHud()
	--setProperty('dad.visible', false)

	addLuaSprite('fon')
	addLuaSprite('fon2')

	setObjectCamera('fon', 'other')
	setObjectCamera('fon2', 'other')

	setObjectCamera('bglogo', 'other')
	setObjectCamera('bglogo2', 'other')
	setObjectCamera('bglogo3', 'other')

	setObjectCamera('logo', 'other')
	setObjectCamera('RightArrow', 'other')
	setObjectCamera('LeftArrow', 'other')

	addLuaSprite('bglogo')
	addLuaSprite('bglogo2')
	addLuaSprite('bglogo3')
	addLuaSprite('logo')

	addLuaSprite('RightArrow')
	addLuaSprite('LeftArrow')


	scaleObject('RightArrow', 0.7, 0.7)
	scaleObject('LeftArrow', 0.7, 0.7)
	
	setProperty('LeftArrow.flipX', true)
	

	--	START TWEENS

	doTweenY('logo1', 'bglogo', 0, 1, 'sineOut')
	doTweenY('logo2', 'bglogo2', -50, 1.2, 'sineOut')
	doTweenY('logo3', 'bglogo3', -50, 1.2, 'sineOut')
	doTweenY('logo4', 'logo', 0, 2, 'sineOut')

	doTweenY('b1', 'LeftArrow', 600, 1.6, 'backOut')
	doTweenY('b2', 'RightArrow', 600, 2, 'backOut')

	--	TWEENS END

	onChange(0)

	makeLuaText('descriptionText', images[id].description, 640, 320, 0)
	setTextSize('descriptionText', 100)
	addLuaText('descriptionText')

	setTextFont('descriptionText', gallerySettings['Font'])

	setObjectCamera('descriptionText', 'other')

	--return Function_Stop;
end

function onUpdate(elapsed)
	--debugPrint(getProperty('RightArrow.scale.x'))
	doTweenColor('fonColor', 'fon', images[id].color, 0.25, 'sineOut')
	doTweenColor('fonColor2', 'fon2', images[id].color, 0.25, 'sineOut')

	--FON START
	setProperty('fon.x', getProperty('fon.x') - bgSettings['Scroll Value'])
	setProperty('fon2.x', getProperty('fon2.x') - bgSettings['Scroll Value'])
	if getProperty('fon.x') <= -1286 then
		setProperty('fon.x', 0)
		setProperty('fon2.x', 1286)
	end

	setProperty('fon.alpha', bgSettings['Bg Alpha Value'])
	setProperty('fon2.alpha', bgSettings['Bg Alpha Value'])
	--FON END

	--scroll2 start

	setProperty('bglogo2.x', getProperty('bglogo2.x')-elapsed*100)
	setProperty('bglogo3.x', getProperty('bglogo3.x')-elapsed*100)
	if getProperty('bglogo2.x') <= -1280 then
		setProperty('bglogo2.x', 0)
		setProperty('bglogo3.x', 1280)
	end

	--scroll2 end


if not inPhoto and gallerySettings['EnablePhotoMode'] then
	if keyJustPressed('right') then
		playSound('scrollMenu')
		--id = id + 1
		onChange(1)
		setTextString('descriptionText', images[id].description)
		doTweenColor('ColorRight', 'RightArrow', '808080', -1)
		runTimer('right', 0.1)
	end
	if keyJustPressed('left') then
		playSound('scrollMenu')
		--id = id - 1
		onChange(-1)
		setTextString('descriptionText', images[id].description)
		doTweenColor('ColorLeft', 'LeftArrow', '808080', -1)
		runTimer('left', 0.1)
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..inputs['PhotoModeKey']) then
		inPhoto = true
	end
elseif inPhoto and gallerySettings['EnablePhotoMode'] then
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..inputs['PhotoModeKey']) then
		inPhoto = false
	end
elseif not gallerySettings['EnablePhotoMode'] then
	if keyJustPressed('right') then
		playSound('scrollMenu')
		--id = id + 1
		onChange(1)
		setTextString('descriptionText', images[id].description)
		doTweenColor('ColorRight', 'RightArrow', '808080', -1)
		runTimer('right', 0.1)
	end
	if keyJustPressed('left') then
		playSound('scrollMenu')
		--id = id - 1
		onChange(-1)
		setTextString('descriptionText', images[id].description)
		doTweenColor('ColorLeft', 'LeftArrow', '808080', -1)
		runTimer('left', 0.1)
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..inputs['PhotoModeKey']) then
		inPhoto = false
	end
end

	if keyJustPressed('back') then
		playSound('cancelMenu')
		endSong()
		return Function_Continue;
	end
	-- 									<-- Photo Mode ;-; -->
	if inPhoto then
		doTweenAlpha('leftImageBrr', 'left2', 0, 0.1, 'sineOut')
		doTweenAlpha('RightImageBrr', 'Right2', 0, 0.1, 'sineOut')

		doTweenAlpha('descriptionTextAlpha', 'descriptionText', 0, 0.1, 'sineOut')

		doTweenAlpha('LogoImageBrr', 'logo', 0, 0.1, 'sineOut')
		doTweenAlpha('BgLogoBrr', 'bglogo', 0, 0.1, 'sineOut')
		doTweenAlpha('BgLogo2Brr', 'bglogo2', 0, 0.1, 'sineOut')
		doTweenAlpha('BgLogo3Brr', 'bglogo3', 0, 0.1, 'sineOut')

		doTweenAlpha('rightButton', 'RightArrow', 0, 0.1, 'sineOut')
		doTweenAlpha('leftButton', 'LeftArrow', 0, 0.1, 'sineOut')
		--							--> CONTROLS OR SMTH <--

		if keyPressed('left') then
			setProperty('Middle2.x', getProperty('Middle2.x') - scrollSpeed)
		end
			if keyPressed('right') then
			setProperty('Middle2.x', getProperty('Middle2.x')+ scrollSpeed)
			end
				if keyPressed('down') then
				setProperty('Middle2.y', getProperty('Middle2.y')+ scrollSpeed)
				end
					if keyPressed('up') then
					setProperty('Middle2.y', getProperty('Middle2.y')- scrollSpeed)
					end

		if keyPressed('space') then
			scrollSpeed = gallerySettings['Shift View Speed'] + 2
		else
			scrollSpeed = gallerySettings['Shift View Speed']
		end

		if getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..inputs['ZoomInKey']) then
		setProperty('Middle2.scale.x', getProperty('Middle2.scale.x')+0.01)
		setProperty('Middle2.scale.y', getProperty('Middle2.scale.y')+0.01)
		elseif getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..inputs['ZoomOutKey']) and getProperty('Middle2.scale.x') >= 0.1 then
		setProperty('Middle2.scale.x', getProperty('Middle2.scale.x')-0.01)
		setProperty('Middle2.scale.y', getProperty('Middle2.scale.y')-0.01)
		end

	else
		doTweenAlpha('leftImageBrr', 'left2', 0.5, 0.25, 'sineOut')
		doTweenAlpha('RightImageBrr', 'Right2', 0.5, 0.25, 'sineOut')

		doTweenAlpha('descriptionTextAlpha', 'descriptionText', 1, 0.25, 'sineOut')

		doTweenAlpha('LogoImageBrr', 'logo', 1, 0.25, 'sineOut')
		doTweenAlpha('BgLogoBrr', 'bglogo', 1, 0.25, 'sineOut')
		doTweenAlpha('BgLogo2Brr', 'bglogo2', 1, 0.25, 'sineOut')
		doTweenAlpha('BgLogo3Brr', 'bglogo3', 1, 0.25, 'sineOut')

		doTweenX('BackMiddleX', 'Middle2', 380, 0.15, 'sineOut')
		doTweenY('BackMiddleY', 'Middle2', 100, 0.15, 'sineOut')

		doTweenAlpha('rightButton', 'RightArrow', 1, 0.15, 'sineOut')
		doTweenAlpha('leftButton', 'LeftArrow', 1, 0.15, 'sineOut')

		setGraphicSize('Middle2', images[id].sizeSelected * 100)
	end
end
function onChange(num)
id = id + num
	
if (id < 0) then
	id = length ;
end
if (id > length) then
	id = 0;
end
if id == 0 then
	makeLuaSprite('left2', 'gallery/'..images[length].name, 60, 100)
	makeLuaSprite('Middle2', 'gallery/'..images[id].name, 380, 100)
	makeLuaSprite('Right2', 'gallery/'..images[id + 1].name, 280*3, 100)

	setGraphicSize('left2', images[length].sizeNotSelected * 100)
	setGraphicSize('Right2', images[id + 1].sizeNotSelected * 100)
elseif id == length  then
	makeLuaSprite('left2', 'gallery/'..images[id-1].name, 60, 100)
	makeLuaSprite('Middle2', 'gallery/'..images[id].name, 380, 100)
	makeLuaSprite('Right2', 'gallery/'..images[0].name, 280*3, 100)

	setGraphicSize('left2', images[id-1].sizeNotSelected * 100)
	setGraphicSize('Right2', images[0].sizeNotSelected * 100)
else
	makeLuaSprite('left2', 'gallery/'..images[id-1].name, 60, 100)
	makeLuaSprite('Middle2', 'gallery/'..images[id].name, 380, 100)
	makeLuaSprite('Right2', 'gallery/'..images[id +1 ].name, 280*3, 100)

	setGraphicSize('left2', images[id-1].sizeNotSelected * 100)
	setGraphicSize('Right2', images[id + 1].sizeNotSelected * 100)
end
	setGraphicSize('Middle2', images[id].sizeSelected * 100)

	setProperty('left2.alpha', 0.5)
	setProperty('Middle2.alpha', 1)
	setProperty('Right2.alpha', 0.5)

	addLuaSprite('left2')
	addLuaSprite('Right2')
	addLuaSprite('Middle2')

	setObjectCamera('left2', 'Other')
	setObjectCamera('Middle2', 'Other')
	setObjectCamera('Right2', 'Other')

	setObjectOrder('left2',getObjectOrder('bglogo'))
	setObjectOrder('Right2',getObjectOrder('bglogo'))
	setObjectOrder('Middle2',getObjectOrder('bglogo'))
	

end
function fuckHud()
		setProperty('scoreTxt.visible', false)
        setProperty('healthBar.visible', false)
        setProperty('healthBarBG.visible', false)
        setProperty('iconP1.visible', false)
        setProperty('iconP2.visible', false)
end

function onTimerCompleted(tag) --for buttons thing
	if tag == 'right' then
		doTweenColor('ColorRight', 'RightArrow', 'FFFFFF', 0.1)
	end
	if tag == 'left' then
		doTweenColor('ColorLeft', 'LeftArrow', 'FFFFFF', 0.1)
	end
end
