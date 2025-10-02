package backend;

import haxe.Json;
import hxd.res.Sound;
import h2d.Tile;
import hxd.Res;

using StringTools;
class Paths {
    public static var graphicCache:Map<String, Tile> = [];

    /**
     * @param key The asset you want to load. DO NOT include "res/" in the key
     * @param returnTile Whether or not to return the loaded image as a tile.
     */
    public static function image(key:String, ?dontLog:Bool = false, ?returnTile:Bool = true):Dynamic {
        var no_key = "missingImage_default_reallylongnameIhopenobodyuses";
        if (!sys.FileSystem.exists("res/images/" + key + ".png")){
            trace('res/images/${key}.png was not found, please add a file at this location');
            key = no_key;
        }
        
        if(!graphicCache.exists(no_key)){
            var tilePlaceholder = Res.load("internal/missing_texture.png").toImage().toTile();
            graphicCache.set(no_key, tilePlaceholder);
        }
        
        if (graphicCache.exists(key)) {
            if (!dontLog) GLogger.info("Returned graphic from cache - " + key);
            return graphicCache.get(key);
        }
        
        try{
            var tileToReturn = Res.load("images/" + key + ".png").toImage().toTile();
            graphicCache.set(key, tileToReturn);
            GLogger.info('Set $key in graphicCache');
            if (returnTile) return tileToReturn;
        }
        catch(err){
            GLogger.error('Could not load ${'key'} (but file exists)');
            return graphicCache.get(no_key);
        }
        
        return 'res/$key.png';
    }

    public static function cacheGraphic(key:String) {
        if (!graphicCache.exists(key)) {
            try{
                var tileToReturn = Res.load("images/" + key + ".png").toImage().toTile();
                graphicCache.set(key, tileToReturn);
                GLogger.success('Sucessfully cached graphic ($key)');
            }
            catch(err){
                GLogger.error('Could not cache ${'key'}');
            }
            
        }
        else GLogger.warning('The tile you\'re trying to cache already exists in the cache ($key)');
    }

    /**
     * Returns a Channel (`songs/key.ogg`)
     */
    public static function song(key:String, ?returnString:Bool):hxd.snd.Channel {
        var song = Res.load("songs/" + key + ".ogg").toSound().play();
        song.pause = true;
        return song;
    }

    /**
     * Returns a Channel (`music/key.ogg`)
     */
    public static function music(key:String, ?returnString:Bool):hxd.snd.Channel {
        var location = "music/" + key + ".ogg";
        if (!sys.FileSystem.exists("res/"+location)){
            var song = Res.load("internal/missing_audio.ogg").toSound().play();
            song.pause = true;
            return song;
        }
        var song = Res.load(location).toSound().play();
        song.pause = true;
        return song;
    }

    public static function checkFileContent(path:String, ?type:String = ""):Dynamic {
        if(!sys.FileSystem.exists(path)){
            GLogger.error('Could not find ${'path'}.${type}');
            switch(type){
                case "xml": return sys.io.File.getContent("res/internal/missing_texture.xml"); 
                case "json": return sys.io.File.getContent("res/internal/missing_texture.json"); 
                default: return "";
            }
        }
        return sys.io.File.getContent(path);
    }
    /**
     * Returns a Sound (`sounds/key.ogg`)
     */
    public static function sound(key:String):Sound {
        var location = "sounds/" + key + ".ogg";
        if (!sys.FileSystem.exists("res/"+location)){
            return Res.load("internal/missing_audio.ogg").toSound();
        }
        return Res.load(location).toSound();
    }

    public static function parseChart(key:String):Dynamic {
        return Json.parse(checkFileContent("res/songs/" + key + "/chart.json".toLowerCase(),"json"));
    }

    public static function parseMetadata(key:String):Dynamic {
        return Json.parse(checkFileContent("res/songs/" + key + "/metadata.json".toLowerCase(),"json"));
    }

    /**
     * Returns the full path of an image.
     */
    public static function getTexPath(image:Tile):String {
        return "res/" + image.getTexture().name;
    }

    /**
     * Returns only the file file name of an image with no file extension
     */
     public static function getTexName(image:Tile):String {
        return Paths.getTexPath(image).split("/").pop().split(".").shift();
    }

    /**
     * Returns the full path of an xml.
     * TODO: Consolidate this function with getTexPath()
     */
     public static function getXmlPath(image:Tile):String {
        return "res/" + image.getTexture().name.replace(".png", ".xml");
    }

    public static function songCheck(key:String):String {
        return "res/songs/" + key + ".ogg";
    }
}