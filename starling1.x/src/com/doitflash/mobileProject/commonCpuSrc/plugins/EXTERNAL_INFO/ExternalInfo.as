package com.doitflash.mobileProject.commonCpuSrc.plugins.EXTERNAL_INFO
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.Plugin;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	
	import flash.display.Bitmap;
    import flash.display.BitmapData;
	import flash.geom.Rectangle;
	//import flash.media.StageWebView;
	//import flash.events.LocationChangeEvent;
	
	//import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Ali Tavakoli - 7/1/2012 4:29 PM
	 */
	public class ExternalInfo extends Plugin 
	{
		private var _toast:*;
		
		private var _stageWebView:*;
		private var _stageWebViewRect:Rectangle;
		private var _bm:Bitmap;
		
		public function ExternalInfo():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_margin = 10;
			_bgAlpha = 1;
			_bgColor = 0x000000;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			drawBg();
			
			
		}
		
		override protected function stageRemoved(e:Event = null):void 
		{
			if (_bm)
			{
				removeChild(_bm);
				_bm = null;
				//_bmd.dispose();
			}
			
			if (_toast) _toast = null;
			// stageWebView will be removed at backBtnHit()
			
			super.stageRemoved(e);
		}
		
		override protected function stageAdded(e:Event = null):void 
		{
			super.stageAdded(e);
			
			if (_base.networkMonitor.available)
			{
				dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, true));
				
				setTimeout(dispatch, 50);
				function dispatch():void
				{
					dispatchEvent(new AppEvent(AppEvent.MODULE_READY));
					setTimeout(setSettings, 1000);
				}
			}
			else
			{
				//showToast();
				_base.showPreloader(true, "No cache and no internet connection!");
				stageRemoved();
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function setSettings():void
		{
			setStageWebView();
			onResize();
		}
		
		private function setStageWebView():void
		{
			if (!_stageWebViewRect) _stageWebViewRect = new Rectangle(0, 0, _width, _height);
			
			if (_base.deviceInfo.supportsStageWebView)
			{
				if (!_stageWebView) _stageWebView = new _base.deviceInfo.stageWebView();
				_stageWebView.stage = this.stage;
				_stageWebView.viewPort = _stageWebViewRect;
				//_stageWebView.addEventListener(Event.COMPLETE, pageLoaded); // e.target.title
				//_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, locationChanged); // e.location
				
				// if (_stageWebView.isHistoryBackEnabled) _stageWebView.historyBack();
				// if (_stageWebView.isHistoryForwardEnabled) _stageWebView.historyForward();
				_stageWebView.loadURL(unescape(_data.content));
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_stageWebViewRect && _stageWebView)
			{
				_stageWebViewRect.width = _width;
				_stageWebViewRect.height = _height;
				
				_stageWebView.viewPort = _stageWebViewRect;
			}
		}
		
		override protected function onNetStatus(e:AppEvent):void
		{
			if (!e.param.available) showToast();
			//_base.c.log(e.param.status, " = ", e.param.msg)
			//_base.c.log(e.param.available);
		}
		
		private function showToast():void
		{
			if (!_toast) _toast = new _base.nativeExtensions["myExtensions"]();
			_toast.showToast("No cache and no internet connection!", true);
		}
		
		
		
		
		override public function backBtnHit($historyId:String=null):void
		{
			if (navHistory.length == 0) // if nothing is open and we're about to close the plugin, remove stageWebView
			{
				if (_stageWebView)
				{
					var bmd:BitmapData = new BitmapData(_stageWebView.viewPort.width, _stageWebView.viewPort.height);
					_stageWebView.drawViewPortToBitmapData(bmd);
					
					_bm = new Bitmap();
					_bm.bitmapData = bmd;
					_bm.pixelSnapping = "auto";
					addChild(_bm);
					
					//_stageWebView.stage = null;
					_stageWebView.dispose();
					_stageWebView = null;
					_stageWebViewRect = null;
				}
			}
			
			super.backBtnHit($historyId);
			dispatchEvent(new AppEvent(AppEvent.FORCE_CLOSE));
		}
		
		
		
		
		/*private function showConnectionAlert():void
		{
			var nativeAlert:* = new base.nativeExtensions["air3Extension"]();
			nativeAlert.addEventListener("status", onNativeAlertStatus); // when a button on alert is clicked
			nativeAlert.alertDialog("Network Error!","Internet connection error.\n\nPlease check your connection.");
		}
		private function onNativeAlertStatus(e:*):void
		{
			e.target.removeEventListener("status", onNativeAlertStatus);
			//e.code == "alertDialog"
			if (e.level == "ok")
			{
				_base.c.log("ok pressed!");
			}
		}*/
		
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}