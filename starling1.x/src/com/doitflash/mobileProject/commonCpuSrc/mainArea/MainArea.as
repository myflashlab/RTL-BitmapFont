package com.doitflash.mobileProject.commonCpuSrc.mainArea
{
	import com.doitflash.text.modules.MyMovieClip;
	import com.greensock.easing.*;
	import com.greensock.TweenMax;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.Responder;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/6/2012 5:47 PM
	 */
	public class MainArea extends MyMovieClip 
	{
		protected var _content:Content;
		protected var _body:Sprite;
		
		public function MainArea():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 0.5;
			//_bgColor = 0xFF9900;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xF000FF;
			//_bgStrokeThickness = 5;
			drawBg();
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		protected function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_base.addEventListener(AppEvent.BACK_BUTTON_CLICK, onDeviceBackButtClick);
			_base.addEventListener(AppEvent.ORIENTATION_CHANGE, onOrientationChanged);
			
			_body = new Sprite();
			this.addChild(_body);
			
			initContent();
		}
		
		private function initContent():void
		{
			_content = new Content();
			_content.base = _base;
			_content.visible = false;
			this.addChild(_content);
		}
		
		protected function onNavSelect(e:AppEvent):void
		{
			/*for (var name:String in e.param) 
			{
				_base.c.log(name + " = " + unescape(e.param[name]))
			}*/
			
			//TweenMax.to(_body, 0.5, {x:-_width+50, ease:Expo.easeOut});
			//_base.c.log("on nav select")
			
			
			if (_base.db.available) // check if the local db file is available?
			{
				// check if required data is available in the local db?
				var obj:Object = _base.db.getPageContent(e.param["id"])[0];
				if (obj.content)
				{
					_base.showPreloader(true);
					//gotoPage(obj.id, obj.type, obj.content);
					setTimeout(gotoPage, 1, obj.id, obj.type, obj.localDb, obj.content);
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
				if (_base.networkMonitor.available)
				{
					_base.showPreloader(true);
					_base.gateway.call("APP.GetData.getPageContent", new Responder(onPageContentResult, _base.onFault), e.param["id"]);
				}
				else
				{
					_base.showPreloader(true, "Connection error...");
				}
			}
		}
		
		private function onPageContentResult($result:Object):void
		{
			_base.showPreloader(false);
			//_base.c.log(">-> ", $result.pageContent[0].id)
			//_base.c.log(">-> ", $result.pageContent[0].content)
			
			// save page content into the local db
			_base.db.savePageContent($result.pageContent[0]);
			
			var obj:Object = _base.db.getPageContent($result.pageContent[0].id)[0];
			_base.showPreloader(true);
			//gotoPage(obj.id, obj.type, obj.content);
			setTimeout(gotoPage, 1, obj.id, obj.type, obj.localDb, obj.content);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_content)
			{
				_content.width = _width;
				_content.height = _height;
			}
		}
		
		private function gotoPage($pageId:int, $pageType:String, $pageLocalDb:String, $pageContent:String):void
		{
			//_base.c.log("gotoPage("+$pageId+", "+$pageType+", ");
			_content.data = { type:$pageType, localDb:$pageLocalDb, id:$pageId, content:$pageContent };
			_content.addEventListener(AppEvent.MODULE_READY, showContent);
			_content.addEventListener(AppEvent.FORCE_CLOSE, hideContent);
			_content.update();
		}
		
		private function showContent(e:Event=null):void
		{
			//_base.c.log("showContent");
			_base.showPreloader(false);
			
			// take snapshots
			var bmd:BitmapData = takeSnapshots();
			//var bm:Bitmap = new Bitmap(bmd, "auto", true);
			var bm:Bitmap = _base.bitmapPool.borrowObject();
			bm.bitmapData = bmd;
			bm.pixelSnapping = "auto";
			bm.smoothing = true;
			
			bm.x = 0;
			
			this.addChild(bm);
			
			TweenMax.killAll(true);
			TweenMax.to(bm, 1, { x: -_width, ease:Expo.easeOut, delay:0.5, onComplete:onAnimationDone } );
			
			_body.visible = false;
			
			function onAnimationDone():void
			{
				_content.visible = true;
				
				removeChild(bm);
				//bm = null;
				_base.bitmapPool.returnObject(bm);
				bmd.dispose();
			}
		}
		
		private function hideContent(e:Event=null):void
		{
			// take snapshots
			var bmd:BitmapData = takeSnapshots();
			//var bm:Bitmap = new Bitmap(bmd, "auto", true);
			var bm:Bitmap = _base.bitmapPool.borrowObject();
			bm.bitmapData = bmd;
			bm.pixelSnapping = "auto";
			bm.smoothing = true;
			
			bm.x = -_width;
			this.addChild(bm);
			
			TweenMax.killAll(true);
			TweenMax.to(bm, 1, { x: 0, ease:Expo.easeOut, delay:0.5, onComplete:onAnimationDone } );
			
			_content.visible = false;
			
			function onAnimationDone():void
			{
				_body.visible = true;
				
				_content.clear();
				
				removeChild(bm);
				//bm = null;
				_base.bitmapPool.returnObject(bm);
				bmd.dispose();
				
				// force garbage collection
				System.gc();
			}
		}
		
		protected function onDeviceBackButtClick(e:AppEvent):void
		{
			if (_content.backBtnEngaged) return; // means the page module needs the back button for it's own functionaleties.
			
			if (!_content.visible && !_body.visible) return; //make sure not to run the hiding animation again if it's already in process
			
			if (_body.visible)
			{
				_base.closeApp();
			}
			else
			{
				hideContent();
			}
		}
		
		protected function onOrientationChanged(e:AppEvent):void
		{
			//trace(">> ", e.param.before, e.param.after)
		}
		
		private function takeSnapshots():BitmapData
		{
			var bmd1:BitmapData = new BitmapData(_width, _height, true, 0x00000000);
			bmd1.draw(_body);
			
			var bmd2:BitmapData = new BitmapData(_width, _height, true, 0x00000000);
			bmd2.draw(_content);
			
			var bmd:BitmapData = new BitmapData(_width*2, _height, true, 0x00000000);
			bmd.copyPixels(bmd1, new Rectangle(0, 0, _width, _height), new Point(0, 0));
			bmd.copyPixels(bmd2, new Rectangle(0, 0, _width, _height), new Point(_width, 0));
			
			bmd1.dispose();
			bmd2.dispose();
			
			return bmd;
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}