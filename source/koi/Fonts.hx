package koi;    
    
import flixel.graphics.frames.FlxBitmapFont;    
import openfl.utils.Assets;    
        
class Fonts {    
    static var presents:FlxBitmapFont;
        
    public static function getPresents(): FlxBitmapFont {    
        if (presents == null) {    
            var silverXMLData = Xml.parse(Assets.getText("assets/fonts/Presents Font.fnt"));    
            presents = FlxBitmapFont.fromAngelCode("assets/fonts/Presents Font.png", silverXMLData);    
        }    
        return presents;    
    }    
}