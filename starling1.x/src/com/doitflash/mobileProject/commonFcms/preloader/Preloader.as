package com.doitflash.mobileProject.commonFcms.preloader
{
	import flash.system.Security;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.SharedObject;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	import flash.system.System;
	
	import com.doitflash.mobileProject.commonFcms.events.LoginEvent;
	import com.doitflash.mobileProject.commonFcms.events.MainEvent;
	import com.doitflash.mobileProject.commonFcms.assets.PreloaderAnimation;
	
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.tools.RemotingConnection;
	import com.doitflash.text.TextArea;
	
	import com.asual.swfaddress.SWFAddress; // Version 2.4
	import com.asual.swfaddress.SWFAddressEvent; // Version 2.4
	
	import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;
	
	//import com.luaye.console.C;
	
	public class Preloader extends MySprite
	{
		protected var _body:Sprite; // All content will be droped into this layer
		private var _gateway:RemotingConnection;
		
		private var _so:SharedObject;
		private var _soServerTime:Number;
		private var _myapperaGateway:RemotingConnection;
		private var _myapperaUserInfo:Object;
		
		private var _serverTime:Number = 0;
		private var _date:String;
		private var _userInfo:Object = { };
		private var _browser:Object = { };
		private var _defaultTitle:String = "fCMS";
		public var version:String = "1.7";
		private var _internalID:String = "NOT_AVAILABLE";
		
		private var _bulkLoader:BulkLoader;
		
		private var _linkPatern:RegExp = new RegExp("(https?://)?(www\\.)?([\\w-.]*)\\b\\.[a-z\\d]{2,4}(\\.[a-z]{2})?((/[\\w_%+-?#&]*)+)?(\\.[a-z]*)?(:\\d{1,5})?", "g");
		
		private var _scroller:*;
		private var _alert:*;
		private var _graphic:*;
		private var _tooltip:*;
		private var _currArea:MyMovieClip;
		private var _loginArea:MyMovieClip;
		private var _mainArea:MyMovieClip;
		
		private var _fbPreloader:PreloaderAnimation;
		
		private var _canConnectToJS:Boolean;
		
		public function Preloader():void 
		{
			/*C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.width = 640;
			C.height = 220;
			C.strongRef = true;
			C.visible = true;*/
			
			// save flashVars
			_flashVars = this.root.loaderInfo.parameters;
			_serverPath = _flashVars.serverPath;
			_serverTime = _flashVars.serverTime;
			_date = _flashVars.date;
			_internalID = _flashVars.internalID;
			
			_gateway = new RemotingConnection(_serverPath + "amfphp/index.php");
			
			_fbPreloader = new PreloaderAnimation();
			//_fbPreloader.scaleX = _fbPreloader.scaleY = 0.7;
			_fbPreloader.mouseChildren = false;
			_fbPreloader.mouseEnabled = false;
			_fbPreloader.play();
			_fbPreloader.visible = false;
			this.stage.addChild(_fbPreloader);
			
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.stage.addEventListener(Event.RESIZE, onResize);
			
			_body = new Sprite();
			this.addChild(_body);
			
			// set the stage alighnment
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			
			// listen to address bar changes
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange);
			
			// start loading assets that might be used during project
			loadAssets();
			
			showPreloader(true);
		}
		
		private function loadAssets():void
		{
			// initialize the _bulkLoader
			_bulkLoader = new BulkLoader("assetsLoader");
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onAllAssetsLoaded);
			_bulkLoader.addEventListener(BulkLoader.PROGRESS, onProgress);
			
			//start loading assets.xml
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onAssetsXmlLoaded);
			loader.load(new URLRequest(_serverPath + _flashVars.assets));
			
			function onAssetsXmlLoaded(e:Event):void
			{
				// save assets.xml
				_xml = new XML(e.currentTarget.data);
				
				// load all fonts
				loadFonts(_xml.font.item);
				
				// load all assets
				loadDll(_xml.dll.item);
				
				// strat loading everything
				_bulkLoader.start(15);
			}
			
			function loadFonts($fontList:XMLList):void
			{
				for (var i:int = 0; i < $fontList.length(); i++ )
				{
					_bulkLoader.add(new URLRequest(_serverPath + _xml.font.@location + $fontList[i].@src), {id:$fontList[i].@name, type:BulkLoader.TYPE_MOVIECLIP});
				}
			}
			
			function loadDll($dllList:XMLList):void
			{
				for (var j:int = 0; j < $dllList.length(); j++) 
				{
					_bulkLoader.add(new URLRequest(_serverPath + _xml.dll.@location + $dllList[j].@src), {id:$dllList[j].@name, type:BulkLoader.TYPE_MOVIECLIP});
				}
			}
		}
		
		private function onAllAssetsLoaded(e:Event):void
		{
			showPreloader(false);
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onAllAssetsLoaded);
			_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			
			_graphic = _bulkLoader.getMovieClip("Graphic");
			
			// initialize the scroller asset and set its configuration
			var scroller:* = _bulkLoader.getMovieClip("Scroller");
			scroller.configXml = new XML(_xml.dll.item.(@name == "Scroller").config);
			scroller.init();
			_scroller = scroller;
			
			// initialize the alert window and set its configuration
			var alert:* = _bulkLoader.getMovieClip("Alert");
			alert.configXml = new XML(_xml.dll.item.(@name == "Alert").config);
			alert.serverPath = _serverPath;
			alert.setScroller = _scroller.getDll;
			alert.init();
			_alert = alert;
			this.stage.addChild(_alert.getDll);
			
			// initialize the tooltip and set its configuration
			var tooltip:* = _bulkLoader.getMovieClip("Tooltip");
			tooltip.configXml = new XML(_xml.dll.item.(@name == "Tooltip").config);
			tooltip.serverPath = _serverPath;
			tooltip.init();
			_tooltip = tooltip.getDll;
			this.stage.addChild(_tooltip);
			
			_canConnectToJS = ExternalInterface.available;
			
			/*setTimeout(kk, 3000);
			function kk():void
			{
				_canConnectToJS = ExternalInterface.available;
				ExternalInterface.addCallback("dd", dd);
				ExternalInterface.call("openNewWindow", "02.php", {someVar:"0132456789132465789"}, "POST");
			}
			
			function dd($str:String):void
			{
				C.log($str);
			}*/
			
			init();
		}
		
		protected function init():void
		{
			// check login status
			checkAccess();
		}
		
		private function checkAccess():void
		{
			showPreloader(true);
			_gateway.call("AccessCheck.check", new Responder(onAccessResult, onFault), _serverTime);
		}
		
		private function onAccessResult($result:String):void
		{
			showPreloader(false);
			var vars:URLVariables = new URLVariables($result);
			
			if (vars.backToFlash == "true")
			{
				// save user details
				saveUserData(vars);
				
				// load the main Area
				loadMainArea();
			}
			else if (vars.backToFlash == "false")
			{
				// load the Login area
				loadLoginArea();
			}
			else
			{
				//show the alert window
				showAlert(vars.backToFlash, "ERROR:", 350, 200);
			}
		}
		
		private function onLoginLoaded(e:Event=null):void
		{
			showPreloader(false);
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onLoginLoaded);
			_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			
			if(!_loginArea) _loginArea = _bulkLoader.getMovieClip("LoginArea") as MyMovieClip;
			_loginArea.addEventListener(LoginEvent.LOGIN_SUCCEEDED, onLoginSuccess);
			_loginArea.base = this;
			_loginArea.serverPath = _serverPath;
			_body.addChild(_loginArea);
			
			_currArea = _loginArea;
			
			onResize();
		}
		
		private function onLoginSuccess(e:LoginEvent):void
		{
			_loginArea.removeEventListener(LoginEvent.LOGIN_SUCCEEDED, onLoginSuccess);
			_body.removeChild(_loginArea);
			
			// save user details
			saveUserData(e.param);
			
			loadMainArea();
		}
		
		private function onMainLoaded(e:Event=null):void
		{
			showPreloader(false);
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onMainLoaded);
			_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			
			if(!_mainArea) _mainArea = _bulkLoader.getMovieClip("MainArea") as MyMovieClip;
			_mainArea.addEventListener(MainEvent.LOGOUT_SUCCEEDED, onLogoutSuccess);
			_mainArea.base = this;
			_mainArea.serverPath = _serverPath;
			_body.addChild(_mainArea);
			
			_currArea = _mainArea;
			
			onResize();
			
			// connect to myappera gateway and check if we're connected to myappera?
			connectToMyapperaGateway();
		}
		
		private function onLogoutSuccess(e:MainEvent):void
		{
			_mainArea.removeEventListener(MainEvent.LOGOUT_SUCCEEDED, onLogoutSuccess);
			_body.removeChild(_mainArea);
			
			loadLoginArea();
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Helpful Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function loadLoginArea():void
		{
			// clean _body to get it ready for the new content
			cleanUp(_body);
			
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onLoginLoaded);
			_bulkLoader.addEventListener(BulkLoader.PROGRESS, onProgress);
			
			_bulkLoader.add(new URLRequest(_serverPath + "LoginArea.swf"), { id:"LoginArea", type:BulkLoader.TYPE_MOVIECLIP } );
			
			// strat loading everything
			_bulkLoader.start(15);
			showPreloader(true);
			
			if (_loginArea) onLoginLoaded();
		}
		
		private function loadMainArea():void
		{
			// clean _body to get it ready for the new content
			cleanUp(_body);
			
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onMainLoaded);
			_bulkLoader.addEventListener(BulkLoader.PROGRESS, onProgress);
			
			_bulkLoader.add(new URLRequest(_serverPath + "MainArea.swf"), { id:"MainArea", type:BulkLoader.TYPE_MOVIECLIP } );
			
			// strat loading everything
			_bulkLoader.start(15);
			showPreloader(true);
			
			if (_mainArea) onMainLoaded();
		}
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_alert && _alert.getDll)
			{
				_alert.getDll.x = stage.stageWidth / 2 - _alert.getDll.width / 2;
				_alert.getDll.y = stage.stageHeight / 2 - _alert.getDll.height / 2;
			}
			
			if (_currArea)
			{
				_currArea.width = this.stage.stageWidth;
				_currArea.height = this.stage.stageHeight;
			}
			
			if (_fbPreloader)
			{
				_fbPreloader.x = stage.stageWidth / 2;
				_fbPreloader.y = stage.stageHeight / 2;
			}
		}
		
		private function onAddressChange(e:Event=null):void
		{
			_browser.value = SWFAddress.getValue();
			_browser.title = SWFAddress.getTitle();
			_browser.url = SWFAddress.getBaseURL();
		}
		
		private function saveUserData($vars:URLVariables):void
		{
			_userInfo.firstName = $vars.firstName;
			_userInfo.lastName = $vars.lastName;
		}
		
		private function connectToMyapperaGateway():void
		{
			Security.loadPolicyFile(_xml.pluginDirectory.policy.text());
			_myapperaGateway = new RemotingConnection(_xml.pluginDirectory.amfphp.text());
			_myapperaGateway.call("users.CheckLogStatus.check", new Responder(onCheckLogResult, onFault), getServerTime());
			
			function onCheckLogResult($result:Object):void
			{
				_myapperaUserInfo = $result;
				myapperaLogStatus(toBoolean($result.status));
			}
		}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		public function getServerTime():Number
		{
			if (!_so) _so = SharedObject.getLocal("fcmsSharedObjects", "/");
			
			if (_so.data.serverTime) _soServerTime = _so.data.serverTime;
			else _soServerTime = _serverTime;
			
			return _soServerTime;
		}
		
		public function logoutMyappera():void
		{
			showPreloader(true);
			_myapperaGateway.call("users.CheckLogStatus.logout", new Responder(onlogoutResult, onFault));
			
			function onlogoutResult($result:Object):void
			{
				showPreloader(false);
				_mainArea["myapperaLogStatus"](false);
				_mainArea["gotoWelcomePage"]();
			}
		}
		
		public function myapperaLogStatus($status:Boolean):void
		{
			_mainArea["myapperaLogStatus"]($status);
		}
		
		public function showPreloader($show:Boolean):void
		{
			_fbPreloader.visible = $show;
			this.stage.setChildIndex(_fbPreloader, this.stage.numChildren - 1); // make sure the loading is on top of everything else!
		}
		
		public function setPageAddress($value:String, $title:String):void
		{
			SWFAddress.setValue($value);
			SWFAddress.setTitle(_defaultTitle + " - " + $title);
		}
		
		public function onProgress(e:BulkProgressEvent):void
		{
			
		}
		
		public function onFault(a:String):void
		{
			showPreloader(false);
			showAlert("<font color='#333333' size='13'>Error, cannot connect to server files!</font>", "ERROR:", 450, 250);
			setTimeout(sizeRefresh, 20);
		}
		
		public function showAlert($alert:String, $alertTitle:String="Alert Window!", $width:Number=450, $height:Number=250):void
		{
			_alert.getDll.w = $width;
			_alert.getDll.h = $height;
			_alert.getDll.title($alertTitle, "Verdana", 0x333333, 18);
			//_alert.openAlert($alert, "Verdana", "cancel", "reject", "approve");
			_alert.getDll.openAlert($alert, "Verdana", "approve");
			onResize();
			setTimeout(sizeRefresh, 20);
		}
		
		public function removeTextFormat($str:String):String
		{
			var tf:TextField = new TextField();
			tf.htmlText = $str;
			
			return tf.text;
		}
		
		public function sizeRefresh():void
		{
			onResize();
		}
		
		/**
		 * converts a date in the following format <code>2012-04-11 08:24:22</code> to a real AS3 Date object.
		 */
		public function convertToDate($str:String):Date
		{
			var year:Number = 2000;
			var month:Number = 01;
			var day:Number = 01;
			var hour:Number = 01;
			var min:Number = 01;
			var sec:Number = 01;
			
			var yearPatt:RegExp = /(\d{4})\-/i;
			var monthAndDayPatt:RegExp = /\-(\d{2})/gi;
			var hourPatt:RegExp = /(\d{2})\:/i;
			var minAndSecPatt:RegExp = /\:(\d{2})/gi;
			
			year = yearPatt.exec($str)[1];
			month = Number(monthAndDayPatt.exec($str)[1]) - 1;
			day = monthAndDayPatt.exec($str)[1];
			hour = hourPatt.exec($str)[1];
			min = minAndSecPatt.exec($str)[1];
			sec = minAndSecPatt.exec($str)[1];
			
			return new Date(year, month, day, hour, min, sec);
		}
		
		public function get bulkLoader():BulkLoader
		{
			return _bulkLoader;
		}
		
		public function get gateway():RemotingConnection
		{
			return _gateway;
		}
		
		public function get myapperaGateway():RemotingConnection
		{
			return _myapperaGateway;
		}
		
		public function set myapperaUserInfo(a:Object):void
		{
			_myapperaUserInfo = a;
		}
		
		public function get myapperaUserInfo():Object
		{
			return _myapperaUserInfo;
		}
		
		public function get userInfo():Object
		{
			return _userInfo;
		}
		
		public function get browser():Object
		{
			return _browser;
		}
		
		public function get date():String
		{
			return _date;
		}
		
		public function get serverTime():Number
		{
			return _serverTime;
		}
		
		public function get projectPath():String
		{
			return _flashVars.projectPath;
		}
		
		public function get linkPatern():RegExp
		{
			return _linkPatern;
		}
		
		public function get getScroller():*
		{
			return _scroller;
		}
		
		public function get getAlert():*
		{
			return _alert;
		}
		
		public function get getTooltip():*
		{
			return _tooltip;
		}
		
		public function get getGraphic():*
		{
			return _graphic;
		}
		
		public function get mainArea():MyMovieClip
		{
			return _mainArea;
		}
		
		public function get internalID():String
		{
			return _internalID;
		}
		
		public function set getSharedObject(a:SharedObject):void
		{
			_so = a;
		}
		
		public function get getSharedObject():SharedObject
		{
			return _so;
		}
		
		public function get canConnectToJS():Boolean
		{
			return _canConnectToJS;
		}
		
		
	}
}