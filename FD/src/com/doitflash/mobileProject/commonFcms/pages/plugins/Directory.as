package com.doitflash.mobileProject.commonFcms.pages.plugins
{
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.net.FileReference;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.TextArea;
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.events.AlertEvent;
	
	import com.doitflash.mobileProject.commonFcms.events.PluginEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/17/2012 11:18 AM
	 */
	public class Directory extends MySprite 
	{
		public static const PLUGIN_INSTALLED:String = "pluginIsInstalled";
		public static const PLUGIN_NOT_INSTALLED:String = "pluginIsNotInstalled";
		public static const PLUGIN_NEEDS_UPDATE:String = "pluginNeedsUpdate";
		public static const PLUGIN_NOT_PURCHASED:String = "pluginNotPurchased";
		
		private var _titleTxt:TextArea;
		
		private var _pluginDirectory:String;
		private var _pluginsXml:XML; // list of available plugins in plugins directory
		private var _installedPlugins:Array; // list of available plugins installed in the fcms
		
		private var _list:List;
		private var _scroller:*;
		
		private var _userPurchasedItems:Array = [];
		
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
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeChild(_scroller);
			_scroller = null;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if(_data.purchaseInfo) _userPurchasedItems = _data.purchaseInfo;
			
			if (!_titleTxt) initTitle();
			if (!_list) initList();
			initScroller();
			
			_pluginDirectory = _base.xml.pluginDirectory.location.text();
			loadPluginsXml();
			
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
			_titleTxt.htmlText = "<font face='Arimo' color='#777777' size='25'>Mobile Plugin Directory:<br><font color='#B94A48' size='15'>Make sure to generate a new apk after installing new plugins</font></font>";
			
			this.addChild(_titleTxt);
		}
		
		private function initList():void
		{
			_list = new List();
			//_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.space = 0;
			_list.speed = 0;
		}
		
		private function initScroller():void
		{
			_scroller = new _base.getScroller.getClass();
			_scroller.importProp = _base.getScroller.getDll.exportProp;
			_scroller.maskContent = _list;
			this.addChild(_scroller);
		}
		
		private function loadPluginsXml():void
		{
			_base.showPreloader(true);
			
			if (_pluginsXml) // if it has already been loaded
			{
				onPluginsXmlLoaded();
				return;
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onPluginsXmlLoaded);
			loader.load(new URLRequest(_pluginDirectory + "plugins.xml?" + getTimer()));
		}
		
		private function onPluginsXmlLoaded(e:Event=null):void
		{
			if (e)
			{
				e.target.removeEventListener(Event.COMPLETE, onPluginsXmlLoaded);
				_pluginsXml = new XML(e.target.data);
			}
			
			if(!_pluginsXml) throw new Error("Plugin directory xml is not available!") 
			
			// check installed plugins from database
			checkInstalledPlugins();
		}
		
		private function checkInstalledPlugins():void
		{
			_list.visible = false;
			_list.alpha = 0;
			
			_base.showPreloader(true);
			_base.gateway.call("plugins.Manage.getInstalledPlugins", new Responder(onInstalledPluginsResult, _base.onFault), _base.serverTime);
			
			function onInstalledPluginsResult($result:Object):void
			{
				_base.showPreloader(false);
				if ($result.status == "true")
				{
					// save array of installed plugins
					_installedPlugins = $result.plugins;
					
					// create list of items and compare them to the ones available in db
					createPluginsList();
				}
			}
		}
		
		private function createPluginsList():void
		{
			TweenMax.to(_list, 0.6, {autoAlpha:1, delay:0.2} );
			
			_list.removeAll();
			var items:XMLList = _pluginsXml.item;
			for (var i:int = 0; i < items.length(); i++) 
			{
				var item:DirectoryItem = new DirectoryItem();
				item.addEventListener(PluginEvent.INSTALL, onInstall)
				item.addEventListener(PluginEvent.UPDATE, onUpdate)
				item.addEventListener(PluginEvent.UNINSTALL, onUninstall)
				item.addEventListener(PluginEvent.PURCHASE, onPurchase)
				item.xml = new XML(items[i]);
				
				if (items[i].price.text() == "0") item.isPurchased = true;
				else item.isPurchased = checkIfPurchased(items[i].name.text(), _userPurchasedItems);
				
				if (item.isPurchased) item.status = comparePlugins(_installedPlugins, item.xml);
				else item.status = Directory.PLUGIN_NOT_PURCHASED;
				
				item.base = _base;
				
				
				_list.add(item);
			}
			
			onResize();
		}
		
		private function onInstall(e:PluginEvent):void
		{
			var processTxt:String = "1/3) Downloading plugin, " + e.param.name.text() + "... ";
			var alertTitle:String = "Plugin installation progress... Please wait";
			
			// Step 1: Download the plugin from our server and put it on the local server
			_base.gateway.call("plugins.Manage.copy", new Responder(onDownloadResult, _base.onFault), _data.id, String(e.param.name.text()), _pluginDirectory, "../" + _base.projectPath + "fcms/amfphp/Services/plugins/", _base.serverTime);
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.setApproveSkin("OK");
			_base.showAlert(processTxt, alertTitle, 420, 220);
			
			function onDownloadResult($result:Object):void
			{
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br>2/3) Extracting the plugin... ");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					
					// Step 2: Install the plugin into local fcms
					_base.gateway.call("plugins.Manage.extract", new Responder(onExtractResult, _base.onFault), String($result.fileName), "../" + _base.projectPath + "fcms/amfphp/Services/plugins/", _base.serverTime);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#B94A48'>" + $result.msg + "</font>");
					_base.showAlert(processTxt, alertTitle, 420, 220);
				}
			}
			
			function onExtractResult($result:Object):void
			{
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br>3/3) Writting plugin info to database... ");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					
					// Step 3: Writting the installed plugin info into database
					var infoObj:Object = { };
					infoObj.price = String(e.param.price.text());
					infoObj.author = String(e.param.author.text());
					infoObj.authorSite = String(e.param.authorSite.text());
					infoObj.type = String(e.param.name.text());
					infoObj.description = String(e.param.description.text());
					infoObj.moreDescription = String(e.param.moreDescription.text());
					infoObj.version = String(e.param.version.text());
					infoObj.manifestAdditions = String(e.param.manifestAdditions);
					infoObj.extensions = String(e.param.extensions);
					infoObj.creationDate = String(e.param.creationDate.text());
					infoObj.modificationDate = String(e.param.modificationDate.text());
					
					_base.gateway.call("plugins.Manage.save", new Responder(onSaveResult, _base.onFault), infoObj, "../" + _base.projectPath + "fcms/amfphp/Services/plugins/", _base.serverTime);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#B94A48'>" + $result.msg + "</font>");
					_base.showAlert(processTxt, alertTitle, 420, 220);
				}
			}
			
			function onSaveResult($result:Object):void
			{
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br><br>Plugin is installed into your fcms. please make sure to compile a new .apk using the \"generate the app\" page.");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
					_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onAlertClose);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#B94A48'>" + $result.msg + "</font>");
					_base.showAlert(processTxt, alertTitle, 420, 220);
				}
			}
		}
		
		private function onUpdate(e:PluginEvent):void
		{
			var processTxt:String = "1/3) Updating plugin, " + e.param.name.text() + "... ";
			var alertTitle:String = "Plugin updating progress... Please wait";
			
			// Step 1: Download the plugin from our server and put it on the local server
			_base.gateway.call("plugins.Manage.copy", new Responder(onDownloadResult, _base.onFault), _data.id, String(e.param.name.text()), _pluginDirectory, "../" + _base.projectPath + "fcms/amfphp/Services/plugins/", _base.serverTime);
			_base.showAlert(processTxt, alertTitle, 420, 220);
			
			function onDownloadResult($result:Object):void
			{
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br>2/3) Extracting the plugin... ");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					
					// Step 2: Install the plugin into local fcms
					_base.gateway.call("plugins.Manage.extract", new Responder(onExtractResult, _base.onFault), String($result.fileName), "../" + _base.projectPath + "fcms/amfphp/Services/plugins/", _base.serverTime);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#B94A48'>" + $result.msg + "</font>");
					_base.showAlert(processTxt, alertTitle, 420, 220);
				}
			}
			
			function onExtractResult($result:Object):void
			{
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br>3/3) Updating plugin info in database... ");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					
					// Step 3: Writting the installed plugin info into database
					var infoObj:Object = { };
					infoObj.price = String(e.param.price.text());
					infoObj.author = String(e.param.author.text());
					infoObj.authorSite = String(e.param.authorSite.text());
					infoObj.type = String(e.param.name.text());
					infoObj.description = String(e.param.description.text());
					infoObj.moreDescription = String(e.param.moreDescription.text());
					infoObj.version = String(e.param.version.text());
					infoObj.manifestAdditions = String(e.param.manifestAdditions);
					infoObj.extensions = String(e.param.extensions);
					infoObj.creationDate = String(e.param.creationDate.text());
					infoObj.modificationDate = String(e.param.modificationDate.text());
					
					_base.gateway.call("plugins.Manage.update", new Responder(onUpdateResult, _base.onFault), infoObj, "../" + _base.projectPath + "fcms/amfphp/Services/plugins/", _base.serverTime);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#B94A48'>" + $result.msg + "</font>");
					_base.showAlert(processTxt, alertTitle, 420, 220);
				}
			}
			
			function onUpdateResult($result:Object):void
			{
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br><br>Plugin updated successfully. please make sure to compile a new .apk using the \"generate the app\" page.");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
					_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onAlertClose);
				}
				else
				{
					processTxt = processTxt.concat("<font color='#B94A48'>" + $result.msg + "</font>");
					_base.showAlert(processTxt, alertTitle, 420, 220);
				}
			}
		}
		
		private function onUninstall(e:PluginEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 400;
			_base.getAlert.getDll.h = 200;
			_base.getAlert.getDll.title("Please confirm!", "Verdana", 0x333333, 18);
			//_base.getAlert.openAlert($alert, "Arimo", "cancel", "reject", "approve");
			_base.getAlert.setApproveSkin("YES");
			_base.getAlert.getDll.openAlert("Are you sure you want to delete this plugin? If you have used this plugin in your pages, they won't work anymore! Please be careful!", "Arimo", "reject", "approve");
			setTimeout(_base.sizeRefresh, 20);
			
			//_base.getAlert.data = e.currentTarget as Item;
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onUninstallConfirmed);
			
			function onUninstallConfirmed(alertEvent:*):void
			{
				_base.showPreloader(true);
				_base.gateway.call("plugins.Manage.delete", new Responder(onDeleteResult, _base.onFault), String(e.param.name.text()), "../" + _base.projectPath + "fcms/amfphp/Services/plugins/", _base.serverTime);
			}
			
			function onDeleteResult($result:Object):void
			{
				//_base.showPreloader(false);
				if ($result.status == "true")
				{
					// check db for installed plugins and refresh the list
					checkInstalledPlugins();
				}
			}
		}
		
		private function onPurchase(e:PluginEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 420;
			_base.getAlert.getDll.h = 320;
			_base.getAlert.getDll.title("Purchase confirmation", "Verdana", 0x333333, 18);
			_base.getAlert.getDll.scrollerEnabled = false;
			_base.getAlert.setApproveSkin("yes");
			
			var confirmBox:ConfirmBox = new ConfirmBox();
			confirmBox.width = _base.getAlert.getDll.contentWidth;
			confirmBox.height = _base.getAlert.getDll.contentHeight;
			confirmBox.data.pluginName = e.param.name.text();
			confirmBox.data.pluginPrice = e.param.price.text();
			if(_data.paypalAddress) confirmBox.paypalAddress = _data.paypalAddress;
			
			_base.getAlert.getDll.openAlert(confirmBox, "Verdana", "reject", "approve");
			setTimeout(_base.sizeRefresh, 20);
			
			//_base.getAlert.data = e.currentTarget as Item;
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onPurchaseConfirmed);
			
			function onPurchaseConfirmed(alertEvent:*):void
			{
				_base.getAlert.getDll.clearEvents();
				
				//C.log(_base.getAlert.getDll.content.paypalAddress);
				
				var vars:URLVariables = new URLVariables();
				vars.item = e.param.name.text(); // item to be purchased
				vars.user = _data.id; // buyer
				vars.productType = "plugin"; // send product type also so the purchase gateway would know
				vars.paypalAddress = _base.getAlert.getDll.content.paypalAddress;
				
				var request:URLRequest = new URLRequest(_base.xml.pluginDirectory.purchaseGateway.text());
				request.method = URLRequestMethod.POST;
				request.data = vars;
				
				navigateToURL(request, "_blank");
			}
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
			
			if (_scroller)
			{
				_scroller.x = _margin;
				_scroller.y = _titleTxt.y + _titleTxt.height + 10;
				_scroller.maskWidth = _width - (_margin * 2) - (_scroller.scrollBarWidth + _scroller.scrollSpace);
				_scroller.maskHeight = _height - (_margin * 2) - _scroller.y - 10;
			}
			
			if (_list)
			{
				for each (var itemHolder:* in _list.items) 
				{
					var item:DirectoryItem = itemHolder.content;
					item.width = _scroller.maskWidth - 2;
					item.height = 110;
				}
			}
		}
		
		private function comparePlugins($hayStack:Array, $needle:XML):String
		{
			var result:String = Directory.PLUGIN_NOT_INSTALLED;
			
			for (var i:int = 0; i < $hayStack.length; i++) 
			{
				var row:Array = $hayStack[i];
				if (row.type == String($needle.name.text()))
				{
					result = Directory.PLUGIN_INSTALLED;
					
					// check if the plugin needs upgrade?
					if (_base.convertToDate(row.modificationDate) < _base.convertToDate($needle.modificationDate.text()))
					{
						result = Directory.PLUGIN_NEEDS_UPDATE;
					}
					break;
				}
			}
			
			return result;
		}
		
		private function onAlertClose(e:*):void
		{
			_base.getAlert.getDll.removeEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.removeEventListener(AlertEvent.APPROVE, onAlertClose);
			
			// check db for installed plugins and refresh the list
			checkInstalledPlugins();
		}
		
		private function checkIfPurchased($pluginName:String, $purchasedItems:Array):Boolean
		{
			for (var i:int = 0; i < $purchasedItems.length; i++) 
			{
				if ($pluginName == $purchasedItems[i].name)
				{
					return true;
				}
			}
			
			return false;
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
	}
	
}