package 
{
	import com.doitflash.starling.MySprite;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	
	import flash.system.Capabilities;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.media.StageWebView;
	import flash.desktop.SystemIdleMode;
	
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Hadi Tavakoli
	 */
	public class Main extends Sprite 
	{
		private var _starling:Starling;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, onResize);
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			MainApp.theBase = this;
			
			_starling = new Starling(MainApp, stage);
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext);
			_starling.enableErrorChecking = false;
			_starling.antiAliasing = 1;
			_starling.start();
		}
		
		private function onContext(e:Event=null):void
		{
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = stage.stageWidth; 
			viewPortRectangle.height = stage.stageHeight;
			
			Starling.current.viewPort = viewPortRectangle;
			
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			
			Starling.current.root["onContextReady"]();
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}