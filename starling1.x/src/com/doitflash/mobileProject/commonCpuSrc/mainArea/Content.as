package com.doitflash.mobileProject.commonCpuSrc.mainArea
{
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.modules.MySprite;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/6/2012 5:47 PM
	 */
	public class Content extends MySprite 
	{
		public static const INFO:String = "INFO";
		public static const READY:String = "onContentReady";
		
		private var _currPage:MyMovieClip;
		private var _backBtnEngaged:Boolean;
		
		private var _isWaitingForJavaPlugin:Boolean;
		
		public function Content():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			/*_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 10;*/
			drawBg();
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_base.holder.addEventListener(AppEvent.FRAMERATE_CHANGE, onFrameRateChange);
			
			onResize();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			//_bg.graphics.clear();
			_bg.graphics.lineStyle(1, 0xE1E1E1);
			_bg.graphics.moveTo(0, 0);
			_bg.graphics.lineTo(0, _height);
			_bg.graphics.endFill();
			
			if (_currPage)
			{
				_currPage.width = _width;
				_currPage.height = _height;
			}
		}
		
		private function howsBackBtnStatus(e:AppEvent):void
		{
			_backBtnEngaged = e.param;
		}
		
		private function onPageReady(e:AppEvent):void
		{
			//_base.c.log("onPageReady 1");
			this.dispatchEvent(new AppEvent(AppEvent.MODULE_READY));
		}
		
		private function onPageClose(e:AppEvent):void
		{
			this.dispatchEvent(new AppEvent(AppEvent.FORCE_CLOSE));
		}
		
		public function javaApkResult($result:Object):void
		{
			_base.showPreloader(false);
			
			if ($result.status)
			{
				if ($result.isAppInstalled)
				{
					_isWaitingForJavaPlugin = true;
					_base.runJavaPlugin(_data);
				}
			}
			else
			{
				_base.showPreloader(true, $result.msg);
				setTimeout(_base.showPreloader, 2500, false);
			}
			
			_isWaitingForJavaPlugin = false;
		}
		
		private function onFrameRateChange(e:AppEvent):void
		{
			if (stage.frameRate > 10 && _isWaitingForJavaPlugin)
			{
				_base.runJavaApk(javaApkResult);
				_isWaitingForJavaPlugin = false;
			}
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		public function update():void // show content and then dispatch that we're ready to be shown
		{
			//_base.c.log("show plugin...");
			clear();
			
			// check if _data.type is a pointing to a java or html plugin?
			if (_data.type.substr(0, 4) == "JAVA" || _data.type.substr(0, 4) == "HTML")
			{
				_base.runJavaApk(javaApkResult);
				setTimeout(_base.showPreloader, 1000, false);
				_isWaitingForJavaPlugin = true;
			}
			else
			{
				// initialize the required page .swf file according to _data.type
				_currPage = _base.bulkLoader.getMovieClip(_data.type) as MyMovieClip;
				_currPage.addEventListener(AppEvent.BACK_BUTTON_ENGAGED, howsBackBtnStatus);
				_currPage.addEventListener(AppEvent.MODULE_READY, onPageReady);
				_currPage.addEventListener(AppEvent.FORCE_CLOSE, onPageClose);
				_currPage.base = _base;
				_currPage.data = _data;
				this.addChild(_currPage);
				
				onResize();
				
				//_base.c.log("_currPage = " + _currPage)
				//_base.c.log("_currPage.base = " + _currPage.base)
			}
		}
		
		public function clear():void // remove content to save resources
		{
			_backBtnEngaged = false;
			
			if (_currPage)
			{	
				this.removeChild(_currPage);
				
				_currPage.removeEventListener(AppEvent.BACK_BUTTON_ENGAGED, howsBackBtnStatus);
				_currPage.removeEventListener(AppEvent.MODULE_READY, onPageReady);
				_currPage = null;
			}
		}

// ----------------------------------------------------------------------------------------------------------------------- Properties

		public function get backBtnEngaged():Boolean
		{
			return _backBtnEngaged;
		}
		
	}
	
}