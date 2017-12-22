package
{

import starling.display.Sprite;
import flash.utils.setTimeout;
import starling.extensions.rtl_text.BitmapFontRTL;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

/**
 * ...
 * @author Hadi Tavakoli
 */
public class MainApp extends Sprite
{
	public static var theBase:Main;
	
	[Embed(source="assets/BKoodakBold.fnt", mimeType="application/octet-stream")]
	public static const KoodakXml:Class;
	
	[Embed(source="assets/BKoodakBold.0.png")]
	public static const KoodakTexture:Class;
	
	[Embed(source="assets/Tahoma.fnt", mimeType="application/octet-stream")]
	public static const TahomaXml:Class;
	
	[Embed(source="assets/Tahoma.0.png")]
	public static const TahomaTexture:Class;
	
	public function MainApp():void
	{
		setTimeout(init, 1000);
	}
	
	private function init():void
	{
		var text:String = "آاببب اب با اپپپ اپ اتتت ات اثثث اث اججج اج اچچچ اچ اححح اح اخخخ اخ ادید اذیذ اریر ازیز اژیژ اسسس اس اششش اش اصصص اص اضضض اض اططط اط اظظظ اظ اععع اع اغغغ اغ اففف اف اققق اق اککک اک اگگگ اگ اللل ال اممم ام اننن ان اویو اههه اه اییی ای";
		
		var texture:Texture = Texture.fromEmbeddedAsset(KoodakTexture);
		var xml:XML = XML(new KoodakXml());
		var bmpFontRTL:BitmapFontRTL = new BitmapFontRTL(texture, xml);
		TextField.registerCompositor(bmpFontRTL, bmpFontRTL.name);
		
		var textField:TextField = new TextField(stage.stageWidth * 0.9, stage.stageHeight * 0.9, text);
		textField.setRequiresRecomposition();
		textField.format.setTo("BKoodakBold", 30, Color.WHITE);
		textField.format.horizontalAlign = Align.CENTER;
		textField.format.verticalAlign = Align.CENTER;
		textField.border = true;
		textField.x = stage.stageWidth - textField.width >> 1;
		textField.y = stage.stageHeight - textField.height >> 1;
		textField.alpha = 0.5;
		addChild(textField);
	}
	
}

}