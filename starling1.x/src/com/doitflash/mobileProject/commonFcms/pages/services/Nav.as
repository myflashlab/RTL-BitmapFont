package com.doitflash.mobileProject.commonFcms.pages.services
{
	import com.doitflash.events.AlertEvent;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import com.doitflash.mobileProject.commonFcms.events.ServiceEvent;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/17/2012 11:18 AM
	 */
	public class Nav extends MySprite 
	{
		private var _list:List;
		private var _currItem:Item;
		
		public function Nav():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_margin = 10;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xD4D4D4;
			_bgStrokeThickness = 1;
			_bgAlpha = 1;
			_bgColor = 0xF2F2F2;
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
			
			initList();
			
			onResize();
			
			// pick the default item
			onAvailableClicked(_list.items[0].content as Item);
		}
		
		private function initList():void
		{
			_list = new List();
			//_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.HORIZONTAL;
			_list.space = 0;
			_list.speed = 0;
			
			_list.add(new Item("Available", onAvailableClicked));
			_list.add(new Item("Installed", onInstallClicked));
			
			this.addChild(_list);
		}
		
		private function onAvailableClicked($item:Item):void
		{
			setNavs($item);
			this.dispatchEvent(new ServiceEvent(ServiceEvent.AVAILABLE_SERVICES))
		}
		
		private function onInstallClicked($item:Item):void
		{
			setNavs($item);
			this.dispatchEvent(new ServiceEvent(ServiceEvent.INSTALLED_SERVICES))
		}
		
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_list)
			{
				var item:Item;
				for (var i:int = 0; i < _list.items.length; i++) 
				{
					item = _list.items[i].content as Item;
					item.width = 100;
					item.height = _height;
				}
			}
		}
		
		private function setNavs($item:Item):void
		{
			if (_currItem) _currItem.unpick();
			_currItem = $item;
			_currItem.pick();
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
	}
	
}
	import flash.events.Event;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;

	internal class Item extends MySprite
	{
		private var _txt:TextArea;
		private var _label:String = "Label";
		private var _selectFunc:Function;
		
		public function Item($label:String, $selectFunc:Function):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_label = $label;
			_selectFunc = $selectFunc;
			
			_bgAlpha = 0;
			_bgColor = 0xDFDFDF;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			this.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			this.buttonMode = true;
			
			_txt = new TextArea();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.embedFonts = true;
			_txt.mouseEnabled = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='15'>" + _label + "</font>";
			
			this.addChild(_txt);
			
			onResize();
		}
		
		private function onOver(e:MouseEvent=null):void
		{
			_bgAlpha = 1;
			drawBg();
		}
		
		private function onOut(e:MouseEvent=null):void
		{
			_bgAlpha = 0;
			drawBg();
		}
		
		private function onClick(e:MouseEvent):void
		{
			_selectFunc.call(null, this);
		}
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_txt)
			{
				_txt.x = _width - _txt.width >> 1;
				_txt.y = _height - _txt.height >> 1;
			}
		}
		
		public function pick():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			this.removeEventListener(MouseEvent.CLICK, onClick);
			
			this.buttonMode = false;
			
			onOver();
		}
		
		public function unpick():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			this.buttonMode = true;
			
			onOut();
		}
	}