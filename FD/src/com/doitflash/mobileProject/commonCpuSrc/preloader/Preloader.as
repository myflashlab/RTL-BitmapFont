package com.doitflash.mobileProject.commonCpuSrc.preloader
{
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoaderDataFormat;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.ByteArray;
	
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.tools.RemotingConnection;
	import com.doitflash.utils.scroll.TouchScroll;
	import com.doitflash.utils.lists.List;
	
	import org.kissmyas.utils.loanshark.LoanShark;
	
	import assets.PreloaderAnimation;
	import com.doitflash.mobileProject.commonCpuSrc.*;
	
	//import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/1/2012 6:52 PM
	 */
	public class Preloader extends MyMovieClip 
	{
		private var _blindXml:XML;
		private var _blindToolsPath:String;
		private var _gateway:RemotingConnection;
		
		private var _db:*;
		private var _sql:*;
		private var _deviceInfo:Class;
		private var _nativeExtensions:Class;
		private var _networkMonitor:*;
		private var _preloaderIcon:PreloaderAnimation;
		private var _proj:String;
		private var _frameRate:int = 30;
		
		private var _newApk:String;
		
		private var _bulkLoader:*;
		private var _mainArea:MyMovieClip;
		
		private var _linkPattern:RegExp = new RegExp("(https?://)?(www\\.)?([\\w-.]*)\\b\\.[a-z\\d]{2,4}(\\.[a-z]{2})?((/[\\w_%+-?#&]*)+)?(\\.[a-z]*)?(:\\d{1,5})?", "g");
		
		public var bitmapPool:LoanShark;
		public var touchScrollPool:LoanShark;
		public var listPool:LoanShark;
		public var mySpritePool:LoanShark;
		
		public function Preloader():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//C.startOnStage(this, "`");
			//C.commandLine = false;
			//C.commandLineAllowed = false;
			//C.width = 470;
			//C.height = 320;
			//C.strongRef = true;
			//C.memoryMonitor = true;
			//C.fpsMonitor = true;
			//C.visible = true;
			
			// save flashVars
			_flashVars = this.root.loaderInfo.parameters;
			//if (!_flashVars.assets) _flashVars.assets = "assets.xml"; // for debug reasons only
			//if (!_flashVars.mainFile) _flashVars.mainFile = "main.swf"; // for debug reasons only
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Privates
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = _frameRate;
			
			//C.log(deviceInfo.info);
			initPreloaderAnimation(); // the whole app will use this preload animation whenever it's needed
			showPreloader(true);
			
			// start building pools
			buildPools();
			
			// start loading assets
			loadAssets();
			
			onResize();
		}
		
		private function initPreloaderAnimation():void
		{
			_preloaderIcon = new PreloaderAnimation();
			_preloaderIcon.scaleX = _preloaderIcon.scaleY = 0.7;
			_preloaderIcon.mouseChildren = false;
			_preloaderIcon.mouseEnabled = false;
			_preloaderIcon.play();
			this.stage.addChild(_preloaderIcon);
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
			mySpritePool = new LoanShark(MySprite, true, 15);
		}
		
		private function loadAssets():void
		{
			showPreloader(true);
			
			//start loading assets.xml
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onAssetsXmlLoaded);
			loader.load(new URLRequest(_flashVars.assets));
			
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
		}
		
		private function checkNetwork():void
		{
			_networkMonitor.addEventListener(AppEvent.NETWORK_STATUS, onNetStatus);
			_networkMonitor.check(new URLRequest(_proj));
		}
		
		private	function onNetStatus(e:AppEvent):void
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
					showPreloader(true, "Internet connection error...");
					setTimeout(closeApp, 5000);
				}
			}
		}
		
		private function connectToGateway():void
		{
			_gateway = new RemotingConnection(_proj + "fcms/amfphp/index.php");
			_gateway.addEventListener(NetStatusEvent.NET_STATUS, onNetError);
			_gateway.call("APP.GetData.getMainInfo", new Responder(onMainInfoResult, onFault), getUpdateIdes());
			
			function onNetError(e:NetStatusEvent):void
			{
				showPreloader(true, "Not able to connect to fCMS!");
				setTimeout(closeApp, 5000);
			}
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
			
			_data.mainInfo = {header:_db.getHeader()[0], footer:_db.getFooter()[0], pages:_db.getPages()};
			
			// initialize the _bulkLoader
			_bulkLoader.addEventListener("complete", onAllAssetsLoaded);
			
			// load all fonts
			loadFonts(_xml.font.item);
			
			// load page templates
			loadPageTemplates(_xml.page.item);
			
			// load the mainFile
			_bulkLoader.add(new URLRequest(_flashVars.mainFile), {id:"mainArea", type:"movieclip"});
			
			// load all assets
			//loadDll(_xml.dll.item);
			
			// strat loading everything
			_bulkLoader.start(15);
		}
		
		private function loadFonts($list:XMLList):void
		{
			for (var i:int = 0; i < $list.length(); i++ )
			{
				_bulkLoader.add(new URLRequest(_xml.font.@location + $list[i].@src), {id:$list[i].@name, type:"movieclip"});
			}
		}
		
		private function loadPageTemplates($list:XMLList):void
		{
			for (var i:int = 0; i < $list.length(); i++ )
			{
				_bulkLoader.add(new URLRequest(_xml.page.@location + $list[i].@src), {id:$list[i].@name, type:"movieclip"});
			}
		}
		
		private function getUpdateIdes():Object
		{
			return {headerUpdateId:_db.getHeaderUpdateId(), footerUpdateId:_db.getFooterUpdateId(), pagesUpdateId:_db.getPagesUpdateId()};
		}
		
		private function onAllAssetsLoaded(e:Event):void
		{
			showPreloader(false);
			_bulkLoader.removeEventListener("complete", onAllAssetsLoaded);
			
			_mainArea = _bulkLoader.getMovieClip("mainArea") as MyMovieClip;
			_mainArea.base = this;
			_mainArea.data = _data;
			
			this.addChild(_mainArea);
			
			onResize();
			if(_newApk) setTimeout(showUpdateAlert, 5000);
		}
		
		override protected function onResize(e:*=null):void
		{
			super.onResize(e);
			
			if (_preloaderIcon)
			{
				_preloaderIcon.x = _width / 2;
				_preloaderIcon.y = _height / 2;
			}
			
			if (_mainArea)
			{
				_mainArea.width = _width;
				_mainArea.height = _height;
			}
		}
		
		private function showUpdateAlert():void
		{
			var nativeAlert:* = new nativeExtensions["myExtensions"]();
			nativeAlert.addEventListener("status", onNativeAlertStatus);
			nativeAlert.showNativeAlert("Updates are available!", "There is a new version available to be downloaded.\n\nAll saved cache data will be preserved", "Yes", "No", "", true);
		}
		
		private function onNativeAlertStatus(e:*):void
		{
			e.target.removeEventListener("status", onNativeAlertStatus);
			
			//trace(e.code, e.level)
			//e.code == "alert_window"
			if (e.level == "Yes")
			{
				navigateToURL(new URLRequest(_newApk), "_blank");
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		

// ----------------------------------------------------------------------------------------------------------------------- Methods
		//private var _prelooder:*;
		public function showPreloader($value:Boolean=true, $msg:String="Loading..."):void
		{
			_preloaderIcon.msg.text = $msg;
			_preloaderIcon.visible = $value;
			
			/*if(!_prelooder) _prelooder = new nativeExtensions["myExtensions"]();
			
			if ($value) 
			{
				_prelooder.showCircleLoading("", $msg, false);
			}
			else 
			{
				_prelooder.dispose();
			}*/
		}
		
		public function onOrientationChange($before:String, $after:String):void
		{
			this.dispatchEvent(new AppEvent(AppEvent.ORIENTATION_CHANGE, {before:$before, after:$after}));
		}
		
		public function onFault(a:String):void
		{
			//C.log("server connection error!");
			showPreloader(false);
			//showAlert("<font color='#333333' size='13'>Error, cannot connect to server files!</font>", "ERROR:", 350, 150);
			//setTimeout(sizeRefresh, 20);
		}
		
		public function buttonBack():void
		{
			if (_preloaderIcon.visible)
			{
				showPreloader(false);
			}
			
			this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_CLICK));
		}
		
		public function buttonMenu():void
		{
			this.dispatchEvent(new AppEvent(AppEvent.MENU_BUTTON_CLICK));
			
			//if (C.visible == true) C.visible = false;
			//else C.visible = true;
		}
		
		public function closeApp():void
		{
			_holder.closeApp();
			//nativeExtensions.nativeAlert.dispose();
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
				bytes = loader.data;
				_db.saveBytes($url.url, bytes);
				
				bytes.position = 0;
				$respond.call(null, bytes);
			}
			
			function onRemoteFileIOError(e:IOErrorEvent):void
			{
				showPreloader(true, "File not found!");
				setTimeout(hidePreloader, 5000);
			}
			
			function hidePreloader():void
			{
				showPreloader(false, "File not found!");
			}
		}
		
		public function runJavaApk($result:Function):void
		{
			// save plugins.apk in _xml.appName.text()
			dispatchEvent(new AppEvent("apkCopy", {result:$result}));
		}
		
		public function runJavaPlugin($data:Object):void
		{
			// run the apk passing the required parameters for the specefic plugin
			dispatchEvent(new AppEvent("apkRun", $data));
		}
		
		public function appInvoked($arg:Array):void
		{
			trace("Preloader.appInvoked >> " + $arg)
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Properties
		
		public function get linkPattern():RegExp
		{
			return _linkPattern;
		}
		
		public function get deviceInfo():Class
		{
			return _deviceInfo;
		}
		
		public function set deviceInfo(a:Class):void
		{
			_deviceInfo = a;
		}
		
		public function get nativeExtensions():Class
		{
			return _nativeExtensions;
		}
		
		public function set nativeExtensions(a:Class):void
		{
			_nativeExtensions = a;
		}
		
		public function get db():*
		{
			return _db;
		}
		
		public function set db(a:*):void
		{
			_db = a;
		}
		
		public function get sql():*
		{
			return _sql;
		}
		
		public function set sql(a:*):void
		{
			_sql = a;
		}
		
		public function get networkMonitor():*
		{
			return _networkMonitor;
		}
		
		public function set networkMonitor(a:*):void
		{
			_networkMonitor = a;
		}
		
		public function get bulkLoader():*
		{
			return _bulkLoader;
		}
		
		public function set bulkLoader(a:*):void
		{
			_bulkLoader = a;
		}
		
		public function get gateway():RemotingConnection
		{
			return _gateway;
		}
		
		public function get proj():String
		{
			return _proj;
		}
		
		/*public function get c():Class
		{
			return C;
		}*/
		
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
	}
	
}