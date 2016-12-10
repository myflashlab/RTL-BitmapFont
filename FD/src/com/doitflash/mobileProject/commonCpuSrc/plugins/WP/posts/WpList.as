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
	
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.posts.Excerpt;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.WordPress;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/12/2012 2:47 PM
	 */
	public class WpList extends MySprite 
	{
		private var _isRequestInProgress:Boolean;
		private var _posts:Array = [];
		
		private var _list:*;
		private var _scroller:*;
		
		public function WpList():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			/*_margin = 0;
			_bgAlpha = 1;
			_bgColor = 0x537237;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0x000000;
			_bgStrokeThickness = 1;
			drawBg();*/
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_list.removeAll();
			this.removeChild(_scroller);
			_scroller.removeEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
			_scroller.removeEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
			//_scroller = null;
			_base.touchScrollPool.returnObject(_scroller);
			
			_base.listPool.returnObject(_list);
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			initList();
			initScroller();
			
			onResize();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initList():void
		{
			//_list = new List();
			_list = _base.listPool.borrowObject();
			//_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.space = 0;
			_list.speed = 0;
		}
		
		private function initScroller():void
		{
			//_scroller = new TouchScroll();
			_scroller = _base.touchScrollPool.borrowObject();
			_scroller.addEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
			_scroller.addEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
			_scroller.orientation = Orientation.VERTICAL;
			_scroller.bitmapMode = ScrollConst.NORMAL;
			_scroller.easeType = "Strong.easeOut";
			_scroller.aniInterval = .5;
			_scroller.holdArea = 10;
			_scroller.isTouchScroll = true;
			_scroller.isMouseScroll = false;
			_scroller.maskContent = _list;
			this.addChildAt(_scroller, 0);
		}
		
		private function onScrollMove(e:*):void
		{
			_scroller._mask.smoothing = true;
			checkForDataRequest();
		}
		
		private function onScrollDone(e:*):void
		{
			_scroller._mask.smoothing = false;
			checkForDataRequest();
		}
		
		private function checkForDataRequest():void
		{
			if (_scroller.yPerc > 99 && !_isRequestInProgress)
			{
				this.dispatchEvent(new AppEvent(AppEvent.REQUEST_RECENT_POSTS, { name:WordPressParser.POSTS }, true ));
				_isRequestInProgress = true;
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_list && _scroller)
			{
				_scroller.maskWidth = _width;
				_scroller.maskHeight = _height;
				
				for (var i:int = 0; i < _list.items.length; i++) 
				{
					var item:Excerpt = _list.items[i].content as Excerpt;
					item.width = _scroller.maskWidth;
					item.height = 150;
				}
			}
			
			if (_list.height < _scroller.maskHeight && !_isRequestInProgress && _posts.length > 0)
			{
				this.dispatchEvent(new AppEvent(AppEvent.REQUEST_RECENT_POSTS, { name:WordPressParser.POSTS }, true ));
				_isRequestInProgress = true;
			}
		}
		
		/*private function onShowContent(e:AppEvent):void
		{
			this.dispatchEvent(new WpEvent(AppEvent.REQUEST_POST, e.param));
		}*/
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		public function update($posts:Array):void
		{
			_posts = $posts;
			
			for (var i:int = 0; i < $posts.length; i++) 
			{
				var foundDuplicated:Boolean = false;
				
				// check for duplications
				for (var j:int = 0; j < _list.items.length; j++)
				{
					var item:Excerpt = _list.items[j].content as Excerpt;
					if (item.data.id == $posts[i].id)
					{
						foundDuplicated = true;
						break;
					}
				}
				
				// add the post if it's not already there!
				if (!foundDuplicated && $posts[i].type == "post")
				{
					var excerpt:Excerpt = new Excerpt();
					excerpt.data = $posts[i];
					excerpt.base = _base;
					excerpt.configXml = _configXml;
					
					_list.add(excerpt);
				}
			}
			
			_isRequestInProgress = false;
			
			onResize();
		}

// ----------------------------------------------------------------------------------------------------------------------- Properties

		public function get list():*
		{
			return _list;
		}
		
	}
	
}