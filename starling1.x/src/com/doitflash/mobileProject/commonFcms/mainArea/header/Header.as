package com.doitflash.mobileProject.commonFcms.mainArea.header
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.navigateToURL;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.TextArea;
	import com.doitflash.events.AlertEvent;
	
	import com.doitflash.mobileProject.commonFcms.events.MainEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/12/2011 11:03 AM
	 */
	public class Header extends MySprite
	{
		private var _isConnected:Boolean;
		private var _logoHolder:Sprite;
		private var _logo:*;
		private var _logoutBtn:*;
		private var _myapperaConnectionBtn:*;
		private var _welcomeTxt:TextArea;
		private var _versionTxt:TextArea;
		private var _fcmsUpdateXml:XML;
		
		public function Header():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_bgAlpha = 1;
			_bgColor = 0x272727;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
			initLogo();
			initLogoutBtn();
			initWelcomeTxt();
			initVersionTxt();
			
			initMyapperaConnection();
			
			checkForUpdates();
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initLogo():void
		{
			_logoHolder = new Sprite();
			
			_logoHolder.graphics.clear();
			_logoHolder.graphics.beginFill(0x101010);
			_logoHolder.graphics.drawRect(0, 0, 200, 40);
			_logoHolder.graphics.endFill();
			
			/*_logoHolder.graphics.lineStyle(1, 0x1D4088);
			_logoHolder.graphics.moveTo(200, 0);
			_logoHolder.graphics.lineTo(200, 40);
			_logoHolder.graphics.endFill();*/
			
			this.addChild(_logoHolder);
			
			_logo = new _base.getGraphic.logo();
			_logoHolder.addChild(_logo);
		}
		
		private function initLogoutBtn():void
		{
			_logoutBtn = new _base.getGraphic.fbBtn0();
			_logoutBtn.addEventListener(MouseEvent.CLICK, onLogout);
			_logoutBtn.label = "LOGOUT";
			this.addChild(_logoutBtn)
		}
		
		private function initWelcomeTxt():void
		{
			var format:TextFormat = new TextFormat();
			format.color = 0xFFFFFF;
			format.size = 13;
			format.font = "Arimo";
			
			_welcomeTxt = new TextArea();
			_welcomeTxt.autoSize = TextFieldAutoSize.LEFT;
			_welcomeTxt.antiAliasType = AntiAliasType.ADVANCED;
			_welcomeTxt.embedFonts = true;
			_welcomeTxt.mouseEnabled = false;
			_welcomeTxt.defaultTextFormat = format;
			setWelcomeMsg();
			
			this.addChild(_welcomeTxt);
		}
		
		private function initVersionTxt():void
		{
			_versionTxt = new TextArea();
			_versionTxt.autoSize = TextFieldAutoSize.LEFT;
			_versionTxt.antiAliasType = AntiAliasType.ADVANCED;
			_versionTxt.embedFonts = true;
			_versionTxt.selectable = false;
			_versionTxt.funcSecurity = false;
			_versionTxt.client = this;
			_versionTxt.holder = this;
			_versionTxt.mouseRollOverEnabled = true;
			setVersionTxt("fCMS V" + _base.version);
			
			this.addChild(_versionTxt);
		}
		
		private function initMyapperaConnection():void
		{
			_myapperaConnectionBtn = new _base.getGraphic.myapperaConnection();
			_myapperaConnectionBtn.addEventListener(MouseEvent.CLICK, onConnect);
			_myapperaConnectionBtn.addEventListener(MouseEvent.ROLL_OVER, onConnectionOver);
			_myapperaConnectionBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			this.addChild(_myapperaConnectionBtn);
		}
		
		private function checkForUpdates():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onAirFcmsXmlLoaded);
			loader.load(new URLRequest(_base.xml.pluginDirectory.fcmsUpdateCheck.text() + "?" + getTimer()));
			
			function onAirFcmsXmlLoaded(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, onAirFcmsXmlLoaded);
				
				_fcmsUpdateXml = new XML(e.target.data);
				
				
				if (_base.version != String(_fcmsUpdateXml.version.text()))
				{
					setVersionTxt("fCMS V" + _base.version + "      " + _fcmsUpdateXml.updateMsg.text())
				}
				else
				{
					setVersionTxt("fCMS V" + _base.version + "      " + _fcmsUpdateXml.uptoDateMsg.text())
				}
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function onLogout(e:MouseEvent):void
		{
			// let MainArea know that the logout button is clicked
			this.dispatchEvent(new MainEvent(MainEvent.LOGOUT));
		}
		
		private function onConnect(e:MouseEvent):void
		{
			if (_isConnected)
			{
				this.dispatchEvent(new MainEvent(MainEvent.DISCONNECT));
			}
			else
			{
				this.dispatchEvent(new MainEvent(MainEvent.CONNECT));
			}
		}
		
		override protected function onResize(e:*=null):void 
		{
			super.onResize(e);
			
			if (_logo)
			{
				_logo.x = 5;
				_logo.y = _height - _logo.height >> 1;
			}
			
			if (_logoutBtn)
			{
				_logoutBtn.x = _width - _logoutBtn.width - 0;
				_logoutBtn.y = _height - _logoutBtn.height >> 1;
			}
			
			if (_welcomeTxt)
			{
				_welcomeTxt.x = _logoutBtn.x - _welcomeTxt.width - 5;
				_welcomeTxt.y = _height - _welcomeTxt.height >> 1;
			}
			
			if (_versionTxt)
			{
				_versionTxt.x = _logoHolder.x + _logoHolder.width + 10;
				_versionTxt.y = _height - _versionTxt.height >> 1;
			}
			
			if (_myapperaConnectionBtn && _versionTxt && _welcomeTxt)
			{
				_myapperaConnectionBtn.x = ((_welcomeTxt.x - (_versionTxt.x + _versionTxt.width)) - _myapperaConnectionBtn.width >> 1) + _versionTxt.x + _versionTxt.width;
				_myapperaConnectionBtn.y = _height - _myapperaConnectionBtn.height >> 1;
			}
		}
		
		private function setVersionTxt($str:String):void
		{
			_versionTxt.fmlText = "<font face='Arimo' size='13' color='#FFFFFF'>" + $str + "</font>";
			onResize();
		}
		
		public function onOver($msg:String):void
		{
			_base.getTooltip.mouseSpaceX = 20;
			_base.getTooltip.mouseSpaceY = 20;
			_base.getTooltip.delay = 0.5;
			_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>"+ $msg +"</font>", "ltr");
		}
		
		public function onOut(e:MouseEvent=null):void
		{
			_base.getTooltip.hide();
		}
		
		private function onConnectionOver(e:MouseEvent):void
		{
			_base.getTooltip.mouseSpaceX = 20;
			_base.getTooltip.mouseSpaceY = 20;
			_base.getTooltip.delay = 0.5;
			
			if (_myapperaConnectionBtn.currentFrame == 1)
			{
				_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>checking your fCMS connection with myappera...</font>", "ltr");
				return;
			}
			
			if (_isConnected)
			{
				_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>You are connected to myappera with the following username:<br>" + _base.myapperaUserInfo.email + "</font>", "ltr");
			}
			else
			{
				_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>Click here to login to myappera<br><br><b>Why do I have to connect to myappera?</b><br>your fCMS needs to be connected to myappera in order to be able to<br>do certain operations such as plugin installation or generating an app.</font>", "ltr");
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 * 		will be called from _fcmsUpdateXml.updateMsg.text() >> fcmsDirectory/airFcms.xml
		 */
		public function updateFcms():void
		{
			var processTxt:String;
			var alertTitle:String;
			var alertWidth:Number = 400;
			var alertHeight:Number = 300;
			
			processTxt = "1/2) Downloading the update package... ";
			alertTitle = "Updating your fCMS, please wait...";
			
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.setApproveSkin("ok");
			_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
			_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onAlertClose);
			
			var respondVars:URLVariables;
			var variables:URLVariables;
			var request:URLRequest;
			var backVars:URLLoader;
			function callUpdate($method:String, $result:Function):void
			{
				variables = new URLVariables();
				variables.internalID = _base.internalID;
				variables.method = $method;
				variables.remote = String(_base.xml.pluginDirectory.fcmsUpdateGet.text());
				
				request = new URLRequest(_base.projectPath + "update.php");
				request.method = URLRequestMethod.POST;
				request.data = variables;
				
				backVars = new URLLoader();
				backVars.dataFormat = URLLoaderDataFormat.VARIABLES;
				backVars.addEventListener(Event.COMPLETE, $result);
				backVars.load(request);
			}
			
			callUpdate("downloadPackage", onDownloadResult);
			
			function onDownloadResult(e:Event):void 
			{
				respondVars = new URLVariables(e.target.data);
				
				if (decodeURI(respondVars.status) == "true")
				{
					processTxt = processTxt.concat("<font color='#005500'> Done</font><br>2/2) Unzipping the package... ");
					_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
					
					callUpdate("extractPackage", onExtractResult);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#990000'> Error!<br><br>" + decodeURI(respondVars.msg));
					_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
				}
			}
			
			function onExtractResult(e:Event):void
			{
				respondVars = new URLVariables(e.target.data);
				
				if (decodeURI(respondVars.status) == "true")
				{
					processTxt = processTxt.concat("<font color='#005500'> Done</font><br><br>" + decodeURI(respondVars.msg));
					_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#990000'> Error!<br><br>" + decodeURI(respondVars.msg));
					_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
				}
			}
			
			function onAlertClose(e:*):void
			{
				_base.getAlert.getDll.removeEventListener(AlertEvent.CLOSE, onAlertClose);
				_base.getAlert.getDll.removeEventListener(AlertEvent.APPROVE, onAlertClose);
				
				//onLogout(null);
				var url:String = _base.browser.url + "/#" + _base.browser.value;
				var slashIndex:int = url.indexOf("/", 8);
				var newuRL:String = url.substr(0, slashIndex) + "//" + url.substr(slashIndex + 1);
				
				navigateToURL(new URLRequest(newuRL), "_self");
			}
		}
		
		public function connectionIcon($status:Boolean):void
		{
			_isConnected = $status;
			
			if (_isConnected) _myapperaConnectionBtn.connect();
			else _myapperaConnectionBtn.disconnect();
			
			onOut();
		}
		
		public function setWelcomeMsg():void
		{
			_welcomeTxt.text = _base.userInfo.firstName + " " + _base.userInfo.lastName;
			onResize();
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function get isConnected():Boolean
		{
			return _isConnected;
		}

	}
	
}