package com.doitflash.mobileProject.commonCpuSrc.plugins.WP.posts
{
	import com.doitflash.events.WpEvent;
	import com.doitflash.remote.wp.WordPressParser;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.utils.scroll.TouchScroll;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.ScrollConst;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/12/2012 2:47 PM
	 */
	public class Posts extends MySprite 
	{
		private var _wpList:WpList;
		public var isSearch:Boolean;
		
		public function Posts():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			/*_margin = 0;
			_bgAlpha = 1;
			_bgColor = 0xFF9900;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0x000000;
			_bgStrokeThickness = 1;
			drawBg();*/
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			initWpList();
			
			onResize();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initWpList():void
		{
			_wpList = new WpList();
			_wpList.base = _base;
			_wpList.configXml = _configXml;
			
			this.addChild(_wpList);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_wpList)
			{
				_wpList.width = _width;
				_wpList.height = _height;
			}
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		public function update($posts:Array):void
		{
			if (_wpList) _wpList.update($posts);
		}
		
		public function clean():void
		{
			if (_wpList) 
			{
				_wpList.list.removeAll();
				_wpList.list.itemArrange();
			}
		}

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}