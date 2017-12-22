package com.doitflash.mobileProject.commonCpuSrc
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.StageOrientationEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Keyboard;
	import flash.events.StatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.air.extensions.MyExtensions;
	import br.com.stimuli.loading.BulkLoader;
	
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/1/2012 3:51 PM
	 */
	public class Startup extends Sprite 
	{
		private var _bulkLoader:BulkLoader;
		private var _preloader:*;
		
		private var _apk:MyExtensions;
		
		//private var view:StageWebViewBridge;
		
		public function Startup():void 
		{
			// touch or gesture?
			//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			stage.autoOrients = true;
			
			//stage.addEventListener(Event.DEACTIVATE, deactivate);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChanged); // must do this first: stage.autoOrients = true;
			
			if (DeviceInfo.cpuArchitecture == "ARM" || DeviceInfo.cpuArchitecture == "x86")
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			}
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// load preloader
			loadPreloader();
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			if (_preloader) stage.frameRate = _preloader.frameRate;
			else stage.frameRate = 30;
			
			setTimeout(dispatchFrameRateChanged, 500);
		}
		
		private function handleDeactivate(e:Event):void
		{
			stage.frameRate = 4;
			
			setTimeout(dispatchFrameRateChanged, 500);
		}
		
		private function dispatchFrameRateChanged():void
		{
			dispatchEvent(new AppEvent(AppEvent.FRAMERATE_CHANGE));
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			if (_preloader) _preloader.appInvoked(e.arguments);
		}
		
		public function closeApp(e:Event=null):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				_preloader.buttonBack();
            } 
			else if(e.keyCode == Keyboard.MENU)
            {
				e.preventDefault();
				_preloader.buttonMenu();
            }
		}
		
		private function onOrientationChanged(e:StageOrientationEvent):void
		{
			if(_preloader) _preloader.onOrientationChange(e.beforeOrientation, e.afterOrientation);
		}
		
		private function onResize(e:*=null):void
		{
			if (_preloader)
			{
				_preloader.width = stage.stageWidth;
				_preloader.height = stage.stageHeight;
				
				/*if (e && e.type == StageOrientationEvent.ORIENTATION_CHANGE)
				{
					_preloader.onOrientationChange(e.beforeOrientation, e.afterOrientation);
				}*/
			}
		}
		
		private function loadPreloader():void
		{
			// initialize the _bulkLoader
			_bulkLoader = new BulkLoader("myBulkLoader");
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onPreloader);
			_bulkLoader.add(new URLRequest("preloader.swf?assets=assets.xml&mainFile=main.swf"), { id:"preloader", type:BulkLoader.TYPE_MOVIECLIP } );
			_bulkLoader.start(10);
		}
		
		private function onPreloader(e:Event):void
		{
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onPreloader);
			
			_preloader = _bulkLoader.getMovieClip("preloader") as MyMovieClip;
			_preloader.addEventListener("apkCopy", onApkCopy);
			_preloader.addEventListener("apkRun", onApkRun);
			_preloader.holder = this;
			_preloader.deviceInfo = DeviceInfo;
			_preloader.nativeExtensions = NativeExtensions;
			_preloader.db = DbClient;
			_preloader.networkMonitor = new NetworkMonitor();
			_preloader.sql = Sql;
			_preloader.bulkLoader = _bulkLoader;
			onResize();
			this.addChild(_preloader);
		}
		
		private function onApkCopy(e:AppEvent):void
		{
			var apkVersion:String = _preloader.xml.pluginUpdateId.text();
			var loader:URLLoader;
			var resultFunc:Function = e.param.result;
			var apk:File = File.documentsDirectory.resolvePath(String(_preloader.xml.appName.text()) + "/plugins.apk");
			
			_apk = new MyExtensions();
			_apk.addEventListener(StatusEvent.STATUS, onApkCheck);
			
			if (apk.exists)
			{
				// check if the apk is copied to sd cart and is it installed and up-to-date?
				_apk.InstallAPK("/" + _preloader.xml.appName.text() + "/", "plugins.apk", _preloader.xml.appName.text(), apkVersion, false);
			}
			else
			{
				doApkCopy();
			}
			
			function doApkCopy():void
			{
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, apkCopy);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onApkNotFound);
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.load(new URLRequest("assets/blindTools/plugins.apk"));
			}
			
			function onApkNotFound(e:IOErrorEvent):void
			{
				loader.removeEventListener(Event.COMPLETE, apkCopy);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onApkNotFound);
				
				resultFunc({status:false, msg:"java apk not found!"});
			}
			
			function apkCopy(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, apkCopy);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onApkNotFound);
				
				var fileStream:FileStream = new FileStream();
				fileStream.addEventListener(Event.CLOSE, apkInstall);
				fileStream.openAsync(apk, FileMode.WRITE);
				fileStream.writeBytes(loader.data);
				fileStream.close();
			}
			
			function apkInstall(e:Event=null):void
			{
				_apk.InstallAPK("/" + _preloader.xml.appName.text() + "/", "plugins.apk", _preloader.xml.appName.text(), apkVersion, true);
			}
			
			function onApkCheck(e:StatusEvent):void
			{
				//trace(e.code, e.level)
				if (e.code == "status")
				{
					trace(e.level)
					return
				}
				
				var exp:RegExp = /[\w\d]+/gi;
				var checkResult:Array = String(e.level).match(exp);
				
				//var isInstalled:String = checkResult[0];
				//var apkVersion:String = checkResult[1];
				//var shouldGoForInstall:String = checkResult[2];
				
				if (!toBoolean(checkResult[0]) && !toBoolean(checkResult[2]))
				{
					doApkCopy();
					return;
				}
				
				if (toBoolean(checkResult[0]) && !toBoolean(checkResult[2]))
				{
					apkInstall();
					return;
				}
				
				if (toBoolean(checkResult[0]) && toBoolean(checkResult[2]))
				{
					resultFunc( { status:true, isAppInstalled:toBoolean(checkResult[0]) } );
					return;
				}
			}
		}
		
		private function onApkRun(e:AppEvent):void
		{
			// run the apk passing the required parameters for the specefic plugin
			var type:String = e.param.type;
			var content:String = e.param.content;
			var remoteDb:String = (e.param.remoteDbPrefix)? e.param.remoteDbPrefix : null;
			var localDb:String = (e.param.localDb)? e.param.localDb : null;
			
			if (type.substr(0, 4) == "HTML")
			{
				_apk.showPlugins("JAVA_WEB_VIEW", _preloader.proj + "fcms/amfphp/Services/plugins/" + type + "/" + type + "/index.php?content=" + content, remoteDb, localDb, _preloader.xml.appName.text());
			}
			else
			{
				_apk.showPlugins(type, unescape(content), remoteDb, localDb, _preloader.xml.appName.text());
			}
		}
		
		private function toBoolean(a:String):Boolean
		{
			if (a == "true") return true;
			
			return false;
		}
	}
	
}