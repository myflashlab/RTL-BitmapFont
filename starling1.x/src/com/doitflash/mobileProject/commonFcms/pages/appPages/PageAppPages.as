package com.doitflash.mobileProject.commonFcms.pages.appPages
{
	import com.doitflash.mobileProject.commonFcms.events.PluginEvent;
	import com.doitflash.text.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.modules.MySprite;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import com.doitflash.tools.URLChecker;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/21/2012 2:10 PM
	 */
	public class PageAppPages extends MyMovieClip 
	{
		private var txt:TextArea;
		private var _holder1:Sprite;
		private var _newMc:NewItem;
		private var _listMc:ListItems;
		
		private var _holder2:Sprite;
		
		private var _currPluginData:Object;
		private var _currPluginMc:MyMovieClip;
		private var _loadedPlugins:Object = { };
		
		private var _urlChecker:URLChecker;
		
		public function PageAppPages():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 50;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			drawBg();
			
			_holder1 = new Sprite();
			this.addChild(_holder1);
			
			_holder2 = new Sprite();
			this.addChild(_holder2);
			
			txt = new TextArea();
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.embedFonts = true;
			txt.mouseEnabled = false;
			txt.htmlText = "<font face='Arimo' color='#468847' size='15'>Any change in your app pages will result in immediate update on users apps!</font>";
			txt.x = _margin;
			txt.y = _margin - txt.height;
			this.addChild(txt);
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
			
			if(!_newMc) initNewMc();
			if(!_listMc) initListMc();
			
			onResize();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private

		private function initNewMc():void
		{
			_newMc = new NewItem();
			_newMc.addEventListener(PageEvent.NEW_ITEM_MODULE_ACTIVATION, onResize);
			_newMc.addEventListener(PageEvent.SAVE_REQUEST_SUCCEEDED, refreshList);
			_newMc.addEventListener(PageEvent.UPDATE_REQUEST_SUCCEEDED, refreshList);
			_newMc.titleHeight = 40;
			_newMc.base = _base;
			_newMc.serverPath = _serverPath;
			
			_holder1.addChild(_newMc)
		}
		
		private function initListMc():void
		{
			_listMc = new ListItems();
			_listMc.addEventListener(PageEvent.ITEM_DROP, refreshList);
			_listMc.addEventListener(PageEvent.ITEM_EDIT, gotoItemGeneralEdit);
			_listMc.addEventListener(PageEvent.ITEM_CONTENT_EDIT, gotoItemContentEdit);
			_listMc.base = _base;
			_listMc.serverPath = _serverPath;
			
			_holder1.addChild(_listMc)
		}
		
		private function gotoItemContentEdit(e:PageEvent):void
		{
			_base.showPreloader(true);
			
			// check if the plugin is already loaded?
			if (_loadedPlugins[e.param.type])
			{
				onPluginLoaded();
			}
			else
			{
				/*// start loading the plugin edit swf
				_base.bulkLoader.addEventListener("complete", onPluginLoaded);
				_base.bulkLoader.addEventListener("error", onPluginLoadError);
				_base.bulkLoader.add(new URLRequest(_base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type + "/" + "FCMS.swf"), { id:"plugin_" + e.param.type, type:"movieclip" } );
				_base.bulkLoader.start(15);*/
				
				_base.gateway.call("plugins.Manage.checkPluginLandingPage", new Responder(onLandingPageCheck, _base.onFault), "../" + _base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type, _base.serverTime);
			}
			
			function onLandingPageCheck($result:Object):void
			{
				if ($result.status == "true")
				{
					switch ($result.cms) 
					{
						case "flash":
							
							// start loading the plugin edit swf
							_base.bulkLoader.addEventListener("complete", onPluginLoaded);
							_base.bulkLoader.add(new URLRequest(_base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type + "/" + "FCMS.swf"), { id:"plugin_" + e.param.type, type:"movieclip" } );
							_base.bulkLoader.start(15);
							
						break;
						
						case "php":
							
							_base.showPreloader(false);
							var sendVars:Object = { };
							sendVars.pluginName = e.param.type;
							sendVars.pageId = e.param.id;
							sendVars.remoteDbPrefix = e.param.remoteDbPrefix;
							sendVars.localDb = e.param.localDb;
							sendVars.pageName = _base.removeTextFormat(unescape(e.param.name));
							sendVars.pageContent = e.param.content;
							sendVars.lastUpdateTime = e.param.itemLastUpdate;
							sendVars.flashTime = _base.serverTime;
							
							ExternalInterface.addCallback("callFlashBack", onJSResult);
							ExternalInterface.call("openNewWindow", _base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type + "/" + "FCMS.php", sendVars, "POST");
							
						break;
						default:
							
							_base.showPreloader(false);
							_base.getAlert.getDll.clearEvents();
							_base.getAlert.getDll.w = 450;
							_base.getAlert.getDll.h = 250;
							_base.getAlert.getDll.title("Cannot load plugin files!", "Verdana", 0x333333, 18);
							_base.getAlert.setApproveSkin("OK");
							_base.getAlert.getDll.openAlert("It seems like this plugin is not installed into your fcms. if you think this is wrong, please check your internet connection or try reinstalling the plugin from the \"plugins\" menu.", "Arimo", "approve");
							setTimeout(_base.sizeRefresh, 20);
					}
				}
			}
			
			/*function onPluginLoadError(event:Event):void
			{
				_base.showPreloader(false);
				_base.bulkLoader.removeEventListener("complete", onPluginLoaded);
				_base.bulkLoader.removeEventListener("error", onPluginLoadError);
				_base.bulkLoader.removeFailedItems();
				
				// check if FCMS.php is available?
				//_urlChecker = new URLChecker();
				//_urlChecker.addEventListener(Event.COMPLETE, urlChecked);
				//_urlChecker.check(_base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type + "/" + "FCMS.php?" + getTimer());
				
				var sendVars:Object = { };
				sendVars.pluginName = e.param.type;
				sendVars.pageId = e.param.id;
				sendVars.remoteDbPrefix = e.param.remoteDbPrefix;
				sendVars.localDb = e.param.localDb;
				sendVars.pageName = _base.removeTextFormat(unescape(e.param.name));
				sendVars.pageContent = e.param.content;
				sendVars.lastUpdateTime = e.param.itemLastUpdate;
				sendVars.flashTime = _base.serverTime;
				
				ExternalInterface.addCallback("callFlashBack", onJSResult);
				ExternalInterface.call("openNewWindow", _base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type + "/" + "FCMS.php", sendVars, "POST");
			}
			
			function urlChecked(event:Event):void 
			{
				_urlChecker.removeEventListener(Event.COMPLETE, urlChecked);
				
				if (event.target.isLive)
				{
					//var sendVars:URLVariables = new URLVariables();
					var sendVars:Object = { };
					sendVars.pluginName = e.param.type;
					sendVars.pageId = e.param.id;
					sendVars.remoteDbPrefix = e.param.remoteDbPrefix;
					sendVars.localDb = e.param.localDb;
					sendVars.pageName = _base.removeTextFormat(unescape(e.param.name));
					sendVars.pageContent = e.param.content;
					sendVars.lastUpdateTime = e.param.itemLastUpdate;
					sendVars.flashTime = _base.serverTime;
					
					//var urlRequest:URLRequest = new URLRequest();
					//urlRequest.url = _base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type + "/" + "FCMS.php";
					//urlRequest.method = URLRequestMethod.POST;
					//urlRequest.data = sendVars;
					//navigateToURL(urlRequest, "_blank");
					
					ExternalInterface.addCallback("callFlashBack", onJSResult);
					ExternalInterface.call("openNewWindow", _base.projectPath + "fcms/amfphp/Services/plugins/" + e.param.type + "/" + "FCMS.php", sendVars, "POST");
				}
				else
				{
					_base.getAlert.getDll.clearEvents();
					_base.getAlert.getDll.w = 450;
					_base.getAlert.getDll.h = 250;
					_base.getAlert.getDll.title("Cannot load plugin files!", "Verdana", 0x333333, 18);
					_base.getAlert.setApproveSkin("OK");
					_base.getAlert.getDll.openAlert("It seems like this plugin is not installed into your fcms. if you think this is wrong, please check your internet connection or try reinstalling the plugin from the \"plugins\" menu.", "Arimo", "approve");
					setTimeout(_base.sizeRefresh, 20);
				}
			}*/
			
			function onPluginLoaded(event:Event=null):void
			{
				// hide _holder1
				txt.visible = false;
				_holder1.visible = false;
				_base.showPreloader(false);
				
				if (_base.bulkLoader.hasEventListener("complete")) 
				{
					_base.bulkLoader.removeEventListener("complete", onPluginLoaded);
					//_base.bulkLoader.removeEventListener("error", onPluginLoadError);
					
				}
				
				// save the current plugin data
				_currPluginData = e.param;
				
				/*for (var name:String in _currPluginData) 
				{
					C.log(name + " = " + _currPluginData[name])
				}*/
				
				// save the plugin into _loadedPlugins
				if (!_loadedPlugins[_currPluginData.type]) _loadedPlugins[_currPluginData.type] = _base.bulkLoader.getMovieClip("plugin_" + _currPluginData.type) as MyMovieClip;
				_currPluginMc = _loadedPlugins[_currPluginData.type];
				_currPluginMc.base = _base;
				_currPluginMc.data = _currPluginData;
				_currPluginMc.addEventListener("onPluginPageRemovedFromStage", onPluginRemovedFromStage);
				_holder2.addChild(_currPluginMc);
				
				onResize();
			}
		}
		
		private function onJSResult($str:String):void
		{
			//C.log($str);
		}
		
		private function onPluginRemovedFromStage(e:Event):void
		{
			_currPluginMc.removeEventListener("onPluginPageRemovedFromStage", onPluginRemovedFromStage);
			_holder2.removeChild(_currPluginMc);
			_holder1.visible = true;
			txt.visible = true;
		}

//--------------------------------------------------------------------------------------------------------------------- Helpful

		private function refreshList(e:PageEvent):void
		{
			_listMc.update();
		}
		
		private function gotoItemGeneralEdit(e:PageEvent):void
		{
			_newMc.open(); // must be opened first
			_newMc.insertMc.fieldsInfo(e.param); // then send in fields info
		}
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_newMc)
			{
				_newMc.width = _width - (_margin * 2);
				_newMc.height = _height - (_margin * 2);
				_newMc.x = _newMc.y = _margin;
			}
			
			if (_listMc)
			{
				if (_newMc.isOpen)
				{
					_listMc.visible = false;
				}
				else
				{
					_listMc.visible = true;
					_listMc.width = _width - (_margin * 2);
					_listMc.height = _height - (_newMc.y + _newMc.titleHeight) - (_margin);
					_listMc.y = _newMc.y + _newMc.titleHeight;
					_listMc.x = _margin;
				}
			}
			
			if (_currPluginMc)
			{
				//_currPluginMc.x = 10;
				//_currPluginMc.y = 10;
				_currPluginMc.width = _width - 0;
				_currPluginMc.height = _height - 0;
			}
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties
		
		
	}
	
}