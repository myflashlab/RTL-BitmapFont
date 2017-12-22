package  
{
	import com.doitflash.consts.Easing;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.starling.MyStarlingSprite;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import starling.textures.Texture;
	
	import starling.text.TextField;
	import starling.text.BitmapFont;
	import starling.extensions.RTL_BitmapFont.RTLTextField;
	import starling.extensions.RTL_BitmapFont.RTLBitmapFont;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Hadi Tavakoli
	 */
	public class MainApp extends Sprite 
	{
		private var _isContextReady:Boolean = false;
		private var _isAddedToStage:Boolean = false;
		private var _isReady:Boolean = false;
		
		public static var theBase:Main;
		
		//[Embed(source="assets/adobeArabic.fnt", mimeType="application/octet-stream")]
		//public static const AdobeArabicXml:Class;
		//
		//[Embed(source="assets/adobeArabic_0.png")]
		//public static const AdobeArabicTexture:Class;
		
		//[Embed(source="assets/BBadr.fnt", mimeType="application/octet-stream")]
		//public static const BBadrXml:Class;
		//
		//[Embed(source="assets/BBadr_0.png")]
		//public static const BBadrTexture:Class;
		
		//[Embed(source="assets/Tahoma.fnt", mimeType="application/octet-stream")]
		//public static const TahomaXml:Class;
		//
		//[Embed(source="assets/Tahoma_0.png")]
		//public static const TahomaTexture:Class;
		
		[Embed(source="assets/BKoodak.fnt", mimeType="application/octet-stream")]
		public static const KoodakXml:Class;
		
		[Embed(source="assets/BKoodak_0.png")]
		public static const KoodakTexture:Class;
		
		private var _titleTxt1:RTLTextField;
		private var _titleTxt2:RTLTextField;
		private var _titleTxt3:RTLTextField;
		private var _titleTxt4:RTLTextField;
		private var _fontSize:int = 40;
		
		public function MainApp():void
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedStage);
		}
		
		private function onAddedStage(e:starling.events.Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedStage);
			
			check();
			
			function check():void
			{
				if(_isContextReady)
				{
					init();
				}
				else
				{
					setTimeout(check, 1000)
				}
			}
		}
		
		private function init():void
		{
			//var texture:Texture = Texture.fromBitmap(new AdobeArabicTexture());
			//var xml:XML = XML(new AdobeArabicXml());
			//RTLTextField.registerBitmapFont(new RTLBitmapFont(texture, xml));
			
			//var texture1:Texture = Texture.fromBitmap(new BBadrTexture());
			//var xml1:XML = XML(new BBadrXml());
			//RTLTextField.registerBitmapFont(new RTLBitmapFont(texture1, xml1));
			
			//var texture2:Texture = Texture.fromBitmap(new TahomaTexture());
			//var xml2:XML = XML(new TahomaXml());
			//RTLTextField.registerBitmapFont(new RTLBitmapFont(texture2, xml2));
			
			var texture3:Texture = Texture.fromBitmap(new KoodakTexture());
			var xml3:XML = XML(new KoodakXml());
			RTLTextField.registerBitmapFont(new RTLBitmapFont(texture3, xml3));
			
			initTextField();
		}
		
		private function initTextField():void
		{
			_fontSize *= DeviceInfo.dpiScaleMultiplier;
			
			//_titleTxt1 = new RTLTextField((stage.stageWidth * 0.9), stage.stageHeight * 0.2, "بِسْمِ اللّه الرَّحْمنِ الرَّحیم", "B Koodak", _fontSize * 1.25, 0x333333, false, 10);
			//_titleTxt1.touchable = false;
			//_titleTxt1.batchable = true;
			//_titleTxt1.hAlign = HAlign.CENTER;
			//_titleTxt1.vAlign = VAlign.CENTER;
			//_titleTxt1.x = stage.stageWidth * 0.05;
			//_titleTxt1.y = stage.stageHeight * 0.1;
			//this.addChild(_titleTxt1);
			
			//_titleTxt2 = new RTLTextField((stage.stageWidth * 0.9), stage.stageHeight * 0.4, "بنی آدم اعضای یک پیکرند \n که در آفرینش ز یک گوهرند \n چو عضوی بدرد آورد روزگار \n دگر عضوها را نماند قرار", "B Koodak", _fontSize * 1.25, 0x333333, false, 10);
			//_titleTxt2.touchable = false;
			//_titleTxt2.batchable = true;
			//_titleTxt2.hAlign = HAlign.CENTER;
			//_titleTxt2.vAlign = VAlign.CENTER;
			//_titleTxt2.x = stage.stageWidth * 0.05;
			//_titleTxt2.y = stage.stageHeight * 0.4;
			//this.addChild(_titleTxt2);
			
			var str:String = "اً اٌ اٍ اَ اُ اِ اّ اًّ اٌّ اٍّ اَّ اُّ اِّ اببب اب با اپپپ اپ اتتت ات اثثث اث اججج اج اچچچ اچ اححح اح اخخخ اخ ادید اذیذ اریر ازیز اژیژ اسسس اس اششش اش اصصص اص اضضض اض اططط اط اظظظ اظ اععع اع اغغغ اغ اففف اف اققق اق اککک اک اگگگ اگ اللل ال اممم ام اننن ان اویو اههه اه اییی ای";
			
			_titleTxt3 = new RTLTextField((stage.stageWidth * 0.9), stage.stageHeight * 0.9, str, "B Koodak", _fontSize * 1.5, 0x333333, false, 10);
			_titleTxt3.touchable = false;
			_titleTxt3.batchable = true;
			_titleTxt3.hAlign = HAlign.CENTER;
			_titleTxt3.vAlign = VAlign.CENTER;
			_titleTxt3.x = stage.stageWidth * 0.05;
			_titleTxt3.y = stage.stageHeight * 0.05;
			this.addChild(_titleTxt3);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		public function onContextReady():void
		{
			_isContextReady = true;
		}
		
// ----------------------------------------------------------------------------------------------------------------------- getter - setter
		
	}

}