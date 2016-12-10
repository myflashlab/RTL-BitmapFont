package com.doitflash.mobileProject.commonFcms.mainArea.navigation
{
	import flash.display.Shape;
	import flash.events.Event;
	
	import com.doitflash.text.modules.MySprite;

	import com.doitflash.mobileProject.commonFcms.events.MainEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/12/2011 11:03 AM
	 */
	public class Navigation extends MySprite
	{
		private var _nav:Nav;
		private var _line:Shape;
		
		public function Navigation():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_line = new Shape();
			this.addChild(_line);
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			// replace this with your own navigation system!
			initMenu();
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initMenu():void
		{
			_nav = new Nav();
			_nav.addEventListener(MainEvent.PAGING, onPageChange);
			_nav.base = _base;
			_nav.serverPath = _serverPath;
			this.addChild(_nav)
			
			// use the folloing xml for creating menu items
			var menuItems:XMLList = _base.xml.page.item;
			
			for (var i:int = 0; i < menuItems.length(); i++) 
			{
				var value:String = _serverPath + _base.xml.page.@location + menuItems[i].@src;
				_nav.add(menuItems[i].@name, {value:value, xml:new XML(menuItems[i])})
			}
		}
		
		private function onPageChange(e:MainEvent):void
		{
			this.dispatchEvent(new MainEvent(MainEvent.PAGING, {target:e.currentTarget , value:e.param.value, xml:e.param.xml}));
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*=null):void 
		{
			super.onResize(e);
			
			_line.graphics.clear();
			_line.graphics.lineStyle(1, 0xB3B3B3);
			_line.graphics.moveTo(_width, 0);
			_line.graphics.lineTo(_width, _height);
			_line.graphics.endFill();
			
			if (_nav)
			{
				_nav.y = 2;
				_nav.width = _width+2;
				_nav.height = _height-2;
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function get nav():Nav
		{
			return _nav;
		}

	}
	
}