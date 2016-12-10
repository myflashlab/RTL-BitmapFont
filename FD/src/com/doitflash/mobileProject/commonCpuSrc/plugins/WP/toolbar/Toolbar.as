package com.doitflash.mobileProject.commonCpuSrc.plugins.WP.toolbar
{
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.fl.motion.Color;
	import com.doitflash.events.WpEvent;
	
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.WordPress;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.assets.WpToolbarIcons;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/19/2012 7:58 PM
	 */
	public class Toolbar extends MySprite 
	{
		public var _list_left:*;
		public var _list_right:*;
		
		public function Toolbar():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_margin = 0;
			//_bgAlpha = _configXml.bgAlpha.text();
			//_bgColor = _configXml.bgColor.text();
			//_bgStrokeAlpha = _configXml.bgStrokeAlpha.text();
			//_bgStrokeColor = _configXml.bgStrokeColor.text();
			//_bgStrokeThickness = _configXml.bgStrokeThickness.text();
			//drawBg();
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			if (_list_left) 
			{
				_list_left.removeEventListener(ListEvent.RESIZE, onResize);
				_list_right.removeEventListener(ListEvent.RESIZE, onResize);
				
				_list_left.removeAll();
				_base.listPool.returnObject(_list_left);
				_base.listPool.returnObject(_list_right);
			}
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_bgAlpha = _configXml.bgAlpha.text();
			_bgColor = _configXml.bgColor.text();
			_bgStrokeAlpha = _configXml.bgStrokeAlpha.text();
			_bgStrokeColor = _configXml.bgStrokeColor.text();
			_bgStrokeThickness = _configXml.bgStrokeThickness.text();
			drawBg();
			
			initList();
			initIcons();
			
			onResize();
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initList():void
		{
			//if(!_list_left) _list_left = new List();
			if(!_list_left) _list_left = _base.listPool.borrowObject();
			_list_left.addEventListener(ListEvent.RESIZE, onResize);
			_list_left.direction = Direction.LEFT_TO_RIGHT;
			_list_left.orientation = Orientation.HORIZONTAL;
			_list_left.table = false;
			_list_left.space = 0;
			_list_left.speed = 0;
			_list_left.x = _list_left.y = 0;
			
			this.addChild(_list_left);
			
			
			
			//if(!_list_right) _list_right = new List();
			if(!_list_right) _list_right = _base.listPool.borrowObject();
			_list_right.addEventListener(ListEvent.RESIZE, onResize);
			_list_right.addEventListener(ListEvent.ITEM_ADDED, onItemAddedToListRight);
			_list_right.direction = Direction.LEFT_TO_RIGHT;
			_list_right.orientation = Orientation.HORIZONTAL;
			_list_right.table = false;
			_list_right.space = 0;
			_list_right.speed = 0;
			_list_right.x = _list_right.y = 0;
			
			this.addChild(_list_right);
		}
		
		private function onItemAddedToListRight(e:*):void
		{
			var item:* = e.param;
			item.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			item.addEventListener(MouseEvent.MOUSE_UP, onUp);
			item.addEventListener(MouseEvent.MOUSE_OUT, onUp);
		}
		
		private function initIcons():void
		{
			for (var i:int = 0; i < _xml.item.length(); i++) 
			{
				var item:WpToolbarIcons = new WpToolbarIcons();
				item.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
				item.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
				item.addEventListener(MouseEvent.MOUSE_OUT, onUp, false, 0, true);
				item.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				
				item.data = { name:_xml.item[i].@name, label:_xml.item[i].@label };
				item.base = _base;
				item.gotoAndStop(_xml.item[i].@name);
				
				_list_left.add(item);
			}
		}
		
		private function onDown(e:MouseEvent):void
		{
			var item:* = e.currentTarget;
			
			var color:Color = new Color();
			color.setTint(0xFFFFFF, 1);
			
			try
			{
				item.icon_mc.transform.colorTransform = color;
				item.label_txt.htmlText = "<font color='#000000' >" + item.label_txt.text;
			}
			catch (err:Error)
			{
				item.transform.colorTransform = color;
			}
		}
		
		private function onUp(e:MouseEvent):void
		{
			var item:* = e.currentTarget;
			
			setTimeout(go, 100);
			function go():void
			{
				var color:Color = new Color();
				color.setTint(0xFFFFFF, 0);
				
				try
				{
					item.icon_mc.transform.colorTransform = color;
					item.label_txt.htmlText = "<font color='#FFFFFF' >" + item.label_txt.text;
				}
				catch (err:Error)
				{
					item.transform.colorTransform = color;
				}
			}
			
			
		}
		
		private function onClick(e:MouseEvent):void
		{
			var item:WpToolbarIcons = e.currentTarget as WpToolbarIcons;
			
			this.dispatchEvent(new AppEvent(AppEvent.REQUEST_DATA, item.data));
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			
			if (_list_right)
			{
				_list_right.x = _width - _list_right.width;
			}
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}