package com.doitflash.mobileProject.commonGpuSrc
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.navigateToURL;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import starling.textures.Texture;
	
	import starling.core.Starling;
	
	import com.doitflash.air.extensions.MyExtensions;
	import com.doitflash.mobileProject.commonCpuSrc.DbClient;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import com.doitflash.mobileProject.commonCpuSrc.NativeExtensions;
	import com.doitflash.mobileProject.commonCpuSrc.NetworkMonitor;
	import com.doitflash.mobileProject.commonCpuSrc.Sql;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.tools.RemotingConnection;
	import com.doitflash.utils.lists.List;
	import com.doitflash.utils.scroll.TouchScroll;
	import com.doitflash.starling.MySprite;
	
	import org.kissmyas.utils.loanshark.LoanShark;
	import br.com.stimuli.loading.BulkLoader;
	
	import assets.PreloaderAnimation;
	
	//import net.hires.debug.Stats;
	
	//import com.luaye.console.C;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 8/6/2012 4:20 PM
	 */
	public class Startup extends Sprite 
	{
		protected var _preloaderIcon:PreloaderAnimation;
		protected var _frameRate:int = 30;
		protected var _linkPattern:RegExp = new RegExp("(https?://)?(www\\.)?([\\w-.]*)\\b\\.[a-z\\d]{2,4}(\\.[a-z]{2})?((/[\\w_%+-?#&]*)+)?(\\.[a-z]*)?(:\\d{1,5})?", "g");
		protected var _db:* = DbClient;
		protected var _sql:* = Sql;
		protected var _deviceInfo:* = DeviceInfo;
		protected var _nativeExtensions:* = NativeExtensions;
		protected var _networkMonitor:NetworkMonitor = new NetworkMonitor();
		protected var _bulkLoader:BulkLoader;
		protected var _xml:XML;
		protected var _data:Object = { };
		protected var _proj:String;
		protected var _blindXml:XML;
		protected var _blindToolsPath:String;
		protected var _newApk:String;
		protected var _gateway:RemotingConnection;
		
		protected var _starling:Starling;
		private var _apk:MyExtensions;
		
		public var bitmapPool:LoanShark;
		public var touchScrollPool:LoanShark;
		public var listPool:LoanShark;
		public var mySpritePool:LoanShark;
		
		private var _tochTexture:com.doitflash.starling.MySprite;
		
		private var _cpuPluginContainer:Sprite;
		
		public function Startup():void 
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.autoOrients = false;
			
			stage.addEventListener(Event.RESIZE, onResize);
			//stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChanged); // must do this first: stage.autoOrients = true;
			
			if (DeviceInfo.cpuArchitecture == "ARM" || DeviceInfo.cpuArchitecture == "x86")
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			}
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			/*C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.width = 470;
			C.height = 320;
			C.strongRef = true;
			C.memoryMonitor = true;
			C.fpsMonitor = true;
			C.visible = true;*/
			
			_tochTexture = new com.doitflash.starling.MySprite();
			_tochTexture.bgAlpha = 0.2;
			_tochTexture.bgColor = 0xFF9900;
			_tochTexture.width = 50;
			_tochTexture.height = 50;
			_tochTexture.drawBg();
			
			_cpuPluginContainer = new Sprite();
			this.stage.addChild(_cpuPluginContainer);
			
			// the whole app will use this preload animation whenever it's needed
			initPreloaderAnimation();
			
			// start building pools
			buildPools();
			
			// start loading assets
			loadAssets();
			
			//stage.addChild(new Stats());
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Privates

		private function initPreloaderAnimation():void
		{
			_preloaderIcon = new PreloaderAnimation();
			_preloaderIcon.scaleX = _preloaderIcon.scaleY = 1;
			_preloaderIcon.mouseChildren = false;
			_preloaderIcon.mouseEnabled = false;
			_preloaderIcon.play();
			this.stage.addChild(_preloaderIcon);
			
			showPreloader(true);
		}
		
		private function buildPools():void
		{
			// Create a BitmapData which will be used in all Bitmap instances
			var bitmapData:BitmapData = new BitmapData(75, 75, false);
			bitmapData.noise(0);
			
			// Create a pool of Bitmaps
			bitmapPool = new LoanShark(Bitmap, true, 15, 0, bitmapData);
			
			// Create a pool of TouchScrolls
			touchScrollPool = new LoanShark(TouchScroll, true, 5);
			
			// Create a pool of Lists
			listPool = new LoanShark(List, true, 5);
			
			// Create a pool of MySprites
			mySpritePool = new LoanShark(com.doitflash.text.modules.MySprite, true, 15);
		}
		
		private function loadAssets():void
		{
			//start loading assets.xml
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onAssetsXmlLoaded);
			loader.load(new URLRequest("assets.xml"));
			
			function onAssetsXmlLoaded(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, onAssetsXmlLoaded);
				
				// save assets.xml
				_xml = new XML(e.currentTarget.data);
				
				// save the location to the project
				_proj = _xml.proj.text();
				
				// set the location for the local DB
				_db.data = { dbPath:_xml.appName.text(), dbName:"app.db" };
				
				// save path to the blindTools Folder
				_blindToolsPath = String(_xml.blindTools.text());
				
				//start loading data.xml
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onBlindXmlLoaded);
				loader.load(new URLRequest(_blindToolsPath + "data.xml"));
			}
			
			function onBlindXmlLoaded(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, onBlindXmlLoaded);
				
				// save assets.xml
				_blindXml = new XML(e.currentTarget.data);
				
				// check for network availablity 
				checkNetwork();
			}
			
			function checkNetwork():void
			{
				_networkMonitor.addEventListener("onNetworkStatus", onNetStatus);
				_networkMonitor.check(new URLRequest(_proj));
			}
		}
		
		private	function onNetStatus(e:*):void
		{
			//C.log("network = " + e.param.available)
			//C.log("DB = " + _db.available)
			if (e.param.available)
			{
				// connect to the gateway
				if (!_gateway) connectToGateway();
			}
			else
			{
				// check if local db is available?
				if (_db.available)
				{
					// connect to database and show information
					onMainInfoResult();
				}
				else
				{
					showPreloader(true, "No local cache & no internet connection!");
					setTimeout(closeApp, 5000);
				}
			}
		}
		
		private function connectToGateway():void
		{
			_gateway = new RemotingConnection(_proj + "fcms/amfphp/index.php");
			_gateway.call("APP.GetData.getMainInfo", new Responder(onMainInfoResult, onFault), getUpdateIdes());
		}
		
		private function onMainInfoResult($result:Object=null):void
		{
			if ($result) // save data from server db into the local db
			{
				if ($result.header) _db.saveHeader($result.header[0]);
				if ($result.footer) _db.saveFooter($result.footer[0]);
				if ($result.pages) _db.savePages($result.pages);
				
				_db.checkForces($result.forces[0]);
				
				// go with version check if the apk is not on the Google Play!
				if ($result.manifest[0].googlePlay != "true") 
				{
					// if oldVersion != current version, save the new apk address
					if (_xml.appVersion.text() != $result.manifest[0].appVersion)
					{
						_newApk = $result.manifest[0].apk;
					}
				}
				
				if ($result.recordsTobeDeleted) _db.dropPages($result.recordsTobeDeleted);
			}
			
			_data.mainInfo = { header:_db.getHeader()[0], footer:_db.getFooter()[0], pages:_db.getPages() };
			
			// initialize the _bulkLoader
			_bulkLoader = new BulkLoader("myBulkLoader");
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onAllAssetsLoaded);
			
			// load fonts
			loadFonts(_xml.font.item);
			
			// load page templates
			loadPageTemplates(_xml.page.item);
			
			// strat loading everything
			_bulkLoader.start(15);
			
			var i:int;
			function loadFonts($list:XMLList):void
			{
				for (i = 0; i < $list.length(); i++ )
				{
					_bulkLoader.add(new URLRequest(_xml.font.@location + $list[i].@src), {id:$list[i].@name, type:"movieclip"});
				}
			}
			
			function loadPageTemplates($list:XMLList):void
			{
				for (i = 0; i < $list.length(); i++ )
				{
					_bulkLoader.add(new URLRequest(_xml.page.@location + $list[i].@src), {id:$list[i].@name, type:"movieclip"});
				}
			}
		}
		
		private function onAllAssetsLoaded(e:Event):void
		{
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onAllAssetsLoaded);
			initTheApp();
		}
		
		protected function initTheApp():void{}
		
		public function showUpdateAlert():void
		{
			if (!_newApk) return;
			
			var nativeAlert:* = new NativeExtensions.myExtensions();
			nativeAlert.addEventListener("status", onNativeAlertStatus);
			nativeAlert.showNativeAlert("Updates are available!", "There is a new version available to be downloaded.\n\nAll saved cache data will be preserved", "Yes", "No", "", true);
			
			function onNativeAlertStatus(e:*):void
			{
				e.target.removeEventListener("status", onNativeAlertStatus);
				
				//trace(e.code, e.level)
				//e.code == "alert_window"
				if (e.level == "Yes")
				{
					navigateToURL(new URLRequest(_newApk), "_blank");
				}
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			stage.frameRate = _frameRate;
			if(_starling) _starling.start();
		}
		
		private function handleDeactivate(e:Event):void
		{
			stage.frameRate = 4;
			if(_starling) _starling.stop();
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_CLICK));
            } 
			else if(e.keyCode == Keyboard.MENU)
            {
				e.preventDefault();
				dispatchEvent(new AppEvent(AppEvent.MENU_BUTTON_CLICK));
				
				//if (C.visible) C.visible = false;
				//else C.visible = true;
            }
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			trace("Startup.onInvoke >> " + e.arguments);
		}
		
		private function onResize(e:*=null):void
		{
			if (_preloaderIcon)
			{
				_preloaderIcon.x = stage.stageWidth >> 1;
				_preloaderIcon.y = stage.stageHeight >> 1;
			}
		}
		
		private function getUpdateIdes():Object
		{
			return {headerUpdateId:_db.getHeaderUpdateId(), footerUpdateId:_db.getFooterUpdateId(), pagesUpdateId:_db.getPagesUpdateId()};
		}
		
		protected function onContext(e:Event=null):void
		{
			if (stage.stageWidth == DeviceInfo.screenResolutionX && stage.stageHeight == DeviceInfo.screenResolutionY)
			{
				Starling.current.root["onContextReady"]();
			}
			else
			{
				showPreloader(true, "resolution problem. Please restart!");
			}
		}
		
		private function toBoolean(a:String):Boolean
		{
			if (a == "true") return true;
			
			return false;
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		public function closeApp(e:Event=null):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		public function onFault(a:String):void
		{
			showPreloader(true, "cannot connect to server files!");
		}
		
		public function showPreloader($value:Boolean=true, $msg:String="Loading..."):void
		{
			_preloaderIcon.msg.text = $msg;
			_preloaderIcon.visible = $value;
		}
		
		public function loadRemoteFile($url:URLRequest, $respond:Function=null):void
		{
			var bytes:ByteArray;
			
			// check if this media is available in db already?
			bytes = _db.getBytes($url.url);
			
			if (bytes)
			{
				bytes.position = 0;
				$respond.call(null, bytes);
				
				return;
			}
			
			// start loading the media
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onRemoteFileLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onRemoteFileIOError);
			loader.load($url);
			
			function onRemoteFileLoaded(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, onRemoteFileLoaded);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onRemoteFileIOError);
				
				bytes = loader.data;
				_db.saveBytes($url.url, bytes);
				
				bytes.position = 0;
				$respond.call(null, bytes);
			}
			
			function onRemoteFileIOError(e:IOErrorEvent):void
			{
				loader.removeEventListener(Event.COMPLETE, onRemoteFileLoaded);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onRemoteFileIOError);
				
				showPreloader(true, "external file not found!");
				setTimeout(hidePreloader, 5000);
			}
			
			function hidePreloader():void
			{
				showPreloader(false, "File not found!");
			}
		}
		
		public function runJavaApk($result:Function):void
		{
			var apkVersion:String = _xml.pluginUpdateId.text();
			var loader:URLLoader;
			var apk:File = File.documentsDirectory.resolvePath(String(_xml.appName.text()) + "/plugins.apk");
			
			_apk = new MyExtensions();
			_apk.addEventListener(StatusEvent.STATUS, onApkCheck);
			
			if (apk.exists)
			{
				// check if the apk is copied to sd cart and is it installed and up-to-date?
				_apk.InstallAPK("/" + _xml.appName.text() + "/", "plugins.apk", _xml.appName.text(), apkVersion, false);
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
				
				$result({status:false, msg:"java apk not found!"});
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
				_apk.InstallAPK("/" + _xml.appName.text() + "/", "plugins.apk", _xml.appName.text(), apkVersion, true);
			}
			
			function onApkCheck(e:StatusEvent):void
			{
				//trace(e.code, e.level) 
				if (e.code == "status")
				{
					//trace(e.level)
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
					$result( { status:true, isAppInstalled:toBoolean(checkResult[0]) } );
					return;
				}
			}
		}
		
		public function runJavaPlugin($data:Object):void
		{
			// run the apk passing the required parameters for the specefic plugin
			var type:String = $data.type;
			var content:String = $data.content;
			var remoteDb:String = ($data.remoteDbPrefix)? $data.remoteDbPrefix : null;
			var localDb:String = ($data.localDb)? $data.localDb : null;
			
			if (type.substr(0, 4) == "HTML")
			{
				_apk.showPlugins("JAVA_WEB_VIEW", _proj + "fcms/amfphp/Services/plugins/" + type + "/" + type + "/index.php?content=" + content, remoteDb, localDb, _xml.appName.text());
			}
			else
			{
				_apk.showPlugins(type, unescape(content), remoteDb, localDb, _xml.appName.text());
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Getter - Setter
		
		public function get linkPattern():RegExp
		{
			return _linkPattern;
		}
		
		public function get deviceInfo():Class
		{
			return _deviceInfo;
		}
		
		public function get nativeExtensions():Class
		{
			return _nativeExtensions;
		}
		
		public function get db():Class
		{
			return _db;
		}
		
		public function get sql():Class
		{
			return _sql;
		}
		
		public function get networkMonitor():NetworkMonitor
		{
			return _networkMonitor;
		}
		
		public function get bulkLoader():BulkLoader
		{
			return _bulkLoader;
		}
		
		public function get gateway():RemotingConnection
		{
			return _gateway;
		}
		
		public function get proj():String
		{
			return _proj;
		}
		
		public function get frameRate():int
		{
			return _frameRate;
		}
		
		public function get blindXml():XML
		{
			return _blindXml;
		}
		
		public function get blindToolsPath():String
		{
			return _blindToolsPath;
		}
		
		public function get preloaderMc():PreloaderAnimation
		{
			return _preloaderIcon;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		public function get cpuPluginContainer():Sprite
		{
			return _cpuPluginContainer;
		}
		
		public function get touchTexture():Texture
		{
			return _tochTexture.getTexture(false);
		}
	}
	
}