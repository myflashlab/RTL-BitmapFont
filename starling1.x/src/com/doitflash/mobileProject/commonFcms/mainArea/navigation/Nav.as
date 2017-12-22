package com.doitflash.mobileProject.commonFcms.mainArea.navigation
{
	import com.doitflash.text.TextArea;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.scroll.MouseScroll;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	
	import com.doitflash.mobileProject.commonFcms.events.MainEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/12/2011 1:49 PM
	 */
	public class Nav extends MySprite
	{
		private var _list:List;
		private var _scroller:MouseScroll;
		private var _currItem:Item;
		private var _oldItem:Item;
		
		public function Nav():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			//_bgAlpha = 0.15;
			//_bgColor = 0x000FF0;
			//drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeChild(_scroller);
			_scroller = null;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			if (!_list)
			{
				initList();
			}
			
			initScroller();
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initList():void
		{
			_list = new List();
			//_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.space = 2;
			_list.speed = 0;
		}
		
		private function initScroller():void
		{
			_scroller = new MouseScroll();
			_scroller.orientation = Orientation.VERTICAL; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_scroller.easeType = "Expo.easeOut";
			_scroller.scrollSpace = 20;
			_scroller.aniInterval = .5;
			_scroller.blurEffect = false;
			_scroller.lessBlurSpeed = 7;
			_scroller.yPerc = 0; // min value is 0, max value is 100
			_scroller.xPerc = 0; // min value is 0, max value is 100
			_scroller.mouseWheelSpeed = 2;
			_scroller.isMouseScroll = true;
			_scroller.maskContent = _list;
			this.addChild(_scroller);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function onClick(e:MainEvent=null):void
		{
			if(e) _currItem = e.currentTarget as Item;
			
			_currItem.pick();
			if (_oldItem) _oldItem.unPick(); 
			
			this.dispatchEvent(new MainEvent(MainEvent.PAGING, { value:_currItem.data.value, xml:_currItem.data.xml } ));
			
			_oldItem = _currItem;
		}
		
		override protected function onResize(e:*=null):void 
		{
			super.onResize(e);
			
			if (_scroller)
			{
				_scroller.x = _margin;
				_scroller.y = _margin;
				_scroller.maskWidth = _width - (_margin * 2);
				_scroller.maskHeight = _height - (_margin * 2);
			}
			
			if (_list)
			{
				for each (var itemHolder:* in _list.items) 
				{
					var item:Item = itemHolder.content;
					item.width = _scroller.maskWidth - 2;
					item.height = 20;
				}
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function add($lebel:String, $data:Object):void
		{
			var item:Item = new Item();
			item.addEventListener(MainEvent.NAV_SELECT, onClick);
			item.serverPath = _serverPath;
			item.base = _base;
			item.label = $lebel;
			item.data = $data;
			
			_list.add(item);
			
			if (_list.items.length == 1)
			{
				_currItem = item;
				onClick();
			}
		}
		
		public function pick($index:int):void
		{
			_currItem = _list.getItemByIndex($index).content as Item;
			onClick();
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function get list():List
		{
			return _list;
		}

	}
	
}