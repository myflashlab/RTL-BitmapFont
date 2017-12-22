package com.doitflash.mobileProject.commonFcms.pages.services
{
	import flash.events.Event;
	import flash.net.Responder;
	import flash.utils.setTimeout;
	
	import com.doitflash.mobileProject.commonFcms.events.ServiceEvent;
	import com.doitflash.mobileProject.commonFcms.pages.plugins.ConfirmBox;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.events.AlertEvent;
	
	import com.greensock.TweenMax;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 9/1/2012 3:07 PM
	 */
	public class InstalledPage extends MySprite 
	{
		private var _list:List;
		private var _scroller:*;
		
		public function InstalledPage():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_marginY = 10;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xB3B3B3;
			//_bgStrokeThickness = 1;
			_bgAlpha = .1;
			_bgColor = 0xFFFFFF;
			drawBg();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (!_list) initList();
			initScroller();
			initItems();
			
			onResize();
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
		
		private function initItems():void
		{
			_list.removeAll();
			_list.visible = false;
			_list.alpha = 0;
			TweenMax.to(_list, 0.6, { autoAlpha:1, delay:0.2 } );
			
			var currAvailableService:XML;
			for (var i:int = 0; i < _data.installedServices.length; i++) 
			{
				var item:InstalledItem = new InstalledItem();
				item.addEventListener(ServiceEvent.UPDATE, onUpdate);
				item.addEventListener(ServiceEvent.UNINSTALL, onUninstall);
				item.addEventListener(ServiceEvent.ACTIVATE, onActive);
				item.addEventListener(ServiceEvent.INACTIVATE, onInactive);
				item.addEventListener(ServiceEvent.SETTING, onSetting);
				item.data = _data.installedServices[i];
				item.base = _base;
				
				currAvailableService = new XML(_data.availableServices.item.(name == item.data.type));
				
				item.status = comparePlugins(_data.installedServices, item.data.type, currAvailableService.modificationDate.text());
				
				_list.add(item);
			}
			
			onResize();
		}
		
		private function onUpdate(e:ServiceEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			var processTxt:String = "1/3) Updating service package, " + e.param.type + "... ";
			var alertTitle:String = "Service updating progress... Please wait";
			
			// Step 1: Download the plugin from our server and put it on the local server
			_base.gateway.call("services.ManageServices.copy", new Responder(onDownloadResult, _base.onFault), _data.id, String(e.param.type), String(_base.xml.pluginDirectory.location.text()), "../" + _base.projectPath + "fcms/amfphp/Services/services/", _base.serverTime);
			_base.showAlert(processTxt, alertTitle, 420, 220);
			
			function onDownloadResult($result:Object):void
			{
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br>2/3) Extracting the service package... ");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					
					// Step 2: Install the service into local fcms
					_base.gateway.call("services.ManageServices.extract", new Responder(onExtractResult, _base.onFault), String($result.fileName), "../" + _base.projectPath + "fcms/amfphp/Services/services/", _base.serverTime);
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
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br>3/3) Updating service info in database... ");
					_base.showAlert(processTxt, alertTitle, 420, 220);
					
					var currAvailableService:XML = new XML(_data.availableServices.item.(name == e.param.type));
					
					// Step 3: Writting the installed plugin info into database
					var infoObj:Object = { };
					infoObj.price = String(currAvailableService.price.text());
					infoObj.author = String(currAvailableService.author.text());
					infoObj.authorSite = String(currAvailableService.authorSite.text());
					infoObj.type = String(currAvailableService.name.text());
					infoObj.description = String(currAvailableService.description.text());
					infoObj.moreDescription = String(currAvailableService.moreDescription.text());
					infoObj.version = String(currAvailableService.version.text());
					infoObj.creationDate = String(currAvailableService.creationDate.text());
					infoObj.modificationDate = String(currAvailableService.modificationDate.text());
					
					_base.gateway.call("services.ManageServices.update", new Responder(onUpdateResult, _base.onFault), infoObj, "../" + _base.projectPath + "fcms/amfphp/Services/services/", _base.serverTime);
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
					processTxt = processTxt.concat("<font color='#468847'>" + $result.msg + "</font><br><br>Service updated successfully. please make sure to compile a new .apk using the \"generate the app\" page.");
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
		
		private function onUninstall(e:ServiceEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 400;
			_base.getAlert.getDll.h = 200;
			_base.getAlert.getDll.title("Please confirm!", "Verdana", 0x333333, 18);
			//_base.getAlert.openAlert($alert, "Arimo", "cancel", "reject", "approve");
			_base.getAlert.setApproveSkin("YES");
			_base.getAlert.getDll.openAlert("Are you sure you want to delete this service? All your setting will be lost!", "Arimo", "reject", "approve");
			setTimeout(_base.sizeRefresh, 20);
			
			//_base.getAlert.data = e.currentTarget as Item;
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onUninstallConfirmed);
			
			function onUninstallConfirmed(alertEvent:*):void
			{
				_base.showPreloader(true);
				_base.gateway.call("services.ManageServices.delete", new Responder(onDeleteResult, _base.onFault), String(e.param.type), "../" + _base.projectPath + "fcms/amfphp/Services/services/", _base.serverTime);
			}
			
			function onDeleteResult($result:Object):void
			{
				if ($result.status == "true")
				{
					// check db for installed services and refresh the list
					_holder.loadInstalledServices(onResult);
				}
				else
				{
					_base.showPreloader(false);
					_base.showAlert("<font color='#B94A48'>" + $result.msg + "</font>", "ERROR", 420, 220);
				}
			}
			
			function onResult():void
			{
				initItems();
			}
		}
		
		private function onAlertClose(e:*=null):void
		{
			_base.getAlert.getDll.removeEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.removeEventListener(AlertEvent.APPROVE, onAlertClose);
			
			_list.visible = false;
			_list.alpha = 0;
			
			// check db for installed services and refresh the list
			_holder.loadInstalledServices(onResult);
			
			function onResult():void
			{
				initItems();
			}
		}
		
		private function onActive(e:ServiceEvent):void
		{
			var item:InstalledItem = e.target as InstalledItem;
			
			_base.showPreloader(true);
			_base.gateway.call("services.ManageServices.serviceActivation", new Responder(onResult, _base.onFault), String(e.param.type), "1", _base.serverTime);
			
			function onResult($result:Object):void
			{
				_base.showPreloader(false);
				if ($result.status == "true")
				{
					item.updateActivation(1);
				}
				else
				{
					_base.showAlert("<font color='#B94A48'>" + $result.msg + "</font>", "Error", 420, 220);
				}
			}
		}
		
		private function onInactive(e:ServiceEvent):void
		{
			var item:InstalledItem = e.target as InstalledItem;
			
			_base.showPreloader(true);
			_base.gateway.call("services.ManageServices.serviceActivation", new Responder(onResult, _base.onFault), String(e.param.type), "0", _base.serverTime);
			
			function onResult($result:Object):void
			{
				_base.showPreloader(false);
				if ($result.status == "true")
				{
					item.updateActivation(0);
				}
				else
				{
					_base.showAlert("<font color='#B94A48'>" + $result.msg + "</font>", "Error", 420, 220);
				}
			}
		}
		
		private function onSetting(e:ServiceEvent):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.SETTING, e.param));
		}
		
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if(_scroller)
			{
				_scroller.y = _marginY;
				_scroller.maskWidth = _width - (_margin * 2) - (_scroller.scrollBarWidth + _scroller.scrollSpace);
				_scroller.maskHeight = _height - (_margin * 2) - _scroller.y;
			}
			
			if (_list)
			{
				for each (var itemHolder:* in _list.items) 
				{
					var item:InstalledItem = itemHolder.content;
					item.width = _scroller.maskWidth - 2;
					item.height = 110;
				}
			}
		}
		
		private function comparePlugins($hayStack:Array, $needle:String, $needleModificationDate:String):String
		{
			var result:String = PageServices.SERVICE_NOT_INSTALLED;
			
			for (var i:int = 0; i < $hayStack.length; i++) 
			{
				var row:Array = $hayStack[i];
				if (row.type == $needle)
				{
					result = PageServices.SERVICE_INSTALLED;
					
					// check if the service needs upgrade?
					if (_base.convertToDate(row.modificationDate) < _base.convertToDate($needleModificationDate))
					{
						result = PageServices.SERVICE_NEEDS_UPDATE;
					}
					break;
				}
			}
			
			return result;
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
	}
	
}