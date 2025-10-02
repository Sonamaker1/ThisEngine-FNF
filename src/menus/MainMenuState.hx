package menus;

import backend.Paths;
import hxd.Key;
import hxd.Window;
import objects.AnimatedSprite;
import hxd.Res;
import h2d.Bitmap;
import backend.MusicBeatState;

enum Direction {
    UP;
    DOWN;
    NONE;
}

class MainMenuState extends MusicBeatState {
    var bg:Bitmap;

    var optionsArray:Array<String> = ["story_mode", "freeplay", "mods", "credits", "options", "achievements"];

    var menuOptions:Array<AnimatedSprite> = [];
    var storyMode:AnimatedSprite;
    var freeplay:AnimatedSprite;
    var options:AnimatedSprite;

    var curSelected:Int = 0;
    public static final screenWidth:Int = 1280;
    public static final screenHeight:Int = 720;
    
    public function new() {
        super();

        bg = new Bitmap(Paths.image("main_menu/menuBG"));
        addObj(bg);

        for (i in 0...optionsArray.length) {
            
            //var menuOption:AnimatedSprite = new AnimatedSprite(0, 50 + 225 * i, Res.images.mainMenu.mainMenu_png.toTile());
            var menuOption:AnimatedSprite = new AnimatedSprite(screenWidth/2, 90 + 140 * i, Paths.image('main_menu/menu_${optionsArray[i]}') );
            
            menuOption.addAnimation("idle", '${optionsArray[i]} idle', true, null, true );
            menuOption.addAnimation("selected", '${optionsArray[i]} selected',true, null, true);
            menuOption.playAnimation("idle");

            if (i == 0) menuOption.setScale(0.95);
            menuOption.x = (screenWidth) / 2;
            
            var checkThese = ["options", "achievements"];
            var indexThese = checkThese.indexOf(optionsArray[i]);
            if(indexThese > -1){
                menuOption.y = 60 + 140 * (i - indexThese);
                menuOption.x = screenWidth*3/4 + indexThese*150 + 50;
                menuOption.setScale(0.70);
            }
            menuOptions.push(menuOption);
            addObj(menuOptions[i]);
        }

        moveSelection(NONE);
    }

    override function update(dt:Float) {
        super.update(dt);
        if (Key.isPressed(Key.DOWN)) moveSelection(DOWN);

        if (Key.isPressed(Key.UP)) moveSelection(UP);

        if (Key.isPressed(Key.RIGHT)) moveSelection(DOWN);
        if (Key.isPressed(Key.LEFT)) moveSelection(UP);

        if (Key.isPressed(Key.ENTER)) {
            // if (TitleState.song != null) TitleState.song.pause = true;
            changeScene(new TitleState());
        }

        if (Key.isPressed(Key.BACKSPACE)) {
            // if (TitleState.song != null) TitleState.song.pause = true;
            changeScene(new TitleState());
        }
    }

    function moveSelection(direction:Direction) {
        GLGU.playSound("scrollMenu");
        var lastSelected = Std.int(curSelected);
        if (direction != NONE) direction == UP ? curSelected-- : curSelected++;
        curSelected = (curSelected + menuOptions.length ) % menuOptions.length;
        
        menuOptions[curSelected].playAnimation("selected");
        menuOptions[lastSelected].playAnimation("idle");

        for (i in 0...menuOptions.length) {
            var menuOption = menuOptions[i];            
            menuOption.x = (screenWidth) / 2;
            
            var checkThese = ["options", "achievements"];
            var indexThese = checkThese.indexOf(optionsArray[i]);
            if(indexThese > -1){
                menuOption.x = screenWidth*3/4 + indexThese*150 + 50;
            }
            //menuOptions[i].x = (screenWidth - menuOptions[i].getBounds().width) / 2;
        }
    }
}