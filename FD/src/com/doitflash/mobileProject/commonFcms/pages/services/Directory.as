package com.doitflash.mobileProject.commonFcms.pages.services
{
	import com.doitflash.events.AlertEvent;
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	
	import com.doitflash.mobileProject.commonFcms.events.ServiceEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/17/2012 11:18 AM
	 */
	public class Directory extends MySprite 
	{
		private var _titleTxt:TextArea;
		
		private var _nav:Nav;
		private var _body:Sprite;
		
		private var _availablePage:AvailablePage;
		private var _installedPage:InstalledPage;
		
		private var _holder2:Sprite;
		private var _currServiceData:Object;
		private var _currServiceMc:MyMovieClip;
		private var _loadedServiceSettings:Object = { };
		
		public function Directory():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_margin = 10;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xB3B3B3;
			//_bgStrokeThickness = 1;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			drawBg();
			
			_holder2 = new Sprite();
			this.addChild(_holder2);
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (_nav)
			{
				_nav.removeEventListener(ServiceEvent.AVAILABLE_SERVICES, goAvailable);
				_nav.removeEventListener(ServiceEvent.INSTALLED_SERVICES, goInstalled);
				this.removeChild(_nav);
				_nav = null;
			}
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_body = new Sprite();
			this.addChild(_body);
			
			if (!_titleTxt) initTitle();
			loadServicesXml();
			
			onResize();
		}
		
		private function initTitle():void
		{
			_titleTxt = new TextArea();
			_titleTxt.autoSize = TextFieldAutoSize.LEFT;
			_titleTxt.antiAliasType = AntiAliasType.ADVANCED;
			_titleTxt.multiline = true;
			_titleTxt.wordWrap = true;
			_titleTxt.embedFonts = true;
			_titleTxt.selectable = false;
			_titleTxt.htmlText = "<font face='Arimo' color='#777777' size='25'>Mobile Service Directory:<br><font color='#B94A48' size='15'>Make sure to generate a new apk after installing new services. If you're changing the activation status of services, you must generate a new apk to make it available in users apps.</font></font>";
			
			this.addChild(_titleTxt);
		}
		
		private function loadServicesXml():void
		{
			_base.showPreloader(true);
			
			if (_data.availableServices) // if it has already been loaded
			{
				onServicesXmlLoaded();
				return;
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onServicesXmlLoaded);
			loader.load(new URLRequest(_base.xml.pluginDirectory.location.text() + "services.xml?" + getTimer()));
		}
		
		private function onServicesXmlLoaded(e:Event=null):void
		{
			if (e)
			{
				e.target.removeEventListener(Event.COMPLETE, onServicesXmlLoaded);
				_data.availableServices = new XML(e.target.data);
			}
			
			if(!_data.availableServices) throw new Error("Services directory xml file is not available!") 
			
			loadInstalledServices(onResult);
			
			function onResult():void
			{
				if(!_nav) initNav();
			}
		}
		
		private function initNav():void
		{
			_nav = new Nav();
			_nav.addEventListener(ServiceEvent.AVAILABLE_SERVICES, goAvailable);
			_nav.addEventListener(ServiceEvent.INSTALLED_SERVICES, goInstalled);
			_nav.base = _base;
			_nav.holder = this;
			
			this.addChild(_nav);
			
			onResize();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_titleTxt)
			{
				_titleTxt.width = _width;
				_titleTxt.x = 0;
				_titleTxt.y = 0;
			}
			
			if (_nav)
			{
				_nav.y = _titleTxt.y + _titleTxt.height + 10;
				_nav.width = _width;
				_nav.height = 40;
			}
			
			if (_availablePage && _availablePage.stage)
			{
				_availablePage.y = _nav.y + _nav.height;
				_availablePage.width = _width;
				_availablePage.height = _height - _availablePage.y;
			}
			
			if (_installedPage && _installedPage.stage)
			{
				_installedPage.y = _nav.y + _nav.height;
				_installedPage.width = _width;
				_installedPage.height = _height - _installedPage.y;
			}
			
			if (_currServiceMc)
			{
				//_currServiceMc.x = 10;
				//_currServiceMc.y = 10;
				_currServiceMc.width = _width - 0;
				_currServiceMc.height = _height - 0;
			}
		}
		
		private function goAvailable(e:ServiceEvent):void
		{
			cleanUp(_body);
			
			if (!_availablePage)
			{
				_availablePage = new AvailablePage();
				_availablePage.holder = this;
				_availablePage.base = _base;
				_availablePage.data = _data;
			}
			
			_body.addChild(_availablePage);
			onResize();
		}
		
		private function goInstalled(e:ServiceEvent):void
		{
			cleanUp(_body);
			
			if (!_installedPage)
			{
				_installedPage = new InstalledPage();
				_installedPage.addEventListener(ServiceEvent.SETTING, gotoServiceSetting, false, 0, true);
				_installedPage.holder = this;
				_installedPage.base = _base;
				_installedPage.data = _data;
			}
			
			_body.addChild(_installedPage);
			onResize();
		}
		
		private function gotoServiceSetting(e:ServiceEvent):void
		{
			_base.showPreloader(true);
			
			// check if the plugin is already loaded?
			if (_loadedServiceSettings[e.param.type])
			{
				onServiceSettingLoaded();
			}
			else
			{
				_base.gateway.call("services.ManageServices.checkServiceLandingPage", new Responder(onLandingPageCheck, _base.onFault), "../" + _base.projectPath + "fcms/amfphp/Services/services/" + e.param.type, _base.serverTime);
			}
			
			function onLandingPageCheck($result:Object):void
			{
				if ($result.status == "true")
				{
					switch ($result.cms) 
					{
						case "flash":
							
							// start loading the service setting swf
							_base.bulkLoader.addEventListener("complete", onServiceSettingLoaded);
							_base.bulkLoader.add(new URLRequest(_base.projectPath + "fcms/amfphp/Services/services/" + e.param.type + "/" + "FCMS.swf"), { id:"service_" + e.param.type, type:"movieclip" } );
							_base.bulkLoader.start(15);
							
						break;
						
						case "php":
							
							_base.showPreloader(false);
							var sendVars:Object = { };
							sendVars.serviceName = e.param.type;
							sendVars.serviceId = e.param.id;
							sendVars.remoteDbPrefix = e.param.remoteDbPrefix;
							sendVars.localDb = e.param.localDb;
							sendVars.content = e.param.content;
							sendVars.version = e.param.version;
							sendVars.activated = e.param.activated;
							sendVars.itemLastUpdate = e.param.itemLastUpdate;
							sendVars.flashTime = _base.serverTime;
							
							ExternalInterface.addCallback("callFlashBack", onJSResult);
							ExternalInterface.call("openNewWindow", _base.projectPath + "fcms/amfphp/Services/services/" + e.param.type + "/" + "FCMS.php", sendVars, "POST");
							
						break;
						default:
							
							_base.showPreloader(false);
							_base.getAlert.getDll.clearEvents();
							_base.getAlert.getDll.w = 450;
							_base.getAlert.getDll.h = 250;
							_base.getAlert.getDll.title("Cannot load plugin files!", "Verdana", 0x333333, 18);
							_base.getAlert.setApproveSkin("OK");
							_base.getAlert.getDll.openAlert("It seems like this service is not installed into your fCMS correctly! if you think this is wrong, please check your internet connection or try reinstalling it", "Arimo", "approve");
							setTimeout(_base.sizeRefresh, 20);
					}
				}
			}
			
			function onServiceSettingLoaded(event:Event=null):void
			{
				_titleTxt.visible = false;
				_nav.visible = false;
				_body.visible = false;
				_base.showPreloader(false);
				
				if (_base.bulkLoader.hasEventListener("complete")) 
				{
					_base.bulkLoader.removeEventListener("complete", onServiceSettingLoaded);
					
				}
				
				// save the current service data
				_currServiceData = e.param;
				
				/*for (var name:String in _currServiceData) 
				{
					C.log(name + " = " + _currServiceData[name])
				}*/
				
				// save the plugin into _loadedServiceSettings
				if (!_loadedServiceSettings[_currServiceData.type]) _loadedServiceSettings[_currServiceData.type] = _base.bulkLoader.getMovieClip("service_" + _currServiceData.type) as MyMovieClip;
				_currServiceMc = _loadedServiceSettings[_currServiceData.type];
				_currServiceMc.base = _base;
				_currServiceMc.data = _currServiceData;
				_currServiceMc.addEventListener("onPageRemovedFromStage", onServiceRemovedFromStage);
				_holder2.addChild(_currServiceMc);
				
				onResize();
			}
		}
		
		private function onJSResult($str:String):void
		{
			//C.log($str);
		}
		
		private function onServiceRemovedFromStage(e:Event):void
		{
			_currServiceMc.removeEventListener("onPageRemovedFromStage", onServiceRemovedFromStage);
			_holder2.removeChild(_currServiceMc);
			_titleTxt.visible = true;
			_nav.visible = true;
			_body.visible = true;
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		public function loadInstalledServices($onComplete:Function=null):void
		{
			_base.showPreloader(true);
			_base.gateway.call("services.ManageServices.getInstalledServices", new Responder(onResult, _base.onFault), _base.serverTime);
			
			function onResult($result:Object):void
			{
				_base.showPreloader(false);
				if ($result.status == "true")
				{
					// save array of installed services
					_data.installedServices = $result.services;
					
					if ($onComplete != null) $onComplete.call();
				}
			}
		}

//--------------------------------------------------------------------------------------------------------------------- Properties

		
	}
	
}