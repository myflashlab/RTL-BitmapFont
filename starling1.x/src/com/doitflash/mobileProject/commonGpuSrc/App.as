package com.doitflash.mobileProject.commonGpuSrc
{
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import com.doitflash.mobileProject.commonGpuSrc.events.AppEventStarling;
	import com.doitflash.mobileProject.commonGpuSrc.PluginContainer;
	import com.greensock.easing.*;
	import com.greensock.TweenMax;
	import flash.geom.Rectangle;
	import flash.net.Responder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import flash.system.System;
	import net.hires.debug.Stats;
	//import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 8/7/2012 9:33 AM
	 */
	public class App extends Sprite 
	{
		protected var _isContextReady:Boolean = false;
		protected var _isAddedToStage:Boolean = false;
		protected var _isReady:Boolean = false;
		
		public static var theBase:Object;
		public static var data:Object;
		
		protected var _body:Sprite;
		protected var _pluginContainer:PluginContainer;
		
		public function App() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
		}
		
		private function onAddedStage(e:Event):void
		{
			_isAddedToStage = true;
			if(_isContextReady && _isAddedToStage) check();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			stage.addEventListener(ResizeEvent.RESIZE, onResize);
			
			App.theBase.addEventListener(AppEvent.BACK_BUTTON_CLICK, onDeviceBackButtClick);
			
			onResize();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Private

		private function check($refresh:Boolean = false):void
		{
			if ($refresh) _isReady = false;
			if (_isReady) return;
			
			_isReady = true;
			
			init();
		}
		
		protected function init():void
		{
			_body = new Sprite();
			this.addChild(_body);
			
			_pluginContainer = new PluginContainer();
			_pluginContainer.theBase = App.theBase;
			_pluginContainer.visible = false;
			_pluginContainer.width = stage.stageWidth;
			_pluginContainer.height = stage.stageHeight;
			this.addChild(_pluginContainer);
			
			theBase.cpuPluginContainer.visible = false;
		}
		
		protected function onNavSelect(e:Event):void
		{
			/*for (var name:String in e.data) 
			{
				trace(name + " = " + unescape(e.data[name]))
			}*/
			
			if (App.theBase.db.available) // check if the local db file is available?
			{
				// check if required data is available in the local db?
				var obj:Object =App.theBase.db.getPageContent(e.data["id"])[0];
				if (obj.content)
				{
					App.theBase.showPreloader(true);
					setTimeout(gotoPage, 500, obj.id, obj.type, obj.localDb, obj.content);
				}
				else
				{
					getPageContentFromServer();
				}
			}
			else
			{
				getPageContentFromServer();
			}
			
			function getPageContentFromServer():void
			{
				if (App.theBase.networkMonitor.available)
				{
					App.theBase.showPreloader(true);
					App.theBase.gateway.call("APP.GetData.getPageContent", new Responder(onPageContentResult, App.theBase.onFault), e.data["id"]);
				}
				else
				{
					App.theBase.showPreloader(true, "Connection error...");
				}
			}
		}
		
		private function onPageContentResult($result:Object):void
		{
			App.theBase.showPreloader(false);
			
			// save page content into the local db
			App.theBase.db.savePageContent($result.pageContent[0]);
			
			var obj:Object = App.theBase.db.getPageContent($result.pageContent[0].id)[0];
			App.theBase.showPreloader(true);
			setTimeout(gotoPage, 500, obj.id, obj.type, obj.localDb, obj.content);
		}
		
		private function gotoPage($pageId:int, $pageType:String, $pageLocalDb:String, $pageContent:String):void
		{
			_pluginContainer.data = { type:$pageType, localDb:$pageLocalDb, id:$pageId, content:$pageContent };
			_pluginContainer.addEventListener(AppEventStarling.MODULE_READY, showContent);
			_pluginContainer.addEventListener(AppEventStarling.FORCE_CLOSE, hideContent);
			_pluginContainer.update();
		}
		
		private function showContent(e:Event=null):void
		{
			/*var theSnapShot:Sprite = snapshot();
			this.addChild(theSnapShot);
			
			setTimeout(doAnimation, 1000);
			function doAnimation():void
			{
				App.theBase.showPreloader(false);
				TweenMax.to(theSnapShot, 1, { x:-stage.stageWidth, ease:Expo.easeOut, onComplete:onAnimationDone } );
			}
			
			_body.flatten();
			_body.visible = false;
			
			
			function onAnimationDone():void
			{
				_pluginContainer.visible = true;
				theBase.cpuPluginContainer.visible = true;
				removeChild(theSnapShot, true);
			}*/
			
			// --------------------------------------------------------------------
			
			_body.flatten();
			_body.visible = false;
			
			_pluginContainer.visible = true;
			theBase.cpuPluginContainer.visible = true;
			
			App.theBase.showPreloader(false);
		}
		
		private function hideContent(e:Event=null):void
		{
			/*App.theBase.showPreloader(true);
			
			setTimeout(prepareSnapshots, 10);
			var theSnapShot:Sprite;
			function prepareSnapshots():void
			{
				theSnapShot = snapshot();
				theSnapShot.x = -stage.stageWidth;
				addChild(theSnapShot);
				
				_pluginContainer.visible = false;
				theBase.cpuPluginContainer.visible = false;
			}
			
			setTimeout(doAnimation, 1000);
			function doAnimation():void
			{
				App.theBase.showPreloader(false);
				TweenMax.to(theSnapShot, 1, { x:0, ease:Expo.easeOut, onComplete:onAnimationDone } );
			}
			
			function onAnimationDone():void
			{
				_body.visible = true;
				_body.unflatten();
				removeChild(theSnapShot, true);
				_pluginContainer.clear();
				
				// force garbage collection
				System.gc();
			}*/
			
			// ----------------------------------------------------------------------
			
			_pluginContainer.visible = false;
			_pluginContainer.clear();
			theBase.cpuPluginContainer.visible = false;
			
			_body.visible = true;
			_body.unflatten();
			
			System.gc();
			
			App.theBase.showPreloader(false);
		}
		
		

// ----------------------------------------------------------------------------------------------------------------------- Helpfull

		protected function onResize(e:*=null):void
		{
			var w:Number;
			var h:Number;
			
			if (e)
			{
				Starling.current.viewPort = new Rectangle(0, 0, e.width, e.height);
				w = e.width;
				h = e.height;
			}
			else
			{
				w = App.theBase.deviceInfo.screenResolutionX;
				h = App.theBase.deviceInfo.screenResolutionY;
			}
			
			stage.stageWidth = w;
			stage.stageHeight = h;
		}
		
		protected function randomNum($min:Number, $max:Number):Number
		{
			return $min + Math.random() * ($max - $min);
		}
		
		private function onDeviceBackButtClick(e:AppEvent):void
		{
			if (App.theBase.preloaderMc.visible)
			{
				App.theBase.showPreloader(false);
				return;
			}
			
			if (!_body || !_pluginContainer)
			{
				App.theBase.closeApp();
				return
			}
			
			if (_pluginContainer.backBtnEngaged) return; // if the page module needs the back button for it's own functionaleties.
			
			if (!_pluginContainer.visible && !theBase.cpuPluginContainer.visible && !_body.visible) return; //make sure not to run the hiding animation again if it's already in process
			
			if (_body.visible)
			{
				App.theBase.closeApp();
			}
			else
			{
				App.theBase.showPreloader(true);
				setTimeout(hideContent, 1);
			}
		}
		
		/*private function snapshot():Sprite
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			var img1:Image;
			var img2:Image;
			var theSnapShot:Sprite = new Sprite();
			
			var texture1:RenderTexture = new RenderTexture(w, h, false);
			texture1.draw(_body);
			img1 = new Image(texture1);
			
			if (_pluginContainer.currPluginType == PluginContainer.GPU_PLUGIN)
			{
				var texture2:RenderTexture = new RenderTexture(w, h, false);
				texture2.draw(_pluginContainer);
				img2 = new Image(texture2);
			}
			else
			{
				var bmd2:BitmapData = new BitmapData(w, h, true, 0x00000000);
				bmd2.draw(theBase.cpuPluginContainer);
				img2 = new Image(Texture.fromBitmapData(bmd2));
				bmd2.dispose();
			}
			
			
			theSnapShot.addChild(img1);
			theSnapShot.addChild(img2);
			
			img2.x = img1.width;
			theSnapShot.flatten();
			
			
			theSnapShot.removeChild(img1, true);
			theSnapShot.removeChild(img2, true);
			
			return theSnapShot;
		}*/

// ----------------------------------------------------------------------------------------------------------------------- Methods

		/**
		 * 		use this method if you want to recreate textures when viewport is changed
		 */
		public function onContextReady():void
		{
			_isContextReady = true;
			if(_isAddedToStage && _isContextReady) check();
		}

// ----------------------------------------------------------------------------------------------------------------------- Getter - Setter

		

	}
}