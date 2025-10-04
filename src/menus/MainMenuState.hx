package menus;

import backend.Paths;
import hxd.Key;
import hxd.Window;
import objects.AnimatedSprite;
import hxd.Res;
import h2d.Bitmap;
import backend.MusicBeatState;
import h3d.scene.Mesh;
import h3d.Camera;
import h3d.scene.CameraController;

enum Direction {
    UP;
    DOWN;
    NONE;
}

abstract Degree(Float){
  public inline function new (value:Float) this = value;
  public inline function toRadians() return this * Math.PI/180;
}

inline function toRads(degrees:Float){
    return degrees * Math.PI/180;
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
    var mesh:Mesh;
    var povVect = new h3d.Vector(0,0.08663,-15.73);
    var cameraController:CameraController;
    var s3dCamera:Camera;

    //Pos: {-14.75,0.7519,13.82}, Pov: {0,0.08663,-15.73} 
    public function setup3DObjects(){
        s3dCamera = Main.ME.s3d.camera;

        var cache = new h3d.prim.ModelCache();
        // Add a model library to cache.
        // This is optional, because `loadModel` and `loadAnimation` add it to cache automatically.
        // Returns hxd.fmt.hmd.Library
        cache.loadLibrary(hxd.Res.test_scene.FNFStage);
        // Create a model instance. Compared to manual model creation, ModelCache loads textures automatically.
        var mesh = cache.loadModel(hxd.Res.test_scene.FNFStage);
        for (materialObj in mesh.getMaterials()){
            materialObj.props = materialObj.getDefaultProps("ui");
            // @:privateAccess(h3d.mat.Material) {
            //     materialObj.set_blendMode(BlendMode.Alpha);

            // }
            //materialObj = 1.0;
        }
        // Optional: scale/position
        mesh.setPosition(0, 0, 0);
        mesh.setScale(1);
        //obj.setRotationAxis(0, 0, 1, new Degree(180).toRadians());
        //obj.setRotationAxis(1, 0, 0, new Degree(180).toRadians());

        Main.ME.engine.backgroundColor = 0xFF51305b;
        Main.ME.s3d.addChild(mesh);

        s3dCamera.up.set(mesh.x, mesh.y, mesh.z);
        // s3dCamera.follow.pos = mesh;
        // s3dCamera.follow.target = mesh;

        // Position the camera back a bit so it can see the cube
        s3dCamera.pos.set(-14.75,0,13.82);
        s3dCamera.up.set(0, 0, new Degree(180).toRadians());
        s3dCamera.update();
    }

    public function new() {
        super();

        setup3DObjects();
        //bg = new Bitmap(Paths.image("main_menu/menuBG"));
        //addObj(bg);

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
    
    var globalDelta = 0.0;
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
        globalDelta += dt;
        var povShiftZ = -toRads(90) - toRads(120) * Math.sin(globalDelta/2.5)/2;
        var povShiftY = -toRads(80) - toRads(80) * Math.sin(globalDelta/5) *4;
        s3dCamera.target.set( s3dCamera.pos.x + 25 + povVect.x , s3dCamera.pos.y +povVect.y + povShiftY, s3dCamera.pos.z +povVect.z + povShiftZ);

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