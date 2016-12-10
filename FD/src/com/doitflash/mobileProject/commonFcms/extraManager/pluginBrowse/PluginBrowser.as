package com.doitflash.mobileProject.commonFcms.extraManager.pluginBrowse
{
	import flash.events.Event;
	import flash.net.Responder;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.events.AlertEvent;
	import com.doitflash.events.RemoteEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 7/3/2012 12:21 PM
	 */
	public class PluginBrowser extends MySprite 
	{
		public static const ITEM_SELECTED:String = "onItemSelected";
		
		private var _selectedPlugin:String = "Please choose a plugin name!";
		private var _list:List;
		private var _currItem:Item;
		
		public function PluginBrowser():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 1;
			//_bgColor = 0xFF9900;
			//drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			//this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_list.removeAll();
			_list.removeEventListener(ListEvent.RESIZE, onListResize);
			this.removeChild(_list);
			_list = null;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			initList();
			
			_base.showPreloader(true);
			_base.gateway.call("plugins.Manage.getInstalledPlugins", new Responder(onPluginsResult, _base.onFault), _base.serverTime);
			
			onResize();
		}
		
		private function initList():void
		{
			_list = new List();
			_list.addEventListener(ListEvent.RESIZE, onListResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.space = 2;
			_list.speed = 0;
			
			this.addChild(_list);
		}
		
		private function onPluginsResult($result:Object):void
		{
			_base.showPreloader(false);
			
			if ($result.status == "true")
			{
				var pluginArr:Array = $result.plugins;
				pluginArr.sortOn("type");
				
				for (var i:int = 0; i < pluginArr.length; i++) 
				{
					var item:Item = new Item();
					item.addEventListener(PluginBrowser.ITEM_SELECTED, onItemSelected, false, 0, true);
					item.name = pluginArr[i].type;
					item.base = _base;
					_list.add(item);
				}
				
				onResize();
			}
			else
			{
				_base.showAlert("<font color='#333333' size='13'>" + $result.msg + "</font>", "", 350, 150);
				setTimeout(_base.sizeRefresh, 20);
			}
			
		}
		
		private function onItemSelected(e:Event):void
		{
			if (_currItem) _currItem.pick(false);
			
			_currItem = e.target as Item;
			_currItem.pick(true);
			
			_selectedPlugin = _currItem.name;
		}
		
		private function onListResize(e:ListEvent):void
		{
			_height = _list.height;
		}
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_list)
			{
				for each (var itemHolder:* in _list.items) 
				{
					var item:Item = itemHolder.content;
					item.width = _width;
					item.height = 30;
				}
			}
		}
		
		public function get selectedPlugin():String
		{
			return _selectedPlugin;
		}
		
	}

}